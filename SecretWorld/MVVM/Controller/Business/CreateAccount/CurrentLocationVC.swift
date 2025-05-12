import UIKit
import MapKit
import CoreLocation
import SDWebImage
import MapboxMaps
import GoogleMaps
import GooglePlaces
import Solar

struct LocationData {
    let placeName: String?
    let lat: Double?
    let long: Double?
    
    init(placeName: String?, lat: Double?, long: Double?) {
        self.placeName = placeName
        self.lat = lat
        self.long = long
    }
}

class CurrentLocationVC: UIViewController{
    //MARK: - OUTLETS
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnCurrentLocation: UIButton!
    @IBOutlet var lblLocationName: UILabel!
    @IBOutlet var viewBack: UIView!
    @IBOutlet var txtFldSearch: UITextField!
  
    @IBOutlet weak var mapView: MapView!
    @IBOutlet var imgVwSearch: UIImageView!
    @IBOutlet var viewSearch: UIView!
   
    //MARK: - VARIABLES
    var city = ""
    let didFindMyLocation = false
    var geocoder = GMSGeocoder()
    var selectedLocation: LocationData?
    var callBack: ((_ selectedLocation: LocationData) -> ())?
    var latitude: Double?
    var longitude: Double?
    var isLocationSelectedManually = false
    var isLocationDetailsUpdated = false
    var isComing = false
    var DynamicView = UIView()
    var locationManager = CLLocationManager()
    private var solar: Solar?
    var pointAnnotationManager: PointAnnotationManager!
    var currentAnnotation: [PointAnnotation] = []
    var isSignUp = false
    var isUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                   swipeRight.direction = .right
                   view.addGestureRecognizer(swipeRight)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getLocationAllow(notification:)), name: Notification.Name("locationAllow"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getLocationDenied(notification:)), name: Notification.Name("locationDenied"), object: nil)

        locationPermission()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("locationAllow"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("locationDenied"), object: nil)
    }
    func locationPermission() {
        if #available(iOS 14.0, *) {
            switch locationManager.authorizationStatus {
            case .restricted, .denied:
                print("Location permission denied")
                locationDeniedAlert()
            case .authorizedWhenInUse, .authorizedAlways:
                print("Location permission allowed")
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
                mapView.addGestureRecognizer(tapGesture)
                setupLocationManager()
            default:
                print("Location permission not determined")
            }
        } else {
            // Fallback for earlier iOS versions
            switch CLLocationManager.authorizationStatus() {
            case .restricted, .denied:
                print("Location permission denied")
                locationDeniedAlert()
            case .authorizedWhenInUse, .authorizedAlways:
                print("Location permission allowed")
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
                mapView.addGestureRecognizer(tapGesture)
                setupLocationManager()
            default:
                print("Location permission not determined")
            }
        }
    }
    @objc func getLocationAllow(notification:Notification){
        self.dismiss(animated: true, completion: nil)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
              mapView.addGestureRecognizer(tapGesture)
        setupLocationManager()
        uiSet()

    }
    
    @objc func handleMapTap(_ gesture: UITapGestureRecognizer) {
        let tapPoint = gesture.location(in: mapView)
        let coordinate = mapView.mapboxMap.coordinate(for: tapPoint)

        print("Tapped at latitude: \(coordinate.latitude), longitude: \(coordinate.longitude)")

        // Ensure annotation manager exists
        if pointAnnotationManager == nil {
            pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        }

        // Remove all existing annotations before adding the new one
        pointAnnotationManager?.annotations = []
        currentAnnotation.removeAll()

        // Delayed call to download image if needed
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let dynamicImage = Store.role == "b_user" ?
                Store.BusinessUserDetail?["profileImage"] as? String ?? "" :
                Store.UserDetail?["profileImage"] as? String ?? ""
            
            self.downloadCurrentImage(centerCoordinate: coordinate, customImg: "business", dynamicImg: dynamicImage)
        }

        // Reverse Geocode to get place name
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let error = error {
                print("Reverse geocode error: \(error.localizedDescription)")
                return
            }
            
            guard let address = response?.firstResult(), let lines = address.lines else {
                print("No address found for this location")
                return
            }
            
            DispatchQueue.main.async {
                let fullAddress = lines.joined(separator: ", ")
                print("Tapped Location: \(fullAddress)")
                self.lblLocationName.text = fullAddress
                self.selectedLocation = LocationData(placeName: fullAddress, lat: coordinate.latitude, long: coordinate.longitude)
            }
        }

//        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
//            guard let address = response?.firstResult(), let lines = address.lines else {
//                print("No address found for this location")
//                return
//            }
//            
//            let fullAddress = lines.joined(separator: ", ")
//            
//            DispatchQueue.main.async {
//                print("Tapped Location: \(fullAddress)")
//                self.lblLocationName.text = fullAddress
//                self.selectedLocation = LocationData(placeName: fullAddress, lat: coordinate.latitude, long: coordinate.longitude)
//            }
//        }
    }
    @objc func getLocationDenied(notification:Notification){

        if !currentAnnotation.isEmpty {
               pointAnnotationManager.annotations = []
               currentAnnotation.removeAll()
           }
        showLocationDetails(placeName: "", latitude: 0, longitude: 0)
        lblLocationName.text = "Selected location?"
        
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

    @objc func handleSwipe() {
                navigationController?.popViewController(animated: true)
            }

    func uiSet() {
        viewBack.layer.cornerRadius = 30
        viewBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setupLocationManager() {
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestWhenInUseAuthorization()
           locationManager.startUpdatingLocation()
//           mapView.settings.myLocationButton = true
       }
    
    func hasNotch() -> Bool {
          if #available(iOS 11.0, *) {
              let window = UIApplication.shared.windows.first
              if let topPadding = window?.safeAreaInsets.top {
                  return topPadding > 20
              }
          }
          return false
      }
    
   
    
    func downloadCurrentImage(centerCoordinate: CLLocationCoordinate2D, customImg: String, dynamicImg: String) {
        // Ensure annotation manager exists
        if pointAnnotationManager == nil {
            pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        }

        // Remove all previous annotations before adding a new one
        pointAnnotationManager?.annotations = []
        currentAnnotation.removeAll()

        guard let baseImage = UIImage(named: customImg), let logoURL = URL(string: dynamicImg) else {
            return
        }

        // Download overlay image
        SDWebImageDownloader.shared.downloadImage(with: logoURL) { [weak self] overlayImage, _, _, error in
            guard let self = self, let overlayImage = overlayImage else { return }

            let combinedImage = self.combineImages(
                baseImage: baseImage,
                overlayImage: overlayImage,
                baseSize: CGSize(width: 34, height: 45),
                overlaySize: CGSize(width: 25, height: 25)
            )

            var pointAnnotation = PointAnnotation(coordinate: centerCoordinate)
            pointAnnotation.image = .init(image: combinedImage ?? UIImage(), name: "business")

            // Remove existing annotations again (to be extra safe)
            self.pointAnnotationManager?.annotations = []
            self.currentAnnotation.removeAll()

            // Add new annotation
            self.currentAnnotation.append(pointAnnotation)
            self.pointAnnotationManager?.annotations = self.currentAnnotation
        }
    }
       
    
    func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage? {
      defer { UIGraphicsEndImageContext() }
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
           image.draw(in: CGRect(origin: .zero, size: size))
      return UIGraphicsGetImageFromCurrentImageContext()
    }

    func combineImages(baseImage: UIImage, overlayImage: UIImage, baseSize: CGSize, overlaySize: CGSize, overlayPosition: CGPoint? = nil) -> UIImage? {
      UIGraphicsBeginImageContextWithOptions(baseSize, false, 0.0)
      baseImage.draw(in: CGRect(origin: .zero, size: baseSize))
      let overlayOrigin = overlayPosition ?? CGPoint(
        x: (baseSize.width - overlaySize.width) / 2,
        y: 3.5
      )
      let overlayFrame = CGRect(origin: overlayOrigin, size: overlaySize)
      let path = UIBezierPath(ovalIn: overlayFrame)
      path.addClip()
      overlayImage.draw(in: overlayFrame)
      let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return combinedImage
    }
    //MARK: - BUTTON ACTIONS
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionCurrentLocation(_ sender: UIButton) {
        
        setupLocationManager()
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .restricted, .denied:
            print("Location permission denied")
            showSwiftyAlert("", "Select location", false)
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission allowed")
            guard let unwrappedLocation = selectedLocation else {
                showSwiftyAlert("", "Select location", false)
                return
            }
            self.navigationController?.popViewController(animated: true)
            callBack?(unwrappedLocation)

        default:
            print("Location permission not determined")
        }

    }
}

//MARK: - UITextFieldDelegate
extension CurrentLocationVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if presentedViewController == nil {
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
        }
    }
}


// MARK: - CLLocationManagerDelegate
extension CurrentLocationVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        // Check if `PointAnnotationManager` is nil and initialize if necessary
        if pointAnnotationManager == nil {
            pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        }

        // Only clear previous annotations if needed (optional)
        if !currentAnnotation.isEmpty {
            pointAnnotationManager.annotations = []
            currentAnnotation.removeAll()
        }
        if isSignUp{
            self.showLocationDetails(placeName: lblLocationName.text ?? "", latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

            if let solar = Solar(coordinate: location.coordinate) {
                self.solar = solar
                let isDaytime = solar.isDaytime
                print(isDaytime ? "It's day time!" : "It's night time!")
                if isDaytime{
                    if let styleURL = URL(string: "mapbox://styles/kevinzhang23a/cm2bod8mi00qg01pgepsohjq0") {
                        mapView.mapboxMap.loadStyle(StyleURI(url: styleURL) ?? .light)
                    }
                    
                }else{
                    mapView.mapboxMap.styleURI = .dark
                }
            }
          
            print("Updating map center to: \(location.coordinate.latitude), \(location.coordinate.longitude)")

            mapView.mapboxMap.setCamera(to: CameraOptions(center: location.coordinate, zoom: 15, bearing: 0, pitch: 0))

            print("Camera update should be applied.")
            let geocoder = GMSGeocoder()
            geocoder.reverseGeocodeCoordinate(location.coordinate) { response, error in
                guard let address = response?.firstResult(), let lines = address.lines else {
                    return
                }
                let fullAddress = lines.joined(separator: ", ")
                DispatchQueue.main.async {
                    print("Current Location: \(fullAddress)")
                    self.showLocationDetails(placeName: fullAddress, latitude: Store.userLatLong?["lat"] as? Double ?? 0, longitude: Store.userLatLong?["long"] as? Double ?? 0)
                    
                    // Download and set annotation image
                    let userImage = (Store.role == "b_user") ? Store.BusinessUserDetail?["profileImage"] as? String ?? "" : Store.UserDetail?["profileImage"] as? String ?? ""
                    let annotationImage =  "business"
                    self.downloadCurrentImage(centerCoordinate: location.coordinate, customImg: annotationImage, dynamicImg: userImage)
                }
            }
        }else{
            let coordinate = CLLocation(latitude: Store.userLatLong?["lat"] as? Double ?? 0, longitude: Store.userLatLong?["long"] as? Double ?? 0)

            if let solar = Solar(coordinate: coordinate.coordinate) {
                self.solar = solar
                let isDaytime = solar.isDaytime
                print(isDaytime ? "It's day time!" : "It's night time!")
                if isDaytime{
                    if let styleURL = URL(string: "mapbox://styles/kevinzhang23a/cm2bod8mi00qg01pgepsohjq0") {
                        mapView.mapboxMap.loadStyle(StyleURI(url: styleURL) ?? .light)
                    }
                    
                }else{
                    mapView.mapboxMap.styleURI = .dark
                }
            }
          
            print("Updating map center to: \(coordinate.coordinate.latitude), \(coordinate.coordinate.longitude)")
            if isUpdate{
                mapView.mapboxMap.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: self.latitude ?? 0, longitude: self.longitude ?? 0), zoom: 15, bearing: 0, pitch: 0))
                print("Camera update should be applied.")
                let geocoder = GMSGeocoder()
                geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: self.latitude ?? 0, longitude: self.longitude ?? 0)) { response, error in
                    guard let address = response?.firstResult(), let lines = address.lines else {
                        return
                    }
                    let fullAddress = lines.joined(separator: ", ")
                    DispatchQueue.main.async {
                        print("Current Location: \(fullAddress)")
                        self.showLocationDetails(placeName: fullAddress, latitude: Store.userLatLong?["lat"] as? Double ?? 0, longitude: Store.userLatLong?["long"] as? Double ?? 0)
                        
                        // Download and set annotation image
                        let userImage = (Store.role == "b_user") ? Store.BusinessUserDetail?["profileImage"] as? String ?? "" : Store.UserDetail?["profileImage"] as? String ?? ""
                        let annotationImage = "business"
                        self.downloadCurrentImage(centerCoordinate: CLLocationCoordinate2D(latitude: self.latitude ?? 0, longitude: self.longitude ?? 0), customImg: annotationImage, dynamicImg: userImage)
                    }
                }
            }else{
                mapView.mapboxMap.setCamera(to: CameraOptions(center: coordinate.coordinate, zoom: 15, bearing: 0, pitch: 0))
                print("Camera update should be applied.")
                let geocoder = GMSGeocoder()
                geocoder.reverseGeocodeCoordinate(coordinate.coordinate) { response, error in
                    guard let address = response?.firstResult(), let lines = address.lines else {
                        return
                    }
                    let fullAddress = lines.joined(separator: ", ")
                    DispatchQueue.main.async {
                        print("Current Location: \(fullAddress)")
                        self.showLocationDetails(placeName: fullAddress, latitude: Store.userLatLong?["lat"] as? Double ?? 0, longitude: Store.userLatLong?["long"] as? Double ?? 0)
                        
                        // Download and set annotation image
                        let userImage = (Store.role == "b_user") ? Store.BusinessUserDetail?["profileImage"] as? String ?? "" : Store.UserDetail?["profileImage"] as? String ?? ""
                        let annotationImage = "business"
                        self.downloadCurrentImage(centerCoordinate: coordinate.coordinate, customImg: annotationImage, dynamicImg: userImage)
                    }
                }
            }
              
           
           
        }
       
        
        locationManager.stopUpdatingLocation()

        // Reverse geocode and update the UI
      
    }
    
  func showLocationDetails(placeName: String, latitude: Double, longitude: Double){
      
    self.lblLocationName.text = placeName
    self.selectedLocation = LocationData(placeName: placeName, lat: latitude, long: longitude)
    self.selectedLocation = LocationData(placeName: placeName, lat: latitude, long: longitude)
    }
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Location manager error: \(error.localizedDescription)")
  }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            setupLocationManager()
        case .denied, .restricted:
            locationDeniedAlert()
        default:
            break
        }
    }
}
//MARK: - GMSAutocompleteViewControllerDelegate
extension CurrentLocationVC: GMSAutocompleteViewControllerDelegate {
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
      
      if !currentAnnotation.isEmpty {
             pointAnnotationManager.annotations = []
             currentAnnotation.removeAll()
         }
    if place.coordinate.latitude.description.count != 0 {
     
            self.latitude = place.coordinate.latitude
        
    }
    if place.coordinate.longitude.description.count != 0 {
   
            self.longitude = place.coordinate.longitude
        
    }
//    txtFldSearch.text = place.formattedAddress
    lblLocationName.text = place.formattedAddress
    if let city = place.addressComponents?.filter({ $0.types.contains("locality") }).first?.name{
      self.city = city
    }
    selectedLocation = LocationData(placeName: place.formattedAddress, lat: latitude, long: longitude)
    
          let selectedLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
          updateMapViewWithGoogleLocation(selectedLocation)
      
      // Get city from address components 
      if let city = place.addressComponents?.first(where: { $0.types.contains("locality") })?.name {
          self.city = city
          print("City: \(city)")
          
          // Use geocoder to get city's lat/lng
          let geocoder = CLGeocoder()
          geocoder.geocodeAddressString(city) { [weak self] placemarks, error in
              guard let placemark = placemarks?.first, let location = placemark.location else {
                  print("City geocode failed: \(error?.localizedDescription ?? "No error info")")
                  return
              }
              print("City Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
          }
      }
      print("exact Location: \(selectedLocation)")
    isLocationSelectedManually = true
    print("isLocationSelectedManually: \(isLocationSelectedManually)")
      

    dismiss(animated: true, completion: nil)
  }
  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    print("Error: ", error.localizedDescription)
  }
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
 
  func updateMapViewWithGoogleLocation(_ location: CLLocation) {
    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15.0)
      if let solar = Solar(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) {
          self.solar = solar
          let isDaytime = solar.isDaytime
          print(isDaytime ? "It's day time!" : "It's night time!")
          if isDaytime{
              if let styleURL = URL(string: "mapbox://styles/kevinzhang23a/cm2bod8mi00qg01pgepsohjq0") {
                  mapView.mapboxMap.loadStyleURI(StyleURI(url: styleURL) ?? .light)
              }

          }else{
              mapView.mapboxMap.styleURI = .dark
          }
          }
      mapView.mapboxMap.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),zoom: 15,bearing: 0,pitch: 0))
      if Store.role == "b_user"{
         
              downloadCurrentImage(centerCoordinate: location.coordinate, customImg: "business", dynamicImg: Store.BusinessUserDetail?["profileImage"] as? String ?? "")
          
      }else{
           downloadCurrentImage(centerCoordinate: location.coordinate, customImg: "business", dynamicImg: Store.UserDetail?["profileImage"] as? String ?? "")
            
      }
    geocoder.reverseGeocodeCoordinate(location.coordinate) { placemarks, error in
      if let error = error {
        print("Reverse geocoding error: \(error.localizedDescription)")
        return
      }
      guard let address = placemarks?.firstResult(), let lines = address.lines else {
        print("No address found")
        return
      }
      let fullAddress = lines.joined(separator: ", ")
      self.lblLocationName.text = fullAddress
        if self.isUpdate{
            self.selectedLocation = LocationData(placeName: fullAddress, lat: location.coordinate.latitude, long: location.coordinate.longitude)
            print("Selected location name: \(fullAddress)")
        }else{
            self.selectedLocation = LocationData(placeName: fullAddress, lat: location.coordinate.latitude, long: location.coordinate.longitude)
            print("Selected location name: \(fullAddress)")
        }
    
    }
  }
    
}

