//
//  EventDetailVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 22/12/23.
//
import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation
struct ServiceCategory {
    var name: String
    var imageName: String
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}
class HomeTabVC: UIViewController,CLLocationManagerDelegate {
    //MARK: - Outlets
    @IBOutlet var viewDot: UIView!
    @IBOutlet var scrollVw: UIScrollView!
    @IBOutlet var lblNoDataBusinesses: UILabel!
    @IBOutlet var lblNoDataTemprary: UILabel!
    @IBOutlet var lblNoDataGig: UILabel!
    @IBOutlet var btnLocation: UIButton!
    @IBOutlet var viewSecod: UIView!
    @IBOutlet var viewFirst: UIView!
    @IBOutlet var txtFldSearch: UITextField!
    @IBOutlet var collVwGiglist: UICollectionView!
    @IBOutlet var collVwBusinesses: UICollectionView!
    @IBOutlet weak var btnAllGig: UIButton!
    @IBOutlet var collVwTempraryStore: UICollectionView!
    @IBOutlet weak var btnAllTemprary: UIButton!
    @IBOutlet weak var btnAllBusiness: UIButton!
    @IBOutlet weak var heightLocationBtn: NSLayoutConstraint!
    //MARK: - Varibales
    var viewModel = ExploreVM()
    var arrBusiness = [Business]()
    var arrGigs = [Gig]()
    var arrTemporaryStores = [TemporaryStores]()
    var currentDay:String?
    var locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    var currentLatitude: CLLocationDegrees?
    var currentLongitude: CLLocationDegrees?
    let refreshControl = UIRefreshControl()
    var address = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadData()
    }
    func viewDidLoadData(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("role"), object: nil)
        print("role:--\(Store.role ?? "")")
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .restricted, .denied:
            // Show alert since location access is denied
            btnLocation.isHidden = true
            btnAllGig.isHidden = true
            btnAllBusiness.isHidden = true
            btnAllTemprary.isHidden = true
            arrGigs.removeAll()
            arrBusiness.removeAll()
            arrTemporaryStores.removeAll()
            collVwBusinesses.reloadData()
            collVwGiglist.reloadData()
            collVwTempraryStore.reloadData()
            lblNoDataGig.text = "Data Not Found!"
            lblNoDataTemprary.text = "Data Not Found!"
            lblNoDataBusinesses.text = "Data Not Found!"
            //locationDeniedAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission allow")
            self.dismiss(animated: false)
            btnLocation.isHidden = false
//            btnAllGig.isHidden = false
//            btnAllBusiness.isHidden = false
//            btnAllTemprary.isHidden = false
            lblNoDataGig.text = ""
            lblNoDataTemprary.text = ""
            lblNoDataBusinesses.text = ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            currentDay = dateFormatter.string(from: Date())
            getLocation()
            uiSet()
        default:
            print("Location permission not determined")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.ExploreApiNotification(notification:)), name: Notification.Name("ExploreApi"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getLocationAllow(notification:)), name: Notification.Name("locationAllow"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getLocationDenied(notification:)), name: Notification.Name("locationDenied"), object: nil)
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .restricted, .denied:
            // Show alert since location access is denied
            btnLocation.isHidden = true
            btnAllGig.isHidden = true
            btnAllBusiness.isHidden = true
            btnAllTemprary.isHidden = true
            arrGigs.removeAll()
            arrBusiness.removeAll()
            arrTemporaryStores.removeAll()
            collVwBusinesses.reloadData()
           collVwGiglist.reloadData()
            collVwTempraryStore.reloadData()
            lblNoDataGig.text = "Data Not Found!"
            lblNoDataTemprary.text = "Data Not Found!"
            lblNoDataBusinesses.text = "Data Not Found!"
           // locationDeniedAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            self.dismiss(animated: false)
            print("Location permission allow")
            btnLocation.isHidden = false
//            btnAllGig.isHidden = false
//            btnAllBusiness.isHidden = false
//            btnAllTemprary.isHidden = false
            lblNoDataGig.text = ""
            lblNoDataTemprary.text = ""
            lblNoDataBusinesses.text = ""
            uiSet()
        default:
            print("Location permission not determined")
        }
    }
    @objc func getLocationAllow(notification:Notification){
        self.dismiss(animated: false)
        btnLocation.isHidden = false
//        btnAllGig.isHidden = false
//        btnAllBusiness.isHidden = false
//        btnAllTemprary.isHidden = false
        lblNoDataGig.text = ""
        lblNoDataTemprary.text = ""
        lblNoDataBusinesses.text = ""
        getLocation()
        uiSet()
    }
    @objc func getLocationDenied(notification:Notification){
        btnLocation.isHidden = true
        btnAllGig.isHidden = true
        btnAllBusiness.isHidden = true
        btnAllTemprary.isHidden = true
        arrGigs.removeAll()
        arrBusiness.removeAll()
        arrTemporaryStores.removeAll()
        collVwBusinesses.reloadData()
       collVwGiglist.reloadData()
        collVwTempraryStore.reloadData()
        lblNoDataGig.text = "Data Not Found!"
        lblNoDataTemprary.text = "Data Not Found!"
        lblNoDataBusinesses.text = "Data Not Found!"
        //locationDeniedAlert()
    }
    func locationDeniedAlert(){
        let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
            //Redirect to Settings app
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func getLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        placesClient = GMSPlacesClient.shared()
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .restricted, .denied:
            // Show alert since location access is denied
            btnLocation.isHidden = true
            btnAllGig.isHidden = true
            btnAllBusiness.isHidden = true
            btnAllTemprary.isHidden = true
            arrGigs.removeAll()
            arrBusiness.removeAll()
            arrTemporaryStores.removeAll()
            collVwBusinesses.reloadData()
            collVwGiglist.reloadData()
            collVwTempraryStore.reloadData()
            lblNoDataGig.text = "Data Not Found!"
            lblNoDataTemprary.text = "Data Not Found!"
            lblNoDataBusinesses.text = "Data Not Found!"
          //  locationDeniedAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission allow")
            btnLocation.isHidden = false
//            btnAllGig.isHidden = false
//            btnAllBusiness.isHidden = false
//            btnAllTemprary.isHidden = false
            lblNoDataGig.text = ""
            lblNoDataTemprary.text = ""
            lblNoDataBusinesses.text = ""
            uiSet()
        default:
            print("Location permission not determined")
        }
    }
    @objc func ExploreApiNotification(notification: Notification) {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .restricted, .denied:
            // Show alert since location access is denied
            btnLocation.isHidden = true
            btnAllGig.isHidden = true
            btnAllBusiness.isHidden = true
            btnAllTemprary.isHidden = true
            arrGigs.removeAll()
            arrBusiness.removeAll()
            arrTemporaryStores.removeAll()
            collVwBusinesses.reloadData()
           collVwGiglist.reloadData()
            collVwTempraryStore.reloadData()
            lblNoDataGig.text = "Data Not Found!"
            lblNoDataTemprary.text = "Data Not Found!"
            lblNoDataBusinesses.text = "Data Not Found!"
           // locationDeniedAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission allow")
            btnLocation.isHidden = false
//            btnAllGig.isHidden = false
//            btnAllBusiness.isHidden = false
//            btnAllTemprary.isHidden = false
            lblNoDataGig.text = ""
            lblNoDataTemprary.text = ""
            lblNoDataBusinesses.text = ""
            getLocation()
            uiSet()
        default:
            print("Location permission not determined")
        }
    }
    func uiSet(){
        viewFirst.layer.cornerRadius = 15
        viewFirst.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        let nib = UINib(nibName: "TempraryStoresCVC", bundle: nil)
        collVwTempraryStore.register(nib, forCellWithReuseIdentifier: "TempraryStoresCVC")
        let nibGigList = UINib(nibName: "GigListCVC", bundle: nil)
        collVwGiglist.register(nibGigList, forCellWithReuseIdentifier: "GigListCVC")
        let nibBusiness = UINib(nibName: "PopularServicesCVC", bundle: nil)
        collVwBusinesses.register(nibBusiness, forCellWithReuseIdentifier: "PopularServicesCVC")
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        scrollVw.addSubview(refreshControl)
        if Store.userNotificationCount ?? 0 > 0{
            self.viewDot.isHidden = false
        }else{
            self.viewDot.isHidden = true
        }
        getExploreDataApi(lat: Store.userLatLong?["lat"] as? Double ?? 0, long: Store.userLatLong?["long"] as? Double ?? 0)
    }
    @objc func refresh(_ sender: AnyObject) {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .restricted, .denied:
            print("Location permission denied")
            // Show alert since location access is denied
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission allow")
            WebService.hideLoader()
            if !(Store.isLocationSelected ?? false) {
                getExploreDataApi(lat: Store.userLatLong?["lat"] as? Double ?? 0, long: Store.userLatLong?["long"] as? Double ?? 0)
            }
            refreshControl.endRefreshing()
        default:
            print("Location permission not determined")
        }
    }
    func getExploreDataApi(lat:Double,long:Double){
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .restricted, .denied:
            arrGigs.removeAll()
            arrBusiness.removeAll()
            arrTemporaryStores.removeAll()
            collVwBusinesses.reloadData()
           collVwGiglist.reloadData()
            collVwTempraryStore.reloadData()
            lblNoDataGig.text = "Data Not Found!"
            lblNoDataTemprary.text = "Data Not Found!"
            lblNoDataBusinesses.text = "Data Not Found!"
            //locationDeniedAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission allow")
            viewModel.GetUserExploreApi(latitude: lat, longitude: long) { data in
                self.arrBusiness = data?.business ?? []
                self.arrGigs = data?.gigs ?? []
                self.arrTemporaryStores = data?.temporaryStores ?? []
                if self.arrBusiness.count > 0{
                    self.lblNoDataBusinesses.text = ""
                    self.btnAllBusiness.isHidden = false
                }else{
                    self.lblNoDataBusinesses.text = "Data Not Found!"
                    self.btnAllBusiness.isHidden = true
                }
                if self.arrGigs.count > 0{
                    self.lblNoDataGig.text = ""
                    self.btnAllGig.isHidden = false
                }else{
                    self.lblNoDataGig.text = "Data Not Found!"
                    self.btnAllGig.isHidden = true
                }
                if self.arrTemporaryStores.count > 0{
                    self.lblNoDataTemprary.text = ""
                    self.btnAllTemprary.isHidden = false
                }else{
                    self.lblNoDataTemprary.text = "Data Not Found!"
                    self.btnAllTemprary.isHidden = true
                }

                self.collVwBusinesses.reloadData()
                self.collVwGiglist.reloadData()
                self.collVwTempraryStore.reloadData()
            }

        default:
            print("Location permission not determined")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let geocoder = GMSGeocoder()
            let currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            geocoder.reverseGeocodeCoordinate(currentLocation.coordinate) { response, error in
                if let error = error {
                    print("Reverse geocode failed: \(error.localizedDescription)")
                    return
                }
                guard let address = response?.firstResult(), let lines = address.lines else {
                    print("No address found")
                    return
                }
                let fullAddress = lines.joined(separator: ", ")
                DispatchQueue.main.async {
                    if !(Store.isLocationSelected ?? false) {
                        Store.userLatLong = ["lat":location.coordinate.latitude,"long":location.coordinate.longitude]
                        self.btnLocation.setTitle(fullAddress, for: .normal)
                        self.btnLocation.titleLabel?.numberOfLines = 2
                        self.btnLocation.sizeToFit()
                        self.heightLocationBtn.constant = self.btnLocation.frame.height
                    }else{
                        self.btnLocation.setTitle(Store.userLatLong?["address"] as? String ?? "", for: .normal)
                        self.btnLocation.titleLabel?.numberOfLines = 2
                        self.btnLocation.sizeToFit()
                        self.heightLocationBtn.constant = self.btnLocation.frame.height
                    }
                }
            }
        }
    }
    @objc func methodOfReceivedNotificationHome(notification: Notification) {
        uiSet()
    }
    //MARK: - Button actions
    @IBAction func actionNotifications(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        vc.callBack = {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                self.viewDot.isHidden = true
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionLocation(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CurrentLocationVC") as! CurrentLocationVC
        vc.isComing = true
        vc.callBack = { address in
            Store.isLocationSelected = true
            Store.userLatLong = ["lat":address.lat ?? 0,"long":address.long ?? 0,"address":address.placeName ?? ""]
            self.btnLocation.setTitle(address.placeName, for: .normal)
            self.getExploreDataApi(lat: Store.userLatLong?["lat"] as? Double ?? 0, long: Store.userLatLong?["long"] as? Double ?? 0)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionSearch(_ sender: UIButton) {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .restricted, .denied:
            // Show alert since location access is denied
            locationDeniedAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission allow")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            self.navigationController?.pushViewController(vc, animated: false)
        default:
            print("Location permission not determined")
        }
    }
    @IBAction func actionGiglist(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigListVC") as! GigListVC
        vc.isComing = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionAllTempraryStore(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TempraryAndBusinessesVC") as! TempraryAndBusinessesVC
//        vc.currentLat = latitude
        vc.currentLat = Store.userLatLong?["lat"] as? Double ?? 0
        vc.currentLong = Store.userLatLong?["long"] as? Double ?? 0
        vc.isSelect = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionSeeAllBusinesss(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TempraryAndBusinessesVC") as! TempraryAndBusinessesVC
        vc.isSelect = 0
        vc.currentLat = Store.userLatLong?["lat"] as? Double ?? 0
        vc.currentLong = Store.userLatLong?["long"] as? Double ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - UICollectionViewDelegate
extension HomeTabVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwGiglist{
            return min(arrGigs.count, 10)
        }else if collectionView == collVwTempraryStore{
            return arrTemporaryStores.count
        }else{
            return arrBusiness.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
            cell.lblName.text = arrGigs[indexPath.row].name ?? ""
            cell.lblPrice.text = "$\(arrGigs[indexPath.row].price ?? 0)"
            cell.lblTitle.text = arrGigs[indexPath.row].title ?? ""
            let rating = arrGigs[indexPath.row].UserRating ?? 0.0
            let formattedRating = String(format: "%.1f", rating)
            cell.lblRating.text = formattedRating
            if arrGigs[indexPath.row].userRatingCount ?? 0 > 1{
                cell.lblUserCount.text = "(\(arrGigs[indexPath.row].userRatingCount ?? 0) Reviews)"
            }else{
                cell.lblUserCount.text = "(\(arrGigs[indexPath.row].userRatingCount ?? 0) Review)"
            }
            if arrGigs[indexPath.row].image == "" || arrGigs[indexPath.row].image == nil{
                cell.imgVwGig.image = UIImage(named: "dummy")
            }else{
                cell.imgVwGig.imageLoad(imageUrl: arrGigs[indexPath.row].image ?? "")
            }
            
            cell.imgVwGig.layer.cornerRadius = 10
            cell.imgVwGig.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            return cell
        }else if collectionView == collVwTempraryStore{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TempraryStoresCVC", for: indexPath) as! TempraryStoresCVC
            cell.viewShadow.layer.masksToBounds = false
            cell.viewShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
            cell.viewShadow.layer.shadowOpacity = 0.44
            cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.viewShadow.layer.shouldRasterize = true
            cell.viewShadow.layer.rasterizationScale = UIScreen.main.scale
            cell.imgVwStore.layer.cornerRadius = 48
            cell.imgVwStore.imageLoad(imageUrl: arrTemporaryStores[indexPath.row].businessLogo ?? "")
            cell.lblStoreName.text = arrTemporaryStores[indexPath.row].name ?? ""
            cell.lblNameProvider.text = arrTemporaryStores[indexPath.row].userId?.name ?? ""
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularServicesCVC", for: indexPath) as! PopularServicesCVC
            cell.indexpath = indexPath.row
           
            cell.vwShadow.layer.masksToBounds = false
            cell.vwShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
            cell.vwShadow.layer.shadowOpacity = 0.44
            cell.vwShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.vwShadow.layer.shouldRasterize = true
            cell.vwShadow.layer.rasterizationScale = UIScreen.main.scale
            cell.vwShadow.layer.cornerRadius = 10
      
            let business = arrBusiness[indexPath.row]
            cell.imgVwUser.imageLoad(imageUrl: business.profilePhoto ?? "")
        
            cell.lblServiceName.text = business.businessname ?? ""
            if business.status == 2{
                cell.imgVwBlueTick.isHidden = false
            }else{
                cell.imgVwBlueTick.isHidden = true
            }
            let rating = business.userRating ?? 0.0
            let formattedRating = String(format: "%.1f", rating)
            cell.lblRating.text = formattedRating
       
            var openingHoursFound = false
            for openingHour in business.openingHours ?? [] {
                if openingHour.day == currentDay {
                    openingHoursFound = true
                    let startTime12 = convertTo12HourFormat(openingHour.starttime ?? "")
                    let endTime12 = convertTo12HourFormat(openingHour.endtime ?? "")
                    cell.lblTime.text = "\(startTime12) - \(endTime12)"
                    break
                }
            }
            if !openingHoursFound {
                cell.lblTime.text = "Closed"
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwGiglist{
            return CGSize(width: collVwGiglist.frame.size.width / 1.8, height: 220)
        }else if collectionView == collVwTempraryStore{
            return CGSize(width: collVwTempraryStore.frame.size.width / 3.2 - 7, height: 150)
        }else{
            return CGSize(width: collVwBusinesses.frame.size.width / 1.5, height: 200)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collVwGiglist{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItineraryVC") as! ItineraryVC
            self.navigationController?.pushViewController(vc, animated: true)

//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ApplyGigVC") as! ApplyGigVC
//            Store.isUserParticipantsList = false
//            vc.isComing = 0
//            vc.gigId = arrGigs[indexPath.row].id ?? ""
//            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == collVwBusinesses{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutServicesVC") as! AboutServicesVC
            vc.businessId = arrBusiness[indexPath.row].id ?? ""
            Store.BusinessUserIdForReview = arrBusiness[indexPath.row].id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupUserVC") as! PopupUserVC
            vc.popupId = arrTemporaryStores[indexPath.row].id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension HomeTabVC {
    func convertTo12HourFormat(_ time24: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let date24 = dateFormatter.date(from: time24) {
            dateFormatter.dateFormat = "h:mm a"
            let time12 = dateFormatter.string(from: date24)
            return time12
        }
        return ""
    }
}
//MARK: - GMSAutocompleteViewControllerDelegate
extension HomeTabVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        btnLocation.setTitle(place.formattedAddress, for: .normal)
        self.btnLocation.titleLabel?.numberOfLines = 2
        btnLocation.sizeToFit()
        heightLocationBtn.constant = btnLocation.frame.height
        Store.userLatLong = ["lat":place.coordinate.latitude,"long":place.coordinate.longitude]
        getExploreDataApi(lat: Store.userLatLong?["lat"] as? Double ?? 0, long: Store.userLatLong?["long"] as? Double ?? 0)
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
