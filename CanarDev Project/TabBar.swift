//
//  TabBar.swift
//  CanarDev Project
//
//  Created by Vincent Michel  on 21/11/2023.
//

import Foundation
import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
            CurrentTrackView()
                .badge(2)
                .tabItem {
                    Label("Received", systemImage: "tray.and.arrow.down.fill")
                }
            TrackListView()
                .badge("!")
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
        }
    }
}
