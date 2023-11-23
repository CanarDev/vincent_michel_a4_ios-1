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

    var body: some View {
        VStack {
            Image(uiImage: musicManager.loadImage(from: track.artwork)!)
                .resizable()
                .frame(width: 300, height: 300)
                .cornerRadius(12)
                .shadow(radius: 10)
                .aspectRatio(contentMode: .fit)

            Text(track.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text(track.artist)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Tableau : ")
            ForEach(track.links.indices) { index in
                Text("Ligne \(index)")
                Text(track.links[index].keys.joined(separator: ", "))
                
            }
        }
        .navigationBarTitle(track.title)
        .onAppear {
            print(track.links.count)
        }
    }
}


struct TrackListView_Previews: PreviewProvider {
    static var previews: some View {
        TrackListView().environmentObject(MusicManager())
    }
}
