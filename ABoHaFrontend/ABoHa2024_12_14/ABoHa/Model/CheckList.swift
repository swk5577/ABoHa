//
//  CheckList.swift
//  ABoHa2024_12_5
//

//-------------체크리스트-----------
struct ResponseData: Codable {
    var success: Bool
    var message: String?
    var CheckList: [CheckList]
}

struct CheckList: Codable, Equatable, Identifiable{
    let id: Int
    let nickName : String
    var isOn : Bool
    var isComplete : Bool
    let startDay : String
//    let completeDay : String
    let alramDate : String?
    let alramTime : String
//    var cycle : String
    var contents : String
//    var createdAt: String
//    var updatedAt: String
//    var deletedAt: String
//    var complete : String
}

//struct TimePeriod : Codable{
//    var amPm : String
//    var hour : Int
//    var minute : Int
//    var date : String
//    var weak : WeekDay
//}

enum WeekDay : Int, Codable, CaseIterable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var name:String{
        switch self{
        case .sunday: return "일"
        case .monday: return "월"
        case .tuesday: return "화"
        case .wednesday: return "수"
        case .thursday: return "목"
        case .friday: return "금"
        case .saturday: return "토"
        }
    }
}
