//
//  ScriptingBridgeInterface.swift
//  Ongaku
//
//  Created by Skip Rousseau on 10/29/21.
//  Copyright © 2021 Spotlight Deveaux. All rights reserved.
//

import Foundation

// Adapted from: https://gist.github.com/pvieito/3aee709b97602bfc44961df575e2b696
@objc enum iTunesEPlS: NSInteger {
    case iTunesEPlSStopped = 0x6B50_5353
    case iTunesEPlSPlaying = 0x6B50_5350
    case iTunesEPlSPaused = 0x6B50_5370
    // (others omitted...)
}

@objc protocol iTunesTrack {
    @objc optional var album: NSString { get }
    @objc optional var artist: NSString { get }
    @objc optional var duration: CDouble { get }
    @objc optional var name: NSString { get }
}

@objc protocol iTunesApplication {
    @objc optional var currentTrack: iTunesTrack { get }
    @objc optional var playerPosition: CDouble { get }
    @objc optional var playerState: iTunesEPlS { get }
}
