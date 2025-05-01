//
//  TikTokCloneView.swift
//  lightek-diy
//
//  Created by Marlon on 4/14/25.
//

import Foundation
import SwiftUI


struct TikTokCloneView: View {
    var body: some View {
        TabView {
            ForEach(0..<5) { i in
                ZStack {
                    Color.black
                    VStack {
                        Spacer()
                        Text("Video \(i)").foregroundColor(.white)
                        Spacer()
                        HStack {
                            Spacer()
                            VStack {
                                Image(systemName: "heart.fill").foregroundColor(.white)
                                Text("123").foregroundColor(.white)
                            }
                            .padding()
                        }
                    }
                }
                .ignoresSafeArea()
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

