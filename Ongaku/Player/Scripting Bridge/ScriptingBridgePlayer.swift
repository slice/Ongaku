//
//  ScriptingBridgePlayer.swift
//  Ongaku
//
//  Created by Skip Rousseau on 10/29/21.
//  Copyright © 2021 Spotlight Deveaux. All rights reserved.
//

import ScriptingBridge

enum ScriptingBridgeError: Error {
    case unableToInstantiate
    case unableToDeterminePlayerState
    case unableToDeterminePlayerPosition
}

struct iTunesPlayerTrack: Track {
    let title: String
    let album: String?
    let artist: String?
    let duration: Int

    init(iTunesTrack: iTunesTrack) {
        guard let title = iTunesTrack.name else {
            fatalError("scripting bridge: itunes track does not have an associated name")
        }

        self.title = title as String
        album = iTunesTrack.album as String?
        artist = iTunesTrack.artist as String?

        guard let duration = iTunesTrack.duration else {
            fatalError("scripting bridge: itunes track does not have a duration")
        }

        self.duration = Int(round(duration))
    }
}

class ScriptingBridgePlayer: Player {
    private var itunes: AnyObject

    init() throws {
        guard let app = SBApplication(bundleIdentifier: "com.apple.Music") else {
            throw ScriptingBridgeError.unableToInstantiate
        }

        itunes = app
    }

    func state() throws -> PlayerState {
        guard let playerState = itunes.playerState else {
            throw ScriptingBridgeError.unableToDeterminePlayerState
        }

        switch playerState {
        case .iTunesEPlSStopped:
            return .stopped
        case .iTunesEPlSPlaying:
            return .playing
        case .iTunesEPlSPaused:
            return .paused
        default:
            throw ScriptingBridgeError.unableToDeterminePlayerState
        }
    }

    func position() throws -> Int {
        guard let playerPosition = itunes.playerPosition else {
            throw ScriptingBridgeError.unableToDeterminePlayerPosition
        }

        return Int(playerPosition)
    }

    func nowPlaying() throws -> Track? {
        guard let currentTrack = itunes.currentTrack else {
            return nil
        }

        return iTunesPlayerTrack(iTunesTrack: currentTrack)
    }
}
