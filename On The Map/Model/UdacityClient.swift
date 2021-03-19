//
//  UdacityClient.swift
//  On The Map
//
//  Created by Jimmy Gutierrez on 3/12/21.
//

import Foundation


class UdacityClient {
    // MARK: - Auth
    struct Auth {
        static var sessionId: String? = nil
        static var key = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
    }
    // MARK: - EndPoints
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        case login
        case location
        case addLocation
        case updateLocation
        case getLoggedInUserProfile
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base + "/session"
            case .location:
                return Endpoints.base + "/StudentLocation"
            case .addLocation:
                return Endpoints.base + "/StudentLocation"
            case .updateLocation:
                return Endpoints.base + "/StudentLocation/" + Auth.objectId
            case .getLoggedInUserProfile:
                return Endpoints.base + "/users/" + Auth.key
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if apiType == "Udacity" {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            //request.addValue(Constants.ApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
            //request.addValue(Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error  in
            if error != nil {
                completion(nil, error)
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                if apiType == "Udacity" {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } else {
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    
    // MARK: - Post Request
    class func taskForPOSTRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, body: String, httpMethod: String, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        if httpMethod == "POST" {
            request.httpMethod = "POST"
        } else {
            request.httpMethod = "PUT"
        }
        if apiType == "Udacity" {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        request.httpBody = body.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                if apiType == "Udacity" {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } else {
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    // MARK: - Login
    class func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        taskForPOSTRequest(url: Endpoints.login.url, apiType: "Udacity", responseType: UdacityResponse.self, body: body, httpMethod: "POST") { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.key = response.account.key
                getLoggedInUserProfile(completion: { (success, error) in
                    if success {
                        print("Logged in user's profile.")
                    }
                })
                print(response)
                completion(true, nil)
                print("RESPONSE")
            } else {
                completion(false, nil)
                print("NO RESPONSE")
            }
        }
    }
    
    
    // MARK: Get Logged In User's Name
    
    class func getLoggedInUserProfile(completion: @escaping (Bool, Error?) -> Void) {
        UdacityClient.taskForGETRequest(url: Endpoints.getLoggedInUserProfile.url, apiType: "Udacity"
                                        , responseType: UserProfile.self) { (profile, error) in
            if let profile = profile {
                Auth.firstName = profile.firstName
                Auth.lastName = profile.lastName
                completion(true, nil)
            } else {
                print("Failed to get user's profile.")
              completion(false, error)

            }
        }
    
    }
    
    
    
    class func getStudentLocation(completion: @escaping ([Student], Error?) -> Void) {
        
        taskForGETRequest(url: Endpoints.location.url, apiType: "Parse", responseType: StudentLocation.self) { response, error in
            if let response = response {
                completion(response.results, nil)
//                print(response.results)
            } else {
                completion([], error)
            }
        }
        
    }
    
    
    class func addStudentLocation(information: Student, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"uniqueKey\": \"\(information.uniqueKey ?? "")\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString ?? "")\", \"mediaURL\": \"\(information.mediaURL ?? "")\",\"latitude\": \(information.latitude ?? 0.0), \"longitude\": \(information.longitude ?? 0.0)}"
        UdacityClient.taskForPOSTRequest(url: Endpoints.addLocation.url, apiType: "Parse", responseType: PostLocationResponse.self, body: body, httpMethod: "POST") { (response, error) in
            if let response = response, response.createdAt != nil {
                Auth.objectId = response.objectId ?? ""
                completion(true, nil)
            }
            completion(false, error)
        }
    }
    
    class func updateStudentLocation(information: Student, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"uniqueKey\": \"\(information.uniqueKey ?? "")\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString ?? "")\", \"mediaURL\": \"\(information.mediaURL ?? "")\",\"latitude\": \(information.latitude ?? 0.0), \"longitude\": \(information.longitude ?? 0.0)}"
        UdacityClient.taskForPOSTRequest(url: Endpoints.updateLocation.url, apiType: "Parse", responseType: UpdateLocationResponse.self, body: body, httpMethod: "PUT") { (response, error) in
            if let response = response, response.updatedAt != nil {
                completion(true, nil)
            }
            completion(false, error)
        }
    }
    
    
    
    
}
