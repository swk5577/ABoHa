//
//  SignUpView.swift
//  ABoHa
//
//  Created by 이미진 on 11/27/24.
//
//
import SwiftUI

struct JoinView: View {
    @EnvironmentObject var userVM: UserViewModel
    @Environment(\.dismiss) var dismiss
    @State var nickName: String = ""
    @State var password: String = ""
    @State var rePassword: String = ""
    @State var email: String = ""
    @State var profileImg: String = ""
    @State var image: UIImage? // 선택된 이미지를 저장할 상태 변수
    @State var isPresented: Bool = false // 이미지 선택 시 화면을 띄울지 여부
    @State var isEditing = false
    @State var isJoinSuccess: Bool = false // 회원가입 성공 여부를 추적하는 상태 변수
    @State var navigateToTabBar: Bool = false // TabBarView로 이동을 위한 상태 변수
    var handler: () -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                    // 타이틀
                    Text("회원가입")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("*필수입력사항")
                        .font(.caption)
                        .frame(alignment: .trailing)
                        .multilineTextAlignment(.trailing)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // 사용자 입력 필드
                    VStack(alignment: .leading, spacing: 15) {
                        InputField(label: "아이디*", placeholder: "사용자 아이디를 입력하세요", text: $nickName)
                        SecureInputField(label: "비밀번호*", placeholder: "비밀번호를 입력하세요", text: $password)
                        SecureInputField(label: "비밀번호 확인*", placeholder: "비밀번호를 다시 입력하세요", text: $rePassword)
                        InputField(label: "이메일*", placeholder: "이메일을 입력하세요", text: $email, keyboardType: .emailAddress)
                    }
                    .padding(.horizontal)
                    
                    // 프로필 이미지 선택 버튼 및 썸네일 표시
                    VStack {
                        // 썸네일 이미지가 선택되었을 때 표시
                        if let selectedImage = image {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .padding(.bottom, 15)
                        } else {
                            // 기본 상태의 이미지 아이콘
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray)
                                .padding(.bottom, 15)
                        }
                        
                        WideImageButton(icon: "camera", title: "사진선택", backgroundColor: 2, textColor: .init(hex: "#9370DB")) {
                            isPresented.toggle() // 이미지 선택 화면을 표시
                        }
                        .sheet(isPresented: $isPresented) {
                            ImagePicker(image: $image) // 이미지 선택 후 결과를 JoinView에 반영
                        }
                    }
                    
                    
                    // 가입하기 버튼 클릭 시 회원가입 처리
                    WideImageButton(icon: "person.badge.plus", title: "가입하기", backgroundColor: 1) {
                        // 회원가입 처리
                        if password == rePassword {
                            userVM.join(nickName: nickName, password: password, rePassword: rePassword, email: email, profileImg: profileImg, image: image)
                            if userVM.isJoinSuccess {
                                isJoinSuccess = true
                                handler() // 가입 성공 시 처리 로직 실행
                            }
                        } else {
                            // 비밀번호가 일치하지 않으면 에러 처리
                            userVM.isJoinShowing = true
                            userVM.message = "비밀번호가 일치하지 않습니다."
                        }
                    }
                    .alert("회원가입", isPresented: $userVM.isJoinShowing) {
                        Button("확인") {
                            userVM.isJoinShowing = false
                            dismiss()
                        }
                    } message: {
                        Text(userVM.message)
                    }
                }
                
                
                //                    // 가입 성공 후 처리
                //                    if userVM.isJoinSuccess {
                //                                    Text("가입이 완료되었습니다!")
                //                                        .foregroundColor(.green)
                //                                        .font(.headline)
                //                                        .padding()
                //
                //                                    Button(action: {
                //                                        navigateToTabBar = true
                //                                    }) {
                //                                        Text("확인")
                //                                            .font(.title2)
                //                                            .foregroundColor(.white)
                //                                            .padding()
                //                                            .background(Color.blue)
                //                                            .cornerRadius(10)
                //                                    }
                //                                    .padding(.top, 20)
                //                                    .navigationDestination(isPresented: $navigateToTabBar) {
                //                                        TabBarView()
                //                                    }
                //                                }
                //                            }
                //                            .padding(.horizontal)
                //                            .background(Color(.systemGroupedBackground))
                //                            .ignoresSafeArea(.keyboard, edges: .bottom)
                //                        }
                //                    }
                //
            }
        }
    }
    struct InputField: View {
        var label: String
        var placeholder: String
        @Binding var text: String
        var keyboardType: UIKeyboardType = .default
        
        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text(label)
                    .font(.headline)
                TextField(placeholder, text: $text)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .keyboardType(keyboardType)
                    .autocapitalization(.none) // 첫 글자 대문자 방지
            }
        }
    }
    
    struct SecureInputField: View {
        var label: String
        var placeholder: String
        @Binding var text: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text(label)
                    .font(.headline)
                SecureField(placeholder, text: $text)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .autocapitalization(.none) // 첫 글자 대문자 방지
            }
        }
    }
}

#Preview {
    let userVM = UserViewModel()

    JoinView(nickName: "", password: "", rePassword: "", email: "", profileImg: "", isPresented: false, isEditing: false, handler: {
        // 예시로 아무 작업도 하지 않는 handler 작성
        print("Handler called")
    })
    .environmentObject(userVM)
}
