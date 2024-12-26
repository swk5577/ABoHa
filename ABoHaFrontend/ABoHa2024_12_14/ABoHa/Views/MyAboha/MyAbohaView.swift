//
//  MyAbohaView.swift
//  ABoHa
//
//  Created by 이미진 on 11/20/24.
//

import SwiftUI

struct MyAbohaView: View {
    @EnvironmentObject var userVM: UserViewModel
    @State var profileImg: String = ""
    @State var nickName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var rePassword: String = ""
    @State private var showModal = false
    @State var selectedImage:UIImage? = nil
    @State var isPresented: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                Text("My 아보하")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                ZStack {
                    if let selectedImage{
                        Image(uiImage: selectedImage).resizable().aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipShape(.circle)
                    } else {
                        let strURL = "https://staboha.blob.core.windows.net/aboha/\(userVM.profileImg)"
                        
                        if let url = URL(string: strURL) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 200)
                                    .clipShape(.circle)
                            } placeholder: {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 200)
                                    .clipShape(.circle)
                                    .padding(.bottom, 33.0) // 이미지 아래 여백
                            }
                        }
                    }
                    
                    
                    
                    // Spacer를 사용해 버튼을 아래로 밀기
                    VStack {
                        Spacer() // Spacer가 버튼을 아래로 밀어줌
                        
                        Button(action: {
                            isPresented.toggle()
                        }) {
                            HStack {
                                Image(systemName: "pencil")
                                //                            Text("사진 변경").bold()
                            }
                        }
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.init(hex: "#CBB9E5"))
                        .cornerRadius(30)
                        .sheet(isPresented: $isPresented) {
                            ImagePicker(image: $selectedImage)
                        }
                        .padding(.bottom, 20) // 버튼 아래 여백을 추가
                    }
                    //                .padding(.bottom, 20) // 버튼과 이미지 사이의 추가 여백
                }
                .frame(width: 200, height: 200) // ZStack의 전체 크기 조정 (필요에 따라 조정)
                
                HStack {
                    Text("아이디")
                        .padding(.horizontal)
                    Spacer()
                }
                Text(userVM.nickName)
                    .background(Color(.systemGray6))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .cornerRadius(5.0)
                    .padding(.bottom, 33.0)
                    .padding(.horizontal)
                
                HStack {
                    Text("이메일")
                        .padding(.horizontal)
                    Spacer()
                }
                TextField("이메일 변경", text: $userVM.email).keyboardType(.emailAddress).autocapitalization(.none)
                    .background(Color(.systemGray6))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .cornerRadius(5.0)
                    .padding(.bottom, 33.0)
                    .padding(.horizontal)
                
                Button(action: {
                    userVM.changeInfo(image: selectedImage, email: userVM.email, nickName: userVM.nickName)
                    userVM.isCompletUpdate = true
                }) {
                    Text("변경사항 저장")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.init(hex: "#9370DB"))
                        .cornerRadius(10)
                }.padding()
                    .onAppear {
                        userVM.userInfo(nickName: UserDefaults.standard.string(forKey: "nickName")!)
                    }
            }
            .alert("변경사항 저장", isPresented: $userVM.isCompletUpdate) {
                    Button("확인") { userVM.isCompletUpdate = false }
                } message: {
                    Text(userVM.message)
                }
            //        Spacer()
            
            
            WideImageButton(title: "로그아웃", backgroundColor: 2) {
                userVM.isLoggedIn = false
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
            }
            //회원탈퇴하기
//            Button(action: {
//                self.showModal = true
//            }){
//                Text("회원 탈퇴").bold().foregroundColor(.init(hex: "#9370DB"))
//                Image(systemName: "arrow.right").foregroundColor(.init(hex: "#9370DB"))
//            }.buttonStyle(.automatic)
//                .sheet(isPresented: self.$showModal) {
//                    WithdrawView()
//                }
            
        }
        .padding(.horizontal)
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationTitle("마이 페이지")
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
            }
        }
    }
}
