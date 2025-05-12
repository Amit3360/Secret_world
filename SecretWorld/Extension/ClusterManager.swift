//
//  ClusterManager.swift
//  SecretWorld
//
//  Created by Ideio Soft on 26/12/24.
//

import Foundation
import MapboxMaps

class ClusterManager {
    private let mapView: MapView
    private let sourceID = "custom-clustered-source"
    private var earthquakeSourceId: String { "earthquakes" }
    private var earthquakeLayerId: String { "earthquake-viz" }
    private var heatmapLayerId: String { "earthquakes-heat" }
    private var heatmapLayerSource: String { "earthquakes" }
    private var circleLayerId: String { "earthquakes-circle" }
    private var earthquakeURL: URL { URL(string: "https://www.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson")! }
    init(mapView: MapView) {
        self.mapView = mapView
    }
    
    func addClusters(with annotations: [ClusterPoint]) {
        var features: [MapboxMaps.Feature] = []
        let uniqueAnnotations = Array(Set(annotations))
        
        for item in uniqueAnnotations {
            let point = Point(item.coordinate)
            var properties: JSONObject = [:]

            // Format price to 2 decimal places
            let formattedPrice = Double(String(format: "%.2f", item.price)) ?? 0.00
            properties["price"] = JSONValue(formattedPrice)
            properties["seen"] = JSONValue(item.seen)

            var feature = Feature(geometry: point)
            feature.properties = properties
            features.append(feature)
        }
        
        let featureCollection = FeatureCollection(features: features)
        var source = GeoJSONSource(id: sourceID)
        source.data = .featureCollection(featureCollection)
        source.cluster = true
        source.clusterRadius = 60
        source.clusterMaxZoom = 16
        source.clusterProperties = [
            "sum_price": Exp(.sum) { Exp(.get) { "price" } },
            "seen": Exp(.sum) { Exp(.get) { "seen" } },
        ]
      
        do {
            try mapView.mapboxMap.addSource(source)
            addImagesToStyle()
            try mapView.mapboxMap.addLayer(createClusteredLayer())
            try mapView.mapboxMap.addLayer(createNumberLayer())
            try mapView.mapboxMap.addLayer(createUnclusteredLayer())
            try mapView.mapboxMap.addLayer(createUnclusteredTextLayer())
            try mapView.mapboxMap.addLayer(createSymbolLayer())
        } catch {
            print("Error adding cluster source or layers: \(error)")
        }
    }

    func removeClusters() {
        do {
            try mapView.mapboxMap.style.removeLayer(withId: "clustered-layer")
        } catch {
            print("Error removing source \("clustered-layer"): \(error)")
        }
        do {
            try mapView.mapboxMap.style.removeLayer(withId: "unclustered-layer")
        } catch {
            print("Error removing source \("clustered-layer"): \(error)")
        }
        do {
            try mapView.mapboxMap.style.removeLayer(withId: "unclustered-symbol-layer")
        } catch {
            print("Error removing source \("unclustered-layer"): \(error)")
        }
        do {
            try mapView.mapboxMap.style.removeLayer(withId: "unclustered-text-layer")
        } catch {
            print("Error removing source \("unclustered-text-layer"): \(error)")
        }
        do {
            try mapView.mapboxMap.style.removeLayer(withId: "cluster-count-layer")
        } catch {
            print("Error removing source \("cluster-count-layer"): \(error)")
        }
        // Remove the source
        let sourceID = "custom-clustered-source" // Replace with the actual source ID
        do {
            try mapView.mapboxMap.style.removeLayer(withId: sourceID)
        } catch {
            print("Error removing source \(sourceID): \(error)")
        }
        
        do {
            try mapView.mapboxMap.style.removeSource(withId: sourceID)
        } catch {
            print("Error removing source \(sourceID): \(error)")
        }
    }
  
    private func addImagesToStyle() {
        do {
            if let unseenImage = UIImage(named: "Coin") {
                try mapView.mapboxMap.style.addImage(unseenImage, id: "Coin")
            }
            if let grayImage = UIImage(named: "grayCoin") {
                try mapView.mapboxMap.style.addImage(grayImage, id: "grayCoin")
            }
            if let seenImage = UIImage(named: "CoinSeen") {
                try mapView.mapboxMap.style.addImage(seenImage, id: "CoinSeen")
            }
        } catch {
            print("Error adding images to style: \(error)")
        }
    }

    private func createClusteredLayer() -> CircleLayer {
        var layer = CircleLayer(id: "clustered-layer", source: sourceID)
        layer.filter = Exp(.has) { "point_count" }
        layer.circleColor = .expression(Exp(.match) {
            Exp(.get) { "seen" }
            0
            UIColor(hex: "#efd267")
            UIColor(hex: "#e8b602")
        })
        layer.circleRadius = .expression(Exp(.step) {
            Exp(.get) { "sum_price" }
            10
            10
            25
            500
            25
            1000
            25
        })
        return layer
    }

    private func createNumberLayer() -> SymbolLayer {
        var layer = SymbolLayer(id: "cluster-count-layer", source: sourceID)
        layer.filter = Exp(.has) { "point_count" }
        
        // Add "$" in front of the price value
        layer.textField = .expression(Exp(.concat) {
            "$"
            Exp(.toString) { Exp(.get) { "sum_price" } }
        })
        

        
        layer.iconImage = .expression(Exp(.match) {
            Exp(.get) { "seen" }
            1.0
            "CoinSeen"
            2.0
            "grayCoin"
            "Coin"
        })

        layer.iconSize = .constant(0.1)
        layer.textSize = .constant(10)
        layer.textColor = .constant(StyleColor(UIColor.black))
        layer.textHaloColor = .constant(StyleColor(UIColor.clear))
        layer.textHaloWidth = .constant(2)
        
        return layer
    }
  
 
    private func createUnclusteredLayer() -> CircleLayer {
        var layer = CircleLayer(id: "unclustered-layer", source: sourceID)
        layer.filter = Exp(.not) { Exp(.has) { "point_count" } }
        layer.circleColor = .expression(Exp(.match) {
            Exp(.get) { "seen" }
            0
            UIColor(hex: "#e8b602")
            UIColor(hex: "#efd267")
        })
        layer.circleRadius = .constant(25)
        layer.circleStrokeWidth = .constant(0)
        layer.circleStrokeColor = .constant(StyleColor(.black))

        // Add SymbolLayer for image icon
        var symbolLayer = SymbolLayer(id: "unclustered-symbol-layer", source: sourceID)
        symbolLayer.filter = Exp(.not) { Exp(.has) { "point_count" } }

        do {
            try mapView.mapboxMap.addLayer(symbolLayer)
        } catch {
            print("Error adding symbol layer with image: \(error)")
        }
        return layer
    }
    
    private func createUnclusteredTextLayer() -> SymbolLayer {
        var layer = SymbolLayer(id: "unclustered-text-layer", source: sourceID)
        layer.filter = Exp(.not) { Exp(.has) { "point_count" } }

        layer.textField = .expression(Exp(.concat) {
            "$"
            Exp(.toString) { Exp(.get) { "price" } }
        })

        layer.iconImage = .expression(Exp(.match) {
            Exp(.get) { "seen" }
            1.0
            "CoinSeen"
            2.0
            "grayCoin"
            "Coin"
        })
        
        
        layer.iconSize = .constant(0.1)
        layer.textSize = .constant(8)
        
        layer.textColor = .constant(StyleColor(UIColor.black))
        
        layer.textHaloColor = .constant(StyleColor(UIColor.clear))
        layer.textHaloWidth = .constant(1)
     
        return layer
    }

    private func createSymbolLayer() -> SymbolLayer {
        var layer = SymbolLayer(id: "unclustered-symbol-layer", source: sourceID)
        layer.filter = Exp(.not) { Exp(.has) { "point_count" } }
        layer.iconImage = .expression(Exp(.match) {
            Exp(.get) { "seen" }
            1.0
            "CoinSeen"
            2.0
            "grayCoin"
            "Coin"
        })
        do {
            try mapView.mapboxMap.addLayer(layer)
        } catch {
            print("Error adding symbol layer with image: \(error)")
        }
        return layer
    }
    func removeExistingLayersAndSources() {
      // Remove heatmap layer
      do {
        try mapView.mapboxMap.removeLayer(withId: heatmapLayerId)
        print("Heatmap layer removed successfully")
      } catch {
        print("Error removing heatmap layer: \(error)")
      }
      // Remove the GeoJSON source if it exists
      do {
        try mapView.mapboxMap.removeSource(withId: earthquakeSourceId)
        print("Earthquake source removed successfully")
      } catch {
        print("Error removing earthquake source: \(error)")
      }
    }
   
    func createEarthquakeSource(arrFeature: [Point]) {
      let features: [MapboxMaps.Feature] = arrFeature.map { point in
        MapboxMaps.Feature(geometry: .point(point))
      }
      let featureCollection = FeatureCollection(features: features)
      var geoJSONSource = GeoJSONSource(id: earthquakeSourceId)
      geoJSONSource.data = .featureCollection(featureCollection)
      do {
        try mapView.mapboxMap.addSource(geoJSONSource)
        print("Source added successfully")
      } catch {
        print("Error adding source: \(error)")
      }
    }
  func createHeatmapLayer() {
      let status = CLLocationManager.authorizationStatus()
      switch status {
      case .restricted, .denied: break
//        removeDataWhileLocationDenied()
        //locationDeniedAlert()
      case .authorizedWhenInUse, .authorizedAlways:
        var heatmapLayer = HeatmapLayer(id: heatmapLayerId, source: earthquakeSourceId)
        heatmapLayer.heatmapColor = .expression(
          Exp(.interpolate) {
            Exp(.linear)
            Exp(.heatmapDensity)
            0
            UIColor.clear
            0.05
            UIColor(hex: "#F0F8FF")
            0.1
            UIColor(hex: "#ADD8E6")
            0.2
            UIColor(hex: "#87CEFA")
            0.3
            UIColor(hex: "#3CB371")
            0.4
            UIColor(hex: "#00FF00")
            0.5
            UIColor(hex: "#FFFF00")
            0.6
            UIColor(hex: "#FFA500")
            0.7
            UIColor(hex: "#FF4500")
            0.8
            UIColor(hex: "#FF0000")
            0.85
            UIColor(hex: "#FF1493")
            0.9
            UIColor(hex: "#FF00FF")
            0.95
            UIColor(hex: "#8A2BE2")
            1.0
            UIColor(hex: "#4B0082")
          }
        )
        // Set heatmap intensity and radius
        heatmapLayer.heatmapIntensity = .constant(0.7)
        heatmapLayer.heatmapRadius = .expression(Exp(.interpolate) {
          Exp(.linear)
          Exp(.zoom)
          0
          40 // Larger radius at low zoom levels
          9
          50 // Increase radius as zoom level increases
          15
          70 // Maximum radius at highest zoom level
        })
        // Set heatmap opacity based on zoom level
        heatmapLayer.heatmapOpacity = .expression(Exp(.interpolate) {
          Exp(.linear)
          Exp(.zoom)
          0
          1 // Full opacity at zoom level 0
          9
          0.5 // Reduced opacity at zoom level 9
          12
          0 // Hide heatmap at zoom level 12 and above
        })
        // Add the heatmap layer above other layers
        do {
          try mapView.mapboxMap.addLayer(heatmapLayer)
          print("Heatmap layer added successfully")
        } catch {
          print("Error adding heatmap layer: \(error)")
        }
      default:
          print("sdasd")
      }
     }
}
