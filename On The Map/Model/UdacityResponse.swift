//
//  UdacityResponse.swift
//  On The Map
//
//  Created by Jimmy Gutierrez on 3/12/21.
//

import Foundation

// MARK: - UdacityResponse
struct UdacityResponse: Codable {
    let account: Account
    let session: Session
}

// MARK: - Account
struct Account: Codable {
    let registered: Bool
    let key: String
}

// MARK: - Session
struct Session: Codable {
    let id, expiration: String
}



