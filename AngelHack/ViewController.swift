//
//  ViewController.swift
//  AngelHack
//
//  Created by Amanda Gao on 7/18/15.
//  Copyright (c) 2015 Amanda Gao. All rights reserved.
//

import UIKit
import GoogleMaps

class OurViewController: UIViewController {
    @IBOutlet var ourLabel : UILabel!
    
    @IBAction func buttonPressed() {
        self.mapView.animateWithCameraUpdate(GMSCameraUpdate.setTarget(self.mapView.myLocation.coordinate))
    }
    
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        var camera = GMSCameraPosition.cameraWithLatitude(-33.86,
            longitude: 151.20, zoom: 6)
        self.mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        
        /* Getting current location */
        self.mapView.myLocationEnabled = true
        self.mapView.accessibilityElementsHidden = false
        
        self.view = self.mapView

        var marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        

        /* For street view
        var panoView = GMSPanoramaView(frame: CGRectZero)
        self.view = panoView
        panoView.moveNearCoordinate(CLLocationCoordinate2DMake(-33.732, 150.312))
        */
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

