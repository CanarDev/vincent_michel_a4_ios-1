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
    
    // Tracks manager -> crud
    func saveTrack(currentTrack : Track) {
        guard let nowPlayingItem = musicPlayer.nowPlayingItem,
              let artworkImage = nowPlayingItem.artwork?.image(at: CGSize(width: 200, height: 200)) else {
            return
        }
        
        if let imageData = artworkImage.pngData() {
            UserDefaults.standard.set(imageData, forKey: "savedTrackArtworkImageData")
        }
        
        let artworkName: String = String(tracks.count + 1)
        
        var newTrack: SaveTrack = SaveTrack(title: currentTrack.title, artist: currentTrack.artist, artwork: saveArtwork(currentTrack.artwork, artworkName )!)
        
        
        print(newTrack.links.count)
        // Fetch all data after save and save it
        getTrackSpotifyLink(title: currentTrack.title, artist: currentTrack.artist) { spotifyURL in
            if let url = spotifyURL {
                let country = "FR"
            
                self.getPostSongwhipData(track: newTrack, spotifyLink: url, country: country) { result in
                    switch result {
                    case .success(let json):
                        // print("JSON response received:", json)
                        self.appendTrackLinks(jsonResponse: json, newTrack: &newTrack, country: country)
                        self.tracks.append(newTrack)
                        print(self.tracks.first?.links)
                        
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
    
    func removeTrack(withID id: UUID) {
        guard let index = tracks.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        let removedTrack = tracks.remove(at: index)
    
        removeArtwork(at: removedTrack.artwork)
    }
    
    
    
    // Track manager -> Links
    func getPostSongwhipData(track: SaveTrack, spotifyLink: String, country: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let params = [
            "url": spotifyLink,
            "country": country
        ]
        
        guard let url = URL(string: "https://songwhip.com/api/songwhip/create") else {
            print("URL creation failed")
            completion(.failure(NSError(domain: "URL creation failed", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("Error creating JSON data: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let responseData = data, error == nil else {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("No data received")
                    completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                    completion(.success(json))
                } else {
                    print("Invalid JSON format")
                    completion(.failure(NSError(domain: "Invalid JSON format", code: 0, userInfo: nil)))
                }
            } catch {
                print("Error converting data to JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func appendTrackLinks(jsonResponse: [String: Any], newTrack: inout SaveTrack, country: String) {
        func formatiTunesLink(for link: String, with countryCode: String) -> String {
            return link.replacingOccurrences(of: "{country}", with: countryCode)
        }

        func traverseLinks(dictionary: [String: Any], countryCode: String) {
            for (_, value) in dictionary {
                if let innerDict = value as? [String: Any] {
                    traverseLinks(dictionary: innerDict, countryCode: countryCode)
                } else if let linksArray = value as? [[String: Any]] {
                    for linkDict in linksArray {
                        if let link = linkDict["link"] as? String {
                            if let platform = linkDict.keys.first {
                                let platformName: String = self.identifyPlatform(from: link)
                                switch platformName {
                                    case "Apple Music":
                                        let formattedLink = formatiTunesLink(for: link, with: countryCode)
                                        newTrack.addLink(link: ["platform": platformName, "link": formattedLink])
                                    default:
                                        newTrack.addLink(link: ["platform": platformName, "link": link])
                                }
                            }
                        }
                    }
                }
            }
        }

        if let data = jsonResponse["data"] as? [String: Any],
           let item = data["item"] as? [String: Any],
           let links = item["links"] as? [String: Any] {
            traverseLinks(dictionary: links, countryCode: country)
        }
    }
    
    func identifyPlatform(from url: String) -> String {
        if url.contains("open.spotify.com") {
            return "Spotify"
        } else if url.contains("music.youtube.com") {
            return "YouTube Music"
        } else if url.contains("audiomack.com") {
            return "Audiomack"
        } else if url.contains("music.amazon") {
            return "Amazon Music"
        } else if url.contains("listen.tidal.com") {
            return "Tidal"
        } else if url.contains("soundcloud.com") {
            return "SoundCloud"
        } else if url.contains("music.apple.com") {
            return "Apple Music"
        } else if url.contains("youtube.com") {
            return "YouTube"
        } else if url.contains("napster.com") {
            return "Napster"
        } else if url.contains("deezer.com") {
            return "Deezer"
        } else if url.contains("pandora.com") {
            return "Pandora"
        } else if url.contains("open.qobuz.com") {
            return "Qobuz"
        } else if url.contains("music.line.me") {
            return "Line"
        } else if url.contains("amazon.fr") {
            return "Amazon"
        } else {
            return "Unknown Platform"
        }
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
    
    func formatItunesLink(for link: String, with countryCode: String) -> String {
        return link.replacingOccurrences(of: "{country}", with: countryCode)
    }
    
    // Track manager -> Artwork
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
    
    func removeArtwork(at fileURL: URL) {
        do {
            let filePath = fileURL.path // Get the file path from the URL
            
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("Artwork file does not exist at path: \(filePath)")
            }
        } catch {
            print("Error removing artwork file at path \(fileURL): \(error.localizedDescription)")
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
