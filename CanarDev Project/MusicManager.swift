//
//  MusicManager.swift
//  CanarDev Project
//
//  Created by Vincent Michel  on 21/11/2023.
//

import Foundation

import MediaPlayer

class MusicManager {
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer
    

    func saveTrack(currentTrack : Track) {
        
        guard let nowPlayingItem = musicPlayer.nowPlayingItem,
            let artworkImage = nowPlayingItem.artwork?.image(at: CGSize(width: 100, height: 100)) else {
            return
        }
        
        if let imageData = artworkImage.pngData() {
            UserDefaults.standard.set(imageData, forKey: "savedTrackArtworkImageData")
        }
        
        UserDefaults.standard.set(currentTrack.title, forKey: "savedTrackTitle")
        UserDefaults.standard.set(currentTrack.artist, forKey: "savedTrackArtist")
        // UserDefaults.standard.set(currentTrack.artwork, forKey: "savedTrackArtist")
    }
    
    func retrieveSavedTrack() -> Track? {
        guard let savedTrackTitle = UserDefaults.standard.string(forKey: "savedTrackTitle"),
             let savedTrackArtist = UserDefaults.standard.string(forKey: "savedTrackArtist"),
             let savedTrackArtworkImageData = UserDefaults.standard.data(forKey: "savedTrackArtworkImageData"),
             let savedArtworkImage = UIImage(data: savedTrackArtworkImageData) else {
           return nil
        }

        return Track(title: savedTrackTitle, artist: savedTrackArtist, artwork: savedArtworkImage)
    }
    
    func convertArtworkToImage(artwork: MPMediaItemArtwork) -> UIImage? {
        return artwork.image(at: CGSize(width: 200, height: 200))
    }

}
