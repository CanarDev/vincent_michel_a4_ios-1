//
//  TabBar.swift
//  CanarDev Project
//
//  Created by Vincent Michel  on 21/11/2023.
//

import Foundation
import SwiftUI

struct TabBar: View {
    let musicManager: MusicManager
    
    var body: some View {
        TabView {
            CurrentTrackView().environmentObject(musicManager)
                .tabItem {
                    Label("En cours", systemImage: "music.note")
                }
            TrackListView().environmentObject(musicManager)
                .tabItem {
                    Label("Enregistrés", systemImage: "music.note.list")
                }
        }
    }
}
