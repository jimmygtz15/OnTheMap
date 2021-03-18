//
//  StudentModel.swift
//  On The Map
//
//  Created by Jimmy Gutierrez on 3/13/21.
//

import Foundation
class StudentModel {
    
    static var students = [Student]()
    
    
    static func updateStudents(completion: @escaping (Bool) -> Void) {
        UdacityClient.getStudentLocation { (studentList, error) in
            if !studentList.isEmpty {
                students = studentList
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}


