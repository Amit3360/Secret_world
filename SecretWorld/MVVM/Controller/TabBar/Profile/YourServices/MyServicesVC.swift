//
//  MyServicesVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 04/01/24.
//
import UIKit

class MyServicesVC: UIViewController {
    //MARK: - OUTLETS
    @IBOutlet var lblNodata: UILabel!
    @IBOutlet var lblScreenTitle: UILabel!
    @IBOutlet var tblVwServices: UITableView!
    
    //MARK: - VARIABELS
    var isSelect = 0
    var viewModel = AddServiceVM()
    var arrService = [ServiceDetail]()
    var userDetail:GetBusinessServiceData?
    var offset = 1
    var limit = 10
    var totalPages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                   swipeRight.direction = .right
                   view.addGestureRecognizer(swipeRight)

        uiSet()
        
    }
    @objc func handleSwipe() {
        switch isSelect{
        case 0:
            SceneDelegate().userRoot()
        case 1:
            self.navigationController?.popViewController(animated: true)
        default:
            break
        }
            }

    func uiSet(){
        let nibNearBy = UINib(nibName: "ServiceTVC", bundle: nil)
        tblVwServices.register(nibNearBy, forCellReuseIdentifier: "ServiceTVC")
        tblVwServices.showsVerticalScrollIndicator = false
        
        switch isSelect{
        case 0:
            lblScreenTitle.text = "All  Services"
        case 1:
            lblScreenTitle.text = "My  Services"
            arrService.removeAll()
            getMyServiceApi(loader: true)
           
        default:
            break
        }
    }
   
    func getMyServiceApi(loader:Bool){
        viewModel.getAllService(loader:loader, offSet: offset, limit: limit) { data in
            self.arrService.append(contentsOf: data?.service ?? [])
            Store.BusinessServicesList = data
            self.userDetail = data
            self.totalPages = data?.totalPages ?? 0
            if self.arrService.count > 0{
                self.lblNodata.text = ""
            }else{
                self.lblNodata.text = "Data Not Found!"
            }
            self.tblVwServices.reloadData()
        }
    }
    
    //MARK: - BUTTON ACTIONS
    @IBAction func actionBack(_ sender: UIButton) {
        switch isSelect{
        case 0:
            SceneDelegate().userRoot()
        case 1:
            self.navigationController?.popViewController(animated: true)
        default:
            break
        }
        
    }
    
    
}
//MARK: - UITableViewDelegate
extension MyServicesVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrService.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTVC", for: indexPath) as! ServiceTVC
        if arrService.count > 0{
            
            if arrService[indexPath.row].serviceImages?.count ?? 0 > 0{
                cell.imgVwService.imageLoad(imageUrl: arrService[indexPath.row].serviceImages?[0] ?? "")
            }
            cell.lblPrice.text = "$\(arrService[indexPath.row].actualPrice ?? 0)"
            cell.lblPrevPrice.text = "$\(arrService[indexPath.row].price ?? 0)"
            cell.lblOff.text = "\(Int(arrService[indexPath.row].discount ?? 0))% off"
            cell.lblServiceName.text = arrService[indexPath.row].serviceName ?? ""
            cell.lblUserName.text = userDetail?.user?.name ?? ""
            let rating = arrService[indexPath.row].rating ?? 0.0
            let formattedRating = String(format: "%.1f", rating)
            cell.lblRating.text = formattedRating
            cell.contentView.layer.masksToBounds = false
            cell.contentView.layer.shadowColor = UIColor.black.cgColor
            cell.contentView.layer.shadowOpacity = 0.1
            cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.contentView.layer.shouldRasterize = true
            cell.contentView.layer.rasterizationScale = UIScreen.main.scale
            cell.indexpath = indexPath.row
            cell.uiSet()
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if totalPages > offset{
            offset += 1
            getMyServiceApi(loader: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceDetailVC") as! ServiceDetailVC
        vc.serviceId = arrService[indexPath.row]._id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  120
        
    }
    
}
