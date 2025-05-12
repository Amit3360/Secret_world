//
//  GigListVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 29/12/23.
//
import UIKit
import CoreLocation
class GigListVC: UIViewController{
    //  MARK: - Outlets
    @IBOutlet var lblNOData: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var heightCollVwFilter: NSLayoutConstraint!
    @IBOutlet var collVwGiglist: UICollectionView!
    @IBOutlet var collVwGigFilter: UICollectionView!
    //  MARK: - variables
    var isLoading = false
    var arrGigFilter = ["All","Near by","Most Recent","Best Matchees"]
    var arrPostGig = ["Upcoming","Ongoing","Completed"]
    var isComing = 0
    var viewModel = AddGigVM()
    var arrGigList = [GigDetail]()
    var offset = 0
    var limit = 100
    var totalPage = 0
    var selectedType = 0
    var locationManager: CLLocationManager!
    var lat:Double?
    var long:Double?
    var arrBusinessGiglist = [Gigess]()
    var gigType = 0
    var isUserParticipantsList = false
    var arrAppliedGigs = [GetAppliedData]()
    var appliedGigType = 0
    var fetchLatLong = false
    var uploadList = false
    var callBack:(()->())?
    var isCreate = false
//    var apiCalling = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)
        let nib = UINib(nibName: "GigListCVC", bundle: nil)
        collVwGiglist.register(nib, forCellWithReuseIdentifier: "GigListCVC")
        
    }
    @objc func handleSwipe() {
        if isComing == 0 || isComing == 1{
            SceneDelegate().tabbarRoots(SelectedIndex: 4)
        }else{
            if isCreate{
                SceneDelegate().tabbarRoots(SelectedIndex: 0)
            }else{
                SceneDelegate().tabbarRoots(SelectedIndex: 4)
            }

//            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//            let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//            nextVC.selectedButtonTag = 5
//            let nav = UINavigationController.init(rootViewController: nextVC)
//            nav.isNavigationBarHidden = true
//            UIApplication.shared.windows.first?.rootViewController = nav
        }
        }
    override func viewWillAppear(_ animated: Bool) {
        uiSet()
    }
    func uiSet(){
        if isComing == 0{
            getLocation(type: selectedType)
            lblTitle.text = "Task"
            arrGigList.removeAll()
            getGigListApi(lat: lat ?? 0.0, long: long ?? 0.0, typee: selectedType)
        }else if isComing == 1{
            lblTitle.text = "Applied Task"
            arrAppliedGigs.removeAll()
            getAppliedGigApi(gigtype: appliedGigType)
        }else{
            lblTitle.text = "Upcoming Task"
            arrBusinessGiglist.removeAll()
            getBusinessUserGigList(gigtype: gigType, loader: true)
        }
    }
    func getAppliedGigApi(gigtype:Int){
        viewModel.GetUserAppliedGigApi(offset: offset, limit: limit, type: appliedGigType){  data in
            self.arrAppliedGigs.removeAll()
            self.totalPage = data?.totalPages ?? 0
            self.arrAppliedGigs.append(contentsOf: data?.gigs ?? [])
            if self.arrAppliedGigs.count > 0{
                self.lblNOData.text = ""
            }else{
                self.lblNOData.text = "Data Not Found!"
            }
            self.uploadList = true
            self.collVwGiglist.reloadData()
        }
    }
    func getBusinessUserGigList(gigtype:Int,loader:Bool){
        viewModel.GetBusinessAllGigsListApi(loader:loader,offset: offset, limit: limit, type: gigType){  data in
            self.arrBusinessGiglist.removeAll()
            self.totalPage = data?.totalPages ?? 0
            self.arrBusinessGiglist.append(contentsOf: data?.gigs ?? [])
            if self.arrBusinessGiglist.count > 0{
                self.lblNOData.text = ""
            }else{
                self.lblNOData.text = "Data Not Found!"
            }
            self.uploadList = true
            self.collVwGiglist.reloadData()
        }
    }
    func getLocation(type:Int){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func getGigListApi(lat: Double, long: Double, typee: Int) {
        viewModel.GetGigApi(offset: offset, limit: limit, type: typee, latitude: lat, longitude: long) { data in
            self.totalPage = data?.totalPages ?? 0
            let newGigs = data?.response ?? []
            // Only add unique businesses
            for business in newGigs {
                if !self.arrGigList.contains(where: { $0.id == business.id }) {
                    self.arrGigList.append(business)
                }
            }
//            self.arrGigList.append(contentsOf: data?.response ?? [])
            if self.arrGigList.count > 0{
                self.lblNOData.text = ""
            }else{
                self.lblNOData.text = "Data Not Found!"
            }
            self.isLoading = false
            self.uploadList = true
            self.collVwGiglist.reloadData()
        }
    }
    @IBAction func actionBack(_ sender: UIButton) {
        if isComing == 0 || isComing == 1{
            self.navigationController?.popViewController(animated:true)
        }else{
            isSelectAnother = true
            if isCreate{
                SceneDelegate().tabbarRoots(SelectedIndex: 0)
            }else{
                SceneDelegate().tabbarRoots(SelectedIndex: 4)
            }
            
           // self.navigationController?.popViewController(animated:true)
            //callBack?()
//            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//            let nextVC = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//            nextVC.selectedButtonTag = 5
//            let nav = UINavigationController.init(rootViewController: nextVC)
//            nav.isNavigationBarHidden = true
//            UIApplication.shared.windows.first?.rootViewController = nav
        }
    }
}
//MARK: - UICollectionViewDelegate
extension GigListVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isComing == 0{
            
            if collectionView == collVwGiglist{
                if arrGigList.count > 0{
                    return arrGigList.count
                }else{
                    return 0
                }
            }else{
                return arrGigFilter.count
            }
        }else if isComing == 1{
            
            if collectionView == collVwGiglist{
                if arrAppliedGigs.count > 0{
                    return arrAppliedGigs.count
                }else{
                    return 0
                }
            }else{
                if arrPostGig.count > 0{
                    return arrPostGig.count
                }else{
                    return 0
                }
            }
        }else{
            
            if collectionView == collVwGiglist{
                if arrBusinessGiglist.count > 0{
                    return arrBusinessGiglist.count
                }else{
                    return 0
                }
            }else{
                if arrPostGig.count > 0{
                    return arrPostGig.count
                }else{
                    return 0
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        loadMoreDataIfNeeded(for: indexPath)
    }
    func loadMoreDataIfNeeded(for indexPath: IndexPath) {
        // Check if the last cell is about to be displayed
        if isComing == 0{
            if indexPath.row == arrGigList.count - 1 && !isLoading && offset < totalPage {
                isLoading = true
                offset += 1
                getGigListApi(lat: lat ?? 0.0, long: long ?? 0.0, typee: selectedType)
            }
        }else if isComing == 1{
            if indexPath.row == arrAppliedGigs.count - 1 && !isLoading && offset < totalPage {
                isLoading = true
                offset += 1
                getAppliedGigApi(gigtype: appliedGigType)
            }
        }else{
            if indexPath.row == arrBusinessGiglist.count - 1 && !isLoading && offset < totalPage {
                isLoading = true
                offset += 1
                getBusinessUserGigList(gigtype: gigType, loader: false)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isComing == 0{
            if collectionView == collVwGiglist{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GigListCVC", for: indexPath) as! GigListCVC
                cell.vwShadow.layer.masksToBounds = false
                cell.vwShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
                cell.vwShadow.layer.shadowOpacity = 0.44
                cell.vwShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
                cell.vwShadow.layer.shouldRasterize = true
                cell.vwShadow.layer.rasterizationScale = UIScreen.main.scale
                cell.vwShadow.layer.cornerRadius = 10
                cell.contentView.layer.cornerRadius = 10
                cell.imgVwGig.layer.cornerRadius = 10
                cell.imgVwGig.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                if arrGigList.count > 0{
                    cell.lblName.text = arrGigList[indexPath.row].name ?? ""
                    let value: Double = arrGigList[indexPath.row].price ?? 0
                    let formattedValue = String(format: "%.2f", value)
                    cell.lblPrice.text = "$\(formattedValue)"
                    cell.lblTitle.text = arrGigList[indexPath.row].title ?? ""
                    let rating = arrGigList[indexPath.row].rating ?? 0.0
                    let formattedRating = String(format: "%.1f", rating)
                    cell.lblRating.text = formattedRating
                    if arrGigList[indexPath.row].review ?? 0 > 1{
                        cell.lblUserCount.text = "(\(arrGigList[indexPath.row].review ?? 0) Reviews)"
                    }else{
                        cell.lblUserCount.text = "(\(arrGigList[indexPath.row].review ?? 0) Review)"
                    }
                    if  arrGigList[indexPath.row].image == "" ||  arrGigList[indexPath.row].image == nil{
                        cell.imgVwGig.image = UIImage(named: "dummy")
                    }else{
                        cell.imgVwGig.imageLoad(imageUrl: arrGigList[indexPath.row].image ?? "dummy")
                    }
                      cell.lblPaymentStatus.text = ""
                }
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GigFilterCVC", for: indexPath) as! GigFilterCVC
                if indexPath.row == selectedType{
                    cell.contentView.backgroundColor = .app
                    cell.lblTitle.text = arrGigFilter[indexPath.row]
                    cell.lblTitle.textColor = .white
                }else{
                    cell.contentView.backgroundColor = .white
                    cell.lblTitle.text = arrGigFilter[indexPath.row]
                    cell.lblTitle.textColor = .app
                }
                return cell
            }
        }else if isComing == 1{
            if collectionView == collVwGiglist{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GigListCVC", for: indexPath) as! GigListCVC
                cell.vwShadow.layer.masksToBounds = false
                cell.vwShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
                cell.vwShadow.layer.shadowOpacity = 0.44
                cell.vwShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
                cell.vwShadow.layer.shouldRasterize = true
                cell.vwShadow.layer.rasterizationScale = UIScreen.main.scale
                cell.vwShadow.layer.cornerRadius = 10
                cell.contentView.layer.cornerRadius = 10
                cell.imgVwGig.layer.cornerRadius = 10
                cell.imgVwGig.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                if arrAppliedGigs.count > 0{
                    cell.lblName.text = arrAppliedGigs[indexPath.row].user?.name ?? ""
                    let value: Double = arrAppliedGigs[indexPath.row].gig?.price ?? 0
                    let formattedValue = String(format: "%.2f", value)
                    cell.lblPrice.text = "$\(formattedValue)"
//                    cell.lblTitle.text = arrAppliedGigs[indexPath.row].gig?.title ?? ""
                    cell.lblTitle.text = "\(arrAppliedGigs[indexPath.row].gig?.title ?? "") \(arrAppliedGigs[indexPath.row].category?.name ?? "")"
                    if  arrAppliedGigs[indexPath.row].gig?.image == "" ||  arrAppliedGigs[indexPath.row].gig?.image == nil{
                        cell.imgVwGig.image = UIImage(named: "dummy")
                    }else{
                        cell.imgVwGig.imageLoad(imageUrl: arrAppliedGigs[indexPath.row].gig?.image ?? "dummy")
                    }
                    let rating = arrAppliedGigs[indexPath.row].rating ?? 0.0
                    let formattedRating = String(format: "%.1f", rating)
                    cell.lblRating.text = formattedRating
                    if arrAppliedGigs[indexPath.row].review ?? 0 > 1{
                        cell.lblUserCount.text = "(\(arrAppliedGigs[indexPath.row].review ?? 0) Reviews)"
                    }else{
                        cell.lblUserCount.text = "(\(arrAppliedGigs[indexPath.row].review ?? 0) Review)"
                    }
                      cell.lblPaymentStatus.text = ""
                    if arrAppliedGigs[indexPath.row].status == 2{
                        cell.imgComplete.isHidden = false
                    }else{
                        cell.imgComplete.isHidden = true
                    }
                }
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GigFilterCVC", for: indexPath) as! GigFilterCVC
                if arrPostGig.count > 0{
                    if indexPath.row == selectedType{
                        cell.contentView.backgroundColor = UIColor(red: 230/255, green: 242/255, blue: 229/255, alpha: 1.0)
                        cell.lblTitle.text = arrPostGig[indexPath.row]
                        cell.lblTitle.textColor = .app
                    }else{
                        cell.contentView.backgroundColor = .white
                        cell.lblTitle.text = arrPostGig[indexPath.row]
                        cell.lblTitle.textColor = UIColor(red: 81/255, green: 81/255, blue: 81/255, alpha: 1.0)
                    }
                }
                return cell
            }
        }else{
            if collectionView == collVwGiglist{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GigListCVC", for: indexPath) as! GigListCVC
                cell.vwShadow.layer.masksToBounds = false
                cell.vwShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
                cell.vwShadow.layer.shadowOpacity = 0.44
                cell.vwShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
                cell.vwShadow.layer.shouldRasterize = true
                cell.vwShadow.layer.rasterizationScale = UIScreen.main.scale
                cell.vwShadow.layer.cornerRadius = 10
                cell.contentView.layer.cornerRadius = 10
                cell.imgVwGig.layer.cornerRadius = 10
                cell.imgVwGig.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                if arrBusinessGiglist.count > 0{
                    
                    cell.lblName.text = "\(arrBusinessGiglist[indexPath.row].user?.name ?? "")"
                    let value: Double = arrBusinessGiglist[indexPath.row].price ?? 0
                    let formattedValue = String(format: "%.2f", value)
                    cell.lblPrice.text = "$\(formattedValue)"
                    cell.lblTitle.text = "\(arrBusinessGiglist[indexPath.row].title ?? "") \(arrBusinessGiglist[indexPath.row].category?.name ?? "")"
                    if arrBusinessGiglist[indexPath.row].image == "" || arrBusinessGiglist[indexPath.row].image == nil{
                        cell.imgVwGig.image = UIImage(named: "dummy")
                    }else{
                        cell.imgVwGig.imageLoad(imageUrl: arrBusinessGiglist[indexPath.row].image ?? "dummy")
                    }
//                    cell.imgVwGig.imageLoad(imageUrl: arrBusinessGiglist[indexPath.row].image ?? "")
                    let rating = arrBusinessGiglist[indexPath.row].avgStarCount ?? 0.0
                    let formattedRating = String(format: "%.1f", rating)
                    cell.lblRating.text = formattedRating
                    if arrBusinessGiglist[indexPath.row].reviewCount ?? 0 > 1{
                        cell.lblUserCount.text = "(\(arrBusinessGiglist[indexPath.row].reviewCount ?? 0) Reviews)"
                    }else{
                        cell.lblUserCount.text = "(\(arrBusinessGiglist[indexPath.row].reviewCount ?? 0) Review)"
                    }
                    if arrBusinessGiglist[indexPath.row].paymentStatus == 0{
                        cell.lblPaymentStatus.text = "Payment Pending"
                    }else{
                        cell.lblPaymentStatus.text = ""
                    }
                    if arrBusinessGiglist[indexPath.row].status == 2{
                            cell.imgComplete.isHidden = false
                        }else{
                            cell.imgComplete.isHidden = true
                        }
                }
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GigFilterCVC", for: indexPath) as! GigFilterCVC
                if isComing == 1 || isComing == 2{
                    if indexPath.row == selectedType{
                        cell.contentView.backgroundColor = UIColor(red: 230/255, green: 242/255, blue: 229/255, alpha: 1.0)
                        cell.lblTitle.text = arrPostGig[indexPath.row]
                        cell.lblTitle.textColor = .app
                    }else{
                        cell.contentView.backgroundColor = .white
                        cell.lblTitle.text = arrPostGig[indexPath.row]
                        cell.lblTitle.textColor = UIColor(red: 81/255, green: 81/255, blue: 81/255, alpha: 1.0)
                    }
                }else{
                    if indexPath.row == selectedType{
                        cell.contentView.backgroundColor = .app
                        cell.lblTitle.text = arrPostGig[indexPath.row]
                        cell.lblTitle.textColor = .white
                    }else{
                        cell.contentView.backgroundColor = .white
                        cell.lblTitle.text = arrPostGig[indexPath.row]
                        cell.lblTitle.textColor = UIColor(red: 81/255, green: 81/255, blue: 81/255, alpha: 1.0)
                    }
                }
                return cell
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collVwGigFilter {
            
            if isComing == 0{
                if indexPath.row == 1{
                    selectedType = 1
                    offset = 0
                    getLocation(type: selectedType)
                    arrGigList.removeAll()
                    collVwGigFilter.reloadData()
                    getGigListApi(lat: lat ?? 0.0, long: long ?? 0.0, typee: selectedType)
                }else  if indexPath.row == 2{
                    selectedType = 2
                    offset = 0
                    getLocation(type: selectedType)
                    arrGigList.removeAll()
                    collVwGigFilter.reloadData()
                    getGigListApi(lat: lat ?? 0.0, long: long ?? 0.0, typee: selectedType)
                }else if indexPath.row == 3{
                    selectedType = 3
                    offset = 0
                    getLocation(type: selectedType)
                    arrGigList.removeAll()
                    collVwGigFilter.reloadData()
                    getGigListApi(lat: lat ?? 0.0, long: long ?? 0.0, typee: selectedType)
                }else{
                    selectedType = 0
                    offset = 0
                    getLocation(type: selectedType)
                    arrGigList.removeAll()
                    collVwGigFilter.reloadData()
                    getGigListApi(lat: lat ?? 0.0, long: long ?? 0.0, typee: selectedType)
                }
                for index in 0..<arrGigFilter.count {
                    let indexPath = IndexPath(item: index, section: 0)
                    if let cell = collectionView.cellForItem(at: indexPath) as? GigFilterCVC {
                        cell.contentView.backgroundColor = UIColor.clear
                        cell.lblTitle.textColor = .app
                    }
                }
            }else if isComing == 1{
                if indexPath.row == 0{
                    appliedGigType = 0
                    offset = 0
                    arrAppliedGigs.removeAll()
                    getAppliedGigApi(gigtype: appliedGigType)
                }else  if indexPath.row == 1{
                    appliedGigType = 1
                    offset = 0
                    arrAppliedGigs.removeAll()
                    getAppliedGigApi(gigtype: appliedGigType)
                }else{
                    appliedGigType = 2
                    offset = 0
                    arrAppliedGigs.removeAll()
                    getAppliedGigApi(gigtype: appliedGigType)
                }
                for index in 0..<arrGigFilter.count {
                    let indexPath = IndexPath(item: index, section: 0)
                    if let cell = collectionView.cellForItem(at: indexPath) as? GigFilterCVC {
                        cell.contentView.backgroundColor = UIColor.clear
                        cell.lblTitle.textColor = UIColor(red: 81/255, green: 81/255, blue: 81/255, alpha: 1.0)
                    }
                }
            }else if isComing == 2{
                if indexPath.row == 1{
                    lblTitle.text = "Ongoing Task"
                    if let cell0 = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? GigFilterCVC {
                        cell0.isUserInteractionEnabled = true
                        print("cell0\(cell0.isUserInteractionEnabled)")
                    }
                    if let cell1 = collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? GigFilterCVC {
                        cell1.isUserInteractionEnabled = false
                        print("cell1\(cell1.isUserInteractionEnabled)")
                    }
                    if let cell2 = collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? GigFilterCVC {
                        cell2.isUserInteractionEnabled = true
                        print("cell2\(cell2.isUserInteractionEnabled)")
                    }
                    gigType = 1
                    offset = 0
                    lblNOData.text = ""
                    arrBusinessGiglist.removeAll()
                    getBusinessUserGigList(gigtype: gigType, loader: true)
                }else if indexPath.row == 2{
                    lblTitle.text = "Completed Task"
                    if let cell0 = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? GigFilterCVC {
                        cell0.isUserInteractionEnabled = true
                        print("cell0\(cell0.isUserInteractionEnabled)")
                    }
                    if let cell1 = collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? GigFilterCVC {
                        cell1.isUserInteractionEnabled = true
                        print("cell1\(cell1.isUserInteractionEnabled)")
                    }
                    if let cell2 = collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? GigFilterCVC {
                        cell2.isUserInteractionEnabled = false
                        print("cell2\(cell2.isUserInteractionEnabled)")
                    }
                    gigType = 2
                    offset = 0
                    lblNOData.text = ""
                    arrBusinessGiglist.removeAll()
                    getBusinessUserGigList(gigtype: gigType, loader: true)
                }else{
                    lblTitle.text = "Upcoming Task"
                    if let cell0 = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? GigFilterCVC {
                        cell0.isUserInteractionEnabled = false
                        print("cell0\(cell0.isUserInteractionEnabled)")
                    }
                    if let cell1 = collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? GigFilterCVC {
                        cell1.isUserInteractionEnabled = true
                        print("cell1\(cell1.isUserInteractionEnabled)")
                    }
                    if let cell2 = collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? GigFilterCVC {
                        cell2.isUserInteractionEnabled = true
                        print("cell2\(cell2.isUserInteractionEnabled)")
                    }
                    gigType = 0
                    offset = 0
                    lblNOData.text = ""
                    arrBusinessGiglist.removeAll()
                    getBusinessUserGigList(gigtype: gigType, loader: true)
                }
                for index in 0..<arrGigFilter.count {
                    let indexPath = IndexPath(item: index, section: 0)
                    if let cell = collectionView.cellForItem(at: indexPath) as? GigFilterCVC {
                        cell.contentView.backgroundColor = UIColor.clear
                        cell.lblTitle.textColor = UIColor(red: 81/255, green: 81/255, blue: 81/255, alpha: 1.0)
                    }
                }
            }else{
                for index in 0..<arrPostGig.count {
                    let indexPath = IndexPath(item: index, section: 0)
                    if let cell = collectionView.cellForItem(at: indexPath) as? GigFilterCVC {
                        cell.contentView.backgroundColor = UIColor.clear
                        cell.lblTitle.textColor = UIColor.app
                    }
                }
            }
            if Store.role == "b_user"{
                if let cell = collectionView.cellForItem(at: indexPath) as? GigFilterCVC {
                    cell.contentView.backgroundColor = UIColor(red: 230/255, green: 242/255, blue: 229/255, alpha: 1.0)
                    cell.lblTitle.textColor = UIColor.app
                }
            }else{
                if isComing == 0{
                    if let cell = collectionView.cellForItem(at: indexPath) as? GigFilterCVC {
                        cell.contentView.backgroundColor = UIColor.app
                        cell.lblTitle.textColor = UIColor.white
                    }
                }else{
                    if let cell = collectionView.cellForItem(at: indexPath) as? GigFilterCVC {
                        cell.contentView.backgroundColor = UIColor(red: 230/255, green: 242/255, blue: 229/255, alpha: 1.0)
                        cell.lblTitle.textColor = UIColor.app
                    }
                }
            }
        }else{
            if uploadList == true{
            if isComing == 0{
                //see all gigs
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ApplyGigVC") as! ApplyGigVC
//                    vc.isComing = 0
//                    if arrGigList.count > 0{
//                        vc.gigId = arrGigList[indexPath.row].id ?? ""
//                    }
//                    self.navigationController?.pushViewController(vc, animated: true)
               
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
                    vc.gigId = arrGigList[indexPath.row].id ?? ""
                    vc.isComing = 0
                    vc.callBack = {
                    self.uploadList = false
                    self.uiSet()
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                
            }else  if isComing == 1{
                
                //appliedgig
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ApplyGigVC") as! ApplyGigVC
//                    vc.isComing = 0
//                    if arrAppliedGigs.count > 0{
//                        vc.gigId = arrAppliedGigs[indexPath.row].gig?.id ?? ""
//                    }
//                    self.navigationController?.pushViewController(vc, animated: true)
                if Store.userId == arrAppliedGigs[indexPath.row].gig?.id ?? "" {
                   
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailOwnerVC") as! TaskDetailOwnerVC
                    vc.gigId = arrAppliedGigs[indexPath.row].gig?.id ?? ""
                    if arrAppliedGigs[indexPath.row].status != nil{
                        vc.isComing = 1
                    }else{
                        vc.isComing = 0
                    }
                    vc.callBack = {
                    self.uploadList = false
                    self.uiSet()
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
                    vc.gigId = arrAppliedGigs[indexPath.row].gig?.id ?? ""
                    vc.isComing = 0
                    vc.callBack = {
                    self.uploadList = false
                    self.uiSet()
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            
            }else{
                
                if Store.role == "b_user"{
                    if Store.userId == arrBusinessGiglist[indexPath.row].user?.id {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailOwnerVC") as! TaskDetailOwnerVC
                        vc.gigId = arrBusinessGiglist[indexPath.row].id ?? ""
                        if arrBusinessGiglist[indexPath.row].status != nil{
                            vc.isComing = 1
                        }else{
                            vc.isComing = 0
                        }
                        vc.callBack = {
                        self.uploadList = false
                        self.uiSet()
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
                        vc.gigId = arrBusinessGiglist[indexPath.row].id ?? ""
                        vc.isComing = 1
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ApplyGigVC") as! ApplyGigVC
//                        vc.isComing = 1
//                        if arrBusinessGiglist.count > 0{
//                            vc.gigId = arrBusinessGiglist[indexPath.row].id ?? ""
//                        }
//                        self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    if Store.userId == arrBusinessGiglist[indexPath.row].user?.id {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailOwnerVC") as! TaskDetailOwnerVC
                        vc.gigId = arrBusinessGiglist[indexPath.row].id ?? ""
                        if arrBusinessGiglist[indexPath.row].status != nil{
                            vc.isComing = 1
                        }else{
                            vc.isComing = 0
                        }
                        vc.callBack = {
                        self.uploadList = false
                        self.uiSet()
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
                        vc.callBack = {
                        self.uploadList = false
                        self.uiSet()
                        }
                        vc.gigId = arrBusinessGiglist[indexPath.row].id ?? ""
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserApplyGigVC") as! UserApplyGigVC
//                        if arrBusinessGiglist.count > 0{
//                            vc.gigId = arrBusinessGiglist[indexPath.row].id ?? ""
//                        }
//                        self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collVwGiglist {
            return 10
        }
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwGiglist{
            return CGSize(width: collVwGiglist.frame.size.width / 2 - 5, height: 220)
        }else{
            if isComing == 0{
                let text = arrGigFilter[indexPath.row]
                let width = text.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 14)) + 40
                return CGSize(width: width, height: 40)
            }else{
                return CGSize(width: collVwGigFilter.frame.size.width / 3 - 9, height: 40)
            }
        }
    }
}
extension String {
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
    }
}
//MARK: - Location
extension GigListVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            lat = latitude
            long = longitude
            print("Latitude: \(latitude), Longitude: \(longitude)")
            if fetchLatLong == false{
                if isComing == 0{
                    getGigListApi(lat: latitude, long: longitude, typee: selectedType)
                    fetchLatLong = true
                }
            }
            locationManager.stopUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
