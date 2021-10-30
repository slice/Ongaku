//
//  Player.swift
//  Ongaku
//
//  Created by Skip Rousseau on 10/29/21.
//  Copyright © 2021 Spotlight Deveaux. All rights reserved.
//

protocol Player {
    /// Returns the track currently being played.
    func nowPlaying() throws -> Track?

    /// Returns the position of the player in milliseconds.
    func position() throws -> Int

    /// Returns the state of the player.
    func state() throws -> PlayerState
}
