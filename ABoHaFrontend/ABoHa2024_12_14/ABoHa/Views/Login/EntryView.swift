//
//  EntryView.swift
//  Yangpa-Market-SU2
//
//  Created by 이미진 on 11/15/24.

//
import SwiftUI

struct EntryView: View {
    @EnvironmentObject var userVM:UserViewModel

    var body: some View {
        VStack{
            if userVM.isLoggedIn{
                TabBarView()
            } else{
                LoginView().transition(.move(edge: .bottom))
            }
        }.animation(.easeInOut, value: userVM.isLoggedIn)
    }
}
