//
//  MapViewController.swift
//  MapApp
//
//  Created by Vladimir Rogozhkin on 2020/09/24.
//  Copyright © 2020 Vladimir Rogozhkin. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak private var mapView: GMSMapView!
    
    private let locationManager = CLLocationManager()
    private let marker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        centerCircleMark()
        
        navigationItem.title = "MapApp"
    }
}

private extension MapViewController {
    
    func configureMap() {
        let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.camera = camera
        
        locationManager.delegate = self
        mapView.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func centerCircleMark() {
        let circleView = UIView()
        circleView.backgroundColor = .cyan
        view.addSubview(circleView)
        view.bringSubviewToFront(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                circleView.heightAnchor.constraint(equalToConstant: 20),
                circleView.widthAnchor.constraint(equalToConstant: 20),
                circleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ]
        )
        
        view.updateConstraints()
        
        UIView.animate(
            withDuration: 0.0,
            animations:
            {
                self.view.layoutIfNeeded()
                circleView.layer.cornerRadius = circleView.frame.width / 2
                circleView.clipsToBounds = true
            }
        )
    }
    
    func addMarkerOnCenter(coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = coordinate
        marker.map = self.mapView
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        addMarkerOnCenter(coordinate: position.target)
    }
}

