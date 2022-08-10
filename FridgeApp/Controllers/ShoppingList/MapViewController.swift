//
//  MapViewController.swift
//  FridgeApp
//
//  Created by Aayush Subedi
//

import UIKit
import MapKit
import CoreLocation

//Class to show map and plot grocery buying places
// using CLLocationManagerDelegate to listen for location updates
class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var hasInitialized = false
    
    //insctance of location manager
    let locationMgr = CLLocationManager()
    
    var userLocation = CLLocation()

    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting this as as the delegate so that we can access localtion change callback
        locationMgr.delegate = self
        askForLocation()
    }
    
    
    //method to request location permission and starting to update location
    func askForLocation()   {
        locationMgr.requestWhenInUseAuthorization()
        locationMgr.startUpdatingLocation()
    }
    
    
    //sets up map region and span
    func setupMapSpan(location: CLLocationCoordinate2D){
        
        let span = 0.1
        map.region = MKCoordinateRegion(center: location, span:MKCoordinateSpan(latitudeDelta: CLLocationDegrees(span), longitudeDelta: CLLocationDegrees(span)))
    }
    
    //method to create annotation pin on map
    func showPinOnMap(cordinates:CLLocation?, title: String, subtitle: String) {
        //removing existing annonations to avoid atcaking multiple annotations
        let annotation = MKPointAnnotation()

        annotation.title = title
        annotation.subtitle = subtitle
        
        if let location = cordinates {
            annotation.coordinate = location.coordinate
            
            map.addAnnotation(annotation)
            
            //setting the cordinates of annotation
        }
      
    }
    
    //callback from delegate when location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if hasInitialized
        {
            return
        }
        //checking if there is any data in the array
        if let location = locations.first
        {
            
            userLocation = location
            let cordinates = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            //showPinOnMap(cordinates: cordinates)
            setupMapSpan(location: cordinates)
            findGroceryStores()
            hasInitialized = true
           
       }
        
    }
    
    
    //method to find list of grocery stores via apple map api
    func findGroceryStores() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "grocery"
        searchRequest.region = map.region
      
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            for item in response.mapItems
            {
              
                self.showPinOnMap(cordinates: item.placemark.location, title: item.name ?? "", subtitle: item.placemark.title ?? "")
                
                
            }
        }
    }

}
