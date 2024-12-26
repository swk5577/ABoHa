import Foundation
import AVFoundation
import Alamofire
import SVProgressHUD

class STTViewModel:NSObject, ObservableObject {
    @Published var isProcessing = false
    @Published var isRecording = false
    @Published var chatGPTResponse: String?
    @Published var isPlaying = false
    
    @Published var transcribedText: String?  //STT결과
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    
    private let azureSTTEndpoint = "https://koreacentral.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=ko-KR"
//    private let azureOpenAIEndpoint = "your_endpoint?api-version=2024-08-01-preview"
    private let azureSpeechKey = "BfV1gbMCqUmTTPt6G0sUhOyplaDSDwsM8qnFUeOdTbO3aeAHSPwmJQQJ99ALACNns7RXJ3w3AAAYACOGobXS"
    
    
    private let audioFileName = "recording.wav"
    
    func toggleRecording() {
        print("toggleRecording()")
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        
        let audioFilename = FileManager.default.temporaryDirectory.appendingPathComponent(audioFileName)
     
        print(audioFilename)
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM), // WAV 포맷
            AVSampleRateKey: 16000,                   // 샘플 레이트: 16kHz
            AVNumberOfChannelsKey: 1,                 // 채널 수: 모노
            AVLinearPCMBitDepthKey: 16,               // 비트 깊이: 16비트
            AVLinearPCMIsBigEndianKey: false,         // 엔디안 설정: Little Endian
            AVLinearPCMIsFloatKey: false              // 정수 포맷
        ]
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
           
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            isRecording = true
            print("Recording started")
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    private func stopRecording() {
        SVProgressHUD.show()
        audioRecorder?.stop()
        isRecording = false
        isProcessing = true
        // Start the workflow
        transcribeAudio()  // STT 요청
        SVProgressHUD.dismiss()
    }
    
    private func transcribeAudio() {
        guard let audioURL = audioRecorder?.url else { return }

        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": azureSpeechKey,
            "Content-Type": "audio/wav"
        ]
        
        AF.upload(audioURL, to: azureSTTEndpoint, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: STTResponse.self) { response in
                print(response)
                switch response.result {
                    case .success(let sttResponse):
                        if let text = sttResponse.DisplayText {
                            print(text)
                            DispatchQueue.main.async {
                                self.transcribedText = text // STT 결과 업데이트
                            }
                        }
                    case .failure(let error):
                        print("STT Error: \(error.localizedDescription)")
                }
            }
    }
    
}

extension STTViewModel:AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.isProcessing = false
    }
}
