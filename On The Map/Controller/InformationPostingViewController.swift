//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Jimmy Gutierrez on 3/14/21.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    var objectId: String?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationButton.isEnabled = true
        locationTextField.delegate = self
    }
    
    @IBAction func findLocation(_ sender: Any) {
        print("location button")
        isLoading(true)
        let newLocation = locationTextField.text
        guard let url = URL(string: self.websiteTextField.text!), UIApplication.shared.canOpenURL(url) else {
            self.showAlert(message: "Please include 'http://' in your link.", title: "Invalid URL")
            isLoading(false)
            return
        }

        geocodePosition(newLocation: newLocation ?? "")

    }
    
    // MARK:- Find geocode position
    private func geocodePosition(newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription, title: "Location Not Found")
                self.isLoading(false)
                print("Location not found.")
            } else {
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.loadNewLocation(location.coordinate)
                } else {
                    self.showAlert(message: "Please try again later.", title: "Error")
                    self.isLoading(false)
                    print("There was an error.")
                }
            }
        }
    }
    
    // MARK:- Push to Final Add Location screen
    private func loadNewLocation(_ coordinate: CLLocationCoordinate2D) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        controller.studentInformation = buildStudentInfo(coordinate)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK:- Student info to display on Final Add Location screen
    private func buildStudentInfo(_ coordinate: CLLocationCoordinate2D) -> Student {
        
        var studentInfo = [
            "uniqueKey": UdacityClient.Auth.key,
            "firstName": UdacityClient.Auth.firstName,
            "lastName": UdacityClient.Auth.lastName,
            "mapString": locationTextField.text!,
            "mediaURL": websiteTextField.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
        ] as [String : Any]
        
        if let objectId = objectId {
            studentInfo["objectId"] = objectId as Any
            print(objectId)
        }

        return Student(studentInfo)

    }

    

    
    
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func isLoading(_ loading: Bool) {
        if loading {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.locationButton.isEnabled = false
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.locationButton.isEnabled = true
            }
        }
        DispatchQueue.main.async {
            self.locationTextField.isEnabled = !loading
            self.websiteTextField.isEnabled = !loading
            self.locationButton.isEnabled = !loading
        }
    }

}
