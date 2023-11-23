//
//  Track.swift
//  CanarDev Project
//
//  Created by Vincent Michel  on 21/11/2023.
//

import Foundation
import MediaPlayer

struct Track {
    let title: String
    let artist: String
    let artwork: UIImage
    // let url: URL
}

struct SaveTrack : Identifiable {
    let id: UUID = UUID()
    let title: String
    let artist: String
    let artwork: URL
    var links: [[String: Any]] = []
    
    mutating func addLink(link: [String: Any]) {
        links.append(link)
    }
}

