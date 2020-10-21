//
//  VLCPlayer.swift
//  SwiftUIAudioPlayer
//
//  Created by Varun Naharia on 20/10/20.
//  Copyright © 2020 Logictrix. All rights reserved.
//

import Foundation
import MobileVLCKit
import SwiftUI

class VLCPlayer
{
    var player:VLCMediaListPlayer = VLCMediaListPlayer()
    @State var volume:Float = 1.0
    @State var pitch:Float = 1.0
    
    func playMusic(musicfile: String, fileExtension:String) {
        if let path = Bundle.main.path(forResource: musicfile, ofType: fileExtension){
            print("Pitch:\(self.pitch)\nVolume:\(self.volume)")
            // 1: load the file
            let media = VLCMedia(path: path)
            let mediaList = VLCMediaList()
            mediaList.add(media)
            
            player.mediaList = mediaList
            player.mediaPlayer.audio.volume = Int32(self.volume)
            player.play()
            player.repeatMode = .repeatAllItems
        }
    }
    
    func stopMusic()
    {
        player.stop()
    }
    
    func setPitch(pitch:Float) {
        self.pitch = pitch
        print("pitch:\(pitch)")
    }
    
    func setVolume(volume:Float) {
        self.volume = volume
        print("volume:\(volume)")
        player.mediaPlayer.audio.volume = Int32(self.volume)
    }
}
