//
//  TestMapVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 22/07/24.
//

import UIKit
import MapKit

class TestMapVC: UIViewController {
    @IBOutlet var mapView: MKMapView!
    private var imageView: UIImageView?
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addCircleOverlay()
        setupImageView()
        animateImageViewInCircle()
    }
    
    private func addCircleOverlay() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 30.7046, longitude: 76.7179)
        let circleRadius = 10000.0
        let circle = MKCircle(center: centerCoordinate, radius: circleRadius)
        mapView.addOverlay(circle)
        let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: circleRadius * 2, longitudinalMeters: circleRadius * 2)
        mapView.setRegion(region, animated: true)
    }

    private func setupImageView() {
        let image = UIImage(named: "dron")
        imageView = UIImageView(image: image)
        imageView?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        if let imageView = imageView {
            mapView.addSubview(imageView)
        }
    }

    private func animateImageViewInCircle() {
        guard let imageView = imageView else { return }
        
        let circleCenterCoordinate = CLLocationCoordinate2D(latitude: 30.7046, longitude: 76.7179)
        let circleRadius = 10000.0
        let mapPointCenter = MKMapPoint(circleCenterCoordinate)
        let radiusPoints = MKMapPointsPerMeterAtLatitude(circleCenterCoordinate.latitude) * circleRadius
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        var points = [NSValue]()
        
        let numberOfSteps = 100
        let angleIncrement = 2 * CGFloat.pi / CGFloat(numberOfSteps)
        
        for step in 0..<numberOfSteps {
            let angle = angleIncrement * CGFloat(step)
            let x = mapPointCenter.x + radiusPoints * cos(Double(angle))
            let y = mapPointCenter.y + radiusPoints * sin(Double(angle))
            let mapPoint = MKMapPoint(x: x, y: y)
            let coordinate = mapPoint.coordinate
            
            // Ensure the coordinate is within the circle
            let distance = MKMapPoint(coordinate).distance(to: mapPointCenter)
            if distance <= radiusPoints {
                let point = mapView.convert(coordinate, toPointTo: mapView)
                points.append(NSValue(cgPoint: point))
            }
        }
        
        animation.values = points
        animation.duration = 5 // Duration of the animation
        animation.repeatCount = .infinity
        
        imageView.layer.add(animation, forKey: "circularMotion")
    }


    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TestMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circle = overlay as? MKCircle {
            let renderer = MKCircleRenderer(circle: circle)
            renderer.fillColor = UIColor(hex: "#3E9C35").withAlphaComponent(0.17)
            renderer.strokeColor = UIColor(hex: "#3E9C35")
            renderer.lineWidth = 1
            return renderer
        }
        return MKOverlayRenderer()
    }
}
