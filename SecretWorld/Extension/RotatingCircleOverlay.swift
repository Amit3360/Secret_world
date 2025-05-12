//
//  RotatingCircleOverlay.swift
//  SecretWorld
//
//  Created by meet sharma on 17/06/24.
//

import Foundation
import MapKit

class RotatingCircleOverlay: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var angle: Double = 0.0
    var annotation: MKPointAnnotation?
    
    init(center: CLLocationCoordinate2D, radius: CLLocationDistance, annotation: MKPointAnnotation?) {
        self.coordinate = center
        self.radius = radius
        self.annotation = annotation
        super.init()
    }
    
    var boundingMapRect: MKMapRect {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: radius * 2, longitudinalMeters: radius * 2)
        return MKMapRect.forCoordinateRegion(region)
    }
    
    func updateCoordinate(with angle: Double) {
          guard let annotation = annotation else { return }
          
          let radianAngle = angle * .pi / 180.0
          let newLatitude = coordinate.latitude + (radius / 111000.0) * cos(radianAngle)
          let newLongitude = coordinate.longitude + (radius / (111000.0 * cos(coordinate.latitude * .pi / 180.0))) * sin(radianAngle)
          
          annotation.coordinate = CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
      }
//    func updateCoordinate(with angle: Double) {
//        let radians = angle * Double.pi / 180.0
//        let newLat = coordinate.latitude + radius * cos(radians) / 111000.0
//        let newLong = coordinate.longitude + radius * sin(radians) / (111000.0 * cos(coordinate.latitude * Double.pi / 180.0))
//        annotation?.coordinate = CLLocationCoordinate2D(latitude: newLat, longitude: newLong)
//    }
}

extension MKMapRect {
    static func forCoordinateRegion(_ region: MKCoordinateRegion) -> MKMapRect {
        let a = MKMapPoint(region.center)
        let b = MKMapPoint(CLLocationCoordinate2D(latitude: region.center.latitude + region.span.latitudeDelta / 2, longitude: region.center.longitude + region.span.longitudeDelta / 2))
        return MKMapRect(x: min(a.x, b.x), y: min(a.y, b.y), width: abs(a.x - b.x) * 2, height: abs(a.y - b.y) * 2)
    }
}
