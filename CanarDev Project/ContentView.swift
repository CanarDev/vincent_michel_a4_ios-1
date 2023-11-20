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

// Modèle pour simuler une musique en cours de lecture
struct Music {
    let title: String
    let artist: String
    let image: String
}

struct ContentView: View {
    @State private var isPlayingMusic: Bool = false
    @State private var currentMusic: Music? = Music(title: "Titre de la musique", artist: "Artiste", image: "blank")
    @State private var newMusic: Music?
    
    var body: some View {
        VStack {
            if let music = currentMusic {
                AsyncImage(url: URL(string: music.image)) {
                   Image in Image.image?.resizable()
               }
               .frame(width: 300, height: 300)
               .cornerRadius(12)
               .shadow(radius: 10)
               .aspectRatio(contentMode: .fit)
            
                           
                Text(music.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(music.artist)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Button(action: {
                    newMusic = currentMusic
                }, label: {
                    Text("ShareLink")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                })
                .padding()
            } else {
                Text("Aucune musique en cours de lecture")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .onAppear {
            playMusic()
        }
        
        
    }
    
    func playMusic() {
        currentMusic = Music(title: "Chlorine", artist: "Twenty One Pilots", image: "https://m.media-amazon.com/images/I/81znz4j2UTL._UF894,1000_QL80_.jpg")
        
        print("hello")
        
        //if let nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo,
        //   let title = nowPlayingInfo[MPMediaItemPropertyTitle] as? String,
        //   let artist = nowPlayingInfo[MPMediaItemPropertyArtist] as? String,
        //}

        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
