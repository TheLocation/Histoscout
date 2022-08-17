//
//  RunningMap_ViewController.swift
//  Historunning
//
//  Created by Matteo Postorino on 14/07/2020.
//  Copyright © 2020 Matteo Postorino. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseCore

@available(iOS 15.0, *)

class Map_ViewController: UIViewController, UIGestureRecognizerDelegate{
        
    let Custom_annotation = EditableAnnotation()
    
    var path_selected = false
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    private var currentCoordinate:CLLocationCoordinate2D?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /*
        let urlTemplate = "http://tile.openstreetmap.org/{z}/{x}/{y}.png"
        let overlay = MKTileOverlay(urlTemplate: urlTemplate)
        overlay.canReplaceMapContent = true
        */
        
        locationManager.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsTraffic = true
        mapView.mapType = .hybridFlyover
        //mapView.addOverlay(overlay, level: .aboveLabels)
        //Location Manager to find user current position.
        checkLocationServices()

    }
    
    @objc(mapView:rendererForOverlay:) func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKTileOverlay {
            let renderer = MKTileOverlayRenderer(overlay: overlay)
            return renderer
        } else {
            return MKTileOverlayRenderer()
        }
    }
    
    //MARK: set up location manager
    func setUpLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func updatelocation(){
        DispatchQueue.main.async {
              self.locationManager.startUpdatingLocation()
          }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManager()
            checklocationAuthorization()
        }else{
            
        }
    }
    
//MARK: checking authorization options:
    
    func checklocationAuthorization(){
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            mapView.showsBuildings = true
            mapView.showsScale = true
            updatelocation()
            //Map Staff
            break
        case .denied:
            //Show alert
            break
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .restricted:
            //Show alert
            break
        case .authorizedAlways:
            mapView.showsUserLocation = true
            mapView.showsBuildings = true
            mapView.showsScale = true
            updatelocation()
            break
        @unknown default:
            fatalError()
        }
    }
    

    @IBAction func yourJourneyBtn(_ sender: Any) {
        performSegue(withIdentifier: "yourJourney", sender: self)
    }
    

    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D){
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
//MARK: All these data will be retrieved from Realm DB.
    
    func setAnnotation() {
        let arsenaleMM = EditableAnnotation()
        arsenaleMM.title = "Arsenale Marina Militare"
        arsenaleMM.subtitle = "L'arsenale e servito per salvaguardarci dai nazisti che senno campo di concentramento easy a go go"
        arsenaleMM.image = "navy_arsenale"
        arsenaleMM.coordinate = CLLocationCoordinate2D(latitude: 44.101638, longitude: 9.820330)
                
        mapView.addAnnotation(arsenaleMM)
    }
}

@available(iOS 15.0, *)

extension Map_ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //code
        
        //If updated location is nil nothing happens
        guard let location = locations.last else {return}
        //Otherwise if user location updates this is fired off
        if currentCoordinate == nil{
            zoomToLatestLocation(with: location.coordinate)
        }
        currentCoordinate = location.coordinate
        
        setAnnotation()
}
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //Code
        checklocationAuthorization()
    }
}

@available(iOS 15.0, *)
extension Map_ViewController:  MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") //as? MKMarkerAnnotationView
        
        if annotationView == nil {
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
            
//                      annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "annotationView") - READ DOCS!!
            
        annotationView?.canShowCallout = true
        
        } else {
            annotationView?.annotation = annotation
        }
        
        if let customAnnotation = annotation as? EditableAnnotation {
            annotationView?.image = UIImage(named: customAnnotation.image)
        }
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.subviews.forEach{ subView in
            subView.removeFromSuperview()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        print("the annotation \(String(describing: view.annotation?.title)) was selected")
    }
}

