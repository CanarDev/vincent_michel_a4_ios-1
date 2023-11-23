//
//  TrackView.swift
//  CanarDev Project
//
//  Created by Vincent Michel  on 21/11/2023.
//

import Foundation
import SwiftUI

struct TrackListView: View {
    @EnvironmentObject var musicManager: MusicManager
    
    var body: some View {
        
        NavigationView {
            List(musicManager.tracks) { track in
                NavigationLink(destination: TrackDetailView(track: track, musicManager: musicManager)) {
                    TrackRowView(track: track, musicManager: musicManager)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button {
                        musicManager.removeTrack(withID: track.id)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
            }
            .navigationBarTitle("Enregistrés")
        }
    }
}

struct TrackRowView: View {
    let track: SaveTrack
    let musicManager: MusicManager

    var body: some View {
        HStack {
            // Afficher l'artwork de la chanson
            Image(uiImage: musicManager.loadImage(from: track.artwork)!)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .cornerRadius(5)
            
            // Afficher le titre et l'artiste de la chanson
            VStack(alignment: .leading) {
                Text(track.title)
                    .font(.headline)
                Text(track.artist)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct TrackDetailView: View {
    let track: SaveTrack
    let musicManager: MusicManager
    
    @State var trackLinks: [PlatformLink] = []
    let country = "FR"

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
               // Artwork, titre et artiste fixés en haut
               VStack(alignment: .center, spacing: 10) {
                   Image(uiImage: musicManager.loadImage(from: track.artwork)!)
                       .resizable()
                       .frame(width: 200, height: 200)
                       .cornerRadius(12)
                       .shadow(radius: 10)
                       .aspectRatio(contentMode: .fit)

                   Text(track.title)
                       .font(.title)
                       .fontWeight(.bold)

                   Text(track.artist)
                       .font(.subheadline)
                       .foregroundColor(.gray)
               }
               .padding()

               // ScrollView pour les boutons de lien de partage
               ScrollView {
                   VStack(spacing: 10) {
                       ForEach(trackLinks, id: \.platformUrl) { link in
                           Link(link.platform, destination: URL(string: link.platformUrl)!)
                               .frame(maxWidth: .infinity)
                               .frame(height: 40)
                               .foregroundColor(.white)
                               .background(Color.blue)
                               .cornerRadius(8)
                               .padding(.horizontal)
                       }
                   }
               }
           }
        .navigationBarTitle("Lien de partage")
        .onAppear {
            if track.links.count > 0 {
                trackLinks = track.links
            } else {
                musicManager.getTrackSpotifyLink(title: track.title, artist: track.artist) { spotifyURL in
                    if let url = spotifyURL {
                    
                        musicManager.getPostSongwhipData(track: track, spotifyLink: url, country: country) { result in
                            switch result {
                            case .success(let json):
                                // print("JSON response received:", json)
                                let linksInArray = musicManager.appendTrackLinksInArray(jsonResponse: json, country: country)
                                
                                trackLinks = linksInArray.map { linkDictionary in
                                    PlatformLink(platform: linkDictionary["platform"] ?? "Default", platformUrl: linkDictionary["link"] ?? "#")
                                }
                                
                                print(trackLinks.count)
                                print(trackLinks)
                                
                                if let index = musicManager.tracks.firstIndex(where: { $0.id == track.id  }) {
                                    // Update the item at the found index
                                    musicManager.tracks[index].links = trackLinks
                                }
                                
                            case .failure(let error):
                                print("Error:", error.localizedDescription)
                                // Handle the error here
                            }
                        }
                    
                    } else {
                        print("Impossible de récupérer l'URL Spotify de la chanson.")
                        return
                    }
                }
            }
        }
    }
}


struct TrackListView_Previews: PreviewProvider {
    static var previews: some View {
        TrackListView().environmentObject(MusicManager())
    }
}
