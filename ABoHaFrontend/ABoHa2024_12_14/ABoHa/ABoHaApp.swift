//
//  ABoHaApp.swift
//  ABoHa
//
//  Created by 박예린 on 11/19/24.
//

import SwiftUI
import JHCalendar

@main
struct ABoHaApp: App {
    @StateObject private var manager = CalendarManager()
    @UIApplicationDelegateAdaptor(AppDelegat.self) var appDelegate
    @StateObject private var checkDataLoader = CheckDataModel()
    @StateObject private var loadingManager = LoadingManager()
    var forecastViewModel = ForecastViewModel()
    var userVM = UserViewModel()
    var dailyVM = DailyViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(checkDataLoader)
                .environmentObject(manager)
                .environmentObject(forecastViewModel)
                .environmentObject(userVM)
                .environmentObject(dailyVM)
                .environmentObject(loadingManager)
        }
    }
}

class AppDelegat : NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        requestnoticationPermission()
        return true
    }
    func requestnoticationPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) { granted, err in
            if granted {
                print("알림권한이 허용되었습니다")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }else{
                print("알림권한이 거부되었습니다")
            }
        }
    }
    // 실행중에 알람 작동
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let info = notification.request.content.userInfo
        print(info["name"] ?? "?")
        completionHandler([.banner, .sound])
    }
    
    // 알람을 누르면 작동하는 부분
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let info = response.notification.request.content.userInfo
        print(info["name"] ?? "?")
        completionHandler()
    }
    
    //디바이스 토큰 가져오기
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token:String = ""
        for i in 0..<deviceToken.count{
            token += String(format: "%02,2hhx", deviceToken[i] as CVarArg)
        }
        print("APNS token : \(token)")
        UserDefaults.standard.set(token, forKey: "token")
    }
}
