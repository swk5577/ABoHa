//
//  checkList.swift
//  ABoHa
//
//  Created by 박예린 on 11/19/24.
//

import Foundation
struct Member: Codable{
    let nickName : String
    let email : String?
    let profileImg: String?
}

struct SignUp: Codable{
    let success: Bool
    let member: Member
    let message: String
}

struct SignIn: Codable{
    let success: Bool
    let token: String
    let member : Member
    let message: String
    
}

// ------------- error ---------
struct APIError: Codable {
    let message: String
}

struct UpadateResult: Codable {
    let success: Bool
    let message: String
}
