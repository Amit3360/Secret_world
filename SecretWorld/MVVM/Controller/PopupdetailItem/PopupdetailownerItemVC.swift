//
//  PopupdetailownerItemVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 25/04/25.
//

import UIKit

class PopupdetailownerItemVC: UIViewController {
    
    @IBOutlet weak var vwDetail: UIView!
    @IBOutlet weak var deleteBtnTop: NSLayoutConstraint!
    
    @IBOutlet weak var btnOnOff: UIButton!
    @IBOutlet weak var vwOpenClose: UIView!
    @IBOutlet weak var heightDeleteBtn: NSLayoutConstraint!
    @IBOutlet weak var heightTblVw: NSLayoutConstraint!
    @IBOutlet weak var heightEditVw: NSLayoutConstraint!
    @IBOutlet weak var topStackVw: NSLayoutConstraint!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnAddItem: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var tblVwItems: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgVwPopup: UIImageView!
    
    var popupId:String?
    var viewModel = PopUpVM()
    var viewModelItem = ItemsVM()
    private var fullText = ""
    private var isExpanded = false
    var popupDetails:PopupDetailData?
    var callBack:(()->())?
    private var heightDescription = 0
    private var reviewHeight = 0
    private var arrItems = [AddItems]()
    var groupedItems = [String: [AddItems]]()
    var sortedCategories = [String]()
    
    // MARK: - Lifecycle
       override func viewDidLoad() {
           super.viewDidLoad()
        
           setupUI()
           tblVwItems.rowHeight = UITableView.automaticDimension
           tblVwItems.estimatedRowHeight = 100
       }

    override func viewWillLayoutSubviews() {
           self.tblVwItems.reloadData()
          self.tblVwItems.layoutIfNeeded()
          self.heightTblVw.constant = self.tblVwItems.contentSize.height + 10
    }

       // MARK: - UI Setup
       private func setupUI() {
           configureTableView()
           addShadowToView(vwDetail)
           addDescriptionTapGesture()
           fetchPopupDetails()
       }

       private func configureTableView() {
           tblVwItems.register(UINib(nibName: "ItemHeaderTVC", bundle: nil), forCellReuseIdentifier: "ItemHeaderTVC")
           tblVwItems.register(UINib(nibName: "ItemCategoryTVC", bundle: nil), forCellReuseIdentifier: "ItemCategoryTVC")
         
       }

       private func addShadowToView(_ view: UIView) {
           view.layer.shadowColor = UIColor.black.cgColor
           view.layer.shadowOpacity = 0.2
           view.layer.shadowOffset = CGSize(width: 4, height: 4)
           view.layer.shadowRadius = 4
           view.layer.masksToBounds = false
       }

       private func addDescriptionTapGesture() {
           lblDescription.isUserInteractionEnabled = true
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDescription))
           lblDescription.addGestureRecognizer(tapGesture)
       }

       // MARK: - Description Toggle
       @objc private func toggleDescription() {
           guard lblDescription.text?.contains("Read") == true else { return }
           isExpanded.toggle()
           if isExpanded {
               lblDescription.appendReadLess(after: fullText, trailingContent: .readless)
           } else {
               lblDescription.appendReadmore(after: fullText, trailingContent: .readmore)
           }

           UIView.animate(withDuration: 0.1) {
               self.view.layoutIfNeeded()
           }
       }

       // MARK: - API Call
       private func fetchPopupDetails() {
           viewModel.getPopupDetailApi(loader: true, popupId: popupId ?? "") { [weak self] data in
               guard let self = self, let data = data else { return }

               self.popupDetails = data
               self.configurePopupStatus(data)
               self.populatePopupDetails(data)
               self.groupItemsByCategory()
            
               self.updateTableViewHeight()

               self.lblDate.text = self.getClosedDaysText(from: data.closedDays)
           }
       }

       private func configurePopupStatus(_ data: PopupDetailData) {
           btnOnOff.isHidden = false
           vwOpenClose.isHidden = !(data.isClosed ?? false)
           btnOnOff.isSelected = !(data.isClosed ?? false)

           switch data.popupStatus {
           case "upcoming":
               toggleEditSection(showEdit: true, showDelete: true)
           case "ongoing":
               toggleEditSection(showEdit: true, showDelete: false)
           default:
               toggleEditSection(showEdit: false, showDelete: false)
           }
       }

       private func toggleEditSection(showEdit: Bool, showDelete: Bool) {
           btnAddItem.isHidden = !showEdit
           btnEdit.isHidden = !showEdit
           btnDelete.isHidden = !showDelete
           heightEditVw.constant = showEdit ? 50 : 0
           heightDeleteBtn.constant = showDelete ? 50 : 0
           deleteBtnTop.constant = showDelete ? 20 : 0
       }

       private func populatePopupDetails(_ data: PopupDetailData) {
           lblName.text = data.name
           lblAddress.text = data.place
           imgVwPopup.imageLoad(imageUrl: data.businessLogo ?? "")

           fullText = data.description ?? ""
           lblDescription.appendReadmore(after: fullText, trailingContent: .readmore)

           let startTime = convertUpdateDateString(data.startDate ?? "")
           let endTime = convertUpdateDateString(data.endDate ?? "")
           lblTime.text = "\(startTime ?? "") - \(endTime ?? "")"

           arrItems = data.addItems ?? []
       }

       private func updateTableViewHeight() {
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
               self.tblVwItems.reloadData()
                 self.tblVwItems.layoutIfNeeded()
                 self.heightTblVw.constant = self.tblVwItems.contentSize.height + 10
            
           }
       }

       private func getClosedDaysText(from rawArray: [String]?) -> String {
           guard let jsonString = rawArray?.first,
                 let jsonData = jsonString.data(using: .utf8),
                 let daysArray = try? JSONDecoder().decode([String].self, from: jsonData) else {
               return "Open all week"
           }
           return "Closed on: \(daysArray.joined(separator: ", "))"
       }

       // MARK: - Helper Methods
       private func groupItemsByCategory() {
           groupedItems = Dictionary(grouping: arrItems, by: { $0.itemCategory ?? "" })
           sortedCategories = groupedItems.keys.sorted()
       }

       private func convertUpdateDateString(_ dateString: String, outputFormat: String = "h:mm a") -> String? {
           let formats = ["yyyy-MM-dd'T'HH:mm:ss.SSSZ", "yyyy-MM-dd'T'HH:mm:ssZ"]
           let formatter = DateFormatter()
           formatter.locale = Locale(identifier: "en_US_POSIX")
           
           for format in formats {
               formatter.dateFormat = format
               if let date = formatter.date(from: dateString) {
                   formatter.dateFormat = outputFormat
                   return formatter.string(from: date)
               }
           }
           return nil
       }

       // MARK: - Actions
       @IBAction func actionBack(_ sender: UIButton) {
           navigationController?.popViewController(animated: true)
           callBack?()
       }

       @IBAction func actionEdit(_ sender: UIButton) {
           guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddPopUpVC") as? AddPopUpVC else { return }
           vc.isComing = true
           vc.popupDetails = popupDetails
           navigationController?.pushViewController(vc, animated: true)
       }

       @IBAction func actionAddItem(_ sender: UIButton) {
           guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddItemsVC") as? AddItemsVC else { return }
           vc.addSingleItem = true
           vc.popupId = popupId
           vc.callBackEdit = { [weak self] _ in self?.fetchPopupDetails() }
           navigationController?.pushViewController(vc, animated: true)
       }

       @IBAction func actionDelete(_ sender: UIButton) {
           guard let cancelVC = storyboard?.instantiateViewController(withIdentifier: "CancelGigVC") as? CancelGigVC else { return }
           cancelVC.isSelect = 2
           cancelVC.popupId = popupDetails?.id ?? ""
           cancelVC.modalPresentationStyle = .overFullScreen
           cancelVC.callBack = { [weak self] message in
               guard let self = self,
                     let popupVC = storyboard?.instantiateViewController(withIdentifier: "CommonPopUpVC") as? CommonPopUpVC else { return }
               popupVC.modalPresentationStyle = .overFullScreen
               popupVC.isSelect = 10
               popupVC.message = message
               popupVC.callBack = {
                   self.navigationController?.popViewController(animated: true)
                   self.callBack?()
               }
               self.navigationController?.present(popupVC, animated: false)
           }
           navigationController?.present(cancelVC, animated: false)
       }

       @IBAction func actionOnOff(_ sender: UIButton) {
           sender.isSelected.toggle()
           vwOpenClose.isHidden = sender.isSelected
           openCloseStoreApi(isOpen: !sender.isSelected)
       }

       private func openCloseStoreApi(isOpen: Bool) {
           viewModel.openCloseStoreApi(popUpId: popupDetails?.id ?? "", status: isOpen) { _ in }
       }
   }


extension PopupdetailownerItemVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemHeaderTVC") as? ItemHeaderTVC else {
            return nil
        }
        cell.lblName.text = sortedCategories[section]
        cell.btnSeeAll.isHidden = true
        cell.contentView.backgroundColor = .white
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCategoryTVC", for: indexPath) as? ItemCategoryTVC else {
            return UITableViewCell()
        }

        let category = sortedCategories[indexPath.section]
        if let items = groupedItems[category] {
            cell.configure(with: items, isType: false, isMyPopup: true, viewSummary: false)
        }
      
        cell.callBackSoldItem = { [weak self] _, itemDetail, soldItems in
            self?.markItemSold(itemDetail: itemDetail, soldItems: soldItems)
        }

        cell.callBack = { [weak self] type, itemDetail, soldItems in
            self?.handleItemAction(type: type ?? 0, itemDetail: itemDetail, soldItems: soldItems)
        }
        
        return cell
    }
   

    // MARK: - Helper Methods

    private func markItemSold(itemDetail: AddItems?, soldItems: Double) {
        guard let itemId = itemDetail?.id, let popupId = popupId else { return }
        viewModelItem.marksoldItemApi(popUpId: popupId, itemId: itemId, soldItems: Double(soldItems)) { [weak self] _ in
            self?.presentInventoryPopupVC()
        }
    }

    private func handleItemAction(type: Int, itemDetail: AddItems?, soldItems: Double) {
        guard let itemDetail = itemDetail else { return }

        switch type {
        case 0:
            let vc = instantiateVC(AddItemsVC.self, id: "AddItemsVC")
            vc.isComingEdit = true
            vc.itemDetail = itemDetail
            vc.popupId = popupId ?? ""
            vc.callBackEdit = { [weak self] _ in self?.fetchPopupDetails() }
            navigationController?.pushViewController(vc, animated: true)

        case 3:
            markItemSold(itemDetail: itemDetail, soldItems: soldItems)

        default:
            let vc = instantiateVC(CancelGigVC.self, id: "CancelGigVC")
            vc.isSelect = 7
            vc.popupId = popupDetails?.id ?? ""
            vc.itemId = itemDetail.id ?? ""
            vc.modalPresentationStyle = .overFullScreen
            vc.callBack = { [weak self] message in
                showSwiftyAlert("", message ?? "", true)
                self?.fetchPopupDetails()
            }
            navigationController?.present(vc, animated: false)
        }
    }

    private func presentInventoryPopupVC() {
        let vc = instantiateVC(InventoryPopupVC.self, id: "InventoryPopupVC")
        vc.modalPresentationStyle = .overFullScreen
        vc.callBack = { [weak self] in self?.fetchPopupDetails() }
        navigationController?.present(vc, animated: true)
    }

    private func instantiateVC<T: UIViewController>(_ type: T.Type, id: String) -> T {
        return storyboard?.instantiateViewController(withIdentifier: id) as! T
    }
}
