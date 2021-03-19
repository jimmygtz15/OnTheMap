//
//  MapViewController.swift
//  On The Map
//
//  Created by Jimmy Gutierrez on 3/13/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    func updateStudentData() {
        activityIndicator.startAnimating()
        let locations = StudentModel.students
        var annotations = [MKPointAnnotation]()
        
        for dictionary in locations {
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        activityIndicator.stopAnimating()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        activityIndicator.startAnimating()
        StudentModel.updateStudents { (success) in
            if success {
                self.updateStudentData()
                self.activityIndicator.stopAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                self.showAlert(message: "Failed loading students", title: "Error")
            }
        }
    }
    
//    func getStudentPins(completion: @escaping (Location, error) -> Void  ) {
//        
//    }
    
//    func getStudentsPins() {
//       // self.activityIndicator.startAnimating()
//        UdacityClient.getStudentLocation() { locations, error in
//            self.mapView.removeAnnotations(self.annotations)
//            self.annotations.removeAll()
//            self.locations = locations ?? []
//            for dictionary in locations ?? [] {
//                let lat = CLLocationDegrees(dictionary.latitude ?? 0.0)
//                let long = CLLocationDegrees(dictionary.longitude ?? 0.0)
//                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//                let first = dictionary.firstName
//                let last = dictionary.lastName
//                let mediaURL = dictionary.mediaURL
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = coordinate
//                annotation.title = "\(first) \(last)"
//                annotation.subtitle = mediaURL
//                self.annotations.append(annotation)
//            }
//            DispatchQueue.main.async {
//                self.mapView.addAnnotations(self.annotations)
//                self.activityIndicator.stopAnimating()
//            }
//        }
//    }

    
    

    
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
