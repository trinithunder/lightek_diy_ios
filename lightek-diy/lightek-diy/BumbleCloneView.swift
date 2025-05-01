//
//  BumbleCloneView.swift
//  lightek-diy
//
//  Created by Marlon on 4/14/25.
//

import Foundation
import SwiftUI


struct BumbleCloneView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.orange)
                    .frame(width: 300, height: 400)
                    .overlay(
                        VStack {
                            Text("Name").font(.title)
                            Text("Age • Interests")
                        }
                        .foregroundColor(.white)
                    )
                Spacer()
                HStack(spacing: 40) {
                    Button(action: {}) {
                        Image(systemName: "xmark.circle.fill").font(.largeTitle)
                    }
                    Button(action: {}) {
                        Image(systemName: "heart.circle.fill").font(.largeTitle)
                    }
                }
            }
            .navigationTitle("Discover")
        }
    }
}

