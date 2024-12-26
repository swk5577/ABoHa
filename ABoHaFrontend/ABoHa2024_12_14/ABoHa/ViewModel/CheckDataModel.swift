//
//  LordJson.swift
//  ABoHa
//
//  Created by 박예린 on 11/19/24.
//

import SwiftUI
import Alamofire
import SVProgressHUD
import JHCalendar

class CheckDataModel:ObservableObject{
    @Published var checkList:[CheckList] = []
    @Published var filterData : [CheckList] = []
    @Published var message = ""
    //상태 전환
    @Published var isFetchError = false
    @Published var isAddError = false
    @Published var seletedDate = Date()
    
    @AppStorage("token") var token:String?
    @AppStorage("nickName") var nickName:String?
    var loadingManager = LoadingManager()
    
//    private let endPoint = "http://localhost:3000"
    private let endPoint = "https://appbeaboha.azurewebsites.net"
    
    
    func getCheckList() {
        guard !loadingManager.isLoading else {return}
        loadingManager.isLoading = true
        SVProgressHUD.show()
        guard let nickName = self.nickName, let token = self.token else {return}
        let headers:HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]
        let url = "\(endPoint)/checklist/\(nickName)"
        AF.request(url, method: .get, headers: headers)
            .response { response in
                if let statueseCode = response.response?.statusCode{
                    switch statueseCode{
                    case 200..<300:
                        if let data = response.data{
                            do{
                                let root = try JSONDecoder().decode(ResponseData.self, from: data)
                                print(root)
                                self.isFetchError = false
                                self.checkList = []
                                self.checkList.append(contentsOf: root.CheckList)
                                
                                if self.checkList.isEmpty{
                                    self.isFetchError = true
                                    self.message = "등록된 체크목록이 없습니다"
                                }
                                self.filterData(for: dateToStr(date: self.seletedDate))
                            }catch let err{
                                self.isFetchError = true
                                self.message = err.localizedDescription
                            }
                        }
                    case 300..<600:
                        self.isFetchError = true
                        if let data = response.data{
                            do{
                                let apiError = try JSONDecoder().decode(APIError.self, from: data)
                                self.message = apiError.message
                            }catch let err{
                                self.message = err.localizedDescription
                            }
                        }
                    default:
                        self.isFetchError = true
                        self.message = "알수없는 애러"
                    }
                }
                SVProgressHUD.dismiss()
            }
        self.loadingManager.isLoading = false
    }
    
    func filterData(for date: String){
        filterData = checkList.filter({ item in
            return item.alramDate == date
        })
        if filterData == []{
            self.isFetchError = true
            self.message = "등록된 체크목록이 없습니다"
        }
    }
    
    func addCheckList(isOn:Bool,startDay:String,alramDate:String,alramTime:String,contents:String){
        guard !loadingManager.isLoading else {return}
        loadingManager.isLoading = true
        guard let nickName = self.nickName else {return}

        let formData = MultipartFormData()
        formData.append(nickName.data(using: .utf8)!, withName: "nickName")
        formData.append((isOn ? "true" : "false").data(using: .utf8)!, withName: "isOn")
        formData.append(startDay.data(using: .utf8)!, withName: "startDay")
            formData.append(alramDate.data(using: .utf8)! , withName: "alramDate")
        formData.append(alramTime.data(using: .utf8)!,withName: "alramTime")
        formData.append(contents.data(using: .utf8)!, withName: "contents")
        
        print("data in-------",nickName,isOn,alramTime)

        let url = "\(endPoint)/checkList/add"
        AF.upload(multipartFormData: formData, to: url).response { response in
            if let statueseCode = response.response?.statusCode{
                self.isAddError = false
                switch statueseCode{
                case 200..<300:
                    if let data = response.data{
                        do{
                            let root = try JSONDecoder().decode(ResponseData.self, from: data)
                            self.isAddError = false
                            self.message = root.message!
                        }catch let err{
                            self.isAddError = true
                            self.message = err.localizedDescription
                        }
                    }
                case 300..<600:
                    if let data = response.data{
                        do{
                            let apiError = try JSONDecoder().decode(APIError.self, from: data)
                            self.isAddError = true
                            self.message = apiError.message
                        }catch let err{
                            self.isAddError = true
                            self.message = err.localizedDescription
                        }
                    }
                default:
                    self.isAddError = true
                    self.message = "알수없는 오류가 발생했습니다."
                }
            }
        }
        self.loadingManager.isLoading = false
    }
    
    // isOn isComplete 패치 문
    func patchCheckList(id:Int,isOn:Bool,isComplete:Bool){
        let url = "\(endPoint)/checkList/\(id)"
        
        let updateParameters : [String:Bool] = [
            "isOn" : isOn,
            "isComplete" : isComplete,
        ]
        
        print(id,isOn,isComplete)
        
        AF.request(url, method: .patch,parameters: updateParameters,encoding: JSONEncoding.default).response{
            response in
            switch response.result {
            case .success :
                print("update success")
            case .failure(let error):
                print("error",error)
            }
        }
    }
    
    func deleteCheckList(id:Int){
        let url = "\(endPoint)/checkList/\(id)"
        
        AF.request(url, method: .delete).response{
            response in
            switch response.result {
            case .success :
                print("delete success")
                self.getCheckList()
            case .failure(let error):
                print("error",error)
            }
        }
    }
}

