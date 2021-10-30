//
//  Track.swift
//  Ongaku
//
//  Created by Skip Rousseau on 10/29/21.
//  Copyright © 2021 Spotlight Deveaux. All rights reserved.
//

protocol Track {
    /// The title of the track.
    var title: String { get }

    /// The name of the album the track is contained within.
    var album: String? { get }

    /// The name of the artist of the track.
    var artist: String? { get }

    /// The duration of the track in milliseconds.
    var duration: Int { get }
}
