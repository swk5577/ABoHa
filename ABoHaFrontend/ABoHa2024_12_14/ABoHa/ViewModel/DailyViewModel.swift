import SwiftUI
import Alamofire
import Combine
import SVProgressHUD

class DailyViewModel: ObservableObject {
    @Published var dailys: [Daily] = []
    @Published var message = ""
    @Published var isFetchError = false
    @Published var isAddShowing = false
    @AppStorage("token") var token:String?
    @AppStorage("nickName") var nickName:String?
    @Published var sentiment: String = "neutral"  // 감정 상태를 추적
    @Published var emotionEmoji: String = "neutral"  // 기본 감정 이모티콘
    
    private var isLoading = false
    private var page = 1
        let endpoint = "https://appbeaboha.azurewebsites.net"
//    let endpoint = "http://localhost:3000"
    
    // 감정 분석 API 호출
    func analyzeSentiment(text: String, completion: @escaping (String) -> Void) {
        guard let token = self.token else {
            print("Token is missing.")
            return
        }
        let url = "\(endpoint)/analyze-sentiment"  // 감정 분석 API의 URL
        let parameters: [String: Any] = ["text": text]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        AF.request(url, method: .post, parameters: parameters, headers: headers)
            .responseDecodable(of: Daily.self) { response in
                switch response.result {
                case .success(let sentimentResponse):
                    // sentiment 값을 추출하고, 기본값을 설정
                    let sentiment = sentimentResponse.sentiment.isEmpty ? "neutral" : sentimentResponse.sentiment
                    completion(sentiment)
                    
                case .failure(let error):
                    print("Error: \(error)")
                    completion("neutral")  // 기본값
                }
            }
        //        AF.request(url, method: .post, parameters: parameters, headers: headers)
        //            .responseJSON { response in
        //                switch response.result {
        //                case .success(let value):
        //                    // 예시: { "sentiment": "positive" }
        //                    if let json = value as? [String: Any], let sentiment = json["sentiment"] as? String {
        //                        completion(sentiment)
        //                    } else {
        //                        completion("neutral")  // 기본값
        //                    }
        //                case .failure(let error):
        //                    print("Error: \(error)")
        //                    completion("neutral")  // 기본값
        //                }
        //            }
    }
    
    // 감정 상태에 맞는 이모티콘 업데이트
    func updateEmotionEmoji(from sentiment: String) {
        switch sentiment {
        case "positive":
            self.emotionEmoji = "positive"
        case "negative":
            self.emotionEmoji = "negative"
        default:
            self.emotionEmoji = "neutral"
        }
    }
    
    func fetchDaily() {
        guard let token = self.token, let nickName = self.nickName else { return }
        SVProgressHUD.show()
        let url = "\(endpoint)/dailys/user"
        let headers:HTTPHeaders = ["Authorization":"Bearer \(token)"]
        let params:Parameters = ["nickName":nickName]
        
        AF.request(url, method: .get, parameters: params, headers: headers)
            .response { response in
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200..<300:
                        if let data = response.data {
                            do {
                                let decoder = JSONDecoder()
                                let root = try decoder.decode(DailyResult.self, from: data)
//                                print(root)
                                self.dailys = root.data
                                if self.dailys.isEmpty {
                                    self.isFetchError = true
                                    self.message = "등록된 일기가 없습니다."
                                }
                                
                            } catch let error {
                                self.isFetchError = true
                                self.message = error.localizedDescription
                                print(error)
                            }
                        }
                        
                    case 300..<600:
                        self.isFetchError = true
                        self.message = self.handleAPIError(data: response.data, defaultError: "등록된 일기가 없습니다.")
                        
                    default:
                        self.isFetchError = true
                        self.message = "알 수 없는 에러가 발생했습니다."
                    }
                    
                    
                }
                self.isLoading=false
                SVProgressHUD.dismiss()
                
            }
    }
    
    func addDaily(image: UIImage?, contents: String?, date: String, weekday: String, sentiment: String) {
        let addImage = (image?.jpegData(compressionQuality: 0.2))
        
        // content나 image가 없으면 저장하지 않음
        guard let contents, !contents.isEmpty || addImage != nil else {
            self.isAddShowing = true
            self.message = "저장할 내용이 없습니다"
            return
        }
        
        guard let token = self.token else {
            print("Token is missing.")
            return
        }
        let formData = MultipartFormData()
        if let addImage = addImage {
            formData.append(addImage, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
        }
        formData.append(contents.data(using: .utf8)!, withName: "contents")
        formData.append(date.data(using: .utf8)!, withName: "date")
        formData.append(weekday.data(using: .utf8)!, withName: "weekday")
        formData.append(sentiment.data(using: .utf8)!, withName: "sentiment")
        formData.append((nickName ?? "Unknown").data(using: .utf8)!, withName: "nickName")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "multipart/form-data"
        ]
        let url = "\(endpoint)/dailys/create"
        SVProgressHUD.show(withStatus: "Uploading...")
        AF.upload(multipartFormData: formData, to: url, headers: headers).response { response in
            if let statusCode = response.response?.statusCode {

                switch statusCode {
                case 200..<300:
                    if let data = response.data {
                        do {
                            let root = try JSONDecoder().decode(DailyResult.self, from: data)
                            print("=======",root)
                            self.isAddShowing = true
                            self.message = root.message
                        } catch let error {
                            self.isAddShowing = true
                            self.message = error.localizedDescription
                        }
                    }
                case 300..<600:
                    self.isAddShowing = true
                    self.message = self.handleAPIError(data: response.data, defaultError: "서버 오류가 발생했습니다.")
                default:
                    self.isAddShowing = true
                    self.message = "알 수 없는 네트워크 오류입니다."
                }
            } else {
                self.isAddShowing = true
                self.message = "서버 응답이 없습니다."
            }
        }
        
        
    }
    
    private func handleAPIError(data: Data?, defaultError: String) -> String {
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
    
    
}
