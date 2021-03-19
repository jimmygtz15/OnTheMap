//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Jimmy Gutierrez on 3/16/21.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    var studentInformation: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finishButton.isEnabled = true
        if let studentLocation = studentInformation {
            let studentLocation = Location(
                objectId: studentLocation.objectId ,
                uniqueKey: studentLocation.uniqueKey,
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                createdAt: studentLocation.createdAt ,
                updatedAt: studentLocation.updatedAt
            )
            showLocations(location: studentLocation)
        }
    }
    
    
    @IBAction func finishButton(_ sender: Any) {
        self.setLoading(true)
        if let studentLocation = studentInformation {
            if UdacityClient.Auth.objectId == "" {
                    UdacityClient.addStudentLocation(information: studentLocation) { (success, error) in
                        if success {
                            DispatchQueue.main.async {
                                self.setLoading(true)
                                self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                                self.setLoading(false)
                            }
                        }
                    }
            } else {
                let alertVC = UIAlertController(title: "", message: "This student has already posted a location. Would you like to overwrite this location?", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action: UIAlertAction) in
                    UdacityClient.updateStudentLocation(information: studentLocation) { (success, error) in
                        if success {
                            DispatchQueue.main.async {
                                self.setLoading(true)
                                self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                                self.setLoading(false)
                            }
                        }
                    }
                }))
                alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                    DispatchQueue.main.async {
                        self.setLoading(false)
                        alertVC.dismiss(animated: true, completion: nil)
                    }
                }))
                self.present(alertVC, animated: true)
            }
        }
        
    }

    // MARK:- New location in map
    private func showLocations(location: Location) {
        mapView.removeAnnotations(mapView.annotations)
        if let coordinate = extractCoordinate(location: location) {
            let annotation = MKPointAnnotation()
            annotation.title = location.locationLabel
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    private func extractCoordinate(location: Location) -> CLLocationCoordinate2D? {
        if let lat = location.latitude, let lon = location.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
    
    // MARK:- Loading state
    func setLoading(_ loading: Bool) {
        if loading {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.finishButton.isEnabled = false            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.finishButton.isEnabled = true            }
        }
        DispatchQueue.main.async {
            self.finishButton.isEnabled = !loading
        }
    }

}
