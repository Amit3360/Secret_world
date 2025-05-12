//
//  ServiceSubCategiriesVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 05/01/24.
//

import UIKit

class ServiceSubCategiriesVC: UIViewController {
    //MARK: -Outlet
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var viewBack: UIView!
    @IBOutlet var txtFldSearch: UITextField!
    @IBOutlet var tblVw: UITableView!
    
    //MARK: - Variables
    var callBack:((_ idName:[String:Any]?,_ categoryName:String)->())?
    var selectedSubCategories = [String:Any]()
    var categoryId = String()
    var viewModel = AddServiceVM()
    var arrSubCategories = [Subcategorylist]()
    var arrSearchSubCategories = [Subcategorylist]()
    var offset = 1
    var limit = 20
    var categoryName = String()
    var isLoading = false
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    //MARK: -Functions
    func uiSet(){
        print("categoryIdForsubcate: \(categoryId)")
        print("selectedSubCategories: \(selectedSubCategories)")
        viewBack.layer.cornerRadius = 30
        viewBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tblVw.rowHeight = UITableView.automaticDimension
        tblVw.estimatedRowHeight = 100
    }
    func filterContentForSearchText(_ searchText: String, offset: Int, limit: Int) {
        
        getSubCategoryApi(categoryId: categoryId, text: searchText, offset: offset, limit: limit)
        
    }
    func getSubCategoryApi(categoryId:String,text: String, offset: Int, limit: Int){
        
        viewModel.getSubCtegoriesApi(service_id: categoryId, offset: offset, limit: limit, search: text) { [weak self] data in
            guard let self = self else { return }
            if offset == 1 {
                arrSearchSubCategories.removeAll()
                self.arrSearchSubCategories = data?.subcategorylist ?? []
            } else {
                self.arrSearchSubCategories.append(contentsOf: data?.subcategorylist ?? [])
            }
            if arrSearchSubCategories.count > 0{
                lblNoData.isHidden = true
            }else{
                lblNoData.isHidden = false
            }
            
            self.tblVw.reloadData()
        }
    }
    //MARK: -Button actions
    @IBAction func actionSave(_ sender: UIButton) {
        if selectedSubCategories.count > 0 {
            self.dismiss(animated: true)
            Store.SubCategoriesId = selectedSubCategories
            self.callBack?(selectedSubCategories as [String: Any]?, categoryName)
            
            print("selectedIds selectedNames : --\(selectedSubCategories)")
            
        }else{
            showSwiftyAlert("", "Select subcategory", false)
        }
    }
    
    
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
}
//MARK: - UITableViewDelegate
extension ServiceSubCategiriesVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSearchSubCategories.count
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
      loadMoreDataIfNeeded(for: indexPath)
    }
    func loadMoreDataIfNeeded(for indexPath: IndexPath) {
        
            if indexPath.row == arrSearchSubCategories.count - 1 && !isLoading{
                isLoading = true
                offset += 1
                getSubCategoryApi(categoryId: categoryId, text: txtFldSearch.text ?? "", offset: offset, limit: limit)
            }
       
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryTVC", for: indexPath) as! SubCategoryTVC
        
        let subCategory = arrSearchSubCategories[indexPath.row]
        cell.lblTitle.text = subCategory.name ?? ""
        
        if let id = subCategory.id, selectedSubCategories.keys.contains(id) {
            cell.imgVwSelect.image = UIImage(named: "Checkboxes25")
        } else {
            cell.imgVwSelect.image = UIImage(named: "unselect 1")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSubCategory = arrSearchSubCategories[indexPath.row]
        if let id = selectedSubCategory.id {
            if selectedSubCategories.keys.contains(id) {
                selectedSubCategories.removeValue(forKey: id)
                print("selectedSubCategories:--\(selectedSubCategories)")
            } else {
                if let name = selectedSubCategory.name {
                    selectedSubCategories[id] = name
                    print("selectedSubCategories:--\(selectedSubCategories)")
                }
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deselectedSubCategory = arrSearchSubCategories[indexPath.row]
        if let id = deselectedSubCategory.id {
            selectedSubCategories.removeValue(forKey: id)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            print("selectedSubCategories:--\(selectedSubCategories)")
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
//MARK: - UITextFieldDelegate
extension ServiceSubCategiriesVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtFldSearch.resignFirstResponder() 
        offset = 1
        limit = 10
        filterContentForSearchText(txtFldSearch.text ?? "", offset: offset, limit: limit)
            return true
        }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let searchText = (txtFldSearch.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        
        offset = 1
        limit = 10
        filterContentForSearchText(searchText, offset: offset, limit: limit)
        
        return true
    }
}
