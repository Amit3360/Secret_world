//
//  ItemsListVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 23/04/25.
//

import UIKit

class ItemsListVC: UIViewController {
    @IBOutlet weak var heightAddVw: NSLayoutConstraint!
    
    @IBOutlet weak var lblDateFound: UILabel!
    @IBOutlet weak var heightTblVw: NSLayoutConstraint!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var vwSearchCategory: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnAddItem: UIButton!
    @IBOutlet weak var vwAddItem: UIView!
    @IBOutlet weak var tblVwItem: UITableView!
    @IBOutlet weak var lblSelectedItem: UILabel!
    @IBOutlet weak var vwSelectedItem: UIView!
    
    var isComingFrom = ""
    var arrItem = [AllItem]()
    var groupedItems = [String: [AllItem]]()
    var sortedCategories = [String]()
    var arrCategory = ["All"]
    var viewModel = ItemsVM()
    var addedCategory = false
    var itemCount = 0
    var selectedItems = [AllItem]()
    var callBack:((_ selectedItems:[AllItem]?)->())?
    var callBackAdd:((_ addItems:[AddItems]?)->())?
    var matchTitle = "All"
    
    
    var arrAddItem = [AddItems]()
    var groupedAddItems = [String: [AddItems]]()
    var isComingUpdate = false
    var isComingSummary = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibHeader = UINib(nibName: "ItemHeaderTVC", bundle: nil)
        tblVwItem.register(nibHeader, forCellReuseIdentifier: "ItemHeaderTVC")
        let nibItems = UINib(nibName: "ItemCategoryTVC", bundle: nil)
        tblVwItem.register(nibItems, forCellReuseIdentifier: "ItemCategoryTVC")
      
        uiSet()
        tblVwItem.rowHeight = UITableView.automaticDimension
        tblVwItem.estimatedRowHeight = 100
    }
    override func viewWillLayoutSubviews() {
          self.tblVwItem.reloadData()
          self.tblVwItem.layoutIfNeeded()
          self.heightTblVw.constant = self.tblVwItem.contentSize.height + 10
    }
    
    
    func uiSet(){
       
        if isComingFrom == "existing"{
            vwSearchCategory.isHidden = false
            self.lblHeader.text = "Add existing item"
           
            getAllItemsApi(search: "")
            if selectedItems.count > 0{
                vwAddItem.isHidden = false
                self.itemCount = selectedItems.count
                vwSelectedItem.isHidden = false
                lblSelectedItem.text = "\(selectedItems.count) items selected"
                
            }else{
                vwAddItem.isHidden = true
                vwSelectedItem.isHidden = true
            }
        }else{
            self.lblHeader.text = "All items"
            vwSearchCategory.isHidden = true
            vwAddItem.isHidden = true
            vwSelectedItem.isHidden = true
            groupAddItems()
       
            updateTableViewHeight()
        }
        
    }
    
    func getAllItemsApi(search:String){
        
        viewModel.getAllItems(search:search) { data in
            self.arrItem.removeAll()
            self.sortedCategories.removeAll()
           
            self.arrItem = data ?? []
            self.groupItemsByCategory()
            self.tblVwItem.reloadData()
            self.updateTableViewHeight()
        }
    }
    private func updateTableViewHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.tblVwItem.reloadData()
              self.tblVwItem.layoutIfNeeded()
              self.heightTblVw.constant = self.tblVwItem.contentSize.height + 10
         
        }
    }
    func groupAddItems() {
        groupedAddItems.removeAll()
       
        for item in arrAddItem {
            let category = item.itemCategory
            if groupedAddItems[category ?? ""] != nil {
                groupedAddItems[category ?? ""]?.append(item)
            } else {
                groupedAddItems[category ?? ""] = [item]
            }
        }
        
        sortedCategories = groupedAddItems.keys.sorted()
       
    }
  
    func groupItemsByCategory() {
        groupedItems.removeAll()
       
        for item in arrItem {
            let category = item.item?.itemCategory
            if groupedItems[category ?? ""] != nil {
                groupedItems[category ?? ""]?.append(item)
            } else {
                groupedItems[category ?? ""] = [item]
            }
        }
        
        sortedCategories = groupedItems.keys.sorted()
        if !self.addedCategory{
            arrCategory.append(contentsOf: groupedItems.keys.sorted())
            self.addedCategory = true
        }
    }
    
    @IBAction func actionAddItem(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        callBack?(selectedItems)
        
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        callBack?(selectedItems)
        callBackAdd?(arrAddItem)
    }
    @IBAction func actionChooseCategory(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
        vc.type = "ChooseCategory"
        vc.matchTitle = matchTitle
        vc.arrItemCategory = self.arrCategory
        vc.modalPresentationStyle = .popover
        vc.callBack = { [weak self] type, title, id in
            guard let self = self else { return }
            self.matchTitle = title
            self.arrItem.removeAll()
            self.sortedCategories.removeAll()
            self.groupedItems.removeAll()
            self.tblVwItem.reloadData()
            self.lblCategory.text = title
            self.lblCategory.textColor = .black
            if title == "All"{
                self.getAllItemsApi(search: "")
            }else{
                self.getAllItemsApi(search: title)
            }
           
        }
        let height = CGFloat(arrCategory.count * 50)
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .up
        vc.preferredContentSize = CGSize(width: vwSearchCategory.frame.size.width, height: height)
        self.present(vc, animated: false)
    }
}

// MARK: - Popup
extension ItemsListVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}
extension ItemsListVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedCategories.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemHeaderTVC") as? ItemHeaderTVC else {
            return nil
        }
        cell.lblName.text = sortedCategories[section]
        cell.btnSeeAll.isHidden = true
        
        return cell.contentView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCategoryTVC", for: indexPath) as? ItemCategoryTVC else {
            return UITableViewCell()
        }
        if isComingFrom == "existing"{
            cell.selectedItem = selectedItems
            let category = sortedCategories[indexPath.section]
            if let items = groupedItems[category] {
                cell.configureAllItem(with: items, isType: true)
                
            }
           
            cell.callBackSelectItem = { [weak self] type,item in
                guard let self = self else { return }
               
                if type == "select"{
                    itemCount += 1
                    vwAddItem.isHidden = false
                    vwSelectedItem.isHidden = false
                    heightAddVw.constant = 100
                    lblSelectedItem.text = "\(itemCount) items selected"
                    self.selectedItems.append(item)
                    lblDateFound.isHidden = true
                }else{
                    itemCount -= 1
                    if itemCount > 0{
                        vwAddItem.isHidden = false
                        vwSelectedItem.isHidden = false
                        heightAddVw.constant = 100
                        lblDateFound.isHidden = true
                    }else{
                        vwAddItem.isHidden = true
                        vwSelectedItem.isHidden = true
                        heightAddVw.constant = 0
                        lblDateFound.isHidden = false
                    }
                    if let index = self.selectedItems.firstIndex(where: { $0.item?.id == item.item?.id }) {
                        self.selectedItems.remove(at: index)
                    }
                    lblSelectedItem.text = "\(itemCount) items selected"
                }
              
                cell.selectedItem = selectedItems
                DispatchQueue.main.async{
                    cell.collVwItems.reloadData()
                }
                

            }
        }else{
          
                let category = sortedCategories[indexPath.section]
                if let items = groupedAddItems[category] {
                   
                    cell.configureAddItem(with: items, isType: true, isAdd: true, isViewSummary: isComingSummary)
                }
            cell.callBackCross = { [weak self] item in
                guard let self = self, let item = item else { return }

                let category = item.itemCategory ?? ""

                // Get section index before modifying any data
                guard let sectionIndex = self.sortedCategories.firstIndex(of: category) else { return }

                // Remove item from main array
                if let index = self.arrAddItem.firstIndex(where: { $0.id == item.id }) {
                    self.arrAddItem.remove(at: index)
                }

                // Update grouped data
                if var sectionItems = self.groupedAddItems[category] {
                    sectionItems.removeAll(where: { $0.id == item.id })
                    if sectionItems.isEmpty {
                        self.lblDateFound.isHidden = true
                        self.groupedAddItems.removeValue(forKey: category)
                        if let sectionIndex = self.sortedCategories.firstIndex(of: category) {
                            self.sortedCategories.remove(at: sectionIndex)
                            self.tblVwItem.deleteSections(IndexSet(integer: sectionIndex), with: .none)
                        }
                    } else {
                        self.lblDateFound.isHidden = true
                        self.groupedAddItems[category] = sectionItems
                        if let sectionIndex = self.sortedCategories.firstIndex(of: category) {
                            self.tblVwItem.reloadSections(IndexSet(integer: sectionIndex), with: .none)
                        }
                    }
                   
                }
                if sortedCategories.count == 0{
                    self.lblDateFound.isHidden = false
                }

            }
            }
        
        return cell
     
      
    }
   
}
