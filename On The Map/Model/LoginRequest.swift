//
//  LoginRequest.swift
//  On The Map
//
//  Created by Jimmy Gutierrez on 3/12/21.
//

import Foundation
// MARK: - Login Request
struct LoginRequest: Codable {
    
    let udacity: [String:String]
    let username: String
    let password: String
}
