//
//  ViewController.swift
//  Ongaku
//
//  Created by Spotlight Deveaux on 1/20/18.
//  Copyright © 2018 Spotlight Deveaux. All rights reserved.
//

import Cocoa
import Foundation
import ScriptingBridge
import SwordRPC

class ViewController: NSViewController {
    // This is the Ongaku app ID.
    // You're welcome to change as you want.
    let rpc = SwordRPC(appId: "402370117901484042")

    var musicBundleIdentifier = "com.apple.Music"
    var assetName = "big_sur_logo"

    var player: Player!

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            player = try ScriptingBridgePlayer()
        } catch {
            fatalError("failed to initialize scripting bridge player: \(error)")
        }

        // Callback for when RPC connects.
        rpc.onConnect { _ in
            NSLog("connected to discord")

            DispatchQueue.main.async {
                // Bye window :)
                self.view.window?.close()
            }

            // Populate information initially.
            self.safelyUpdateRichPresence()
        }

        // Music sends out a NSNotification upon various state changes.
        // We should update the rich presence on these events.
        DistributedNotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: "\(musicBundleIdentifier).playerInfo"),
            object: nil,
            queue: nil
        ) { _ in
            NSLog("received playerInfo notification")
            self.safelyUpdateRichPresence()
        }

        rpc.connect()
    }

    func safelyUpdateRichPresence() {
        do {
            try updateRichPresence()
        } catch {
            NSLog("failed to update rich presence: \(error)")
        }
    }

    func updateRichPresence() throws {
        NSLog("updating rich presence...")

        var presence = RichPresence()

        // By default, show a lack of state.
        presence.details = "Stopped"
        presence.state = "Nothing is currently playing"
        presence.assets.largeImage = assetName
        presence.assets.largeText = "There's nothing here!"
        presence.assets.smallImage = "stop"
        presence.assets.smallText = "Currently stopped"

        let state = try player.state()
        guard let track = try player.nowPlaying(), state != .stopped else {
            rpc.setPresence(presence)
            return
        }

        // Always set image.
        presence.assets.largeImage = assetName

        let album = track.album ?? "Unknown Album"
        let artist = track.artist ?? "Unknown Artist"
        presence.state = "\(album) - \(artist)"
        presence.assets.largeText = track.title

        switch state {
        case .playing:
            presence.details = "\(track.title)"
            presence.assets.smallImage = "play"
            presence.assets.smallText = "Actively playing"

            // The following needs to be in milliseconds.
            let trackDuration = Double(track.duration)
            let trackPosition = Double(try player.position())
            let trackSecondsRemaining = trackDuration - trackPosition

            let currentTimestamp = Date()
            let startTimestamp = currentTimestamp - trackPosition
            let endTimestamp = currentTimestamp + trackSecondsRemaining

            // Go back (position amount)
            presence.timestamps.start = Date(timeIntervalSince1970: startTimestamp.timeIntervalSince1970 * 1000)

            // Add time remaining
            presence.timestamps.end = Date(timeIntervalSince1970: endTimestamp.timeIntervalSince1970 * 1000)
        case .paused:
            presence.details = "Paused - \(track.title)"
            presence.assets.smallImage = "pause"
            presence.assets.smallText = "Currently paused"
        case .stopped:
            // Unreachable.
            break
        }

        rpc.setPresence(presence)
    }
}
