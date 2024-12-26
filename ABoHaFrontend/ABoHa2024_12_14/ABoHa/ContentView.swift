//
//  ContentView.swift
//  ABoHa2024_12_5
//
//  Created by 박예린 on 12/5/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var loadingManager : LoadingManager
    var body: some View {
        VStack{
            ZStack{
                EntryView()
                if loadingManager.isLoading {LodingPag()}
            }.onAppear{
                loadingManager.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now()+2){
                    loadingManager.isLoading = false
                }
            }
        }
    }
}
#Preview {
    let userVM = UserViewModel()
    ContentView().environmentObject(userVM)
}
