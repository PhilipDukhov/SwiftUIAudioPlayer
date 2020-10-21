//
//  Player.swift
//  eVu Senz
//
//  Created by Varun Naharia on 25/09/20.
//  Copyright © 2020 Logictrix. All rights reserved.
//

import Foundation
import AVFoundation

class Player {
    
    private static var breathAudioPlayer:AVAudioPlayer?
    private static var audioPlayerEngine = AVAudioEngine()
    private static let speedControl = AVAudioUnitVarispeed()
    private static var pitchControl = AVAudioUnitTimePitch()
    private static var audioPlayerNode = AVAudioPlayerNode()
    private static var mixerNode = AVAudioMixerNode()
    private static var volume:Float = 1.0
    private static func playSounds(soundfile: String) {
    
    
        if let path = Bundle.main.path(forResource: soundfile, ofType: "m4a"){
            
            do{
                
                breathAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                breathAudioPlayer?.volume = self.volume
                breathAudioPlayer?.prepareToPlay()
                breathAudioPlayer?.play()
                
            }catch {
                print("Error")
            }
        }
    }
    
    static func playMusic(musicfile: String, fileExtension:String) {
        if let path = Bundle.main.path(forResource: musicfile, ofType: fileExtension){
            
            do{
                // 1: load the file
                let audioPlayFile = try AVAudioFile(forReading: URL(fileURLWithPath: path))
                let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioPlayFile.fileFormat, frameCapacity: AVAudioFrameCount(audioPlayFile.length))
                try? audioPlayFile.read(into: audioFileBuffer!)

                // 2: create the audio player
                
                audioPlayerNode = AVAudioPlayerNode()
                
                audioPlayerEngine = AVAudioEngine()
                
                // you can replace mp3 with anything else you like, just make sure you load it from our project
                
                // making sure to clean up the audio hardware to avoid any damage and bugs
                
//                audioPlayerNode.stop()
                
                audioPlayerEngine.stop()
                
                audioPlayerEngine.reset()
                
                
                
                let nodes = [
                    audioPlayerNode,
                    pitchControl,
                    mixerNode,
                ]
                nodes.forEach { node in
                    audioPlayerEngine.attach(node)
                }
                zip(nodes, (nodes.dropFirst() + [audioPlayerEngine.outputNode]))
                    .forEach { firstNode, secondNode in
                        audioPlayerEngine.connect(firstNode, to: secondNode, format: nil)
                    }
                
                scheduleNext(audioPlayFile: audioPlayFile)
//                audioPlayerNode.scheduleFile(audioPlayFile, at: nil) {
//                    DispatchQueue.main.async {
//
//                    playMusic(musicfile: musicfile, fileExtension: fileExtension)
//                    }
//                }
                
                // try to start playing the audio
//                audioPlayerNode.scheduleBuffer(audioFileBuffer!, at: nil, options: .loops, completionHandler: nil)
                do {
                    try audioPlayerEngine.start()
                } catch {
                    print(error)
                }
                
                // play the audio
                
                
                
                audioPlayerNode.play()
            }catch {
                print("Error \(error)")
            }
        }
    }
    
static func scheduleNext(audioPlayFile: AVAudioFile) {
    audioPlayerNode.scheduleFile(audioPlayFile, at: nil) {
        DispatchQueue.main.async {
            scheduleNext(audioPlayFile: audioPlayFile)
        }
    }
}
    static func breathIn() {
//            Player.playSounds(soundfile: "breathin")
    }
    
    static func breathOut() {
//            Player.playSounds(soundfile: "breathout")
    }
    
    static func play(musicFile:String, fileExtension:String)
    {
        
        Player.playMusic(musicfile: musicFile,fileExtension: fileExtension)
        
    }
    
    static func stopMusic() {
        audioPlayerNode.pause()
        audioPlayerNode.stop()
    }
    
    static func setPitch(pitch:Float) {
        pitchControl.pitch = pitch
    }
    
    static func setVolume(volume:Float) {
        mixerNode.outputVolume = volume
    }
}
