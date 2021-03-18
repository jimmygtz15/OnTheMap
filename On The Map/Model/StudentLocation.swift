//
//  StudentLocation.swift
//  On The Map
//
//  Created by Jimmy Gutierrez on 3/12/21.
//

import Foundation

// MARK: - StudentLocation
struct StudentLocation: Codable {
    let results: [Student]
}

// MARK: - Result
struct Student: Codable {
    let createdAt, firstName, lastName: String
    let latitude, longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId, uniqueKey, updatedAt: String

//    enum CodingKeys: String, CodingKey {
//        case createdAt, firstName, lastName, latitude, longitude, mapString, mediaURL
//        case objectId = "objectId"
//        case uniqueKey, updatedAt
//    }
    init(_ dictionary: [String: Any]) {
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.mapString = dictionary["mapString"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
        self.objectId = dictionary["objectId"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String ?? ""
}

}

