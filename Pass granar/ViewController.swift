//
//  ViewController.swift
//  Pass granar
//
//  Created by Robin Wahlgren on 2018-04-27.
//  Copyright © 2018 Robin Wahlgren. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GoogleMobileAds


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate,GADBannerViewDelegate {
    
   @IBOutlet weak var theBanner: GADBannerView!
    
    @IBOutlet weak var theMap: MKMapView!
    
  var locationManager: CLLocationManager!
    var annotation = MKPointAnnotation()
 var bannerView: GADBannerView!
   

    //MARK: - AdMob
    var adMobBannerView = GADBannerView()
    // lägg in eget unit_id från AdMob kontrollpanel
    let ADMOB_BANNER_UNIT_ID = "ca-app-pub-2887421681267453/6521815240"
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        if UserDefaults.standard.object(forKey: "locationArray") != nil {
            for dictionary in UserDefaults.standard.object(forKey: "locationArray") as! [[String:Double]]{
                let center = CLLocationCoordinate2D(latitude: dictionary["latitude"]!, longitude: dictionary["longitude"]!)
                let annotation = MKPointAnnotation()
                annotation.coordinate = center
                self.theMap.addAnnotation(annotation)
                
            }
        }
        
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 0.5
        self.theMap.addGestureRecognizer(longPressGesture)
        
        
       
   }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        self.locationManager = CLLocationManager()
        
        if(CLLocationManager.authorizationStatus() == .denied)
        {
            
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            theMap.showsUserLocation = true
            
        }
        
        
       
        
        
        let request = GADRequest()
        theBanner.delegate = self
        theBanner.adUnitID = ADMOB_BANNER_UNIT_ID
        theBanner.rootViewController = self
        theBanner.load(request)


       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let lng = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        
        print(lng)
        print(lat)
        
    }
        
     
    
    @IBAction func center(_ sender: Any) {
         var region = MKCoordinateRegion()
        region.center = theMap.userLocation.coordinate
        var span = MKCoordinateSpan()
        span.latitudeDelta = 0.003
        span.longitudeDelta = 0.003
        region.span = span
        theMap.setRegion(region, animated: true)
        
    }
    
    @objc func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .ended {
            let point = gesture.location(in: self.theMap)
            let coordinate = self.theMap.convert(point, toCoordinateFrom: self.theMap)
            print(coordinate)
            //Now use this coordinate to add annotation on map.
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            self.theMap.addAnnotation(annotation)
            
            let locationDictionary:[String:Double] = ["latitude":annotation.coordinate.latitude,"longitude":annotation.coordinate.longitude]
            var locationArray = [[String:Double]]()
            if UserDefaults.standard.object(forKey: "locationArray") != nil {
                locationArray = UserDefaults.standard.object(forKey: "locationArray") as! [[String:Double]]
                
            }
            
            locationArray.append(locationDictionary)
            
            UserDefaults.standard.set(locationArray, forKey: "locationArray")
            UserDefaults.standard.synchronize()
            
        }
        
        }

    
    
    func  mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
 
        view.isDraggable = true
        
       
    }

}
