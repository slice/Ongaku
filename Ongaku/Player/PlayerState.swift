//
//  PlayerState.swift
//  Ongaku
//
//  Created by Skip Rousseau on 10/29/21.
//  Copyright © 2021 Spotlight Deveaux. All rights reserved.
//

enum PlayerState {
    /// Indicates that the player was playing a track, but has been paused by
    /// the user.
    case paused

    /// Indicates that the player is actively playing a track.
    case playing

    /// Indicates that the player is not playing anything.
    case stopped
}
