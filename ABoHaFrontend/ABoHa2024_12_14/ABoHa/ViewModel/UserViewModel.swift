

import SwiftUI
import Alamofire
import SVProgressHUD

class UserViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var isLoginError = false
    @Published var isJoinShowing = false
    @Published var isJoinSuccess = false
    @Published var message = ""
    
    // 로그인 시 발급받은 토큰
    @Published var authToken: String?
    @Published var nickName: String = ""  // 사용자 닉네임 추가
    @Published var profileImg: String = "" // 사용자 프로필 이미지 추가
    @Published var email:String = ""
    @Published var isCompletUpdate = false
    let endPoint = "http://localhost:3000"
//    let endPoint = "https://appbeaboha.azurewebsites.net"
    
    init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        self.authToken = UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    func login(nickName: String, password: String) {
        SVProgressHUD.show()
        let url = "\(endPoint)/members/sign-in"
        let params: Parameters = ["nickName": nickName, "password": password]
        AF.request(url, method: .post, parameters: params)
            .response { response in
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200..<300:
                        if let data = response.data {
                            do {
                                print(String(data: data, encoding: .utf8) ?? "Invalid data")
                                let signIn = try JSONDecoder().decode(SignIn.self, from: data)
                                self.isLoggedIn = true
                                self.authToken = signIn.token // 저장
                                
                                // UserDefaults에 저장
                                UserDefaults.standard.set(signIn.token, forKey: "token")
                                UserDefaults.standard.set(signIn.member.nickName, forKey: "nickName")
                                UserDefaults.standard.set(self.isLoggedIn, forKey: "isLoggedIn")
                                
                            } catch let error {
                                self.isLoginError = true
                                self.message = error.localizedDescription
                                print(error)
                            }
                        }
                    case 300..<600:
                        self.isLoginError = true
                        if let data = response.data {
                            do {
                                let apiError = try JSONDecoder().decode(APIError.self, from: data)
                                self.message = apiError.message
                            } catch let error {
                                self.message = error.localizedDescription
                            }
                        }
                    default:
                        self.isLoginError = true
                        self.message = "알 수 없는 에러가 발생했습니다."
                    }
                }
            }
        SVProgressHUD.dismiss()
    }
    
    
    func join(nickName: String, password: String, rePassword: String, email: String, profileImg: String, image: UIImage?) {
        SVProgressHUD.show()
        let formData = MultipartFormData()
        if let imageData = image?.jpegData(compressionQuality: 0.2){
            formData.append(imageData, withName: "profileImg", fileName: "profileImg.jpg", mimeType: "image/jpeg")
        }
                formData.append(email.data(using: .utf8)!, withName: "email")
                formData.append(nickName.data(using: .utf8)!, withName: "nickName")
        formData.append(password.data(using: .utf8)!, withName: "password")
        formData.append(rePassword.data(using: .utf8)!, withName: "rePassword")
        
        let headers: HTTPHeaders = [
                  "Content-Type": "multipart/form-data"
              ]
        let url = "\(endPoint)/members/sign-up"
        SVProgressHUD.show(withStatus: "Uploading...")
//        let params: Parameters = [
//            "nickName": nickName,
//            "password": password,
//            "rePassword": rePassword,
//            "email": email,
//            "profileImg": profileImg
//        ]
        AF.upload(multipartFormData: formData, to: url, method: .post, headers: headers)
            .response { response in
                if let statusCode = response.response?.statusCode {
                    self.isJoinShowing = true //회원가입 성공시
                    switch statusCode {
                    case 200..<300:
                        if let data = response.data {
                            do {
                                let signUp = try JSONDecoder().decode(SignUp.self, from: data)
                                self.message = signUp.message
                                // 회원가입 성공 처리
                                self.isJoinSuccess = true // 회원가입 성공 시 true로 설정
                                
                            } catch let error {
                                self.message = error.localizedDescription
                                self.isJoinSuccess = false // 실패 시 false 유지
                            }
                        }
                    case 300..<600:
                        if let data = response.data {
                            do {
                                let apiError = try JSONDecoder().decode(APIError.self, from: data)
                                self.message = apiError.message
                                self.isJoinSuccess = false // 실패 시 false로 설정
                            } catch let error {
                                self.message = error.localizedDescription
                                self.isJoinSuccess = false // 실패 시 false로 설정
                            }
                        }
                    default:
                        self.message = "알 수 없는 에러가 발생했습니다."
                        self.isJoinSuccess = false // 실패 시 false로 설정
                    }
                }
            }
        SVProgressHUD.dismiss()
    }
    
    func userInfo(nickName: String) {
        SVProgressHUD.show()
        let url = "\(endPoint)/members/userInfo"
        let params: Parameters = [
            "nickName": nickName
        ]
        AF.request(url, method: .post, parameters: params)
            .response { response in
                if let statusCode = response.response?.statusCode {
                    //회원가입 성공시
                    switch statusCode {
                    case 200..<300:
                        if let data = response.data {
                            do {
                                let signUp = try JSONDecoder().decode(SignUp.self, from: data)
                                self.message = signUp.message
                                // 회원가입 성공 처리
                                self.nickName = signUp.member.nickName
                                if let profileImg = signUp.member.profileImg {
                                    self.profileImg = profileImg
                                }
                                if let email = signUp.member.email {
                                    self.email = email
                                }
                                                              
                            } catch let error {
                                self.message = error.localizedDescription
                                self.isJoinSuccess = false // 실패 시 false 유지
                            }
                        }
                    case 300..<600:
                        if let data = response.data {
                            do {
                                let apiError = try JSONDecoder().decode(APIError.self, from: data)
                                self.message = apiError.message
                                self.isJoinSuccess = false // 실패 시 false로 설정
                            } catch let error {
                                self.message = error.localizedDescription
                                self.isJoinSuccess = false // 실패 시 false로 설정
                            }
                        }
                    default:
                        self.message = "알 수 없는 에러가 발생했습니다."
                        self.isJoinSuccess = false // 실패 시 false로 설정
                    }
                }
            }
        SVProgressHUD.dismiss()
    }
    
    
    func changeInfo(image: UIImage?, email: String, nickName: String) {
        guard let imageData = image?.jpegData(compressionQuality: 0.2) else {
            print("Image data is missing.")
            return
        }
        guard let token = self.authToken else {
            print("Token is missing.")
            return
        }
        
        let nickName = UserDefaults.standard.string(forKey: "nickName") ?? ""
        let formData = MultipartFormData()
        formData.append(imageData, withName: "profileImg", fileName: "profileImg.jpg", mimeType: "image/jpeg")
        formData.append(email.data(using: .utf8)!, withName: "email")
        formData.append(nickName.data(using: .utf8)!, withName: "nickName")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "multipart/form-data"
        ]
        let url = "\(endPoint)/members/change-userInfo"
        
        SVProgressHUD.show(withStatus: "Uploading...")
        
        AF.upload(multipartFormData: formData, to: url, headers: headers).response { response in
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200..<300:
                    if let data = response.data {
                        do {
                            let result = try JSONDecoder().decode(UpadateResult.self, from: data)
                            self.message = result.message
                            self.isCompletUpdate = true
                            
                        } catch let error {
                            self.isCompletUpdate = false // 실패 시 false 유지
                            self.message = error.localizedDescription
                        }
                    }
                case 300..<600:
                    if let data = response.data {
                        do {
                            let apiError = try JSONDecoder().decode(APIError.self, from: data)
                            self.message = apiError.message
                            self.isCompletUpdate = false // 실패 시 false로 설정
                        } catch let error {
                            self.message = error.localizedDescription
                            self.isCompletUpdate = false // 실패 시 false로 설정
                        }
                    }
                default:
                    self.message = "알 수 없는 에러가 발생했습니다."
                }
            }
        }
        SVProgressHUD.dismiss()
    }
    
    func handleAPIError(data: Data?, defaultError: String) -> String {
        guard let data = data else {
            return defaultError
        }
        do {
            let apiError = try JSONDecoder().decode(APIError.self, from: data)
            return apiError.message
        } catch {
            return error.localizedDescription
        }
    }
    
//    func deleteUser(id:Int){
//        let url = "\(endPoint)/checkList/\(id)"
//        
//        AF.request(url, method: .delete).response{
//            response in
//            switch response.result {
//            case .success :
//                print("delete success")
//                self.ContentView()
//            case .failure(let error):
//                print("error",error)
//            }
//        }
//    }
}
