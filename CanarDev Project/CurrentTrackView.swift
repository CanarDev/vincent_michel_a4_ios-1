//
//  CurrentTrackView.swift
//  CanarDev Project
//
//  Created by Vincent Michel  on 21/11/2023.
//

import Foundation
import Foundation
import SwiftUI
import MusicKit
import MediaPlayer

struct CurrentTrackView: View {
    @EnvironmentObject var musicManager: MusicManager
    
    // Current item
    @State private var currentTrack: Track?
    
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
                    musicManager.saveTrack(currentTrack: currentTrack!)
                }, label: {
                    Text("Enregistrer")
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
        
        guard let fetchedTitle : String = musicManager.musicPlayer.nowPlayingItem?.title else {
            print("Titre")
            return
        }
        guard let fetchedArtist : String = musicManager.musicPlayer.nowPlayingItem?.artist else {
            print("Artiste")
            return
        }
        
        guard let fetchedArtwork = musicManager.convertArtworkToImage(artwork: (musicManager.musicPlayer.nowPlayingItem?.artwork)!) else {
                print("Artwork")
                return
            }
        
        currentTrack = Track(
            title: fetchedTitle,
            artist: fetchedArtist,
            artwork: fetchedArtwork
        )
        
    }
}

struct CurrentTrackView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentTrackView().environmentObject(MusicManager())
    }
}
