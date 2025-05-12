//
//  ItemCategoryTVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 23/04/25.
//

import UIKit

class ItemCategoryTVC: UITableViewCell {

    @IBOutlet weak var heightCollVw: NSLayoutConstraint!
    
    @IBOutlet weak var collVwItems: UICollectionView!
    
    var type:Bool?
    var items: [AddItems] = []
    var allItem: [AllItem] = []
    var selectedItem: [AllItem] = []
    var selectedItemMark: [AddItems] = []
    var soldCount: Double = 0
    var itemDetail:AddItems?
    var callBack:((_ type:Int?,_ itemDetail:AddItems?,_ soldItem:Double)->())?
    var callBackSelectItem:((_ type:String,_ item:AllItem)->())?
    var callBackMarkSelectItem:((_ type:String,_ item:AddItems)->())?
    var callBackSoldItem:((_ type:Int?,_ itemDetail:AddItems?,_ soldItem:Double)->())?
    var callBackCross:((_ item:AddItems?)->())?
    var arrEditItems = [AddItems]()
  
    var isComingFromSeeAll = false
    var isAdd = false
    var isMyPopup = false
    var viewSummary = false
    var isSelect = false
    override func awakeFromNib() {
        super.awakeFromNib()
 
    
        collVwItems.delegate = self
        collVwItems.dataSource = self
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateCollectionViewHeight()
    }
    private func updateCollectionViewHeight() {
        self.collVwItems.layoutIfNeeded()
        let height = self.collVwItems.collectionViewLayout.collectionViewContentSize.height + 10
        self.heightCollVw.constant = height
        self.layoutIfNeeded()
        
        // Inform the table view to re-calculate height
       
            if let tableView = self.superview(of: UITableView.self) {
                tableView.beginUpdates()
                tableView.endUpdates()
               
            }
         
    }
    func uiSet(){
       
        if type ?? false{
          
            let nibCategory = UINib(nibName: "AddItemCVC", bundle: nil)
            collVwItems.register(nibCategory, forCellWithReuseIdentifier: "AddItemCVC")
        }else{
            if isMyPopup{
                let nibCategory = UINib(nibName: "MarkSoldCVC", bundle: nil)
                collVwItems.register(nibCategory, forCellWithReuseIdentifier: "MarkSoldCVC")
                let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
                collVwItems.addGestureRecognizer(longPressGesture)
            }else{
                let nibCategory = UINib(nibName: "AddItemCVC", bundle: nil)
                collVwItems.register(nibCategory, forCellWithReuseIdentifier: "AddItemCVC")
            }
        }
        
       }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: collVwItems)
            
            if let indexPath = collVwItems.indexPathForItem(at: point) {
                let cell = collVwItems.cellForItem(at: IndexPath(row: indexPath.row, section: 0)) as! MarkSoldCVC
                cell.vwEditDelete.isHidden = false
                cell.btnEdit.addTarget(self, action: #selector(editItem), for: .touchUpInside)
                cell.btnEdit.tag = indexPath.row
                cell.btndelete.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
                cell.btndelete.tag = indexPath.row
            }
        }
    }
    
    @objc func editItem(sender:UIButton){
        let cell = collVwItems.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as! MarkSoldCVC
        cell.vwEditDelete.isHidden = true
        callBack?(0,items[sender.tag], 0)
    }
    
    @objc func deleteItem(sender:UIButton){
        let cell = collVwItems.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as! MarkSoldCVC
        cell.vwEditDelete.isHidden = true
        callBack?(1,items[sender.tag], 0)
    }
    
    func configure(with item: [AddItems], isType: Bool,isMyPopup:Bool,viewSummary:Bool) {
        isComingFromSeeAll = false
        var addedIds = Set<String>()
        self.items = item.filter {
            if let id = $0.id, !addedIds.contains(id) {
                addedIds.insert(id)
                return true
            }
            return false
        }
        self.type = isType
        self.isMyPopup = isMyPopup
        self.viewSummary = viewSummary
        if viewSummary{
            self.collVwItems.isScrollEnabled = false
        }else{
            self.collVwItems.isScrollEnabled = true
        }
        uiSet()
        collVwItems.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateCollectionViewHeight()
        }
    }

    func configureAllItem(with item: [AllItem], isType: Bool) {
        isComingFromSeeAll = false
        var addedIds = Set<String>()
        self.allItem = item.filter {
            if let id = $0.item?.id, !addedIds.contains(id) {
                addedIds.insert(id)
                return true
            }
            return false
        }
        self.type = isType
        uiSet()
        collVwItems.reloadData()
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateCollectionViewHeight()
        }
    }
    func configureAddItem(with item: [AddItems], isType: Bool,isAdd:Bool,isViewSummary:Bool) {
        isComingFromSeeAll = true
        self.arrEditItems = item
        self.viewSummary = isViewSummary

        self.type = isType
        uiSet()
        
        collVwItems.reloadData()
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ItemCategoryTVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type ?? false{
            if isComingFromSeeAll{
                
                    return arrEditItems.count
                
            }else{
                return allItem.count
            }
            
        }else{
            return items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if type ?? false{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddItemCVC", for: indexPath) as! AddItemCVC
            cell.vwBackground.addTopShadow(shadowColor: UIColor(hex: "000000").withAlphaComponent(0.3), shadowOpacity: 1.0, shadowRadius: 3, offset:CGSize(width: 2, height: 2))
          
            if isComingFromSeeAll{
              
                    if self.viewSummary{
                    cell.btnDelete.isHidden = true
                    }else{
                    cell.btnDelete.isHidden = false
                    }
                    cell.btnSelect.isHidden = true
                    let itemData = arrEditItems[indexPath.row]
                    cell.lblItemName.text = itemData.itemName ?? ""
                   
                    cell.imgVwItem.imageLoad(imageUrl: itemData.image?[0] ?? "")
                   
                    let sellingPrice = itemData.sellingPrice ?? 0
                    let discount = itemData.discount ?? 0
                    let discountType = itemData.discountType ?? 0
                    if itemData.discount == 0{
                        cell.lblOff.isHidden = true
                        cell.lblTotalPrice.isHidden = true
                        cell.lblActualPrice.isHidden = false
                        cell.lblLine.isHidden = true
                    }else{
                        cell.lblOff.isHidden = false
                        cell.lblTotalPrice.isHidden = false
                        cell.lblActualPrice.isHidden = false
                        cell.lblLine.isHidden = false
                    }
                    cell.lblTotalPrice.text = "$\(sellingPrice)"
                   
                    var finalPrice: Double = Double(sellingPrice)

                    if discountType == 0 {
                        // Fixed amount off
                        cell.lblOff.text = "$\(discount) off"
                        finalPrice = Double(sellingPrice) - Double(discount)
                    } else {
                        // Percentage off
                        cell.lblOff.text = "\(discount)% off"
                        finalPrice = Double(sellingPrice) - (Double(sellingPrice) * Double(discount) / 100.0)
                    }

                    // Show the final price after discount with two decimal places
                    cell.lblActualPrice.text = String(format: "$%.2f", finalPrice)
                cell.btnDelete.addTarget(self, action: #selector(crossItems), for: .touchUpInside)
                cell.btnDelete.tag = indexPath.row
            }else{
                cell.btnDelete.isHidden = true
                cell.btnSelect.isHidden = false
                let itemData = allItem[indexPath.row].item
                cell.lblItemName.text = itemData?.itemName ?? ""
                if selectedItem.contains(where: { $0.item?.id == allItem[indexPath.row].item?.id }) {
                    cell.btnSelect.isSelected = true
                    cell.btnSelect.setTitle("Deselect", for: .normal)
                    cell.vwBackground.backgroundColor = UIColor(hex: "#FBE7B8")
                    cell.btnSelect.setTitleColor(.black, for: .normal)
                }else{
                    cell.btnSelect.isSelected = false
                    cell.btnSelect.setTitle("Select", for: .normal)
                    cell.vwBackground.backgroundColor = .white
                    cell.btnSelect.setTitleColor(.black, for: .normal)
                }
                cell.imgVwItem.imageLoad(imageUrl: itemData?.image?[0] ?? "")
               
                let sellingPrice = itemData?.sellingPrice ?? 0
                let discount = itemData?.discount ?? 0
                let discountType = itemData?.discountType ?? 0
                if itemData?.discount == 0{
                    cell.lblOff.isHidden = true
                    cell.lblTotalPrice.isHidden = true
                    cell.lblActualPrice.isHidden = false
                    cell.lblLine.isHidden = true
                }else{
                    cell.lblOff.isHidden = false
                    cell.lblTotalPrice.isHidden = false
                    cell.lblActualPrice.isHidden = false
                    cell.lblLine.isHidden = false
                }
                cell.lblTotalPrice.text = "$\(sellingPrice)"
               
                var finalPrice: Double = Double(sellingPrice)

                if discountType == 0 {
                    // Fixed amount off
                    cell.lblOff.text = "$\(discount) off"
                    finalPrice = Double(sellingPrice) - Double(discount)
                } else {
                    // Percentage off
                    cell.lblOff.text = "\(discount)% off"
                    finalPrice = Double(sellingPrice) - (Double(sellingPrice) * Double(discount) / 100.0)
                }

                // Show the final price after discount with two decimal places
                cell.lblActualPrice.text = String(format: "$%.2f", finalPrice)
                cell.btnSelect.addTarget(self, action: #selector(selectItem), for: .touchUpInside)
                cell.btnSelect.tag = indexPath.row
            }
         
          
            return cell
        }else{
         
            if isMyPopup{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarkSoldCVC", for: indexPath) as! MarkSoldCVC
                let item = items[indexPath.item]
                print("Item---",item)
                cell.uiSet()
                cell.lblName.text = item.itemName ?? ""
                cell.selectedItems = self.items
                cell.txtFldWeight.tag = indexPath.row
                cell.selectedItems = items
                cell.imgVwItem.imageLoad(imageUrl: item.image?[0] ?? "")
                cell.lblQuantity.text = "\(0)"
                cell.txtFldWeight.text = ""
                let sellingPrice = item.sellingPrice ?? 0
                let discount = item.discount ?? 0
                let discountType = item.discountType ?? 0
                setGradientBackground(for: cell.vwGradiant, colors: [.clear, .clear])
                if item.sellingType == 0 {
                    if item.stockType == 0 {
                        if item.totalStock ?? 0.0 < 20 {
                            setGradientBackground(for: cell.vwGradiant, colors: [UIColor(hex: "#FB0000").withAlphaComponent(0.3), UIColor(hex: "#FFFFFF").withAlphaComponent(0.5)])
                        }
                    } else {
                        if item.totalStock ?? 0.0 < 5 {
                            setGradientBackground(for: cell.vwGradiant, colors: [UIColor(hex: "#FB0000").withAlphaComponent(0.3), UIColor(hex: "#FFFFFF").withAlphaComponent(0.5)])
                        }
                    }
                } else {
                    if item.totalStock ?? 0.0 < 10 {
                        setGradientBackground(for: cell.vwGradiant, colors: [UIColor(hex: "#FB0000").withAlphaComponent(0.3), UIColor(hex: "#FFFFFF").withAlphaComponent(0.5)])
                    }
                }
              
                if item.discount == 0{
                    cell.lblOff.isHidden = true
                    cell.lblOffPrice.isHidden = true
                    cell.lblActualPrice.isHidden = false
                    cell.lblLine.isHidden = true
                }else{
                    cell.lblOff.isHidden = false
                    cell.lblOffPrice.isHidden = false
                    cell.lblActualPrice.isHidden = false
                    cell.lblLine.isHidden = false
                }
                cell.lblOffPrice.text = "$\(sellingPrice)"
                
                var finalPrice: Double = Double(sellingPrice)
                
                if discountType == 0 {
                    // Fixed amount off
                    cell.lblOff.text = "$\(discount) off"
                    finalPrice = Double(sellingPrice) - Double(discount)
                } else {
                    // Percentage off
                    cell.lblOff.text = "\(discount)% off"
                    finalPrice = Double(sellingPrice) - (Double(sellingPrice) * Double(discount) / 100.0)
                }
                
                // Show the final price after discount with two decimal places
                cell.lblActualPrice.text = String(format: "$%.2f", finalPrice)
                
                if item.sellingType == 0{
                    if item.stockType == 0{
                        cell.lblAvailability.text = String(format: "Availability: %.2f g", item.totalStock ?? 0.0)
                        cell.lblSoldUnit.text = String(format: "Sold: %.2f g", item.soldItems ?? 0.0)
                        cell.vwSold.isHidden = false
                        cell.vwQuantity.isHidden = true
                    }else{
                        cell.lblAvailability.text = String(format: "Availability: %.2f kg", item.totalStock ?? 0.0)
                        cell.lblSoldUnit.text = String(format: "Sold: %.2f kg", item.soldItems ?? 0.0)
                        cell.vwSold.isHidden = false
                        cell.vwQuantity.isHidden = true
                    }
                    
                }else{
                    cell.lblSoldUnit.text = "Sold: \(Int(item.soldItems ?? 0)) Unit"
                    cell.vwSold.isHidden = true
                    cell.vwQuantity.isHidden = false
                    cell.lblAvailability.text = "Availability: \(Int(item.totalStock ?? 0)) Unit"
                }
                
                cell.vwBackground.addTopShadow(shadowColor: UIColor(hex: "000000").withAlphaComponent(0.3), shadowOpacity: 1.0, shadowRadius: 3, offset:CGSize(width: 2, height: 2))
              
                cell.btnPlus.addTarget(self, action: #selector(plusItems), for: .touchUpInside)
                cell.btnPlus.tag = indexPath.row
                cell.btnMinus.addTarget(self, action: #selector(minusItems), for: .touchUpInside)
                cell.btnMinus.tag = indexPath.row
                cell.btnMarkSold.addTarget(self, action: #selector(markSold), for: .touchUpInside)
                cell.btnMarkSold.tag = indexPath.row
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddItemCVC", for: indexPath) as! AddItemCVC
                cell.vwBackground.addTopShadow(shadowColor: UIColor(hex: "000000").withAlphaComponent(0.3), shadowOpacity: 1.0, shadowRadius: 3, offset:CGSize(width: 2, height: 2))
                cell.btnDelete.isHidden = true
                cell.btnSelect.isHidden = false
                let itemData = items[indexPath.row]
                cell.lblItemName.text = itemData.itemName ?? ""
                if selectedItemMark.contains(where: { $0.id == items[indexPath.row].id }) {
                    cell.btnSelect.isSelected = true
                    cell.btnSelect.setTitle("Remove", for: .normal)
                    cell.vwBackground.backgroundColor = UIColor(hex: "#FBE7B8")
                    cell.btnSelect.setTitleColor(.black, for: .normal)
                }else{
                    cell.btnSelect.isSelected = false
                    cell.btnSelect.setTitle("Add", for: .normal)
                    cell.vwBackground.backgroundColor = .white
                    cell.btnSelect.setTitleColor(.black, for: .normal)
                }
                cell.imgVwItem.imageLoad(imageUrl: itemData.image?[0] ?? "")
               
                let sellingPrice = itemData.sellingPrice ?? 0
                let discount = itemData.discount ?? 0
                let discountType = itemData.discountType ?? 0
                if itemData.discount == 0{
                    cell.lblOff.isHidden = true
                    cell.lblTotalPrice.isHidden = true
                    cell.lblActualPrice.isHidden = false
                    cell.lblLine.isHidden = true
                }else{
                    cell.lblOff.isHidden = false
                    cell.lblTotalPrice.isHidden = false
                    cell.lblActualPrice.isHidden = false
                    cell.lblLine.isHidden = false
                }
                cell.lblTotalPrice.text = "$\(sellingPrice)"
               
                var finalPrice: Double = Double(sellingPrice)

                if discountType == 0 {
                    // Fixed amount off
                    cell.lblOff.text = "$\(discount) off"
                    finalPrice = Double(sellingPrice) - Double(discount)
                } else {
                    // Percentage off
                    cell.lblOff.text = "\(discount)% off"
                    finalPrice = Double(sellingPrice) - (Double(sellingPrice) * Double(discount) / 100.0)
                }

                // Show the final price after discount with two decimal places
                cell.lblActualPrice.text = String(format: "$%.2f", finalPrice)
                cell.btnSelect.addTarget(self, action: #selector(markSelectedItem), for: .touchUpInside)
                cell.btnSelect.tag = indexPath.row
                if self.viewSummary{
                    cell.btnSelect.isHidden = true
                }else{
                    cell.btnSelect.isHidden = false
                }
                return cell
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isMyPopup{
            let cell = collectionView.cellForItem(at: IndexPath(row: indexPath.row, section: 0)) as! MarkSoldCVC
            cell.vwEditDelete.isHidden = true
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if type ?? false{
            return CGSize(width: collVwItems.frame.width/2-2, height:220)
        }else{
            if isMyPopup{
                return CGSize(width: collVwItems.frame.width/2-0, height:250)
            }else{
                return CGSize(width: collVwItems.frame.width/2-0, height:220)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if type ?? false{
            return 2
        }else{
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if type ?? false{
            return 2
        }else{
            return 0
        }
    }
    
    @objc func selectItem(sender: UIButton) {
        sender.isSelected.toggle()

        guard let cell = collVwItems.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as? AddItemCVC else { return }

        if sender.isSelected {
            cell.vwBackground.backgroundColor = UIColor(hex: "#FBE7B8")
            cell.btnSelect.setTitle("Deselect", for: .normal)
            callBackSelectItem?("select", allItem[sender.tag])
        } else {
            cell.vwBackground.backgroundColor = .white
            cell.btnSelect.setTitle("Select", for: .normal)
            callBackSelectItem?("deselect", allItem[sender.tag])
        }

        cell.btnSelect.setTitleColor(.black, for: .normal)
        cell.btnSelect.setTitleColor(.black, for: .selected) // optional
    }
    @objc func markSelectedItem(sender: UIButton) {
        sender.isSelected.toggle()

        guard let cell = collVwItems.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as? AddItemCVC else { return }

        if sender.isSelected {
            cell.vwBackground.backgroundColor = UIColor(hex: "#FBE7B8")
            cell.btnSelect.setTitle("Remove", for: .normal)
            callBackMarkSelectItem?("Remove", items[sender.tag])
        } else {
            cell.vwBackground.backgroundColor = .white
            cell.btnSelect.setTitle("Add", for: .normal)
            callBackMarkSelectItem?("Add", items[sender.tag])
        }

        cell.btnSelect.setTitleColor(.black, for: .normal)
        cell.btnSelect.setTitleColor(.black, for: .selected) // optional
    }
   
    @objc func plusItems(sender: UIButton) {
        guard let cell = collVwItems.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as? MarkSoldCVC else { return }
        let item = items[sender.tag]
        let totalStock = item.totalStock ?? 0

        if soldCount < totalStock {
            soldCount += 1
            cell.lblQuantity.text = "\(Int(soldCount))"
        } else {
            showSwiftyAlert("", "Cannot sell more than available stock.", false)
        
        }
    }
    
    @objc func minusItems(sender: UIButton) {
        let cell = collVwItems.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as! MarkSoldCVC

        if soldCount > 0 {
            soldCount -= 1
        }

        cell.lblQuantity.text = "\(Int(soldCount))"
    }
    @objc func markSold(sender:UIButton){
        let cell = collVwItems.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as! MarkSoldCVC
        if items[sender.tag].sellingType == 0{
            callBackSoldItem?(3,items[sender.tag],Double(cell.txtFldWeight.text ?? "") ?? 0)
        }else{
            callBack?(3,items[sender.tag],Double(cell.lblQuantity.text ?? "") ?? 0)
        }
    }
    @objc func crossItems(sender:UIButton){
        callBackCross?(arrEditItems[sender.tag])
    }
    func setGradientBackground(for view: UIView, colors: [UIColor], cornerRadius: CGFloat = 10.0) {
        // Remove existing gradient layers
        view.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colors.map { $0.cgColor }
        
        // Set gradient direction: top to bottom
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        // Set corner radius
        gradient.cornerRadius = cornerRadius
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true

        view.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIView {
    func superview<T: UIView>(of type: T.Type) -> T? {
        var currentSuperview = self.superview
        while let superview = currentSuperview {
            if let typedSuperview = superview as? T {
                return typedSuperview
            }
            currentSuperview = superview.superview
        }
        return nil
    }
}
