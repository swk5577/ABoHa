
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userVM: UserViewModel
    @State private var isJoinActive = false
    @State var nickName: String = ""
    @State var password: String = ""
    @State private var isLoginSuccess = false // 로그인 성공 여부를 추적하는 상태 변수
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "E6E6FA"), Color(hex: "D8BFD8")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 25) {
                    Text("아주 보통의 하루")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.purple)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    Image("aboha")
    //                Image("expression")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.purple.opacity(0.8))
                        .padding(.bottom, 30)
                    
                    VStack(spacing: 15) {
                        // 사용자 아이디 입력창
                        CustomTextField(
                            icon: "person.fill",
                            placeholder: "사용자 ID를 입력",
                            text: $nickName
                        )
                        .padding()
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
                        
                        // 비밀번호 입력창
                        CustomTextField(
                            icon: "lock.fill",
                            placeholder: "비밀번호 입력",
                            text: $password,
                            isSecurde: true
                        )
                        .padding()
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
                    }
                    .padding(.horizontal, 20)
                    
                    // 로그인 버튼 클릭 시 로그인 처리
                    WideImageButton(
                        icon: "person.badge.key",
                        title: "로그인",
                        backgroundColor: 1
                    ) {
                        // 로그인 처리 후 성공 시 상태 업데이트
                        userVM.login(nickName: nickName, password: password)
                        if userVM.isLoggedIn {  // 로그인 성공했을 경우
                            isLoginSuccess = true
                        }
                    }
                    .alert("로그인 실패", isPresented: $userVM.isLoginError) {
                        Button("확인") {
                            userVM.isLoginError = false
                        }
                    } message: {
                        Text(userVM.message)
                    }
                    NavigationLink(destination: JoinView(handler: {
                        print("회원가입 완료 후 처리")
                    }), isActive: $isJoinActive) {
                        WideImageButton(icon: "person.badge.plus", title: "회원가입", backgroundColor: 2, textColor: .init(hex: "9370DB")) {
                            self.isJoinActive = true
                        }
                        .frame(height: 50)
                    }
                }
                .padding(.top, 50)
            }
        }

    }
}

#Preview {
    let userVM = UserViewModel()
    LoginView().environmentObject(userVM)
}
