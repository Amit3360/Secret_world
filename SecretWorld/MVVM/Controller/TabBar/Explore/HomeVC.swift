//
//  HomeVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 13/02/25.
//

import UIKit
import Messages
import Pulsator
import JJFloatingActionButton
import VerticalSlider
import MapKit
import SwiftUI
import SDWebImage
import SocketIO
import MapboxMaps
import MapboxCommon
import MapboxCoreMaps
import Turf
import Solar

struct Coordinate: Hashable {
    let latitude: Double
    let longitude: Double
    init(_ coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
struct ClusterPoint: Hashable {
    let coordinate: CLLocationCoordinate2D
    let price: Double
    let seen: Int
    // Conform to Hashable for deduplication
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
        hasher.combine(price)
        hasher.combine(seen)
    }
    static func == (lhs: ClusterPoint, rhs: ClusterPoint) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude &&
        lhs.price == rhs.price &&
        lhs.seen == rhs.seen
    }
}

class HomeVC: UIViewController, GestureManagerDelegate {
    //MARK: - OUTLETS

    @IBOutlet var viewDot: UIView!
    @IBOutlet var lblMoment: UILabel!
    @IBOutlet var heightTblVwMoment: NSLayoutConstraint!
    @IBOutlet var btnMomentFilter: UIButton!
    @IBOutlet var btnAllMoment: UIButton!
    @IBOutlet var vwMoment: UIView!
    @IBOutlet var tblVwMoments: UITableView!
    @IBOutlet weak var lblBusiness: UILabel!
    @IBOutlet weak var lblPopup: UILabel!
    @IBOutlet weak var lblTask: UILabel!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var heightPopUpColl: NSLayoutConstraint!
    @IBOutlet weak var heightBusinessColl: NSLayoutConstraint!
    @IBOutlet weak var heightTaslTblVw: NSLayoutConstraint!
    @IBOutlet weak var bottomCenterVw: NSLayoutConstraint!
    @IBOutlet weak var topSearchVw: NSLayoutConstraint!
    @IBOutlet weak var btnAllPopup: UIButton!
    @IBOutlet weak var btnAllBusiness: UIButton!
    @IBOutlet weak var btnAllTask: UIButton!
    @IBOutlet weak var vwRefresh: UIView!
    @IBOutlet weak var vwRecenter: UIView!
    @IBOutlet weak var lblWorldwideTask: UILabel!
    @IBOutlet weak var imgVwWorldwideTask: UIImageView!
    @IBOutlet weak var lblLocalTask: UILabel!
    @IBOutlet weak var imgVwLocalTask: UIImageView!
    @IBOutlet weak var vwWorldwideTask: UIView!
    @IBOutlet weak var vwLocalTask: UIView!
    @IBOutlet weak var vwPopup: UIView!
    @IBOutlet weak var vwBusiness: UIView!
    @IBOutlet weak var vwTask: UIView!
    @IBOutlet weak var collVwPopUp: UICollectionView!
    @IBOutlet weak var collVwBusiness: UICollectionView!
    @IBOutlet weak var collVwSelectType: UICollectionView!
    @IBOutlet weak var tblVwTask: UITableView!
    @IBOutlet weak var btnGigFilter: UIButton!
    @IBOutlet weak var btnStoreFilter: UIButton!
    @IBOutlet weak var btnBusinessFilter: UIButton!
    @IBOutlet weak var heightStackVw: NSLayoutConstraint!
    @IBOutlet weak var bottomStackVw: NSLayoutConstraint!
    @IBOutlet weak var topMapVw: NSLayoutConstraint!
    @IBOutlet weak var vwCustomMap: UIView!
    @IBOutlet weak var vwSelectType: UIView!
    @IBOutlet var imgVwEarnShadow: UIImageView!
    @IBOutlet weak var lblEarning: UILabel!
    @IBOutlet weak var vwEarning: UIView!
    @IBOutlet weak var widthEarningVw: NSLayoutConstraint!
   
    
    //MARK: - VARIABLES
    private var currentLocationAnnotationManager: PointAnnotationManager?
    let locationManager = CLLocationManager()
    var isSelectTask = false
    var arrPoint = [Point]()
    var arrTask = [FilteredItem]()
    var arrPopUp = [FilteredItem]()
    var arrBusiness = [FilteredItem]()
    var arrMoments = [FilteredItem]()
    var currentLat = 0.0
    var currentLong = 0.0
    private var solar: Solar?
    var arrOverlapAnnotation = [CLLocationCoordinate2D]()
    private var cancelables = Set<AnyCancelable>()
    var mapView:MapView!
    var mapAdded:Bool = false
    private var arrType = ["All","Moment","Popup","Business"]
//    private var typeIndex = 0
    private var selectTypeIndex = false
    var currentDay:String?
    var minDitance = 0.0
    var maxDistance = 8046.72
    var homeListenerCall = false
//    var type = 1
    var mapRadius:Double = 10
    let deviceHasNotch = UIApplication.shared.hasNotch
    private var openList = false
    var pointAnnotationManagerGig: PointAnnotationManager!
    var pointAnnotationManagerPop: PointAnnotationManager!
    var pointAnnotationManagerBusiness: PointAnnotationManager!
    var pointAnnotationManagerMoments: PointAnnotationManager!
    var arrGigPointAnnotations: [PointAnnotation] = []
    var arrPopUpPointAnnotations: [PointAnnotation] = []
    var arrBusinessPointAnnotations: [PointAnnotation] = []
    var arrMomentsPointAnnotations: [PointAnnotation] = []
    var arrData = [FilteredItem]()
    var customAnnotations: [ClusterPoint] = []
    var isAppendHeatMap = false
    var lastZoomUpdateTime: TimeInterval = 0
    var isAnnotationViewVisible = false
    var visibleIndex = 0
    var gigPopUpShow = false
    var isPopUpVCShown = false
    var isNavigating = false
    var gigAppliedStatus = 0
    var isReadyChat = 0
    var gigDetail:FilteredItem?
    var gigUserId = ""
    var gigIdForGroup = ""
    var groupId = ""
    var selectItemSeen = 0
    var selectGigId = ""
    var viewModel = PopUpVM()
    var arrSkills = [SkillsCategory]()
    var isSearch = false
 
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.callSocket(notification:)), name: Notification.Name("callHomeSocket"), object: nil)
        print("Token------",Store.authKey ?? "")
        registerCell()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    func registerCell(){
        let nib1 = UINib(nibName: "MomentsListTVC", bundle: nil)
        tblVwMoments.register(nib1, forCellReuseIdentifier: "MomentsListTVC")

            let nib = UINib(nibName: "StoreCVC", bundle: nil)
            self.collVwPopUp.register(nib, forCellWithReuseIdentifier: "StoreCVC")
            let nibBusiness = UINib(nibName: "PopularServicesCVC", bundle: nil)
            self.collVwBusiness.register(nibBusiness, forCellWithReuseIdentifier: "PopularServicesCVC")
            self.collVwBusiness.decelerationRate = .fast
            self.collVwPopUp.decelerationRate = .fast
            let nibNearBy = UINib(nibName: "GigNearByTVC", bundle: nil)
            self.tblVwTask.register(nibNearBy, forCellReuseIdentifier: "GigNearByTVC")
            self.tblVwTask.showsVerticalScrollIndicator = false
            self.tblVwTask.separatorStyle = .none
       

            NotificationCenter.default.addObserver(self, selector: #selector(self.selectOtherTab(notification:)), name: Notification.Name("SelectOther"), object: nil)
            self.btnAllTask.underline()
            self.btnAllPopup.underline()
            self.btnAllBusiness.underline()
           self.btnAllMoment.underline()
        self.vwEarning.isHidden = false
            Store.isSelectTab = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            self.currentDay = dateFormatter.string(from: Date())
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .restricted, .denied:
                self.removeDataWhileLocationDenied()
                self.locationDeniedAlert()
            case .authorizedWhenInUse, .authorizedAlways:
                self.homeListenerCall = false
                self.removeAllArray()
                self.socketData()
            default:
                print("Location permission not determined")
            }
            self.locationdata()
        
    }
    @objc func callSocket(notification: Notification) {
        registerCell()
        NotificationCenter.default.post(name: Notification.Name("callBackGetDot"), object: nil)
    }
    func uiSet(){
        print("Device Token---",Store.deviceToken ?? "")
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        vwSelectType.addGestureRecognizer(panGesture)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationdata(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .restricted, .denied:
            removeDataWhileLocationDenied()
        case .authorizedWhenInUse, .authorizedAlways:
            getDidLoadData()
        default:
            print("Location permission not determined")
        }
    }
    override func viewWillAppear(_ animated: Bool){

        if Store.role != "user"{
            configureNonUserView()
            if !UIDevice.current.hasDynamicIsland {
                if isSelectAnother{
                    bottomCenterVw.constant = 30
                }else{
                    bottomCenterVw.constant = 20
                }
            }
        }
//        self.typeIndex = 0
        self.collVwSelectType.reloadData()
//        self.type = 1
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .restricted, .denied:
            removeDataWhileLocationDenied()
        case .authorizedWhenInUse, .authorizedAlways:
            self.dismiss(animated: true)
            removeAllArray()
            homeListenerCall = false
        default:
            print("Location permission not determined")
        }
        
    }
   
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        switch gesture.state {
        case .changed:
            let velocity = gesture.velocity(in: self.view).y
            if velocity < 0 {
                self.vwLocalTask.isHidden = true
                self.vwWorldwideTask.isHidden = true
                self.vwRefresh.isHidden = true
                self.vwRecenter.isHidden = true
                self.openList = true
                UIView.animate(withDuration: 0.5) {
                    
                    self.mapView.viewAnnotations.removeAll()
                    
                    if self.deviceHasNotch{
                        if UIDevice.current.hasDynamicIsland {
                            self.heightStackVw.constant = CGFloat(self.view.frame.height - 150)
                        }else{
                            self.heightStackVw.constant = CGFloat(self.view.frame.height - 140)
                        }
                    }else{
                        self.heightStackVw.constant = CGFloat(self.view.frame.height - 100)
                    }
                    
                    self.view.layoutIfNeeded()
                }
            } else {
                self.openList = false
                UIView.animate(withDuration: 0.5) {
                    if selectHomeIndex == 1{
//                        self.vwLocalTask.isHidden = false
//                        self.vwWorldwideTask.isHidden = false
                        self.vwLocalTask.isHidden = true
                        self.vwWorldwideTask.isHidden = true
                        self.vwRecenter.isHidden = false
                        self.vwRefresh.isHidden = false
                    }
                    
                    self.view.layoutIfNeeded()
                    self.heightStackVw.constant = 100
                    
                }
            }
        default:
            break
        }
    }
    
    func addMapView(currentLat: Double, currentLong: Double) {
        let mapInitOptions = MapInitOptions(
            cameraOptions: CameraOptions(
                center: CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong),
                zoom: 15.62,
                bearing: 70,
                pitch: 69
            )
        )
        
        DispatchQueue.main.async {
            self.mapView = MapView(frame: self.view.bounds, mapInitOptions: mapInitOptions)
            self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.vwCustomMap.addSubview(self.mapView)
            
            // Set Day/Night style based on solar time
            if let solar = Solar(coordinate: CLLocationCoordinate2D(latitude: self.currentLat, longitude: self.currentLong)) {
                self.solar = solar
                let isDaytime = solar.isDaytime
                print(isDaytime ? "It's day time!" : "It's night time!")
                self.mapView.mapboxMap.styleURI = isDaytime ? .dark : .dark
            }
            
            self.mapView.ornaments.scaleBarView.isHidden = true
            self.mapView.ornaments.logoView.isHidden = true
            self.mapView.ornaments.attributionButton.isHidden = true
            self.mapView.ornaments.compassView.isHidden = true

            self.mapView.gestures.delegate = self
            
            self.mapData(type: selectHomeIndex, gigType: Store.GigType ?? 0, lat: self.mapView.mapboxMap.cameraState.center.latitude, long: self.mapView.mapboxMap.cameraState.center.longitude)
            
        }
    }
  
    func addCurrentLocationMarker(location:CLLocationCoordinate2D) {
        // Create or reuse the annotation manager
        if currentLocationAnnotationManager == nil {
            currentLocationAnnotationManager = mapView.annotations.makePointAnnotationManager()
        }
        // Clear any existing annotations
        currentLocationAnnotationManager?.annotations = []
        // Create and add the new annotation
        let originalImage = UIImage(named: "blueDot")!
        let resizedImage = resizeImage(originalImage, to: CGSize(width: 35, height: 35))
        var pointAnnotation = PointAnnotation(coordinate: location)
        pointAnnotation.image = .init(image: resizedImage ?? UIImage(), name: "blueDot")
        currentLocationAnnotationManager?.annotations = [pointAnnotation]
    }
    func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        image.draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func getDidLoadData(){
        NotificationCenter.default.removeObserver(self, name: Notification.Name("locationAllow"), object: nil)
           NotificationCenter.default.removeObserver(self, name: Notification.Name("locationDenied"), object: nil)
           NotificationCenter.default.removeObserver(self, name: Notification.Name("TabBar"), object: nil)
           NotificationCenter.default.removeObserver(self, name: Notification.Name("SelectOther"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getLocationAllow(notification:)), name: Notification.Name("locationAllow"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getLocationDenied(notification:)), name: Notification.Name("locationDenied"), object: nil)
        
    }
    
    
  
    @objc func selectOtherTab(notification: Notification) {
        isSelectAnother = true
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .restricted, .denied:
            removeDataWhileLocationDenied()
            // locationDeniedAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            self.dismiss(animated: true)
            
        default:
            print("Location permission not determined")
        }
    }
    @objc func getLocationDenied(notification:Notification){
        removeDataWhileLocationDenied()
    }
    func removeDataWhileLocationDenied(){
        vwRefresh.isHidden = true
        vwRecenter.isHidden = true
        tblVwMoments.reloadData()
        tblVwTask.reloadData()
        collVwPopUp.reloadData()
        collVwBusiness.reloadData()
    }
    @objc func getLocationAllow(notification:Notification){
        self.dismiss(animated: false)
        getDidLoadData()
    }
    
    func animateZoomInOut() {
        UIView.animate(withDuration: 3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.imgVwEarnShadow.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.imgVwEarnShadow.center = CGPoint(x: self.vwEarning.bounds.midX, y: self.vwEarning.bounds.midY)
        }) { (finished) in
            UIView.animate(withDuration: 3, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.imgVwEarnShadow.transform = CGAffineTransform.identity
                self.imgVwEarnShadow.center = CGPoint(x: self.vwEarning.bounds.midX, y: self.vwEarning.bounds.midY)
            }, completion: { _ in
                self.animateZoomInOut()
            })
        }
    }
    
    func socketData(){
        animateZoomInOut()
      
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
            if SocketIOManager.sharedInstance.socket?.status == .connected{
             
                self.mapData(type: selectHomeIndex, gigType: Store.GigType ?? 0,lat: self.mapView.mapboxMap.cameraState.center.latitude,long: self.mapView.mapboxMap.cameraState.center.longitude)

                
            }else{
                SocketIOManager.sharedInstance.reConnectSocket(userId: Store.userId ?? "")
                DispatchQueue.main.asyncAfter(deadline: .now()+4.0){
                   
                    self.mapData(type: selectHomeIndex, gigType: Store.GigType ?? 0,lat: self.mapView.mapboxMap.cameraState.center.latitude,long: self.mapView.mapboxMap.cameraState.center.longitude)

                }
            }
        }
    }
    func getEarning(radius:Double,lat:Double,long:Double){
        
        if Store.GigType == 0 || Store.GigType == 1{
            let param: [String: Any] = [
                "deviceId":Store.deviceToken ?? "",
                "userId": Store.userId ?? "",
                "lat": "\(lat)",
                "long": "\(long)",
                "radius": radius,
                "gigType":Store.GigType ?? 0
            ]
            print("getEarningParam----", param)
            SocketIOManager.sharedInstance.getEarnings(dict: param)
            
        }else{
            let param: [String: Any] = [
                "deviceId":Store.deviceToken ?? "",
                "userId": Store.userId ?? "",
                "lat": "\(lat)",
                "long": "\(long)",
                "radius": radius,
            ]
            print("getEarningParam----", param)
            SocketIOManager.sharedInstance.getEarnings(dict: param)
            
        }
        SocketIOManager.sharedInstance.earningData = { data in
            
            if Store.role == "user" {
                self.lblEarning.text = "$\(data?[0].totalEarnings ?? 0)"
                
            }
        }
    }
    
   
    func convertKilometersToMiles(kilometers: Double) -> Double {
        return kilometers * 0.621371
    }
    func convertMilesToKilometers(miles: Double) -> Double {
        return miles / 1.60934
    }
    func mapData(type: Int, gigType: Int, lat: Double, long: Double) {
        
        guard let userId = Store.userId else { return }
        
        //         var param: [String: Any] = ["userId": userId, "lat": lat, "long": long, "radius": radius, "type": type]
        
        var param: [String: Any] = ["userId": userId, "lat": lat, "long": long, "type": type]
        if Store.role == "user" {
            switch type {
            case 1: // Gig
                if Store.isSelectGigFilter == true {
                    
                    param.merge(Store.filterData ?? [:]) { _, new in new }
                    
                    param = param.mapValues { value in
                        if let nsArray = value as? NSArray {
                            return nsArray.compactMap { $0 as? Int }
                        }
                        return value
                    }
                    let allDistances = Set([1,2,3])
                    let selectedDistances = Set(Store.taskMiles)
                    
                    if allDistances.isSubset(of: selectedDistances) {
                        print("All")
                        param["minDistanceInMeters"] = minDitance
                        param["maxDistanceInMeters"] = maxDistance
                    } else if selectedDistances == [1] {
                        print("Only 1")
                        param["minDistanceInMeters"] = minDitance
                        param["maxDistanceInMeters"] = maxDistance
                    }else if selectedDistances == [2] {
                        print("Only 2")
                        
                        param["minDistanceInMeters"] = minDitance
                        param["maxDistanceInMeters"] = maxDistance
                    } else if selectedDistances == [3] {
                        print("Only 3")
                        param["minDistanceInMeters"] = minDitance
                        param["maxDistanceInMeters"] = 1000000
                        //                         param.removeValue(forKey: "maxDistanceInMeters")
                    } else if selectedDistances == [1,2] {
                        print("Only 1,2")
                        
                        param["minDistanceInMeters"] = minDitance
                        param["maxDistanceInMeters"] = 24140.2
                    } else if selectedDistances == [2,3] {
                        print("Only 2,3")
                        param["maxDistanceInMeters"] = 1000000
                        param["minDistanceInMeters"] = minDitance
                        
                    } else if selectedDistances == [1,3] {
                        print("Only 1,3")
                        
                        param["minDistanceInMeters"] = minDitance
                        param["maxDistanceInMeters"] = maxDistance
                    }else{
                        param["minDistanceInMeters"] = minDitance
                        param["maxDistanceInMeters"] = maxDistance
                    }
//                    param["gigType"] = gigType
                }else{
                    param["minDistanceInMeters"] = minDitance
                    param["maxDistanceInMeters"] = maxDistance
//                    param["gigType"] = gigType
                    
                }
                
            case 2: // Store
                
                if Store.isSelectPopUpFilter == true {
                    param.merge(Store.filterDataPopUp ?? [:]) { _, new in new }
                    param = param.mapValues { value in
                        if let nsArray = value as? NSArray {
                            return nsArray.compactMap { $0 as? Int }
                        }
                        return value
                    }
                    param["minDistanceInMeters"] = minDitance
                    param["maxDistanceInMeters"] = maxDistance
                }else{
                    param["minDistanceInMeters"] = minDitance
                    param["maxDistanceInMeters"] = maxDistance
                }
            default: // Business
                if Store.isSelectBusinessFilter == true {
                    param.merge(Store.filterDataBusiness ?? [:]) { _, new in new }
                    param = param.mapValues { value in
                        if let nsArray = value as? NSArray {
                            return nsArray.compactMap { $0 as? Int }
                        }
                        return value
                    }
                    param["minDistanceInMeters"] = minDitance
                    param["maxDistanceInMeters"] = maxDistance
                }else{
                    param["minDistanceInMeters"] = minDitance
                    param["maxDistanceInMeters"] = maxDistance
                }
            }
            print("Param-----",param)
            SocketIOManager.sharedInstance.home(dict: param)
            
            SocketIOManager.sharedInstance.homeData = { data in
                self.selectTypeIndex = false
              
                NotificationCenter.default.post(name: Notification.Name("MapLoaded"), object: nil)
                guard let data = data, data.count > 0 else { return }
                
                if !self.homeListenerCall {
               
                    self.setDataBottomList(item: data[0].data?.filteredItems ?? [])
                    if selectHomeIndex == 5{
                        
                        self.btnGigFilter.isHidden = true
                        self.btnBusinessFilter.isHidden = true
                        self.btnStoreFilter.isHidden = true
                    }else{
                        self.btnGigFilter.isHidden = false
                        self.btnBusinessFilter.isHidden = false
                        self.btnStoreFilter.isHidden = false
                    }
                   
                    self.updateData(from: data[0].data)
                }
            }
        }else{
            var param2: [String: Any] = ["userId": userId, "lat": lat, "long": long]
            param2["minDistanceInMeters"] = minDitance
            param2["maxDistanceInMeters"] = maxDistance
            print("Param-----",param2)
            SocketIOManager.sharedInstance.home(dict: param2)
            
            SocketIOManager.sharedInstance.homeData = { data in
                guard let data = data, data.count > 0 else { return }
                print("Data------",data)
                if !self.homeListenerCall {
                    
                    self.updateData(from: data[0].data)
                }
            }
        }
    }
    func setDataBottomList(item:[FilteredItem]){
        for i in item{
            if i.type == "gig"{
                self.arrTask.append(i)
            }else if i.type == "popUp"{
                self.arrPopUp.append(i)
            }else if i.type == "moment"{
                self.arrMoments.append(i)
            }else{
                self.arrBusiness.append(i)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
            //-----------------
            if self.arrTask.count == 0{
                self.heightTaslTblVw.constant = CGFloat(0)
                if selectHomeIndex == 5{
                    self.vwTask.isHidden = true
                }
                self.lblTask.text = "No matching results"
            }else if self.arrTask.count < 2{
                self.heightTaslTblVw.constant = CGFloat(self.arrTask.count*140)
                self.lblTask.text = "Task"
                if selectHomeIndex == 5{
                    self.vwTask.isHidden = false
                }
            }else{
                self.lblTask.text = "Task"
                if selectHomeIndex == 5{
                    self.vwTask.isHidden = false
                }
                if selectHomeIndex == 5{
                self.heightTaslTblVw.constant = 276
                }else{
                self.heightTaslTblVw.constant = CGFloat(self.arrTask.count*140)
                }
                
            }
            //--------------------
            if self.arrPopUp.count == 0{
                self.heightPopUpColl.constant = CGFloat(0)
                if selectHomeIndex == 5{
                    self.vwPopup.isHidden = true
                }
                self.lblPopup.text = "No matching results"
            }else if self.arrPopUp.count < 2{
                if selectHomeIndex == 5{
                    self.vwPopup.isHidden = false
                }
                self.heightPopUpColl.constant = CGFloat(self.arrPopUp.count*130)
                self.lblPopup.text = "Popup"
            }else{
                self.lblPopup.text = "Popup"
                if selectHomeIndex == 5{
                    self.vwPopup.isHidden = false
                }
                if selectHomeIndex == 5{
                self.heightPopUpColl.constant = 260
                }else{
                self.heightPopUpColl.constant = CGFloat(self.arrPopUp.count*130)
                }
               
            }
            
            //-----------------
            if self.arrBusiness.count == 0{
                if selectHomeIndex == 5{
                    self.vwBusiness.isHidden = true
                }
                self.heightBusinessColl.constant = CGFloat(0)
                self.lblBusiness.text = "No matching results"
            }else if self.arrBusiness.count < 2{
                if selectHomeIndex == 5{
                    self.vwBusiness.isHidden = false
                }
                self.heightBusinessColl.constant = CGFloat(self.arrBusiness.count*100)
                self.lblBusiness.text = "Business"
            }else{
                self.lblBusiness.text = "Business"
                if selectHomeIndex == 5{
                    self.vwBusiness.isHidden = false
            
                self.heightBusinessColl.constant = 200
                }else{
                self.heightBusinessColl.constant = CGFloat(self.arrBusiness.count*100)
                }
              
            }
            //-----------
            if self.arrMoments.count == 0{
                self.heightTblVwMoment.constant = CGFloat(0)
                if selectHomeIndex == 5{
                    self.vwMoment.isHidden = true
                }
                self.lblTask.text = "No matching results"
                self.lblMoment.text = "No matching results"
            }else if self.arrMoments.count < 2{
                self.heightTblVwMoment.constant = CGFloat(self.arrMoments.count*120)
                self.lblMoment.text = "Moment"
                self.lblTask.text = "Moment"
                if selectHomeIndex == 5{
                    self.vwMoment.isHidden = false
                }
            }else{
                self.lblMoment.text = "Moment"
                self.lblTask.text = "Moment"
                if selectHomeIndex == 5{
                    self.vwMoment.isHidden = false
                }
                if selectHomeIndex == 5{
                self.heightTblVwMoment.constant = 240
                }else{
                self.heightTblVwMoment.constant = CGFloat(self.arrMoments.count*120)
                }
                
            }

            self.tblVwMoments.reloadData()
            self.tblVwTask.reloadData()
            self.collVwPopUp.reloadData()
            self.collVwBusiness.reloadData()
        }
        
    }
    
    func removeAllArray(){
        SDWebImageDownloader.shared.cancelAllDownloads()
        pointAnnotationManagerMoments?.annotations = []
        pointAnnotationManagerGig?.annotations = []
        pointAnnotationManagerPop?.annotations = []
        pointAnnotationManagerBusiness?.annotations = []
        arrBusinessPointAnnotations.removeAll()
        arrGigPointAnnotations.removeAll()
        arrPopUpPointAnnotations.removeAll()
        arrMomentsPointAnnotations.removeAll()
        arrPoint.removeAll()
        arrData.removeAll()
        arrTask.removeAll()
        arrMoments.removeAll()
        arrPopUp.removeAll()
        arrBusiness.removeAll()
        customAnnotations.removeAll()
    }
    
    // Helper Methods
    private func updateData(from data: HomeData?) {
        guard let data = data else { return }
        
        // Update notifications count
        Store.userNotificationCount = data.notificationsCount ?? 0
        
        if data.notificationsCount ?? 0 > 0{
            self.viewDot.isHidden = true
        }else{
            self.viewDot.isHidden = true
        }

        // Filter and append data
        let filteredItems = data.filteredItems ?? []
        let filteredItemIDs = Set(filteredItems.map { $0.id })
        
        self.arrData.removeAll { !filteredItemIDs.contains($0.id) }
        for item in filteredItems where !self.arrData.contains(where: { $0.id == item.id }) {
            
            self.arrData.append(item)
        }
        
        if Store.role == "user" {
            handleTypeUpdateUI(data: arrData)
        }
        
        updateAnnotations(from: filteredItems)
    }
    
    private func updateAnnotations(from items: [FilteredItem]) {
        print("Items----", items)
        
        if Store.role != "user" {
            configureNonUserView()
        }
        
        for item in items {
            let centerCoordinate = CLLocationCoordinate2D(latitude: item.lat ?? 0, longitude: item.long ?? 0)
            let userId = item.userID
            let isCurrentUser = (Store.userId == userId)
            let seenStatus = isCurrentUser ? 2 : (item.seen ?? 0)
            
            switch selectHomeIndex {
            case 1:
                addGigAnnotation(for: item, seen: seenStatus)
                
            case 3:
                downloadBusinessImage(for: item)
                

            case 5:
                handleTypeFourAnnotations(for: item, seen: seenStatus)
                
            default:
                downloadPopupImage(for: item)
                
            }
        }
        if selectHomeIndex != 1{
            heatMapLayer()
        }
        initializeAnnotationManagers()
        homeListenerCall = true
    }
    private func initializeAnnotationManagers() {
        if pointAnnotationManagerBusiness == nil {
            pointAnnotationManagerBusiness = mapView.annotations.makePointAnnotationManager()
            pointAnnotationManagerBusiness?.delegate = self
        }
        if pointAnnotationManagerGig == nil {
            pointAnnotationManagerGig = mapView.annotations.makePointAnnotationManager()
            pointAnnotationManagerGig?.delegate = self
        }
        if pointAnnotationManagerPop == nil {
            pointAnnotationManagerPop = mapView.annotations.makePointAnnotationManager()
            pointAnnotationManagerPop?.delegate = self
        }
        if pointAnnotationManagerMoments == nil {
            pointAnnotationManagerMoments = mapView.annotations.makePointAnnotationManager()
            pointAnnotationManagerMoments?.delegate = self
        }

      
    }
    private func configureNonUserView() {
        heightStackVw.constant = 0
        vwSearch.isHidden = true
    }

    private func handleTypeFourAnnotations(for item: FilteredItem, seen: Int) {
        if item.type == "gig" {
            addGigAnnotation(for: item, seen: seen)
        } else if item.type == "popUp" {
            downloadPopupImage(for: item)
        }else if item.type == "moment" {
            DispatchQueue.main.asyncAfter(deadline: .now()){
                self.downloadMoment(for: item)
            }
        } else {
            downloadBusinessImage(for: item)
        }
        
    }

    private func addGigAnnotation(for item: FilteredItem, seen: Int) {
        let coordinate = CLLocationCoordinate2D(latitude: item.lat ?? 0, longitude: item.long ?? 0)
        let formattedPrice = String(format: "%.2f", Double(item.price ?? 0))
        if item.type != "moment"{
            self.customAnnotations.append(ClusterPoint(coordinate: coordinate, price: item.price ?? 0, seen: seen))
            processGigImageAndAnnotation(for: item)
        }else{
            downloadMoment(for: item)
        }
    }

    private func downloadMoment(for item: FilteredItem) {
        print("Price---", item.price ?? "")
        let uniqueID = "moment_\(item.id ?? "")"
   
        let imageName: String

        if item.userID == Store.userId {
            imageName = "myMoment"
        } else {
            imageName = item.seen == 1 ? "seenMoment" : "unseenMoment"
        }

        guard let baseImage = UIImage(named: imageName) else { return }
        
//        let value: Double = item.price ?? 0
//        let formattedValue = String(format: "%.1f", value)

        let combinedImage = self.combineImagesMoment(
            baseImage: baseImage,
            baseSize: CGSize(width: 45, height: 45),
            text:"\(item.tasks?.count ?? 0)"
        )
        
        // Check if annotation with the same ID already exists
        if arrMomentsPointAnnotations.contains(where: { $0.userInfo?["id"] as? String == uniqueID }) {
            return
        }

        var pointAnnotation = PointAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat ?? 0, longitude: item.long ?? 0))
        let imageNames = "moment_image_\(item.id ?? UUID().uuidString)" // Ensure image name is unique
        pointAnnotation.image = .init(image: combinedImage ?? UIImage(), name: imageNames)
        pointAnnotation.userInfo = ["id": uniqueID]

        self.arrMomentsPointAnnotations.append(pointAnnotation)
        self.pointAnnotationManagerMoments?.annotations = self.arrMomentsPointAnnotations
    }
    
    func combineImagesMoment(baseImage: UIImage, baseSize: CGSize, overlayPosition: CGPoint? = nil, text: String = "", textAttributes: [NSAttributedString.Key: Any]? = nil) -> UIImage? {
      UIGraphicsBeginImageContextWithOptions(baseSize, false, 0.0)
      // Draw the base image
      baseImage.draw(in: CGRect(origin: .zero, size: baseSize))
      // Default text
      guard !text.isEmpty else {
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return combinedImage
      }
      // Set default attributes
      let font = UIFont.boldSystemFont(ofSize: 8)
      let attributes: [NSAttributedString.Key: Any] = textAttributes ?? [
        .font: font,
        .foregroundColor: UIColor(hex: "#F2CC2F")
      ]
      // Calculate text size
      let textSize = text.size(withAttributes: attributes)
      let padding: CGFloat = 6
      let badgeSize = CGSize(width: max(textSize.width + padding+3, textSize.height + padding+3), height: textSize.height + padding+3)
      // Calculate top-right badge position
      let badgeOrigin = CGPoint(
        x: baseSize.width - badgeSize.width,
        y: 0
      )
      let badgeRect = CGRect(origin: badgeOrigin, size: badgeSize)
      // Draw circular background (badge)
      let badgePath = UIBezierPath(roundedRect: badgeRect, cornerRadius: badgeSize.height / 2)
        UIColor(hex: "#D49A34").setFill()
      badgePath.fill()
      // Center text inside badge
      let textRect = CGRect(
        x: badgeOrigin.x + (badgeSize.width - textSize.width) / 2,
        y: badgeOrigin.y + (badgeSize.height - textSize.height) / 2,
        width: textSize.width,
        height: textSize.height
      )
      text.draw(in: textRect, withAttributes: attributes)
      // Get final image
      let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return combinedImage
    }
    
    private func processGigImageAndAnnotation(for item: FilteredItem) {
        let uniqueID = "gig_\(item.id ?? "")"
        let centerCoordinate = CLLocationCoordinate2D(latitude: item.lat ?? 0, longitude: item.long ?? 0)
        
        if !arrPoint.contains(where: { $0.coordinates == centerCoordinate }) {
            arrPoint.append(Point(centerCoordinate))
           
        }
        
        let width = calculateGigImageWidth(for: Double(item.price ?? 0))
        guard let originalImage = UIImage(named: item.seen == 1 ? "seeGig" : "seeGig") else { return }
        let resizedImage = resizeGigImage(originalImage, to: Int(item.price ?? 0), withTitle: "", width: Int(width), height: Int(width))
        
        let pointAnnotation = createPointAnnotation(for: centerCoordinate, withImage: resizedImage, uniqueID: uniqueID)
        updateGigAnnotations(with: pointAnnotation, uniqueID: uniqueID)
    }
    
    private func calculateGigImageWidth(for price: Double) -> CGFloat {
        switch price {
        case ..<10: return 30
        case ..<100: return 45
        case ..<1000: return 55
        case ..<10000: return 65
        default: return 75
        }
    }
    
    func createPointAnnotation(for coordinate: CLLocationCoordinate2D, withImage image: UIImage, uniqueID: String) -> PointAnnotation {
        var annotation = PointAnnotation(coordinate: coordinate)
        annotation.image = .init(image: image, name: uniqueID) // Ensure unique name
        return annotation
    }
    
    private func updateGigAnnotations(with pointAnnotation: PointAnnotation, uniqueID: String) {
        if let existingIndex = arrGigPointAnnotations.firstIndex(where: { $0.image?.name == uniqueID }) {
            arrGigPointAnnotations[existingIndex] = pointAnnotation
        } else {
         
            arrGigPointAnnotations.append(pointAnnotation)
        }
        
        DispatchQueue.main.async {
            if selectHomeIndex != 1{
                if self.mapView.mapboxMap.cameraState.zoom > 7 {
                    self.pointAnnotationManagerGig?.annotations = self.arrGigPointAnnotations
                    let clusterManager = ClusterManager(mapView: self.mapView)
                    clusterManager.removeClusters()
                    DispatchQueue.main.async {
                        clusterManager.addClusters(with: self.customAnnotations)
                    }
                } else {
                    self.pointAnnotationManagerGig?.annotations = []
                    
                    
                }
            }else{
                self.pointAnnotationManagerGig?.annotations = self.arrGigPointAnnotations
                let clusterManager = ClusterManager(mapView: self.mapView)
                clusterManager.removeClusters()
                DispatchQueue.main.async {
                    clusterManager.addClusters(with: self.customAnnotations)
                }
            }
            
        }
    }
   
    
    func downloadBusinessImage(for item: FilteredItem) {
        
        let uniqueID = "business_\(item.id ?? "")"
        guard let logoURL = URL(string: item.profilePhoto ?? "") else {
            print("Invalid business image URL")
            return
        }
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: item.latitude ?? 0, longitude: item.longitude ?? 0)
        if !arrPoint.contains(where: { $0.coordinates == centerCoordinate }) {
            arrPoint.append(Point(centerCoordinate))
            self.isAppendHeatMap = true
        }
        
        let image = self.combineImagesPopUp(overlayImage: UIImage(named: "business2") ?? UIImage(), overlaySize: CGSize(width: 40, height: 40))
        let pointAnnotation = self.createPointAnnotation(for: centerCoordinate, withImage: image ?? UIImage(), uniqueID: uniqueID)
        self.updateBusinessAnnotations(with: pointAnnotation, uniqueID: uniqueID)
    }
    
    private func updateBusinessAnnotations(with pointAnnotation: PointAnnotation, uniqueID: String) {
        if let existingIndex = arrBusinessPointAnnotations.firstIndex(where: { $0.image?.name == uniqueID }) {
            arrBusinessPointAnnotations[existingIndex] = pointAnnotation
        } else {
            arrBusinessPointAnnotations.append(pointAnnotation)
        }
        
        DispatchQueue.main.async {
          
                if self.mapView.mapboxMap.cameraState.zoom > 7 {
                    self.pointAnnotationManagerBusiness?.annotations = self.arrBusinessPointAnnotations
                } else {
                    self.pointAnnotationManagerBusiness?.annotations = []
                }
           
        }
      
    }
    
    func downloadPopupImage(for item: FilteredItem) {
        
        let uniqueID = "popup_\(item.id ?? UUID().uuidString)"
     
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: item.lat ?? 0, longitude: item.long ?? 0)
        if !arrPoint.contains(where: { $0.coordinates == centerCoordinate }) {
            arrPoint.append(Point(centerCoordinate))
            self.isAppendHeatMap = true
        }
        
      
            let image = self.combineImagesPopUp(overlayImage: UIImage(named: "newPop") ?? UIImage(), overlaySize: CGSize(width: 35, height: 30))
            let pointAnnotation = self.createPointAnnotation(for: centerCoordinate, withImage: image ?? UIImage(), uniqueID: uniqueID)
            self.updatePopUpAnnotations(with: pointAnnotation, uniqueID: uniqueID)
        
    }
    
    private func updatePopUpAnnotations(with pointAnnotation: PointAnnotation, uniqueID: String) {
        if let existingIndex = arrPopUpPointAnnotations.firstIndex(where: { $0.image?.name == uniqueID }) {
            arrPopUpPointAnnotations[existingIndex] = pointAnnotation
        } else {
            arrPopUpPointAnnotations.append(pointAnnotation)
        }
        
        DispatchQueue.main.async {
           
                if self.mapView.mapboxMap.cameraState.zoom > 7 {
                    self.pointAnnotationManagerPop?.annotations = self.arrPopUpPointAnnotations
                } else {
                    self.pointAnnotationManagerPop?.annotations = []
                }
            
        }
    }
    
    func heatMapLayer() {
        let currentTime = Date().timeIntervalSince1970
        guard currentTime - lastZoomUpdateTime > 0.5 else { return } // Debounce for 0.5 seconds
        
        lastZoomUpdateTime = currentTime
        if selectHomeIndex != 1 {
            let zoomLevel = self.mapView.mapboxMap.cameraState.zoom
            print("Current zoom level: \(zoomLevel)")
            
            let clusterManager = ClusterManager(mapView: self.mapView)
            
            if zoomLevel < 7 {
                // Remove all existing annotations
                self.pointAnnotationManagerPop?.annotations = []
                self.arrPopUpPointAnnotations.removeAll()
                
                self.pointAnnotationManagerBusiness?.annotations = []
                self.arrBusinessPointAnnotations.removeAll()
                
                self.pointAnnotationManagerGig?.annotations = []
                self.arrGigPointAnnotations.removeAll()
              
                self.pointAnnotationManagerMoments?.annotations = []
                self.arrMomentsPointAnnotations.removeAll()

                self.customAnnotations.removeAll()
                let clusterManager = ClusterManager(mapView: self.mapView)
                clusterManager.removeClusters()
               
                print("All annotations removed.")
                
                guard !self.arrPoint.isEmpty else {
                    print("No points to create earthquake source.")
                    return
                }
                
                // Create the heatmap layer
                clusterManager.removeExistingLayersAndSources()
                clusterManager.createEarthquakeSource(arrFeature: self.arrPoint)
                clusterManager.createHeatmapLayer()
                
                self.isAppendHeatMap = false
                print("Heatmap layer created.")
            } else {
                // Remove the heatmap layer and restore annotations for zoom level >= 5
                clusterManager.removeExistingLayersAndSources()
                print("Heatmap layers and sources removed for zoom level >= 5.")
                
                // Optionally restore annotations if needed
                
                if selectHomeIndex == 2 {
                    self.pointAnnotationManagerPop?.annotations = self.arrPopUpPointAnnotations
                } else if selectHomeIndex == 3{
                    self.pointAnnotationManagerBusiness?.annotations = self.arrBusinessPointAnnotations
                }else if selectHomeIndex == 4{
                    self.pointAnnotationManagerMoments?.annotations = self.arrMomentsPointAnnotations
                }else if selectHomeIndex == 5{
                    self.pointAnnotationManagerPop?.annotations = self.arrPopUpPointAnnotations
                    self.pointAnnotationManagerBusiness?.annotations = self.arrBusinessPointAnnotations
                    self.pointAnnotationManagerGig?.annotations = self.arrGigPointAnnotations
                    self.pointAnnotationManagerMoments?.annotations = self.arrMomentsPointAnnotations
                    let clusterManager = ClusterManager(mapView: self.mapView)
                    clusterManager.removeClusters()
                    DispatchQueue.main.async {
                        clusterManager.addClusters(with: self.customAnnotations)
                    }
                }else{
                    self.pointAnnotationManagerGig?.annotations = self.arrGigPointAnnotations
                    let clusterManager = ClusterManager(mapView: self.mapView)
                    clusterManager.removeClusters()
                    DispatchQueue.main.async {
                        clusterManager.addClusters(with: self.customAnnotations)
                    }
                }
                
                print("Annotations restored.")
            }
        }
    }
    
    func handleTypeUpdateUI(data:[FilteredItem]){
        if selectHomeIndex == 1 || selectHomeIndex == 5{
            let filteredPrices = data.compactMap { $0.price }
            let totalPrice = filteredPrices.reduce(0, +)
            
            if self.arrData.count > 0 {
//                self.lblEarning.text = "$\(String(format: "%.2f", totalPrice))"
//                self.lblEarning.sizeToFit()
//                self.widthEarningVw.constant = self.lblEarning.frame.width+80
                self.lblEarning.text = "$\(String(format: "%.2f", totalPrice))"
                self.lblEarning.lineBreakMode = .byClipping
                self.lblEarning.numberOfLines = 1

                self.lblEarning.setContentHuggingPriority(.required, for: .horizontal)
                self.lblEarning.setContentCompressionResistancePriority(.required, for: .horizontal)

                self.view.layoutIfNeeded() // Ensure layout updates before size calculations
                self.lblEarning.sizeToFit()

                self.widthEarningVw.constant = self.lblEarning.intrinsicContentSize.width + 90
                self.view.layoutIfNeeded() // Apply the updated constraint
                
            } else {
                let clusterManager = ClusterManager(mapView: self.mapView)
                clusterManager.removeClusters()
                self.lblEarning.text = "$0.00"
            }
        }
    }
    
 
    
    func resizeGigImage(_ image: UIImage, to price: Int, withTitle title: String, width: Int, height: Int) -> UIImage {
        let size = CGSize(width: width, height: height)
        
        // Begin image context for drawing
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        // Create a circular path and clip the context to make the resulting image round
        let circlePath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: size))
        context?.addPath(circlePath.cgPath)
        context?.clip()
        
        // Draw the resized image into the clipped context
        image.draw(in: CGRect(origin: .zero, size: size))
        
        // Determine text color based on daytime/nighttime logic
        var textColor: UIColor = .white
        if let solar = Solar(coordinate: CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong)) {
            self.solar = solar
            let isDaytime = solar.isDaytime
            textColor = isDaytime ? .white : .black
        }
        
        // Define text attributes (font, color, alignment)
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Nunito-SemiBold", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .bold),
            .foregroundColor: textColor,
            .backgroundColor: UIColor.clear
        ]
        
        // Calculate position for the centered text within the image
        let textSize = title.size(withAttributes: textAttributes)
        let textRect = CGRect(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        
        // Draw the text into the circular image
        let titleText = NSString(string: title)
        titleText.draw(in: textRect, withAttributes: textAttributes)
        
        // Retrieve the resulting rounded image
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage ?? image
    }
    
    
    
    func combineImagesPopUp(
        overlayImage: UIImage,
        overlaySize: CGSize
    ) -> UIImage? {
        // Set up adjusted base size
        let adjustedBaseSize = CGSize(width: overlaySize.width, height: overlaySize.height)
        
        // Start graphics context
        UIGraphicsBeginImageContextWithOptions(adjustedBaseSize, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Failed to create graphics context.")
            return nil
        }
        
        // Define overlay position
        let overlayOrigin = CGPoint(x: 0, y: 0)
        let overlayRect = CGRect(origin: overlayOrigin, size: overlaySize)
        
        // Clip the image into a circular shape
//        let path = UIBezierPath(ovalIn: overlayRect)
//        context.saveGState()
//        path.addClip()
        
        // Draw the image only once, within the circular path
        overlayImage.draw(in: overlayRect)
        
        // Restore state
        context.restoreGState()
        
        // Get the final combined image
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return combinedImage
    }
   
    func combineImages(baseImage: UIImage, overlayImage: UIImage, baseSize: CGSize, overlaySize: CGSize, overlayPosition: CGPoint? = nil,type:String) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(baseSize, false, 0.0)
        baseImage.draw(in: CGRect(origin: .zero, size: baseSize))
        let overlayOrigin = overlayPosition ?? CGPoint(
            x: (baseSize.width - overlaySize.width) / 2,
            y: type == "business" ? 3 : 8
        )
        let overlayFrame = CGRect(origin: overlayOrigin, size: overlaySize)
        let path = UIBezierPath(ovalIn: overlayFrame)
        path.addClip()
        overlayImage.draw(in: overlayFrame)
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return combinedImage
    }
    
    
    
     func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
         
         print("DidBegan")
         
         
         self.vwLocalTask.isHidden = true
         self.vwWorldwideTask.isHidden = true
       
//         NotificationCenter.default.post(name: Notification.Name("touchMap"), object: nil)
         DispatchQueue.main.asyncAfter(deadline: .now()){
             if self.gigPopUpShow == true{
                 if self.mapView.viewAnnotations.allAnnotations.count > 0{
                     self.mapView.viewAnnotations.removeAll()
                     self.gigPopUpShow = false
                 }
             }
         }
         
     }
     func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
         if selectHomeIndex != 1{
             heatMapLayer()
         }
         print("didendanimate")
         let status = CLLocationManager.authorizationStatus()
         switch status {
         case .restricted, .denied:
             removeDataWhileLocationDenied()
             //locationDeniedAlert()
         case .authorizedWhenInUse, .authorizedAlways:
             let radius = getMapRadiusInKilometers()
             
             mapRadius = radius
             if (Store.isSelectGigFilter ?? false){
                 let allDistances = Set([1,2,3])
                 let selectedDistances = Set(Store.taskMiles)
                 
                 if allDistances.isSubset(of: selectedDistances) {
                     minDitance = 0
                     maxDistance = radius
                 } else if selectedDistances == [1] {
                     minDitance = 0
                     maxDistance = radius
                 }else if selectedDistances == [2] {
                     minDitance = 0
                     maxDistance = radius
                 } else if selectedDistances == [3] {
                     minDitance = radius
                     maxDistance = 1000000
                 } else if selectedDistances == [1,2] {
                     minDitance = 0
                     maxDistance = radius
                 } else if selectedDistances == [2,3] {
                     minDitance = radius
                     
                     maxDistance = 1000000
                 } else if selectedDistances == [1,3] {
                     print("Only 1,3")
                     minDitance = 0
                     maxDistance = radius
                 }else{
                     minDitance = 0
                     maxDistance = radius
                     
                 }
             }else{
                 minDitance = 0
                 maxDistance = radius
             }
             print("Radius of visible map area: \(radius) km\(mapView.mapboxMap.cameraState.center.latitude)")
             self.currentLat = mapView.mapboxMap.cameraState.center.latitude
             self.currentLong = mapView.mapboxMap.cameraState.center.longitude
             self.arrMoments.removeAll()
             self.arrTask.removeAll()
             self.arrBusiness.removeAll()
             self.arrPopUp.removeAll()
             homeListenerCall = false
             mapData(type: selectHomeIndex, gigType: Store.GigType ?? 0,lat: mapView.mapboxMap.cameraState.center.latitude,long: mapView.mapboxMap.cameraState.center.longitude)
             
//             if Store.role == "user"{
//                 if type == 1{
//                     getEarning(radius: mapRadius,lat: mapView.mapboxMap.cameraState.center.latitude,long: mapView.mapboxMap.cameraState.center.longitude)
//                 }
//             }
         default:
             print("Location permission not determined")
         }
         
     }
     func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
         print("Zoom",mapView.mapboxMap.cameraState.zoom)
         print("Bearing",mapView.mapboxMap.cameraState.bearing)
         print("Pitch",mapView.mapboxMap.cameraState.pitch)
         if selectHomeIndex != 1{
             heatMapLayer()
         }
         self.currentLat = mapView.mapboxMap.cameraState.center.latitude
         self.currentLong = mapView.mapboxMap.cameraState.center.longitude
         print("didendanimate")
         let status = CLLocationManager.authorizationStatus()
         switch status {
         case .restricted, .denied:
             removeDataWhileLocationDenied()
             //locationDeniedAlert()
         case .authorizedWhenInUse, .authorizedAlways:
             let radius = getMapRadiusInKilometers()
             mapRadius = radius
             print("Radius of visible map area: \(radius) km\(mapView.mapboxMap.cameraState.center.latitude)")
             homeListenerCall = false
             self.arrMoments.removeAll()
             self.arrTask.removeAll()
             self.arrBusiness.removeAll()
             self.arrPopUp.removeAll()
             mapData(type: selectHomeIndex, gigType: Store.GigType ?? 0,lat: mapView.mapboxMap.cameraState.center.latitude,long: mapView.mapboxMap.cameraState.center.longitude)
             
//             if Store.role == "user"{
//                 if type == 1{
//                     getEarning(radius: mapRadius,lat: mapView.mapboxMap.cameraState.center.latitude,long: mapView.mapboxMap.cameraState.center.longitude)
//                 }
//             }
         default:
             print("Location permission not determined")
         }
         
     }
    func getMapRadiusInKilometers() -> CLLocationDistance {
        mapView.ornaments.scaleBarView.isHidden = true
        mapView.ornaments.logoView.isHidden = true
        let centerCoordinate = mapView.cameraState.center
        let topCenterPoint = CGPoint(x: mapView.bounds.midX, y: 0)
        let topCenterCoordinate = mapView.mapboxMap.coordinate(for: topCenterPoint)
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        let radiusInMeters = centerLocation.distance(from: topCenterLocation)
        let radiusInKilometers = radiusInMeters
        return radiusInKilometers
    }
    
    //MARK: - BUTTON ACTION
    
    
    @IBAction func actionNotification(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        vc.callBack = { [weak self] in
            guard let self = self else { return }
            
            self.animateZoomInOut()
            self.socketData()

            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                if Store.userNotificationCount ?? 0 > 0{
                    self.viewDot.isHidden = true
                }else{
                    self.viewDot.isHidden = true
                }
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionSearch(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeSearchVC") as! HomeSearchVC
        vc.modalPresentationStyle = .overFullScreen
        vc.currentLat = currentLat
        vc.currentLong = currentLong
        vc.callBack = { index,type,id,taskStatus,userId in
            if type == "task"{
                if userId == Store.userId{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailOwnerVC") as! TaskDetailOwnerVC
                    vc.gigId = id ?? ""
                    if taskStatus != nil{
                        vc.isComing = 1
                    }else{
                        vc.isComing = 0
                    }
                    vc.callBack = {
                        
                        self.animateZoomInOut()
                        self.socketData()
                        
                    }
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
                    vc.gigId = id ?? ""
                   
                    vc.callBack = {
                        
                        self.animateZoomInOut()
                        self.socketData()
                        
                    }
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
              
            }else if type == "business"{
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutServicesVC") as! AboutServicesVC
                vc.businessId = id ?? ""
                vc.businessIndex = index ?? 0
                Store.BusinessUserIdForReview = self.arrData[index ?? 0].id ?? ""
                vc.callBack = { [weak self] index in
                    guard let self = self else { return }
                    self.removeAllArray()
                    self.animateZoomInOut()
                    self.socketData()
                    
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else if type == "moment"{
                if Store.userId == userId{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OwnerMomentDetailVC") as! OwnerMomentDetailVC
                    vc.momentId = id
                    vc.callBack = { [weak self] in
                        guard let self = self else { return }
                        self.isNavigating = false
                        self.animateZoomInOut()
                        self.socketData()
                    }

                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                   
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserSideMomentDetailVC") as! UserSideMomentDetailVC
                    vc.momentId = id ?? ""
                    vc.callBack = { [weak self] in
                        guard let self = self else { return }
                        self.isNavigating = false
                        self.animateZoomInOut()
                        self.socketData()
                    }

                    self.navigationController?.pushViewController(vc, animated: true)

                }
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupUserVC") as! PopupUserVC
                    vc.popupId = id ?? ""
                    vc.callBack = { [weak self]  in
                        guard let self = self else { return }
                        self.isPopUpVCShown = false
                        self.removeAllArray()
                        self.animateZoomInOut()
                        self.socketData()
                       
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
          
        }
        vc.callBackSeeAll = { data,tag in
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SeeAllTypeVC") as? SeeAllTypeVC else { return }
            
            vc.isSelect = tag ?? 1
            vc.arrSearchData = data ?? []
            vc.isComingSearch = true
            vc.callBack = {
                self.arrMoments.removeAll()
                self.arrTask.removeAll()
                self.arrPopUp.removeAll()
                self.arrBusiness.removeAll()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.navigationController?.present(vc, animated:true)
    }
    
    @IBAction func actionInMyLocation(_ sender: UIButton) {
        self.dismiss(animated: true)
        Store.GigType = 1
        homeListenerCall = false
        vwLocalTask.isHidden = true
        vwWorldwideTask.isHidden = true
        myLocationSetup()
        removeAllArray()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
            self.socketData()
        }
    }
    
    func myLocationSetup(){
          isSelectTask = true
          vwRefresh.isHidden = false
          vwRecenter.isHidden = false
          vwWorldwideTask.borderWid = 1
          vwWorldwideTask.borderCol = .app
          lblLocalTask.textColor = .white
          lblWorldwideTask.textColor = .app
          vwLocalTask.backgroundColor = .app
          imgVwLocalTask.image = UIImage(named: "inMySel")
          vwWorldwideTask.backgroundColor = .white
          imgVwWorldwideTask.image = UIImage(named: "world")
          
      }
    @IBAction func actionWorldWide(_ sender: UIButton) {
        self.dismiss(animated: true)
        homeListenerCall = false
             Store.GigType = 0
             vwLocalTask.isHidden = true
             vwWorldwideTask.isHidden = true
             worldwideSetup()
        removeAllArray()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
            self.socketData()
        }
    }
    func worldwideSetup(){
          isSelectTask = true
          vwRefresh.isHidden = false
          vwRecenter.isHidden = false
          vwLocalTask.borderWid = 1
          vwLocalTask.borderCol = .app
          lblWorldwideTask.textColor = .white
          lblLocalTask.textColor = .app
          vwLocalTask.backgroundColor = .white
          imgVwLocalTask.image = UIImage(named: "inmy")
          vwWorldwideTask.backgroundColor = .app
          imgVwWorldwideTask.image = UIImage(named: "worldSel")
          
      }
    
    @IBAction func actionFilter(_ sender: UIButton) {
        let  vc = self.storyboard?.instantiateViewController(withIdentifier: "AllFilterVC") as! AllFilterVC
               vc.modalPresentationStyle = .overFullScreen
               vc.type = selectHomeIndex
               
               vc.callBack = { (distance) in
                   self.homeListenerCall = false
                   self.removeAllArray()
                   if selectHomeIndex == 1{
                      
                       if (Store.isSelectGigFilter ?? false){
                           self.minDitance = Store.filterData?["minDistanceInMeters"] as? Double ?? 0
                           self.maxDistance = Store.filterData?["maxDistanceInMeters"] as? Double ?? 8046.72
                           let mapWidth = self.mapView.bounds.width
                           print(Store.filterData?["minDistanceInMeters"] as? Double ?? 0)
                           print(Store.filterData?["maxDistanceInMeters"] as? Double ?? 8046.72)
//                           self.mapRadius = Double(radius)
                           // Calculate the zoom level
//
                           if distance ?? 0 > 0{
                               let zoom = self.zoomLevel(from: (distance ?? 8046.0)/1000, mapViewWidth: mapWidth)
//
                               print("Zoom Level: \(zoom), Radius: \(radius) km")
                           
                               let cameraOptions = CameraOptions(
                                center: CLLocationCoordinate2D(latitude: self.currentLat, longitude: self.currentLong),
                                zoom: self.mapRadius,
                                pitch: 0.0
                               )
                               self.mapView.camera.ease(to: cameraOptions, duration: 0.3, curve: .easeInOut)
                           }
                              
                           
                        
                       }else{
                           self.minDitance = 0
                           self.maxDistance = 1000000.0
                           let mapWidth = self.mapView.bounds.width
                           
                           self.mapRadius = Double(radius)
                           // Calculate the zoom level
                           

                       }
                       self.socketData()
                   }else if selectHomeIndex == 2{
                       if (Store.isSelectGigFilter ?? false){
                           self.minDitance = Store.filterDataPopUp?["minDistanceInMeters"] as? Double ?? 0
                           self.maxDistance = Store.filterDataPopUp?["maxDistanceInMeters"] as? Double ?? 8046.72
                           let mapWidth = self.mapView.bounds.width
                           
                           self.mapRadius = Double(radius)
                           // Calculate the zoom level
                           
                           let zoom = self.zoomLevel(from: (distance ?? 8046.72)/1000, mapViewWidth: mapWidth)
                           print("Zoom Level: \(zoom), Radius: \(radius) km")
                           let cameraOptions = CameraOptions(
                               center: CLLocationCoordinate2D(latitude: self.currentLat, longitude: self.currentLong),
                               zoom: zoom,
                               pitch: 0.0
                           )
                           
                           self.mapView.camera.ease(to: cameraOptions, duration: 0.3, curve: .easeInOut)
                       }else{
                           self.minDitance = 0
                           self.maxDistance = 8046.72
                           let mapWidth = self.mapView.bounds.width
                           
                           self.mapRadius = Double(radius)
                           // Calculate the zoom level
                           
//                           let zoom = self.zoomLevel(from: self.maxDistance/1000, mapViewWidth: mapWidth)
//                           print("Zoom Level: \(zoom), Radius: \(radius) km")
//                           let cameraOptions = CameraOptions(
//                               center: CLLocationCoordinate2D(latitude: self.currentLat, longitude: self.currentLong),
//                               zoom: zoom,
//                               pitch: 0.0
//                           )
//
//                           self.mapView.camera.ease(to: cameraOptions, duration: 0.3, curve: .easeInOut)
                       }
                       self.socketData()
                   }else if selectHomeIndex == 3{
                       if (Store.isSelectBusinessFilter ?? false){
                           self.minDitance = Store.filterDataBusiness?["minDistanceInMeters"] as? Double ?? 0
                           self.maxDistance = Store.filterDataBusiness?["maxDistanceInMeters"] as? Double ?? 8046.72
                           let mapWidth = self.mapView.bounds.width
                           
                           self.mapRadius = Double(radius)
                           // Calculate the zoom level
                           
//                           let zoom = self.zoomLevel(from: (distance ?? 8046.0)/1000, mapViewWidth: mapWidth)
//                           print("Zoom Level: \(zoom), Radius: \(radius) km")
//
//                           let cameraOptions = CameraOptions(
//                               center: CLLocationCoordinate2D(latitude: self.currentLat, longitude: self.currentLong),
//                               zoom: zoom,
//                               pitch: 0.0
//                           )
//
//                           self.mapView.camera.ease(to: cameraOptions, duration: 0.3, curve: .easeInOut)
                       }else{
                           self.minDitance = 0
                           self.maxDistance = 8046.72
                           let mapWidth = self.mapView.bounds.width
                           
                           self.mapRadius = Double(radius)
                           // Calculate the zoom level
                           
//                           let zoom = self.zoomLevel(from: self.maxDistance/1000, mapViewWidth: mapWidth)
//                           print("Zoom Level: \(zoom), Radius: \(radius) km")
//                           let cameraOptions = CameraOptions(
//                               center: CLLocationCoordinate2D(latitude: self.currentLat, longitude: self.currentLong),
//                               zoom: zoom,
//                               pitch: 0.0
//                           )
//
//                           self.mapView.camera.ease(to: cameraOptions, duration: 0.3, curve: .easeInOut)
                       }
                       self.socketData()
                   }
                   
               }
               self.navigationController?.present(vc, animated:true)
    }
    
    @IBAction func actionSeeAll(_ sender: UIButton) {
        
        if homeListenerCall {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "SeeAllTypeVC") as? SeeAllTypeVC else { return }
            
            vc.isSelect = sender.tag
            
            vc.arrData = {
                switch sender.tag {
                case 1:
                    return arrTask
                case 3:
                    return arrPopUp
                case 4:
                    return arrMoments
                default:
                    return arrBusiness
                }
            }()
            vc.callBack = {
                self.arrMoments.removeAll()
                self.arrTask.removeAll()
                self.arrPopUp.removeAll()
                self.arrBusiness.removeAll()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func zoomLevel(from radius: Double, mapViewWidth: CGFloat) -> Double {
        let earthCircumference: Double = 40075016.686 // Earth's circumference in meters
        let radiusInMeters = radius * 1000 // Convert kilometers to meters
        let mapWidth = Double(mapViewWidth) // Map's pixel width
        
        // Calculate zoom level
        let zoom = log2((mapWidth * earthCircumference) / (radiusInMeters * 2)) - 8
        return zoom
    }
    
  
    
    
    func isSelectStoreAndBusinessBtn(){
        if self.isSelectTask{
            self.vwRefresh.isHidden = false
            self.vwRecenter.isHidden = false
        }
        
        vwEarning.isHidden = true
    }
    
    
    @IBAction func actionRefresh(_ sender: UIButton) {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .restricted, .denied:
            print("denied")
        case .authorizedWhenInUse, .authorizedAlways:
            self.dismiss(animated: false)
            customAnnotations.removeAll()
            let clusterManager = ClusterManager(mapView: self.mapView)
            clusterManager.removeClusters()
            vwRefresh.animateRefreshAndRecenter()
            removeAllArray()
            homeListenerCall = false
            socketData()
        default:
            print("Location permission not determined")
        }
        
    }
    @IBAction func actionRecenter(_ sender: UIButton){
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .restricted, .denied:
            print("denied")
        case .authorizedWhenInUse, .authorizedAlways:
            self.dismiss(animated: false)
            mapRadius = 0.7
                recenter()
        default:
            print("Location permission not determined")
        }
    }
    func recenter() {
        homeListenerCall = false
        vwRecenter.animateRefreshAndRecenter()
        customAnnotations.removeAll()
        let clusterManager = ClusterManager(mapView: self.mapView)
        clusterManager.removeClusters()
        removeAllArray()
     
        socketData()

        let centerCoordinate = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong)
        mapView.mapboxMap.setCamera(to: CameraOptions(center: centerCoordinate, zoom: 15))

    }
    }
    

//MARK: - CLLocationManagerDelegate
extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        currentLat = userLocation.coordinate.latitude
        currentLong = userLocation.coordinate.longitude
        uiSet()
        if !self.mapAdded{
            self.addMapView(currentLat: userLocation.coordinate.latitude, currentLong: userLocation.coordinate.longitude)
            self.mapAdded = true
       
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
            
            self.addCurrentLocationMarker(location: userLocation.coordinate)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("User has not yet made a choice regarding location permissions")
        case .restricted, .denied:
            print("Location access denied")
            
            locationDeniedAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            self.dismiss(animated: false)
            homeListenerCall = false
            removeAllArray()
            socketData()
            print("Location access granted")
        @unknown default:
            print("Unknown location permission status")
        }
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
}


//MARK: - AnnotationInteractionDelegate
extension HomeVC:AnnotationInteractionDelegate{
   
    func annotationManager(_ manager: any MapboxMaps.AnnotationManager, didDetectTappedAnnotations annotations: [any MapboxMaps.Annotation]) {
      
        guard let annotation = annotations.first as? PointAnnotation else { return }
        let coordinate = annotation.point.coordinates
        print("Annotation tapped at coordinate: \(coordinate)")
        
        // Ensure the annotation view is only shown once
        guard !self.isAnnotationViewVisible else { return }
        
        self.isAnnotationViewVisible = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.showAnnotationView(at: coordinate)
            
            // Reset the flag after showing the view
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isAnnotationViewVisible = false
            }
        }
    }
    func showAnnotationView(at coordinate: CLLocationCoordinate2D) {
        guard !isNavigating else { return }  // Prevent multiple pushes
        
        
        guard let selectedItem = arrData.first(where: {
            ($0.lat == coordinate.latitude || $0.latitude == coordinate.latitude) &&
            ($0.long == coordinate.longitude || $0.longitude == coordinate.longitude)
        }) else {
            print("No matching item found for the provided coordinate")
            return
        }
        
        guard let selectedIndex = arrData.firstIndex(where: {
            ($0.lat == coordinate.latitude || $0.latitude == coordinate.latitude) &&
            ($0.long == coordinate.longitude || $0.longitude == coordinate.longitude)
        }) else {
            print("Unable to find index for the selected item")
            return
        }
        
        print("Selected item index: \(selectedIndex)")
        
        let pushVC: (UIViewController) -> Void = { vc in
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        print(selectedItem.id ?? "","--------Id")
        if selectedItem.type == "gig" {
            if Store.role == "user" {
                isNavigating = true
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigPopupViewVC") as! GigPopupViewVC
                vc.currentIndex = selectedIndex
                vc.selectedId = selectedItem.id ?? ""
                vc.modalPresentationStyle = .overFullScreen
                for i in arrData{
                    if i.type == "gig"{
                        vc.arrData.append(i)
                    }
                }
                //                vc.arrData = arrData
                
                vc.callBack = { [weak self] isSelect, isChat, data, isUserGig in
                    guard let self = self else { return }
                    self.isNavigating = false  // Reset flag
                    
                    if isUserGig {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailOwnerVC") as! TaskDetailOwnerVC
                        vc.gigId = selectedItem.id ?? ""
                        if selectedItem.status != nil{
                            vc.isComing = 1
                        }else{
                            vc.isComing = 0
                        }
                        vc.callBack = { [weak self] in
                            guard let self = self else { return }
                            self.isNavigating = false
                            self.customAnnotations.removeAll()
                            ClusterManager(mapView: self.mapView).removeClusters()
                            self.dismiss(animated: false)
                            self.removeAllArray()
                            self.isNavigating = false
                            self.tblVwMoments.reloadData()
                            self.tblVwTask.reloadData()
                            self.collVwPopUp.reloadData()
                            self.collVwBusiness.reloadData()
                        }
                        pushVC(vc)
                    } else {
                        if selectedItem.seen == 0 {
                            let param: parameters = ["userId": Store.userId ?? "",
                                                     "lat": "\(self.currentLat)",
                                                     "long": "\(self.currentLong)",
                                                     "radius": self.mapRadius,
                                                     "gigId": selectedItem.id ?? "",
                                                     "type": 2,
                                                     "gigType": Store.GigType ?? 0]
                            SocketIOManager.sharedInstance.home(dict: param)
                        }
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
                        vc.gigId = selectedItem.id ?? ""
                        vc.callBack = { [weak self] in
                            guard let self = self else { return }
                            self.isNavigating = false
                            self.customAnnotations.removeAll()
                            ClusterManager(mapView: self.mapView).removeClusters()
                            self.dismiss(animated: false)
                            self.removeAllArray()
                            self.isNavigating = false
                            self.tblVwMoments.reloadData()
                            self.tblVwTask.reloadData()
                            self.collVwPopUp.reloadData()
                            self.collVwBusiness.reloadData()
                        }
                        pushVC(vc)
                    }
                }
                vc.callBackCancel = {
                    self.isNavigating = false
                }
                self.present(vc, animated: true)
            } else {
                isNavigating = true
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
                vc.gigId = selectedItem.id ?? ""
                vc.isComing = 1
                vc.callBack = { [weak self] in
                    guard let self = self else { return }
                    self.isNavigating = false
                 
                    self.pointAnnotationManagerGig.annotations = []
                    self.arrGigPointAnnotations.removeAll()
                    self.animateZoomInOut()
                    self.isNavigating = false
                    self.mapData(type: selectHomeIndex, gigType: Store.GigType ?? 0, lat: self.mapView.mapboxMap.cameraState.center.latitude, long: self.mapView.mapboxMap.cameraState.center.longitude)
                }
                pushVC(vc)
            }
        }else if selectedItem.type == "moment" {
            isNavigating = true
            var arrMoment = [FilteredItem]()
            for i in arrData{
                if i.type == "moment"{
                    arrMoment.append(i)
                }
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigPopupViewVC") as! GigPopupViewVC
            vc.currentIndex = selectedIndex
            vc.selectedId = selectedItem.id ?? ""
           
                vc.callBackMoment = { [weak self] momentId,userId in
                    guard let self = self else { return }
                    self.isNavigating = false
                if Store.UserDetail?["userId"] as? String ?? "" == userId{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OwnerMomentDetailVC") as! OwnerMomentDetailVC
                    vc.momentId = momentId
                    vc.isComingHome = true
                    vc.callBack = { [weak self] in
                        guard let self = self else { return }
                        self.isNavigating = false
                        
                        self.removeAllArray()
                        self.animateZoomInOut()
                        self.socketData()
                    }
                    
                    pushVC(vc)
                }else{
                    if selectedItem.seen == 0 {
                        let param: parameters = ["userId": Store.userId ?? "",
                                                 "lat": "\(self.currentLat)",
                                                 "long": "\(self.currentLong)",
                                                 "radius": self.mapRadius,
                                                 "momentId": selectedItem.id ?? "",
                                                 "type": 2,
                                                 "gigType": Store.GigType ?? 0]
                        SocketIOManager.sharedInstance.home(dict: param)
                    }
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserSideMomentDetailVC") as! UserSideMomentDetailVC
                    vc.momentId = momentId
                    vc.callBack = { [weak self] in
                        guard let self = self else { return }
                        self.isNavigating = false
                        self.removeAllArray()
                        self.animateZoomInOut()
                        self.socketData()
                    }
                    
                    pushVC(vc)
                    
                }
            }
            vc.callBackCancel = {
                self.isNavigating = false
            }
            vc.arrData = arrMoment
            vc.isComingMoment = true
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)

        } else if selectedItem.type == "popUp" {
            isNavigating = true
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupUserVC") as! PopupUserVC
            vc.popupId = selectedItem.id ?? ""
            vc.callBack = { [weak self] in
                guard let self = self else { return }
                self.isNavigating = false
                self.isPopUpVCShown = false
                self.animateZoomInOut()
                self.isNavigating = false
                
                self.removeAllArray()
                self.animateZoomInOut()
                self.socketData()

            }
            pushVC(vc)
        } else if selectedItem.type == "business" {
            
            isNavigating = true
            guard !isPopUpVCShown else { return }
            isPopUpVCShown = true
            
            if Store.role == "b_user" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BusinessProfileVC") as! BusinessProfileVC
                vc.businessId = selectedItem.id ?? ""
                vc.isComing = true
                pushVC(vc)
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutServicesVC") as! AboutServicesVC
                vc.businessId = selectedItem.id ?? ""
                Store.BusinessUserIdForReview = selectedItem.id ?? ""
                vc.businessIndex = visibleIndex
                vc.callBack = { [weak self] index in
                    guard let self = self else { return }
                    self.isNavigating = false
                    self.visibleIndex = index
                    self.isNavigating = false
                    self.animateZoomInOut()
                    self.isPopUpVCShown = false
                    
                    self.removeAllArray()
                    self.animateZoomInOut()
                    self.socketData()

                }
                pushVC(vc)
            }
        } else if selectedItem.type == "moment" {
            
            isNavigating = true
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserSideMomentDetailVC") as! UserSideMomentDetailVC
            pushVC(vc)
        }
    }
    @objc func viewMore(sender:UIButton){
        if Store.role == "user"{
          
            if gigAppliedStatus == 1{
                if isReadyChat == 1{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigChatVC") as! GigChatVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.gigId = gigIdForGroup
                    vc.gigUserId = self.gigUserId
                    vc.callBack = { [weak self] isBack in
                        guard let self = self else { return }
                        self.socketData()
                        if !isBack{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigCompleteVC") as! GigCompleteVC
                            vc.modalPresentationStyle = .overFullScreen
                            vc.callBack = {[weak self] in
                                
                                guard let self = self else { return }
                                self.socketData()
                                self.mapView.viewAnnotations.removeAll()
                            }
                            self.navigationController?.present(vc, animated: true)
                        }
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigReadyVC") as! GigReadyVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.gigDetail = gigDetail
                    vc.groupId = groupId
                    vc.callBack = { [weak self] in
                        guard let self = self else { return }
                        let param:parameters = ["userId":Store.userId ?? "",
                                                "deviceId":Store.deviceToken ?? "",
                                                "gigId":self.gigIdForGroup,
                                                "groupId":self.groupId]
                        print("param--",param)
                        SocketIOManager.sharedInstance.readyUser(dict: param)
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                            if Store.role == "user"{
                                let param2 = ["senderId":Store.userId ?? "","groupId":self.groupId,
                                              "message":"\(Store.UserDetail?["userName"] as? String ?? "") is ready",
                                              "deviceId":Store.deviceToken ?? "",
                                              "gigId":self.gigIdForGroup]
                                print("param2--",param2)
                                SocketIOManager.sharedInstance.sendMessage(dict: param2)
                            }else{
                                let param2 = ["senderId":Store.userId ?? "",
                                              "groupId":self.groupId,
                                              "message":"\(Store.BusinessUserDetail?["userName"] as? String ?? "") is ready",
                                              "deviceId":Store.deviceToken ?? "",
                                              "gigId":self.gigIdForGroup]
                                SocketIOManager.sharedInstance.sendMessage(dict: param2)
                            }
                        }
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigChatVC") as! GigChatVC
                        vc.modalPresentationStyle = .overFullScreen
                        vc.gigId = self.gigIdForGroup
                        vc.gigUserId = self.gigUserId
                        vc.callBack = { [weak self] isBack in
                            
                            guard let self = self else { return }
                            
                            self.socketData()
                            if !isBack{
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GigCompleteVC") as! GigCompleteVC
                                vc.modalPresentationStyle = .overFullScreen
                                vc.callBack = { [weak self] in
                                    guard let self = self else { return }
                                    self.socketData()
                                }
                                self.navigationController?.present(vc, animated: true)
                            }
                        }
                        self.present(vc, animated: true)
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                print("View More button pressed")
                print("selectItemSeen: \(selectItemSeen)")
                if selectItemSeen == 1 {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
                    vc.gigId = selectGigId
                    vc.callBack = {[weak self] in
                        
                        guard let self = self else { return }
                        
                        self.mapView.viewAnnotations.removeAll()
                        self.pointAnnotationManagerGig.annotations = []
                        self.arrGigPointAnnotations.removeAll()
                        self.mapData(type: selectHomeIndex, gigType: Store.GigType ?? 0 ,lat: self.mapView.mapboxMap.cameraState.center.latitude,long: self.mapView.mapboxMap.cameraState.center.longitude)
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                } else if selectItemSeen == 0 {
                    let param: parameters = ["userId": Store.userId ?? "", "lat": "\(currentLat)", "long": "\(currentLong)", "radius": mapRadius, "gigId": selectGigId,"type":2,"gigType":Store.GigType ?? 0 ]
                    SocketIOManager.sharedInstance.home(dict: param)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
                    vc.callBack = { [weak self] in
                        guard let self = self else { return }
                        
                        self.mapView.viewAnnotations.removeAll()
                        self.pointAnnotationManagerGig.annotations = []
                        self.arrGigPointAnnotations.removeAll()
                        self.removeAllArray()
                        self.mapData(type: selectHomeIndex, gigType: Store.GigType ?? 0 ,lat: self.mapView.mapboxMap.cameraState.center.latitude,long: self.mapView.mapboxMap.cameraState.center.longitude)
                    }
//                    vc.gigId = self.selectGigId
                    print("Pushing ApplyGigVC with gigId: \(vc.gigId)")
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
//            vc.gigId = self.selectGigId
            vc.isComing = 1
            vc.callBack = {[weak self] in
                
                guard let self = self else { return }
                
                self.mapView.viewAnnotations.removeAll()
                self.pointAnnotationManagerGig.annotations = []
                self.arrGigPointAnnotations.removeAll()
                self.animateZoomInOut()
                self.mapData(type: selectHomeIndex, gigType: Store.GigType ?? 0 ,lat: self.mapView.mapboxMap.cameraState.center.latitude,long: self.mapView.mapboxMap.cameraState.center.longitude)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}

//MARK: - UICollectionViewDelegate
extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwSelectType{
            return arrType.count
        }else if collectionView == collVwPopUp{
          
                return arrPopUp.count
          
        }else{
            return arrBusiness.count
          
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwSelectType{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectTypeCVC", for: indexPath) as! SelectTypeCVC
            cell.lblType.text = arrType[indexPath.row]
            if typeIndex == indexPath.row{
                cell.vwMain.backgroundColor = .app
                cell.lblType.textColor = .white
            }else{
                cell.vwMain.backgroundColor = .white
                cell.lblType.textColor = .black
            }
            
            return cell
            
        } else if collectionView == collVwBusiness{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularServicesCVC", for: indexPath) as! PopularServicesCVC
            cell.vwShadow.layer.masksToBounds = false
            cell.vwShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
            cell.vwShadow.layer.shadowOpacity = 0.44
            cell.vwShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.vwShadow.layer.shouldRasterize = true
            cell.vwShadow.layer.rasterizationScale = UIScreen.main.scale
            cell.isComing = true
           
                if arrBusiness.count > 0{
                    cell.indexpath = indexPath.row
                    
                    
                    let business = arrBusiness[indexPath.row]
                    let rating = business.UserRating ?? 0
                    let formattedRating = String(format: "%.1f", rating)
                    cell.lblRating.text = formattedRating
                    if let category = business.category {
                        switch category {
                        case .intValue(let intValue):
                            print("Category is an integer:", intValue)
                            
                            switch intValue {
                            case 1:
                                cell.lblCategory.text = "Restaurants"
                                cell.widthCategoryVw.constant = 70
                            case 2:
                                cell.lblCategory.text = "Clothing/fashion"
                                cell.widthCategoryVw.constant = 100
                            case 3:
                                cell.lblCategory.text = "Tech/electronics"
                                cell.widthCategoryVw.constant = 100
                            case 4:
                                cell.lblCategory.text = "Grocery"
                                cell.widthCategoryVw.constant = 70
                            case 5:
                                cell.lblCategory.text = "Fitness"
                                cell.widthCategoryVw.constant = 70
                            case 6:
                                cell.lblCategory.text = "Entertainment"
                                cell.widthCategoryVw.constant = 70
                            default:
                                cell.lblCategory.text = "Other"
                                cell.widthCategoryVw.constant = 45
                            }
                            
                        case .objectValue(let categoryObject):
                            // Handle the case where category is a Category object
                            cell.lblCategory.text = categoryObject.name ?? "Unknown"
                            cell.widthCategoryVw.constant = 60 // Adjust width as needed
                        }
                    }
                    
                    
                    cell.lblServiceName.text = business.businessname ?? ""
                    cell.imgVwUser.imageLoad(imageUrl: business.profilePhoto ?? "")
                    cell.lblAddress.text = business.place ?? ""
                    if business.status == 2{
                        cell.imgVwBlueTick.isHidden = false
                    }else{
                        cell.imgVwBlueTick.isHidden = true
                    }
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
                }
       
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCVC", for: indexPath) as! StoreCVC
            cell.viewShadow.layer.masksToBounds = false
            cell.viewShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
            cell.viewShadow.layer.shadowOpacity = 0.44
            cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.viewShadow.layer.shouldRasterize = true
            cell.viewShadow.layer.rasterizationScale = UIScreen.main.scale
         
                if arrPopUp.count > 0{
                    cell.lblStoreName.text = arrPopUp[indexPath.row].name ?? ""
                    cell.imgVwStore.imageLoad(imageUrl: arrPopUp[indexPath.row].businessLogo ?? "")
                    
                    if arrPopUp[indexPath.row].categoryType == 1{
                        cell.lblUserName.text = "Food & Drinks"
                    }else if arrPopUp[indexPath.row].categoryType == 2{
                        cell.lblUserName.text = "Services"
                    }else if arrPopUp[indexPath.row].categoryType == 3{
                        cell.lblUserName.text = "Clothes / Fashion"
                    }else if arrPopUp[indexPath.row].categoryType == 4{
                        cell.lblUserName.text = "Beauty / Self-Care"
                    }else {
                        cell.lblUserName.text = "Low Key"
                    }
                    let rating = arrPopUp[indexPath.row].UserRating ?? 0
                    let formattedRating = String(format: "%.1f", rating)
                    cell.lblAddress.text = arrPopUp[indexPath.row].place ?? ""
                    if arrPopUp[indexPath.row].deals ?? "" == ""{
                        cell.widthImgOffer.constant = 0
                    }else{
                        cell.widthImgOffer.constant = 120
                    }
                    cell.lblOffer.text = arrPopUp[indexPath.row].deals ?? ""
                    if arrPopUp[indexPath.row].endSoon ?? false{
                        cell.approveImg.image = UIImage(named: "redApprove")
                    }else{
                        cell.approveImg.image = UIImage(named: "greenApprove")
                    }
                    cell.lblRating.text = formattedRating
                    if let formattedStartDate = convertToDateFormat(arrPopUp[indexPath.row].startDate ?? "",
                                                                    dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                                                    convertFormat: "MMM dd, h:mm a"),
                       let formattedEndDate = convertToDateFormat(arrPopUp[indexPath.row].endDate ?? "",
                                                                  dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                                                  convertFormat: "MMM dd, h:mm a") {
                        cell.lblTime.text = "\(formattedStartDate) - \(formattedEndDate)"
                    } else {
                        print("Invalid date format")
                    }
                }
          
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collVwSelectType{
            if !selectTypeIndex{
                typeIndex = indexPath.row
                heightTaslTblVw.constant = 0
                heightBusinessColl.constant = 0
                heightPopUpColl.constant = 0
                arrMoments.removeAll()
                arrTask.removeAll()
                arrPopUp.removeAll()
                arrBusiness.removeAll()
                collVwPopUp.reloadData()
                collVwBusiness.reloadData()
                tblVwTask.reloadData()
                tblVwMoments.reloadData()
                collVwSelectType.reloadData()
                selectTypeIndex = true
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3){
                    self.updateDataSelectType(for: indexPath.row)
                }
            }
        }else{
           
            if self.arrData.count > 0{
                    
                    if self.homeListenerCall{
                        
                        self.dismiss(animated: true)
                        if collectionView == self.collVwBusiness{
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutServicesVC") as! AboutServicesVC
                            vc.businessId = self.arrBusiness[indexPath.row].id ?? ""
                            vc.businessIndex = indexPath.row
                            
                            Store.BusinessUserIdForReview = self.arrBusiness[indexPath.row].id ?? ""
                            vc.callBack = { [weak self] index in
                                
                                guard let self = self else { return }
                                
                                self.removeAllArray()
                                self.animateZoomInOut()
                                self.socketData()
                                
                            }
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupUserVC") as! PopupUserVC
                            vc.popupId = self.arrPopUp[indexPath.row].id ?? ""
                            vc.callBack = { [weak self]  in
                                guard let self = self else { return }
                                DispatchQueue.main.async {
                                    self.isPopUpVCShown = false
                                    self.removeAllArray()
                                    self.animateZoomInOut()
                                    self.socketData()
                                }
                            }
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                    }
                }
            }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwSelectType{
            return CGSize(width: view.frame.size.width / 4-9, height: 35)
        }else if collectionView == collVwBusiness{
            return CGSize(width: view.frame.size.width / 1-20, height: 100)
        }else{
            return CGSize(width: view.frame.size.width / 1-20, height: 130)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collVwSelectType{
            return 5
        }else{
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collVwSelectType{
            return 5
        }else{
            return 0
        }
    }
    private func updateDataSelectType(for index: Int) {
        let isListOpen = openList
        self.vwLocalTask.isHidden = true
        self.vwWorldwideTask.isHidden = true
        vwRefresh.isHidden = isListOpen
        vwRecenter.isHidden = isListOpen
        
        self.homeListenerCall = false
      
        removeAllArray()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
            switch index {
            case 0, 1:
                
                if index == 1 {
                    
                    self.updateSection(self.arrTask, heightConstraint: self.heightTaslTblVw, view: self.vwTask, itemHeight: 140, maxHeight: 260)
                    selectHomeIndex = 1
                    self.vwEarning.isHidden = false
                    self.vwTask.isHidden = false
                    self.vwMoment.isHidden = true
                    self.vwPopup.isHidden = true
                    self.vwBusiness.isHidden = true
                    self.btnAllTask.isHidden = true
                    self.btnAllPopup.isHidden = true
                    self.btnAllBusiness.isHidden = true
                    self.btnAllMoment.isHidden = true
                    self.btnGigFilter.isHidden = false
                    self.btnStoreFilter.isHidden = false
                    self.btnBusinessFilter.isHidden = false
                    self.btnAllMoment.isHidden = false
                    self.btnMomentFilter.isHidden = false
                    DispatchQueue.main.async {
                        self.removeAllArray()
                        let clusterManager = ClusterManager(mapView: self.mapView)
                        clusterManager.removeClusters()
                        clusterManager.removeExistingLayersAndSources()
                    }
                    self.socketData()
                    
                }else{

                    //                DispatchQueue.main.async {
                    //                    clusterManager.addClusters(with: self.customAnnotations)
                    //                }

                    self.updateSection(self.arrTask, heightConstraint: self.heightTaslTblVw, view: self.vwTask, itemHeight: 140, maxHeight: 260)

                    self.updateSection(self.arrPopUp, heightConstraint: self.heightPopUpColl, view: self.vwPopup, itemHeight: 144, maxHeight: 280)
                    self.updateSection(self.arrBusiness, heightConstraint: self.heightBusinessColl, view: self.vwBusiness, itemHeight: 100, maxHeight: 200)
                    self.btnAllMoment.isHidden = true
                    self.btnMomentFilter.isHidden = true

                    self.homeListenerCall = false
                    self.vwEarning.isHidden = false
                    self.btnAllTask.isHidden = false
                    self.btnAllPopup.isHidden = false
                    self.btnAllBusiness.isHidden = false
                    self.btnGigFilter.isHidden = true
                    self.btnAllMoment.isHidden = false
                    self.btnStoreFilter.isHidden = true
                    self.btnBusinessFilter.isHidden = true
                    self.vwTask.isHidden = false
                    self.vwPopup.isHidden = false
                    self.vwBusiness.isHidden = false
                    selectHomeIndex = 5
                    self.removeAllArray()
                    self.socketData()
                    let clusterManager = ClusterManager(mapView: self.mapView)
                    clusterManager.removeClusters()
                    clusterManager.removeExistingLayersAndSources()
                    DispatchQueue.main.async {
                        clusterManager.addClusters(with: self.customAnnotations)
                    }
                }
            case 2:
                self.btnAllMoment.isHidden = true
                self.btnMomentFilter.isHidden = true
                self.btnAllMoment.isHidden = true
                self.vwEarning.isHidden = true
                self.updateSection(self.arrPopUp, heightConstraint: self.heightPopUpColl, view: self.vwPopup, itemHeight: 144, maxHeight: 280)
                selectHomeIndex = 2
                self.vwTask.isHidden = true
                self.vwPopup.isHidden = false
                self.vwMoment.isHidden = true
                self.vwBusiness.isHidden = true
                self.btnAllTask.isHidden = true
                self.btnAllPopup.isHidden = true
                self.btnAllBusiness.isHidden = true
                self.btnGigFilter.isHidden = false
                self.btnStoreFilter.isHidden = false
                self.btnBusinessFilter.isHidden = false
                
                self.removeAllArray()
                self.socketData()
                
                let clusterManager = ClusterManager(mapView: self.mapView)
                clusterManager.removeClusters()
                clusterManager.removeExistingLayersAndSources()
                DispatchQueue.main.async {
                    clusterManager.addClusters(with: self.customAnnotations)
                }
            case 3:
                self.btnAllMoment.isHidden = true
                self.btnMomentFilter.isHidden = true
                self.btnAllMoment.isHidden = true
                self.vwEarning.isHidden = true
                self.updateSection(self.arrBusiness, heightConstraint: self.heightBusinessColl, view: self.vwBusiness, itemHeight: 100, maxHeight: 200)
                selectHomeIndex = 3
                self.vwTask.isHidden = true
                self.vwPopup.isHidden = true
                self.vwBusiness.isHidden = false
                self.btnAllTask.isHidden = true
                self.btnAllPopup.isHidden = true
                self.btnAllBusiness.isHidden = true
                self.btnGigFilter.isHidden = false
                self.btnStoreFilter.isHidden = false
                self.btnBusinessFilter.isHidden = false
                
                self.removeAllArray()
                self.socketData()
                let clusterManager = ClusterManager(mapView: self.mapView)
                clusterManager.removeClusters()
                clusterManager.removeExistingLayersAndSources()
                DispatchQueue.main.async {
                    clusterManager.addClusters(with: self.customAnnotations)
                }
//            case 3:
//
//                self.vwEarning.isHidden = true
//                self.updateSection(self.arrMoments, heightConstraint: self.heightTblVwMoment, view: self.vwMoment, itemHeight: 100, maxHeight: 200)
//                self.type = 4
//                self.vwMoment.isHidden = false
//                self.vwTask.isHidden = true
//                self.vwPopup.isHidden = true
//                self.vwBusiness.isHidden = true
//                self.btnAllTask.isHidden = true
//                self.btnAllPopup.isHidden = true
//                self.btnAllBusiness.isHidden = true
//                self.btnGigFilter.isHidden = false
//                self.btnStoreFilter.isHidden = false
//                self.btnBusinessFilter.isHidden = false
//
//                self.removeAllArray()
//                self.socketData()
//                let clusterManager = ClusterManager(mapView: self.mapView)
//                clusterManager.removeClusters()
//                clusterManager.removeExistingLayersAndSources()
//                DispatchQueue.main.async {
//                    clusterManager.addClusters(with: self.customAnnotations)
//                }

            default:
                break
            }
        }
    }
    
    private func updateSection(_ array: [Any], heightConstraint: NSLayoutConstraint, view: UIView, itemHeight: CGFloat, maxHeight: CGFloat) {
        guard !array.isEmpty else {
            heightConstraint.constant = 0
          
            view.isHidden = true
            return
        }
        
        view.isHidden = false
        if array.count < 2 {
            heightConstraint.constant = CGFloat(array.count) * itemHeight
          
        } else {
            heightConstraint.constant = maxHeight
           
        }
    }
    
}

extension HomeVC {
    func convertTo12HourFormat(_ time24: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // Input is in UTC
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date24 = dateFormatter.date(from: time24) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "h:mm a"
           // outputFormatter.timeZone = TimeZone.current // Convert to local time
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            return outputFormatter.string(from: date24)
        }
        return ""
    }
}
//MARK: - UIPopoverPresentationControllerDelegate
extension HomeVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
//MARK: - TABLEVIEW DELEGATE AND DATASOURCE
extension HomeVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVwMoments{
            if arrMoments.count > 0 {
                return arrMoments.count
            }else{
                return 0
            }
            
        }else{
            if arrTask.count > 0 {
                return arrTask.count
            }else{
                return 0
            }

        }
        
      
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblVwMoments{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsListTVC", for: indexPath) as! MomentsListTVC
            cell.viewShadow.layer.masksToBounds = false
            cell.viewShadow.layer.shadowColor = UIColor(hex: "#5F5F5F").cgColor
            cell.viewShadow.layer.shadowOpacity = 0.44
            cell.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.viewShadow.layer.shouldRasterize = true
            cell.viewShadow.layer.rasterizationScale = UIScreen.main.scale
            cell.viewShadow.layer.cornerRadius = 10
            cell.contentView.layer.cornerRadius = 10
            if indexPath.row < arrMoments.count {
                let moments = arrMoments[indexPath.row]
                cell.lblTitle.text = moments.title ?? ""
                let isoDate = moments.startDate ?? ""
                cell.lblDate.text = formatDateString(isoDate)
                cell.lblTime.text = formatTimeString(isoDate)
                cell.lblLocation.text = moments.place
                
                if moments.tasks?.count ?? 0 == 1 {
                    cell.lblTaskCount.text = "\(moments.tasks?.count ?? 0) Task"
                }else{
                    cell.lblTaskCount.text = "\(moments.tasks?.count ?? 0) Tasks"
                }
            }
            return cell
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigNearByTVC", for: indexPath) as! GigNearByTVC
        
            if arrTask.count > 0{
                if let category = arrTask[indexPath.row].category {
                    switch category {
                        
                    case .objectValue(let categoryObject):
                        
                        cell.lblTitle.text = "\(arrTask[indexPath.row].title ?? "") \(categoryObject.name ?? "")"
                        
                    case .intValue(_):
                        print("")
                    }
                }
                let timeString = arrTask[indexPath.row].serviceDuration ?? ""
                print("Service Duration------", timeString)
                
                var hour = 0
                var minute = 0
                
                if timeString.contains(":") {
                    let components = timeString.split(separator: ":")
                    if let h = Int(components[0]) {
                        hour = h
                    }
                    if components.count > 1, let m = Int(components[1].split(separator: " ")[0]) {
                        minute = m
                    }
                } else if timeString.contains("hour") || timeString.contains("hours") {
                    // Extract hour count from "2 hours" or "1 hour"
                    let hourComponents = timeString.split(separator: " ")
                    if let h = Int(hourComponents[0]) {
                        hour = h
                    }
                }
                
                // Format the end time
                if let formattedTime = convertToDateFormat(arrTask[indexPath.row].endDate ?? "",
                                                           dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                                           convertFormat: "Ha") {
                    if hour > 1 {
                        cell.lblTime.text = "\(formattedTime) (\(hour) H)"
                    } else {
                        let totalMinutes = (hour * 60) + minute
                        print("\(totalMinutes) M") // Output in minutes
                        cell.lblTime.text = "\(formattedTime) (\(totalMinutes) M)"
                    }
                } else {
                    print("Invalid date format")
                }
                
                
                cell.lblName.text = arrTask[indexPath.row].name ?? ""
                //                cell.lblTitle.text = arrTask[indexPath.row].title
                let value: Double = arrTask[indexPath.row].price ?? 0
                let formattedValue = String(format: "%.2f", value)
                cell.lblPrice.text = "$\(formattedValue)"
                cell.lblAddress.text = arrTask[indexPath.row].address ?? ""
                
                let skills = arrTask[indexPath.row].skills ?? []
                cell.arrCategory = skills
                cell.uiSet(load: true)
                
                if let formattedDate = convertToDateFormat(arrTask[indexPath.row].startDate ?? "", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", convertFormat:"dd MMM yyyy") {
                    cell.lblDate.text = formattedDate
                } else {
                    print("Invalid date format")
                }
                
                
                
                let rating = arrTask[indexPath.row].UserRating ?? 0.0
                let formattedRating = String(format: "%.1f", rating)
                cell.lblRatingReview.text = formattedRating
                
                if let imageURL = arrTask[indexPath.row].image, !imageURL.isEmpty {
                    cell.imgVwGig.imageLoad(imageUrl: imageURL)
                } else {
                    cell.imgVwGig.image = UIImage(named: "dummy")
                }
                
                cell.viewShadow.applyShadow()
                
            }
            return cell
        }
    }
    func formatDateString(_ isoDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent parsing

        if let date = formatter.date(from: isoDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dMMMMYYYY" // e.g., 4July2025
            outputFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent formatting
            return outputFormatter.string(from: date)
        }
        
        return ""
    }
    func formatTimeString(_ isoDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent parsing

        if let date = formatter.date(from: isoDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "h:mm a" // e.g., 4 PM
            outputFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent formatting
            return outputFormatter.string(from: date)
        }

        return ""
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblVwMoments{
            return 120
        }else{
            return 145
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if homeListenerCall{
            self.dismiss(animated: true)
            if tableView == tblVwMoments{
                if Store.UserDetail?["userId"] as? String ?? "" == arrMoments[indexPath.row].userID ?? ""{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OwnerMomentDetailVC") as! OwnerMomentDetailVC
                    vc.momentId = arrMoments[indexPath.row].id ?? ""
                    vc.callBack = {
                        
                        self.animateZoomInOut()
                        self.socketData()
                        
                    }

                    self.navigationController?.pushViewController(vc, animated: true)

                }else{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserSideMomentDetailVC") as! UserSideMomentDetailVC
                    vc.momentId = arrMoments[indexPath.row].id ?? ""
                    vc.callBack = {
                        self.isNavigating = false
                        self.animateZoomInOut()
                        self.socketData()
                        
                    }

                    self.navigationController?.pushViewController(vc, animated: true)

                }
            }else{
                if arrTask.count > 0{
                    if Store.userId == arrTask[indexPath.row].userID {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailOwnerVC") as! TaskDetailOwnerVC
                        if arrTask[indexPath.row].status != nil{
                            vc.isComing = 1
                        }else{
                            vc.isComing = 0
                        }
                        if arrTask.count > 0{
                            vc.gigId = arrTask[indexPath.row].id ?? ""
                        }
                        vc.callBack = {
                            
                            self.animateZoomInOut()
                            self.socketData()
                            
                        }
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewTaskVC") as! ViewTaskVC
                        if arrTask.count > 0{
                            vc.gigId = arrTask[indexPath.row].id ?? ""
                        }
                        vc.callBack = {
                            
                            self.animateZoomInOut()
                            self.socketData()
                            
                        }
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
     
    }
    func convertToDateFormat(_ dateString: String, dateFormat: String, convertFormat: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = dateFormat
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent parsing

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = convertFormat
            outputFormatter.timeZone = TimeZone.current // Convert to local time
            outputFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent formatting
            
            return outputFormatter.string(from: date)
        }
        return nil
    }
}



