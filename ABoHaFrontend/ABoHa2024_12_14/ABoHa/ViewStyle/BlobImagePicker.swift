import SwiftUI
import Alamofire

struct BlobImagePicker: View {
    @Binding var selectedImage: String
    @Environment(\.dismiss) var dismiss

    @State private var images: [String] = [] // Blob 이름 저장
    @State private var isLoading = true
    var authToken: String // 인증 토큰

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("이미지 로딩 중...")
                } else {
                    List(images, id: \.self) { imageName in
                        HStack {
                            // 이미지 미리보기
                            AsyncImage(url: URL(string: "https://staboha.blob.core.windows.net/aboha/\(imageName)")) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            } placeholder: {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                            Text(imageName)
                                .font(.body)
                        }
                        .onTapGesture {
                            selectedImage = imageName
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("이미지 선택")
            .navigationBarItems(leading: Button("취소") {
                dismiss()
            })
            .onAppear {
                fetchBlobImages()
            }
        }
    }

    func fetchBlobImages() {
        // Azure Blob Storage와 연동하여 이미지 파일 목록 가져오기
        guard let url = URL(string: "https://staboha.blob.core.windows.net/aboha?restype=container&comp=list&prefix=profileImg/") else {
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(authToken)" // 인증 토큰 설정
        ]
        
        AF.request(url, method: .get, headers: headers).response { response in
            // 디버깅: 요청 상태 확인
            print("Response: \(String(describing: response.response))")
            print("Response Data: \(String(describing: response.data))")
            
            if let error = response.error {
                print("Error fetching blob images: \(error.localizedDescription)")
                return
            }
            
            // 성공적인 응답
            if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                // 디버깅: 응답 문자열 출력
                print("XML Response: \(responseString)")
                
                let fileNames = parseBlobResponse(responseString)
                // 디버깅: 파일 이름 목록 확인
                print("File Names: \(fileNames)")
                
                DispatchQueue.main.async {
                    self.images = fileNames
                    self.isLoading = false
                }
            }
        }
    }

    func parseBlobResponse(_ response: String) -> [String] {
        // XML을 파싱하여 Blob 이름 목록 반환
        var fileNames: [String] = []
        let pattern = "<Name>(.*?)</Name>"
        
        // 디버깅: 정규식 적용 상태 확인
        print("Parsing response using regex pattern: \(pattern)")
        
        if let regex = try? NSRegularExpression(pattern: pattern) {
            let matches = regex.matches(in: response, range: NSRange(location: 0, length: response.count))
            
            // 디버깅: 정규식 매칭 정보 확인
            print("Found \(matches.count) matches")
            
            for match in matches {
                if let range = Range(match.range(at: 1), in: response) {
                    let imageName = String(response[range])
                    fileNames.append(imageName)
                    print("Matched file name: \(imageName)") // 디버깅: 매칭된 파일 이름
                }
            }
        } else {
            print("Regex matching failed.")
        }
        return fileNames
    }
}

