//
//  Daily.swift
//  ABoHa
//
//  Created by koifish on 11/28/24.
//

import Foundation

struct Daily: Codable, Identifiable {
    let id : Int
    let nickName: String
    let contents : String?
    let date : String
    let weekday: String
    let sentiment : String
    let photo : String?
//    let createdAt : Date


    // 날짜 포맷터 정의
    var formattedDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full  // 전체 날짜 형식으로 포맷
        return formatter
    }
}

struct DailyResult : Codable {
    let data : [Daily]
    let message : String
}

struct STTResponse: Decodable {
    let DisplayText: String?
}


struct ChatGPTResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}


