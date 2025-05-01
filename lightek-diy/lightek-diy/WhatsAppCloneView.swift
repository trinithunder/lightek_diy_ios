//
//  WhatsAppCloneView.swift
//  lightek-diy
//
//  Created by Marlon on 4/14/25.
//

import Foundation
import SwiftUI

struct WhatsAppCloneView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<10) { i in
                    NavigationLink(destination: ChatDetailView(name: "User \(i)")) {
                        HStack {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 50, height: 50)
                            VStack(alignment: .leading) {
                                Text("User \(i)")
                                    .fontWeight(.bold)
                                Text("Last message...")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Chats")
        }
    }
}

struct ChatDetailView: View {
    let name: String
    var body: some View {
        VStack {
            Spacer()
            Text("Chat with \(name)")
            Spacer()
        }
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
