//
//  RouteVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 05/03/25.
//

import UIKit
import MapboxMaps
import Solar
import CoreLocation
import GoogleMaps
import GooglePlaces
import SDWebImage
import MapKit
import Turf
import MapboxDirections

class RouteVC: UIViewController {

    @IBOutlet weak var mapVw: MapView!
    
    private var solar: Solar?
    var lat:Double = 0
    var long:Double = 0
    var pointAnnotationManager: PointAnnotationManager!
    var CurrentpointAnnotationManager: PointAnnotationManager!
    var destinationMarkerAnnotation: [PointAnnotation] = []
    var currentAnnotation: PointAnnotation?
    private let locationManager = CLLocationManager()
    private var userRouteCoordinates: [CLLocationCoordinate2D] = []
    private var routePolyline: PolylineAnnotation?
    private var polylineAnnotationManager: PolylineAnnotationManager?
    var routeDrawn = false
    var hasCenteredOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
      
    }
    func uiSet(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if let solar = Solar(coordinate: CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)) {
            self.solar = solar
            let isDaytime = solar.isDaytime
            print(isDaytime ? "It's day time!" : "It's night time!")
            if isDaytime{
                if let styleURL = URL(string: "mapbox://styles/kevinzhang23a/cm2bod8mi00qg01pgepsohjq0") {
                    mapVw.mapboxMap.loadStyle(StyleURI(url: styleURL) ?? .light)
                }
                
            }else{
                mapVw.mapboxMap.styleURI = .dark
            }
        }
   
      
        self.mapVw.ornaments.scaleBarView.isHidden = true
        self.mapVw.ornaments.logoView.isHidden = true
        self.mapVw.ornaments.attributionButton.isHidden = true
        let userImage = (Store.role == "b_user") ? Store.BusinessUserDetail?["profileImage"] as? String ?? "" : Store.UserDetail?["profileImage"] as? String ?? ""
        let annotationImage =  "business"
        self.downloadCurrentImage(centerCoordinate: CLLocationCoordinate2D(latitude: self.lat, longitude: self.long), customImg: annotationImage, dynamicImg: userImage)

   
    }
   
    func drawLineByRoad(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        let directions = Directions(credentials: Credentials(accessToken: "pk.eyJ1Ijoia2V2aW56aGFuZzIzYSIsImEiOiJjbTJibnlmMHYwc3kyMmtweW5oYWJrbzRjIn0.6dtm6-z0rx5kqbAAh_N96Q"))

        // Use `targetCoordinate` to reduce snapping at start and end
        let origin = Waypoint(coordinate: start)
        origin.targetCoordinate = start

        let destination = Waypoint(coordinate: end)
        destination.targetCoordinate = end

        let options = RouteOptions(waypoints: [origin, destination], profileIdentifier: .automobile)
        options.includesSteps = false
        options.routeShapeResolution = .full
        options.shapeFormat = .polyline

        directions.calculate(options) { [weak self] (_, result) in
            guard let self = self else { return }

            switch result {
            case .failure(let error):
                print("Error calculating directions: \(error)")

            case .success(let response):
                guard let route = response.routes?.first,
                      let routeCoordinates = route.shape?.coordinates else { return }

                self.polylineAnnotationManager?.annotations = []

                // Forcefully add the building location as start and end
                var fullRoute = [start]
                fullRoute += routeCoordinates
                fullRoute.append(end)

                let lineString = LineString(fullRoute)
                var polyline = PolylineAnnotation(lineString: lineString)
                polyline.lineWidth = 6
                polyline.lineColor = .init(UIColor(hex: "#3E9C35"))

                if self.polylineAnnotationManager == nil {
                    self.polylineAnnotationManager = self.mapVw.annotations.makePolylineAnnotationManager()
                }

                self.polylineAnnotationManager?.annotations = [polyline]
            }
        }
    }
    func downloadCurrentImage(centerCoordinate: CLLocationCoordinate2D, customImg: String, dynamicImg: String) {
        // Ensure annotation manager exists
        if pointAnnotationManager == nil {
            pointAnnotationManager = mapVw.annotations.makePointAnnotationManager()
        }

        // Remove all previous annotations before adding a new one
        pointAnnotationManager?.annotations = []
        destinationMarkerAnnotation.removeAll()

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
            self.destinationMarkerAnnotation.removeAll()

            // Add new annotation
            self.destinationMarkerAnnotation.append(pointAnnotation)
            self.pointAnnotationManager?.annotations = self.destinationMarkerAnnotation
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
   
    func currenMarker(baseImage: UIImage, baseSize: CGSize,overlayPosition: CGPoint? = nil) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(baseSize, false, 0.0)
        baseImage.draw(in: CGRect(origin: .zero, size: baseSize))
       
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return combinedImage
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
  
       
     
}

extension RouteVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }

        let newCoordinate = latest.coordinate

            if !hasCenteredOnce {
                mapVw.mapboxMap.setCamera(to: CameraOptions(center: newCoordinate, zoom: 15))
                hasCenteredOnce = true
            }

        // Create marker image
//        mapVw.mapboxMap.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: latest.coordinate.latitude, longitude: latest.coordinate.longitude), zoom: 15, bearing: 0, pitch: 0))
        guard let baseImage = UIImage(named: "blueDot") else { return }
        let combinedImage = currenMarker(baseImage: baseImage, baseSize: CGSize(width: 35, height: 35))

        // Remove previous annotation(s)
        if CurrentpointAnnotationManager == nil {
            CurrentpointAnnotationManager = mapVw.annotations.makePointAnnotationManager()
        } else {
            CurrentpointAnnotationManager?.annotations = []
       
        }

        // Add updated marker
        var updatedAnnotation = PointAnnotation(coordinate: newCoordinate)
        updatedAnnotation.image = .init(image: combinedImage ?? UIImage(), name: "blueDot")
        currentAnnotation = updatedAnnotation
        CurrentpointAnnotationManager?.annotations = [updatedAnnotation]

        // Always re-draw route
        drawLineByRoad(start: newCoordinate, end: CLLocationCoordinate2D(latitude: self.lat, longitude: self.long))
    }
}
