//
//  MainTabView.swift
//  lightek-diy
//
//  Created by Marlon on 4/14/25.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            WhatsAppCloneView()
                .tabItem {
                    Label("Chat", systemImage: "message")
                }

            InstagramCloneView()
                .tabItem {
                    Label("Feed", systemImage: "photo.on.rectangle")
                }

            TikTokCloneView()
                .tabItem {
                    Label("Reels", systemImage: "play.rectangle.fill")
                }

            BumbleCloneView()
                .tabItem {
                    Label("Match", systemImage: "heart.circle")
                }
        }
    }
}

