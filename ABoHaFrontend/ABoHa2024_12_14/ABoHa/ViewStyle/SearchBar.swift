//
//  SearchBar.swift
//  OpenApiWithSwift
//
//  Created by 이미진 on 11/8/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText:String
    @State var isEditing = false
    var handler:() -> Void
    
    var body: some View {
        HStack {
            TextField("검색어를 입력하시오", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(.rect(cornerRadius: 15))
                .padding(.horizontal, 10)
                .onSubmit {
                    handler()
                }
                .onTapGesture {
                    isEditing = true
                }.animation(.easeInOut, value: isEditing)
            if isEditing {
                Button {
                    isEditing = false
                } label: {
                    Text("Cancel")
                }
                .padding(.trailing, 15)
                .transition(.move(edge: .trailing))
            }
        }
    }
}

#Preview {
    SearchBar(searchText: .constant("한강")){
        
    }
}
