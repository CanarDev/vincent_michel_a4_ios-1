//
//  TrackView.swift
//  CanarDev Project
//
//  Created by Vincent Michel  on 21/11/2023.
//

import Foundation
import SwiftUI

struct TrackListView: View {
    let tracks: [Track] = MusicManager().retrieveSavedTrack()

    var body: some View {
        NavigationView {
            List(tracks) { track in
                NavigationLink(destination: TrackDetailView(track: track)) {
                    TrackRowView(track: track)
                }
            }
            .navigationBarTitle("Enregistrés")
        }
    }
}

struct TrackRowView: View {
    let track: Track

    var body: some View {
        HStack {
            // Afficher l'artwork de la chanson
            Image(systemName: "music.note")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
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
    let track: Track

    var body: some View {
        VStack {
            // Afficher l'artwork de la chanson
            Image(systemName: "music.note")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 300)

            Text(track.title)
                .font(.title)
                .padding()
            
            Text(track.artist)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding()
            
            // Autres détails de la chanson à afficher ici
        }
        .navigationBarTitle(track.title)
    }
}


struct TrackListView_Previews: PreviewProvider {
    static var previews: some View {
        TrackListView()
    }
}
