//
//  Player.swift
//  eVu Senz
//
//  Created by Varun Naharia on 25/09/20.
//  Copyright © 2020 Logictrix. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftUI

class Player {
    
    private var breathAudioPlayer:AVAudioPlayer?
    private var audioPlayerEngine = AVAudioEngine()
    private let speedControl = AVAudioUnitVarispeed()
    private var pitchControl = AVAudioUnitTimePitch()
    private var audioPlayerNode = AVAudioPlayerNode()
    var audioFormat: AVAudioFormat?
    var audioSampleRate: Float = 0
    var audioLengthSeconds: Float = 0
    var audioLengthSamples: AVAudioFramePosition = 0
    var needsFileScheduled = true
    var audioFile: AVAudioFile? {
        didSet {
            if let audioFile = audioFile {
                audioLengthSamples = audioFile.length
                audioFormat = audioFile.processingFormat
                audioSampleRate = Float(audioFormat?.sampleRate ?? 44100)
                audioLengthSeconds = Float(audioLengthSamples) / audioSampleRate
            }
        }
    }
    
    private var volume:Float = 0.4{
        didSet {
            audioPlayerNode.volume = volume
        }
    }
    
    private var pitch:Float = 1.0{
        didSet {
            pitchControl.pitch = pitch
            
        }
    }
    
    var audioFileURL: URL? {
        didSet {
            if let audioFileURL = audioFileURL {
                audioFile = try? AVAudioFile(forReading: audioFileURL)
            }
        }
    }
    
    
    private func playSounds(soundfile: String) {
    
    
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
    
    var musicfile = ""
    var fileExtension = ""
    func playMusic(musicfile: String, fileExtension:String) {
        self.musicfile = musicfile
        self.fileExtension = fileExtension
        setupAudio(musicfile: musicfile, fileExtension: fileExtension)
        self.play()
        /*if let path = Bundle.main.path(forResource: musicfile, ofType: fileExtension){
//            print("Pitch:\(self.pitch)\nVolume:\(self.volume)")
            do{
                // 1: load the file
                let audioPlayFile = try AVAudioFile(forReading: URL(fileURLWithPath: path))
//                let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioPlayFile.fileFormat, frameCapacity: AVAudioFrameCount(audioPlayFile.length))
//                try? audioPlayFile.read(into: audioFileBuffer!)
                
                // 2: create the audio player
                
                
                
                // you can replace mp3 with anything else you like, just make sure you load it from our project
                
                // making sure to clean up the audio hardware to avoid any damage and bugs
                
                audioPlayerNode.stop()
                
                audioPlayerEngine.stop()
                
                audioPlayerEngine.reset()
                audioPlayerNode.volume = self.volume
                audioPlayerEngine.attach(audioPlayerNode)
                                
                // assign the speed and pitch
                
                audioPlayerEngine.attach(pitchControl)
                pitchControl.pitch = self.pitch
                audioPlayerEngine.connect(audioPlayerNode, to: pitchControl, format: nil)
                
                audioPlayerEngine.connect(pitchControl, to: audioPlayerEngine.outputNode, format: nil)
                
                audioPlayerNode.scheduleFile(audioPlayFile, at: nil) {
                    print("PlayEnd")
                    DispatchQueue.main.async {
                        self.play(musicFile: musicfile, fileExtension: fileExtension)
                    }
                    
                }
                
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
                print("Error")
            }
        }
         */
        
    }
    
    func play() {
        if audioPlayerNode.isPlaying {
            
            audioPlayerNode.pause()
        } else {
            if needsFileScheduled {
                needsFileScheduled = false
                scheduleAudioFile()
            }
            audioPlayerNode.play()
        }
    }
    
    func setupAudio(musicfile: String, fileExtension:String) {
        audioFileURL  = Bundle.main.url(forResource: musicfile, withExtension: fileExtension)
        
        audioPlayerEngine.attach(audioPlayerNode)
        audioPlayerEngine.attach(pitchControl)
        audioPlayerEngine.connect(audioPlayerNode, to: pitchControl, format: audioFormat)
        audioPlayerEngine.connect(pitchControl, to: audioPlayerEngine.mainMixerNode, format: audioFormat)
        
        audioPlayerEngine.prepare()
        
        do {
            try audioPlayerEngine.start()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func scheduleAudioFile() {
        guard let audioFile = audioFile else { return }
        audioPlayerNode.scheduleFile(audioFile, at: nil) {
            print("PlayEnd")
            DispatchQueue.main.async {
//                self.play(musicFile: self.musicfile, fileExtension: self.fileExtension)
                self.scheduleAudioFile()
            }
            
        }
        
//        audioPlayerNode.scheduleFile(audioFile, at: nil) { [weak self] in
//            self?.needsFileScheduled = true
//        }
    }
    
    func breathIn() {
//            Player.playSounds(soundfile: "breathin")
    }
    
    func breathOut() {
//            Player.playSounds(soundfile: "breathout")
    }
    
    func play(musicFile:String, fileExtension:String)
    {
        
        self.playMusic(musicfile: musicFile,fileExtension: fileExtension)
        
    }
    
    func stopMusic() {
        audioPlayerNode.pause()
        audioPlayerNode.stop()
    }
    
    func setPitch(pitch:Float) {
        self.pitch = pitch
        pitchControl.pitch = pitch
         print("pitch:\(pitch)")
    }
    
    func setVolume(volume:Float) {
        self.volume = volume
        audioPlayerNode.volume = volume
        print("volume:\(volume)")
    }
}
