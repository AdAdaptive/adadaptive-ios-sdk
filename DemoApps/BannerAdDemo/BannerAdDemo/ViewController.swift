//
//  ViewController.swift
//  BannerAdDemo
//
//  Created by Peter Bunus on 2017-02-21.
//  Copyright © 2017 SystemicsCode. All rights reserved.
//

import UIKit
import MapKit
import AdAdaptiveFramework
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var myADView: AdAdaptiveBannerView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SDK Version = \(myADView.getAdAdaptiveSDKVersion())")
        
        // ----------------- Authorize the API Access ----------------------------------------------------------------------------------------- //
        // Replace the following line with your own API, publisherID and appID if you want to use your private AD Echange provided by AdAdaptive.
        // e.g. myADView.authorizeAPI(API: "your API e.g http://yourcompany.adadaptive.com/api/v1.0", publisherID: "Your Publisher ID", appID: "Your App ID")
        myADView.authorizeAPI(publisherID:"eyJhbGciOiJIUzI1NiJ9.cGV0ZXIuYnVudXNAc3lzdGVtaWNzY29kZS5jb20.gORA9JIIO0atYeqoSbbWeO56j-NELKhkMHLd5c2oTaA"
            ,appID:"58ab7e068701dd000489d260")
        // ------------------------------------------------------------------------------------------------------------------------------------ //
        
        
        let adLocation =  CLLocation(latitude: 82.867486, longitude: -36.634547)
        myADView.loadAD(adLocation, completion:nil)
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()           // This API call was introduced in iOS 9 and triggers a one-time location request.
            //locationManager.startUpdatingLocation()   // For iOS 8 and prior. This API continuously requests the current location, and
                                                        // leaves it up to the developer to figure out when to stop location updates
            self.mapView.showsUserLocation = true;      // shows the user's curent location by placing a "blue dot" on the map
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ---------------------- Location Manager Delegates -------------------------------------------------------------------------//
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let my_location = locations.first {
            
            print("User Location = \(my_location.coordinate.latitude) \(my_location.coordinate.longitude)")
        
            //center the map an zoom into the user location
            let map_center  = my_location.coordinate
            let map_span    = MKCoordinateSpanMake(0.01, 0.01)
            let map_region  = MKCoordinateRegionMake(map_center, map_span)
            self.mapView.setRegion(map_region, animated: true)
            
            // load ad AD from the current user location. If there is no AD available prints a message to the app console
            myADView.loadAD(my_location){
                (result:Bool) -> Void in
                if (!result) { //no AD has been found at the current location
                    print ("BannerAdDemo Info: No AD have been found at location \(my_location.coordinate)")
                }
                print ("BannerAdDemo Info: Displaying AD at location \(my_location.coordinate)")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("BannerAdDemo Error: Location request failed: \(error)")
    }


}

