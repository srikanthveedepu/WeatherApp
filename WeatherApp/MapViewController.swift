//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Veedepu Srikanth on 06/01/21.
//

import UIKit
import MapKit


protocol MapViewControllerDelegate: AnyObject {
    
    func didAddLocation(_ place: CLPlacemark)
}

class MapViewController: UIViewController {
    
    weak var delegate: MapViewControllerDelegate?
    let mapView = MKMapView()
    var annotation: MKPointAnnotation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeMapScreen))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocation))
        
        let initialLocation = CLLocation(latitude: 17.3850, longitude: 78.4867)
        
        let center = CLLocationCoordinate2D(latitude: initialLocation.coordinate.latitude, longitude: initialLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(mRegion, animated: true)
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        [
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ].forEach { $0.isActive = true }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        gestureRecognizer.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func handleTap(tap: UITapGestureRecognizer) {
        
        let location = tap.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        // Add annotation:
        
        if let ann = annotation {
            mapView.removeAnnotation(ann)
            annotation = nil
        }
        
        annotation = MKPointAnnotation()
        annotation!.coordinate = coordinate
        mapView.addAnnotation(annotation!)
    }
    
    @objc func addLocation() {
        
        guard let _ = annotation else { return }
        let geocoder = CLGeocoder()
        
        let location = CLLocation(latitude: annotation!.coordinate.latitude, longitude: annotation!.coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { [unowned self] (placemarks, error) in
            if error == nil {
                guard let firstLocation = placemarks?[0] else { return }
                print(firstLocation.locality!)
                self.delegate?.didAddLocation(firstLocation)
                closeMapScreen()
            }
            else {
            }
        })
    }
    
    @objc func closeMapScreen() {
        dismiss(animated: true, completion: nil)
    }
}
