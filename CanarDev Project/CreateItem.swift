//
//  CreateItem.swift
//  CanarDev Project
//
//  Created by Vincent Michel  on 20/11/2023.
//

import Foundation
import SwiftUI

struct MusicItem {
    var title: String
    var artist: String
    var imageName: String
}

struct CreateItem: View {
    @State private var title = ""
    @State private var artist = ""
    @State private var imageName = ""

    @State private var isPlaying = false

    var body: some View {
        VStack {
            Image(systemName: isPlaying ? "music.note" : "music.note.slash")
                .resizable()
                .frame(width: 150, height: 150)
                .foregroundColor(isPlaying ? .green : .red)
                .padding()

            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Artist", text: $artist)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Image Name", text: $imageName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                let newMusicItem = MusicItem(title: self.title, artist: self.artist, imageName: self.imageName)
                // Vous pouvez utiliser newMusicItem comme vous le souhaitez, par exemple l'ajouter à une liste de lecture simulée
                print("New music item created:", newMusicItem)
            }) {
                Text("Create Music Item")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }

            Spacer()
        }
        .padding()
        .navigationBarTitle("Create Music Item")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
