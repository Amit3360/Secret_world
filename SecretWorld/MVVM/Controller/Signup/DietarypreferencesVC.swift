//
//  DietarypreferencesVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 22/12/23.
//

import UIKit


class DietarypreferencesVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var txtFldSearch: UITextField!
    @IBOutlet var lblTitleOfScreen: UILabel!
    @IBOutlet var viewShadow: UIView!
    @IBOutlet var tblVwDietry: UITableView!
    
    //MARK: - VARIABLES
    var callBack:((_ title:[String],_ id:[String])->())?
    var callBackCategory:((_ subcategory:String?)->())?
    var isComing = 0
    var selectedItemsInterst: [String] = []
    var selectedItemsDietry: [String] = []
    var selectedItemsSpecialize: [String] = []
    var arrSearchInterst = [Functions]()
    var arrSearchSpecialize = [Functions]()
    var arrSearchDietary = [Functions]()
    var viewModel = AuthVM()
    var arrInterst = [Functions]()
    var arrSpeciasliz = [Functions]()
    var arrDietary = [Functions]()
    var selectedInterstItemsId = [String]()
    var selectedDietryItemsId = [String]()
    var selectedSpecilizeItemsId = [String]()
    var offset = 1
    var limit = 100
    var isDataLoading:Bool=false
    var pageNo:Int=0
    //"type": "Interests/Specialization/Dietary Preferences"
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        tblVwDietry.allowsMultipleSelection = true
        viewShadow.layer.cornerRadius = 35
        viewShadow.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tblVwDietry.showsVerticalScrollIndicator = false
        switch isComing {
            
        case 0:
            print("selectedInterstItemsId:--\(selectedInterstItemsId)")
            arrSearchInterst = arrInterst
            lblTitleOfScreen.text = "Add Interests"
            
            
        case 1:
            print("selectedItemsDietry:--\(selectedItemsDietry)")
            
            arrSearchDietary = arrDietary
            lblTitleOfScreen.text = "Dietary preferences"
            
            
        default:
            print("selectedItemsSpecialize:--\(selectedItemsSpecialize)")
            arrSearchSpecialize = arrSpeciasliz
            lblTitleOfScreen.text = "Add Expertise"
            
            
        }
        setupOverlayView()
    }
    func setupOverlayView() {
            viewShadow = UIView(frame: self.view.bounds)
        viewShadow.backgroundColor = UIColor.black.withAlphaComponent(0.5)
              let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        viewShadow.addGestureRecognizer(tapGesture)
              self.view.insertSubview(viewShadow, at: 0)
          }
        @objc func overlayTapped() {
              self.dismiss(animated: true)
          }
    func FilterData(_ searchText: String, offset: Int, limit: Int) {
        switch isComing {
        case 0:
            interestApi(text: searchText, offset: offset, limit: limit)
        case 1:
            dietryApi(text: searchText, offset: offset, limit: limit)
        default:
            specilizeApi(text: searchText, offset: offset, limit: limit)
        }
    }
    
    //MARK: - Button Actions
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func ActionSave(_ sender: UIButton) {
        
        switch self.isComing {
        case 0:
            if !self.selectedItemsInterst.isEmpty {
                self.dismiss(animated: true)
                self.callBack?(self.selectedItemsInterst, self.selectedInterstItemsId)
                
            }else{
                showSwiftyAlert("", "Select interest", false)
            }
        case 1:
            if !self.selectedItemsDietry.isEmpty {
                self.dismiss(animated: true)
                self.callBack?(self.selectedItemsDietry, self.selectedDietryItemsId)
            }else{
                showSwiftyAlert("", "Select dietary preference", false)
            }
        default:
            if !self.selectedItemsSpecialize.isEmpty {
                self.dismiss(animated: true)
                self.callBack?(self.selectedItemsSpecialize, self.selectedSpecilizeItemsId)
            }else{
                showSwiftyAlert("", "Select specialization", false)
            }
        }
        
        
        
    }
    
}
extension DietarypreferencesVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch isComing {
        case 0:
            if arrSearchInterst.count > 0{
                lblNoData.isHidden = true
                return arrSearchInterst.count
            }else{
                lblNoData.isHidden = false
                return 0
            }
            
        case 1:
            if arrSearchDietary.count > 0{
                lblNoData.isHidden = true
                return arrSearchDietary.count
            }else{
                lblNoData.isHidden = false
                return 0
                
            }
            
        default :
            if arrSearchSpecialize.count > 0{
                lblNoData.isHidden = true
            return arrSearchSpecialize.count
        }else{
            lblNoData.isHidden = false
            return 0
        }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch isComing {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DietaryPreferencesTVC", for: indexPath) as! DietaryPreferencesTVC
            cell.lblTitle.text = arrSearchInterst[indexPath.row].name ?? ""
            if selectedItemsInterst.contains(arrSearchInterst[indexPath.row].name ?? "") {
                cell.imgVwSelect.image = UIImage(named: "Checkboxes25")
            }else{
                cell.imgVwSelect.image = UIImage(named: "unselect 1")
            }
            if selectedInterstItemsId.contains(arrSearchInterst[indexPath.row]._id ?? "") {
                cell.imgVwSelect.image = UIImage(named: "Checkboxes25")
            }else{
                cell.imgVwSelect.image = UIImage(named: "unselect 1")
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DietaryPreferencesTVC", for: indexPath) as! DietaryPreferencesTVC
            cell.lblTitle.text = arrSearchDietary[indexPath.row].name ?? ""
            if selectedItemsDietry.contains(arrSearchDietary[indexPath.row].name ?? "") {
                cell.imgVwSelect.image = UIImage(named: "Checkboxes25")
            }else{
                cell.imgVwSelect.image = UIImage(named: "unselect 1")
            }
            
            return cell
            
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DietaryPreferencesTVC", for: indexPath) as! DietaryPreferencesTVC
            cell.lblTitle.text = arrSearchSpecialize[indexPath.row].name ?? ""
            if selectedItemsSpecialize.contains(arrSearchSpecialize[indexPath.row].name ?? "") {
                cell.imgVwSelect.image = UIImage(named: "Checkboxes25")
            }else{
                cell.imgVwSelect.image = UIImage(named: "unselect 1")
            }
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch isComing {
            
        case 0:
            let lastItem = self.arrInterst.count - 1
            if indexPath.row == lastItem {
                print("IndexRow\(indexPath.row)")
                if offset < limit {
                    offset += 1
                    interestApi(text: txtFldSearch.text ?? "", offset: offset, limit: limit)
                }
            }
            
        case 1:
            let lastItem = self.arrDietary.count - 1
            if indexPath.row == lastItem {
                print("IndexRow\(indexPath.row)")
                if offset < limit {
                    offset += 1
                    dietryApi(text: "", offset: offset, limit: limit)
                }
            }
            
        default:
            let lastItem = self.arrSpeciasliz.count - 1
            if indexPath.row == lastItem {
                print("IndexRow\(indexPath.row)")
                if offset < limit {
                    offset += 1
                    specilizeApi(text: "", offset: offset, limit: limit)
                }
            }
            
        }
        
    }
    func interestApi(text: String, offset: Int, limit: Int) {
        viewModel.UserFunstionsListApi(type: "Interests", offset: offset, limit: limit, search: text) { [weak self] data in
            guard let self = self else { return }
            if offset == 1 {
                self.arrSearchInterst = data?.data ?? []
            } else {
                self.arrSearchInterst.append(contentsOf: data?.data ?? [])
            }
            self.tblVwDietry.reloadData()
        }
    }
    
    func dietryApi(text: String, offset: Int, limit: Int) {
        viewModel.UserFunstionsListApi(type: "Dietary Preferences", offset: offset, limit: limit, search: text) { [weak self] data in
            guard let self = self else { return }
            if offset == 1 {
                self.arrSearchDietary = data?.data ?? []
            } else {
                self.arrSearchDietary.append(contentsOf: data?.data ?? [])
            }
            self.tblVwDietry.reloadData()
        }
    }
    
    func specilizeApi(text: String, offset: Int, limit: Int) {
        viewModel.UserFunstionsListApi(type: "Specialization", offset: offset, limit: limit, search: text) { [weak self] data in
            guard let self = self else { return }
            if offset == 1 {
                self.arrSearchSpecialize = data?.data ?? []
            } else {
                self.arrSearchSpecialize.append(contentsOf: data?.data ?? [])
            }
            self.tblVwDietry.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch isComing {
        case 0:
            let selectedCell = tableView.cellForRow(at: indexPath) as! DietaryPreferencesTVC
            let deselectedInterstItem = arrSearchInterst[indexPath.row]._id
            if selectedItemsInterst.contains(arrSearchInterst[indexPath.row].name ?? "") {
                if let indexToRemove = selectedItemsInterst.firstIndex(of: arrSearchInterst[indexPath.row].name ?? "") {
                    selectedItemsInterst.remove(at: indexToRemove)
                    selectedInterstItemsId.remove(at: indexToRemove)
                    selectedCell.imgVwSelect.image = UIImage(named: "unselect 1")
                    
                }
                
            }else {
                
                selectedInterstItemsId.append(arrSearchInterst[indexPath.row]._id ?? "")
                selectedItemsInterst.append(arrSearchInterst[indexPath.row].name ?? "")
                selectedCell.imgVwSelect.image = UIImage(named: "Checkboxes25")
            }
            
        case 1:
            let selectedCell = tableView.cellForRow(at: indexPath) as! DietaryPreferencesTVC
            
            if selectedItemsDietry.contains(arrSearchDietary[indexPath.row].name ?? "") {
                
                if let indexToRemove = selectedItemsDietry.firstIndex(of: arrSearchDietary[indexPath.row].name ?? "") {
                    
                    selectedItemsDietry.remove(at: indexToRemove)
                    selectedDietryItemsId.remove(at: indexToRemove)
                    selectedCell.imgVwSelect.image = UIImage(named: "unselect 1")
                }
                
            }else {
                selectedDietryItemsId.append(arrSearchDietary[indexPath.row]._id ?? "")
                selectedItemsDietry.append(arrSearchDietary[indexPath.row].name ?? "")
                selectedCell.imgVwSelect.image = UIImage(named: "Checkboxes25")
            }
            
            
        default:
            let selectedCell = tableView.cellForRow(at: indexPath) as! DietaryPreferencesTVC
            
            if selectedItemsSpecialize.contains(arrSearchSpecialize[indexPath.row].name ?? "") {
                
                if let indexToRemove = selectedItemsSpecialize.firstIndex(of: arrSearchSpecialize[indexPath.row].name ?? "") {
                    
                    selectedItemsSpecialize.remove(at: indexToRemove)
                    selectedSpecilizeItemsId.remove(at: indexToRemove)
                    selectedCell.imgVwSelect.image = UIImage(named: "unselect 1")
                }
                
            }else {
                selectedSpecilizeItemsId.append(arrSearchSpecialize[indexPath.row]._id ?? "")
                selectedItemsSpecialize.append(arrSearchSpecialize[indexPath.row].name ?? "")
                selectedCell.imgVwSelect.image = UIImage(named: "Checkboxes25")
            }
        }
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch isComing {
        case 0:
            let deselectedCell = tableView.cellForRow(at: indexPath) as! DietaryPreferencesTVC
            let deselectedInterstItem = arrSearchInterst[indexPath.row]
            if let indexToRemove = selectedItemsInterst.firstIndex(of: deselectedInterstItem.name ?? "") {
                selectedItemsInterst.remove(at: indexToRemove)
                selectedInterstItemsId.remove(at: indexToRemove)
                deselectedCell.imgVwSelect.image = UIImage(named: "unselect 1")
                
                
            }else{
                
                selectedInterstItemsId.append(arrSearchInterst[indexPath.row]._id ?? "")
                selectedItemsInterst.append(arrSearchInterst[indexPath.row].name ?? "")
                deselectedCell.imgVwSelect.image = UIImage(named: "Checkboxes25")
                
            }
            
            
        case 1:
            let deselectedCell = tableView.cellForRow(at: indexPath) as! DietaryPreferencesTVC
            let deselectedDietryItem = arrSearchDietary[indexPath.row]
            if let indexToRemove = selectedItemsDietry.firstIndex(of: deselectedDietryItem.name ?? "") {
                selectedItemsDietry.remove(at: indexToRemove)
                selectedDietryItemsId.remove(at: indexToRemove)
                deselectedCell.imgVwSelect.image = UIImage(named: "unselect 1")
                print("Deselected dietryitems: \(selectedItemsDietry)")
                print("Removed item IDdietry: \(deselectedDietryItem._id ?? "")")
            }else{
                //
                selectedDietryItemsId.append(arrSearchDietary[indexPath.row]._id ?? "")
                selectedItemsDietry.append(arrSearchDietary[indexPath.row].name ?? "")
                deselectedCell.imgVwSelect.image = UIImage(named: "Checkboxes25")
                
            }
            
            
        default:
            let deselectedCell = tableView.cellForRow(at: indexPath) as! DietaryPreferencesTVC
            let deselectedSpecilizeItem = arrSearchSpecialize[indexPath.row]
            if let indexToRemove = selectedItemsSpecialize.firstIndex(of: deselectedSpecilizeItem.name ?? "") {
                selectedItemsSpecialize.remove(at: indexToRemove)
                selectedSpecilizeItemsId.remove(at: indexToRemove)
                deselectedCell.imgVwSelect.image = UIImage(named: "unselect 1")
            }else{
                
                selectedSpecilizeItemsId.append(arrSearchSpecialize[indexPath.row]._id ?? "")
                print("selectedselectedSpecilizeItemsId:--\(selectedSpecilizeItemsId)")
                selectedItemsSpecialize.append(arrSearchSpecialize[indexPath.row].name ?? "")
                deselectedCell.imgVwSelect.image = UIImage(named: "Checkboxes25")
                
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
extension DietarypreferencesVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let searchText = (txtFldSearch.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        offset = 1
        limit = 10
        FilterData(searchText, offset: offset, limit: limit)
        
        return true
    }
}
