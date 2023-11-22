//
//  MusicManager.swift
//  CanarDev Project
//
//  Created by Vincent Michel  on 21/11/2023.
//

import Foundation

import MediaPlayer

class MusicManager: ObservableObject {
    @Published var tracks: [SaveTrack] = []
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    // Tracks manager
    
    func saveTrack(currentTrack : Track) {
        guard let nowPlayingItem = musicPlayer.nowPlayingItem,
              let artworkImage = nowPlayingItem.artwork?.image(at: CGSize(width: 200, height: 200)) else {
            return
        }
        
        if let imageData = artworkImage.pngData() {
            UserDefaults.standard.set(imageData, forKey: "savedTrackArtworkImageData")
        }
        
        let artworkName: String = String(tracks.count + 1)
        
        getTrackSpotifyLink(title: currentTrack.title, artist: currentTrack.artist) { spotifyURL in
            if let url = spotifyURL {
                print("URL Spotify de la chanson : \(url)")
            
                // Chercher tous les autres liens
            
            } else {
                print("Impossible de récupérer l'URL Spotify de la chanson.")
                return
            }
        }
        
        let newTrack: SaveTrack = SaveTrack(title: currentTrack.title, artist: currentTrack.artist, artwork: saveArtwork(currentTrack.artwork, artworkName )!)
        
        tracks.append(newTrack)
    }
    
    func removeTrack(withID id: UUID) {
        tracks.removeAll { $0.id == id }
    }
    
    
    
    // Track manager
    func getAllPlatformLinks(track: SaveTrack) {
        
    }
    
    func getTrackSpotifyLink(title: String, artist: String, completion: @escaping (String?) -> Void) {
        let queryItems = [
            URLQueryItem(name: "q", value: title + " " + artist),
            URLQueryItem(name: "country", value: "FR"),
            URLQueryItem(name: "limit", value: "1")
        ]
        
        var urlComponents = URLComponents(string: "https://songwhip.com/api/songwhip/search")!
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            print("URL creation failed")
            completion(nil)
            return
        }

        let session = URLSession.shared

        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erreur lors de la recherche de donnée: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let responseData = data else {
                print("Aucune donnée reçue")
                completion(nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                   let data = json["data"] as? [String: Any],
                   let tracks = data["tracks"] as? [[String: Any]],
                   let firstTrack = tracks.first,
                   let sourceURL = firstTrack["sourceUrl"] as? String {
                        completion(sourceURL)
                        return
                }
            } catch {
                print("Error converting data to JSON: \(error.localizedDescription)")
            }
            
            completion(nil)
        }

        task.resume()
    }
    
    
    
    func convertArtworkToImage(artwork: MPMediaItemArtwork) -> UIImage? {
        return artwork.image(at: CGSize(width: 200, height: 200))
    }
    
    func saveArtwork(_ image: UIImage, _ name: String) -> URL? {
        guard let data = image.pngData() else {
            return nil
        }
        
        do {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(name + ".png")
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Erreur lors de l'enregistrement de l'image: : \(error.localizedDescription)")
            return nil
        }
    }
    
    func loadImage(from url: URL) -> UIImage? {
        do {
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image: \(error.localizedDescription)")
            return nil
        }
    }

}
