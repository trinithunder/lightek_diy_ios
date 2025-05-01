//
//  InstagramCloneView.swift
//  lightek-diy
//
//  Created by Marlon on 4/14/25.
//

import Foundation
import SwiftUI

struct InstagramCloneView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(0..<10) { i in
                    VStack(alignment: .leading) {
                        HStack {
                            Circle().fill(Color.purple).frame(width: 40, height: 40)
                            Text("User \(i)").fontWeight(.bold)
                        }
                        Rectangle()
                            .fill(Color.gray)
                            .frame(height: 300)
                        Text("Caption for post \(i)")
                            .padding([.leading, .trailing])
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle("Feed")
        }
    }
}

