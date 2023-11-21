//
//  TabBarView.swift
//  CanarDev Project
//
//  Created by Vincent Michel  on 21/11/2023.
//

import Foundation
import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: Int

    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("First")
                }
                .tag(0)

            TrackView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Second")
                }
                .tag(1)
        }
    }
}
