//
//  MapView.swift
//  PictureBook
//
//  Created by Ma Xueyuan on 2019/12/26.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var imageInfo: ImageInfo
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Placemark"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
        
            return annotationView
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        // Center
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: imageInfo.latitude, longitude: imageInfo.longitude)
        
        // Annotation
        let annotation = MKPointAnnotation()
        annotation.title = imageInfo.name
        annotation.coordinate = CLLocationCoordinate2D(latitude: imageInfo.latitude, longitude: imageInfo.longitude)
        mapView.addAnnotation(annotation)
        
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapView>) {
    }
}

