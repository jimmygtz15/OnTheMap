//
//  ListTableViewController.swift
//  On The Map
//
//  Created by Jimmy Gutierrez on 3/13/21.
//

import UIKit

class ListTableViewController: UITableViewController {
    @IBOutlet var studentListTableView: UITableView!
    var students = StudentModel.students
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentsList()
        print(students)
        print("HERE ARE THE STUDENTS")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    // MARK: - Student list
    func getStudentsList() {
        //activityIndicatorWillShow()
        UdacityClient.getStudentLocation() {students, error in
            self.students = students
            DispatchQueue.main.async {
                self.tableView.reloadData()
                //self.activityIndicatorWillHide()
            }
        }
    }
    // MARK: - Activity Indicator
//    func activityIndicatorWillShow() {
//        activityIndicator.startAnimating()
//        activityIndicator.isHidden = false
//    }
//    func activityIndicatorWillHide() {
//        activityIndicator.stopAnimating()
//        activityIndicator.isHidden = true
//    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentListTableViewCell", for: indexPath)
        let student = students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL )"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        openLink(student.mediaURL )
    }
    
    func openLink(_ url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
//            showAlert(message: "Cannot open link.", title: "Invalid Link")
            return
        }
        UIApplication.shared.open(url, options: [:])
    }

}
