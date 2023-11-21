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
    @State private var currentTrack: Track?
    @State private var newTrack: Track?
    
    @State private var nowPlayingItem: MPMediaItem?
    
    var body: some View {
        VStack {
            if let music = currentTrack {
                Image(uiImage: music.artwork)
                    .resizable()
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
                    newTrack = currentTrack
                }, label: {
                    Text("Generate platform links")
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
            let _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                getCurrentTrack()
            }
        }
    }
        
    func getCurrentTrack() {
        let musicPlayer = MPMusicPlayerController.systemMusicPlayer
        guard let fetchedTitle : String = musicPlayer.nowPlayingItem?.title else {
            print("Titre")
            return
        }
        guard let fetchedArtist : String = musicPlayer.nowPlayingItem?.artist else {
            print("Artiste")
            return
        }
        guard let fetchedArtwork =  convertArtworkToImage(artwork: (musicPlayer.nowPlayingItem?.artwork)!) else {
            print("Artwork")
            return
        }
        
        
        currentTrack = Track(title: fetchedTitle, artist: fetchedArtist, artwork: fetchedArtwork)
        
    }
    
    func convertArtworkToImage(artwork: MPMediaItemArtwork) -> UIImage? {
        return artwork.image(at: CGSize(width: 200, height: 200))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
