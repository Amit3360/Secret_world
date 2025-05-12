//
//  CreateMembershipVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 09/05/25.
//

import UIKit

struct Membership {
    let priceType: String?
    let price: Double?
    let benefits:String?
    
    init(priceType: String?, price: Double?, benefits: String?) {
        self.priceType = priceType
        self.price = price
        self.benefits = benefits
    }
}
struct MembershipService {
    let serviceId: String?
    let name: String?
    init(serviceId: String?, name: String?) {
        self.serviceId = serviceId
        self.name = name
    }
}

class CreateMembershipVC: UIViewController {

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var heightCollVwCategory: NSLayoutConstraint!
    @IBOutlet weak var heightTblVwPlan: NSLayoutConstraint!
    @IBOutlet weak var collVwCategory: UICollectionView!
    @IBOutlet weak var btnSelectAll: UIButton!
    @IBOutlet weak var tblVwPlan: UITableView!
    @IBOutlet weak var txtFldMembershipName: UITextField!
    @IBOutlet weak var lblHeader: UILabel!
    
    
 
    var viewModelService = AddServiceVM()
    var viewModel = MembershipVM()

    var arrService: [MembershipService] = []
    var arrPlan: [Membership] = []
    var selectServiceId: [MembershipService] = []
    var selectAllServieId: [MembershipService] = []

    var isComing = false
    var memberShipData: MembershipData?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchServices()
       
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateTableViewHeight()
    }

    private func fetchServices() {
        print(Store.authKey ?? "")
        viewModelService.getAllService(loader: false, offSet: 1, limit: 1000) { [weak self] data in
            guard let self = self else { return }
            for i in data?.service ?? []{
                self.arrService.append(MembershipService(serviceId: i._id ?? "", name: i.serviceName ?? ""))
            }
            DispatchQueue.main.async {
                self.collVwCategory.reloadData()
            }
        }
        isComing ? loadExistingMembership() : arrPlan.append(Membership(priceType: "", price: 0, benefits: ""))
        lblHeader.text = isComing ? "Update Membership" : "Create Membership"
        btnSave.setTitle(isComing ? "Update" : "Save", for: .normal)
    }

    private func loadExistingMembership() {
        txtFldMembershipName.text = memberShipData?.name ?? ""

        arrPlan = memberShipData?.plans?.compactMap {
            Membership(priceType: $0.type, price: $0.price, benefits: $0.benefits)
        } ?? []

        selectServiceId = memberShipData?.services?.compactMap {
            MembershipService(serviceId: $0.serviceID ?? "", name: $0.name ?? "")
        } ?? []

        DispatchQueue.main.async {
            self.collVwCategory.reloadData()
            self.tblVwPlan.reloadData()
        }
    }

    private func updateTableViewHeight() {
        tblVwPlan.reloadData()
        tblVwPlan.layoutIfNeeded()
        heightTblVwPlan.constant = tblVwPlan.contentSize.height + 10
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        self.view.endEditing(true) // Dismiss keyboard

         guard let name = txtFldMembershipName.text?.trimWhiteSpace, !name.isEmpty else {
             showSwiftyAlert("", "Enter membership name.", false)
             return
         }

         for (index, _) in arrPlan.enumerated() {
             guard let cell = tblVwPlan.cellForRow(at: IndexPath(row: index, section: 0)) as? AddMembershipTVC else { continue }

             let priceType = cell.txtFldPlanType.text?.trimWhiteSpace ?? ""
             let priceText = cell.txtFldPrice.text?.trimWhiteSpace ?? "0"
             let price = Double(priceText) ?? 0
             let benefits = cell.txtVwDescription.text?.trimWhiteSpace ?? ""

             // Validation
             if priceType.isEmpty {
                 showSwiftyAlert("", "Choose pricing type.", false)
                 return
             }

             if price == 0 {
                 showSwiftyAlert("", "Enter price.", false)
                 return
             }

             if benefits.isEmpty {
                 showSwiftyAlert("", "Enter benefits.", false)
                 return
             }

             arrPlan[index] = Membership(priceType: priceType, price: price, benefits: benefits)
         }

         guard !selectServiceId.isEmpty else {
             showSwiftyAlert("", "Select any service.", false)
             return
         }

         print(arrPlan)
        if isComing{
            viewModel.editMembershipApi(id: memberShipData?.id ?? "", membershipName: txtFldMembershipName.text ?? "", arrPlan: arrPlan, service: selectServiceId) {
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            viewModel.createMembershipApi(membershipName: txtFldMembershipName.text ?? "", arrPlan: arrPlan, service: selectServiceId) {
                self.navigationController?.popViewController(animated: true)
            }
        }
      
         
    }
    
    @IBAction func actionSelectAllCategory(_ sender: UIButton) {
        self.selectServiceId.append(contentsOf: selectAllServieId)
        self.collVwCategory.reloadData()
    }
    
    @IBAction func actionCreateNewPlan(_ sender: UIButton) {
        if arrPlan.count < 4{
            self.arrPlan.append(Membership(priceType: "", price: 0, benefits: ""))
            self.tblVwPlan.reloadData()
            self.tblVwPlan.layoutIfNeeded()
            self.heightTblVwPlan.constant = self.tblVwPlan.contentSize.height + 10
        }else{
            showSwiftyAlert("", "Add maximum 4 plans", false)
        }
    }
    
}

extension CreateMembershipVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPlan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddMembershipTVC", for: indexPath) as! AddMembershipTVC
        if isComing{
            cell.txtFldPlanType.text = arrPlan[indexPath.row].priceType ?? ""
            cell.txtFldPlanType.textColor = .black
            cell.txtFldPrice.text = "\(arrPlan[indexPath.row].price ?? 0)"
            cell.txtVwDescription.text = arrPlan[indexPath.row].benefits ?? ""
          
        }
        cell.vwPlan.addTopShadow(shadowColor: .black, shadowOpacity: 0.25, shadowRadius: 3.0, offset: CGSize(width: 3.0, height: 3.0))
        cell.lblPlan.text = "Plan \(indexPath.row+1)"
        cell.btnDropdownPrice.addTarget(self, action: #selector(choosePriceType), for: .touchUpInside)
        cell.btnDropdownPrice.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deletePlan), for: .touchUpInside)
        cell.btnDelete.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    @objc func choosePriceType(sender:UIButton){
        view.endEditing(true)
        let cell = tblVwPlan.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! AddMembershipTVC
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
        vc.type = "choosePriceType"
        vc.matchTitle = cell.txtFldPlanType.text ?? ""
        vc.modalPresentationStyle = .popover
        vc.callBackBusiness = {[weak self] (name,index) in
            guard let self = self else { return }
         
            cell.txtFldPlanType.text = name
            cell.txtFldPlanType.textColor = .black
        }
        let height = CGFloat(200)
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .up
        vc.preferredContentSize = CGSize(width: cell.txtFldPlanType.frame.size.width, height: height)
        self.present(vc, animated: false)
    }
    
    @objc func deletePlan(sender: UIButton) {
        let index = sender.tag
        guard index < arrPlan.count else { return }
        
        arrPlan.remove(at: index)
        tblVwPlan.reloadData()
        tblVwPlan.layoutIfNeeded()
        heightTblVwPlan.constant = tblVwPlan.contentSize.height + 10
    }
}

extension CreateMembershipVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrService.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureCVC", for: indexPath) as! FeatureCVC
        cell.lblName.text = arrService[indexPath.row].name ?? ""
        cell.btnTick.addTarget(self, action: #selector(tickUntick), for: .touchUpInside)
        cell.btnTick.tag = indexPath.row
        print(selectServiceId)
        print(arrService)
        if let id = arrService[indexPath.row].serviceId,
           selectServiceId.contains(where: { $0.serviceId == id }) {
            cell.btnTick.isSelected = true
        } else {
            cell.btnTick.isSelected = false
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2-0, height: 32)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func tickUntick(sender: UIButton) {
        sender.isSelected.toggle()
        print(sender.tag, sender.isSelected)
        let service = arrService[sender.tag]
        let serviceObj = MembershipService(serviceId: service.serviceId, name: service.name)
        
        if sender.isSelected {
            selectServiceId.append(serviceObj)
        } else {
            if let index = selectServiceId.firstIndex(where: { $0.serviceId == service.serviceId }) {
                selectServiceId.remove(at: index)
            }
        }
        
    }
}

// MARK: - CreateMembershipVC
extension CreateMembershipVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}

