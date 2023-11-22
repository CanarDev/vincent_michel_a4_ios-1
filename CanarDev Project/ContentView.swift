//
//  CreateItem.swift
//  CanarDev Project
//
//  Created by Vincent Michel  on 20/11/2023.
//

import Foundation
import SwiftUI
import MusicKit
import MediaPlayer

struct ContentView: View {
    @StateObject var musicManager = MusicManager()
    
    var body: some View {
        TabBar(musicManager: musicManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
