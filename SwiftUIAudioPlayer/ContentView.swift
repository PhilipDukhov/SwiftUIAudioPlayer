//
//  ContentView.swift
//  SwiftUIAudioPlayer
//
//  Created by Varun Naharia on 14/10/20.
//  Copyright © 2020 Logictrix. All rights reserved.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State var volume:Double = 0.00
    @State var pitch:Double = 0.0
    @State var musicFiles:[SoundModel] = [SoundModel(file: "metro35", name: "Metronome", fileExtension: "wav"), SoundModel(file: "johnson_tone_down_5min", name: "Johnson", fileExtension: "wav"), SoundModel(file: "sine_140_6s_fade_ogg", name: "Sine mp3e", fileExtension: "mp3")]
    @State var selectedMusicFile:SoundModel = SoundModel(file: "sine_140_6s_fade_ogg", name: "Sine mp3e", fileExtension: "mp3")
    @State var showSoundPicker = false
    @State var selectedGraph = "skin_conductance"
    @State var iconSize:CGFloat = 0.124
    @State var iconSpace:CGFloat = 0.015
    @State var heart = false
    @State var  minimumValue:Float = -2400.0
    @State var maximumValue:Float = 2400.0
    var player:Player = Player()
    
    init() {
        player.setPitch(pitch: Float(self.pitch))
        player.setVolume(volume: Float(self.volume))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                VStack(alignment: .leading) {
                    Button(action: {
                        self.heart = !self.heart
                        self.selectedGraph = "heart"
                        if(self.heart)
                        {
                            self.player.playMusic(musicfile: self.selectedMusicFile.file, fileExtension: self.selectedMusicFile.fileExtension)
                        }
                        else
                        {
                            self.player.stopMusic()
                            self.selectedGraph = ""
                        }
                    })
                    {
                        
                        Image(self.selectedGraph == "heart" ? "heart" : "heart_disabled")
                            .resizable()
                            .frame(width: geometry.size.height*self.iconSize, height: geometry.size.height*self.iconSize)
                        
                    }
                    .frame(width: geometry.size.height*self.iconSize, height: geometry.size.height*self.iconSize)
                    .padding(.bottom, geometry.size.height*(self.iconSpace/2))
                    
                    Button(action: {
                        self.showSoundPicker = !self.showSoundPicker
                    })
                    {
                        
                        Image("tone")
                            .resizable()
                            .frame(width: geometry.size.height*self.iconSize, height: geometry.size.height*self.iconSize)
                        
                    }
                    .frame(width: geometry.size.height*self.iconSize, height: geometry.size.height*self.iconSize)
                    .padding(.bottom, geometry.size.height*(self.iconSpace/2))
                    
                    HStack{
                        SwiftUISlider(
                            thumbColor: .green,
                            thumbImage: "musicNote 2",
                            value: self.$volume.didSet(execute: { (value) in
                                self.player.setVolume(volume: Float(value))
                            })
                        ).padding(.horizontal)
                        Button(action: {
                            
                        })
                        {
                            
                            Image("centerGraph")
                                .resizable()
                                .frame(width: geometry.size.width*0.05, height: geometry.size.width*0.05)
                            
                            
                        }
                        .frame(width: geometry.size.width*0.03, height: geometry.size.width*0.03)
                        SwiftUISlider(
                            thumbColor: .green,
                            
                            thumbImage: "timerSlider 2",
                            minValue: self.minimumValue,
                            maxValue: self.maximumValue,
                            value: self.$pitch.didSet(execute: { (value) in
                                self.player.setPitch(pitch: Float(value))
                            })
                            
                        )
                            .padding(.horizontal)
                            .frame(width: (geometry.size.width/2)-geometry.size.width*0.05, height: geometry.size.width*0.05)
                    }
                    .background(Color(UIColor.lightGray))
                    .frame(width: geometry.size.width, height: geometry.size.height*0.10)
                    if(self.showSoundPicker)
                    {
                        ChooseSoundView(
                            musicFiles: self.musicFiles,
                            selectedMusicFile: self.$selectedMusicFile ,
                            showSoundPicker: self.$showSoundPicker,
                            isPlaying: self.selectedGraph != ""
                        )
                            .frame(width: geometry.size.width*0.6, height: geometry.size.height*0.7, alignment: .center)
                            .background(Color.white)
                    }
                        
                }
                .frame(maxWidth: geometry.size.width,
                       maxHeight: geometry.size.height)
                .background(Color(UIColor.lightGray))
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}



struct ChooseSoundView: View {
    @State var musicFiles:[SoundModel]
    @Binding var selectedMusicFile:SoundModel
    @Binding var showSoundPicker:Bool
    @State var isPlaying:Bool
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading)
            {
                List(self.musicFiles, id: \.name)
                { item in
                    Image(self.selectedMusicFile.file == item.file ? "radio-button_on" : "radio-button_off")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Button(action: {
                        print(item.name)
                        self.selectedMusicFile = item
                        self.showSoundPicker = false
                        if(self.isPlaying)
                        {
                            //                            Player.stopMusic()
                            //                            Player.playMusic(musicfile: self.selectedMusicFile.file, fileExtension: self.selectedMusicFile.fileExtension)
                        }
                    }){
                        Text(item.name)
                            .frame(width: geometry.size.width*90,
                                   height: 50.0,
                                   alignment: .leading)
                    }
                    .frame(width: geometry.size.width*90, height: 50.0)
                }
                HStack{
                    Button(action: {
                        self.showSoundPicker = false
                    }){
                        Text("Done")
                            .frame(width: geometry.size.width*0.45,
                                   height: 50.0,
                                   alignment: .center)
                    }
                    .frame(width: geometry.size.width*0.45, height: 50.0)
                    Button(action: {
                        self.showSoundPicker = false
                    }){
                        Text("Cancel")
                            .frame(width: geometry.size.width*0.45,
                                   height: 50.0,
                                   alignment: .center)
                    }
                    .frame(width: geometry.size.width*0.45, height: 50.0)
                }
                .background(Color.white)
            }
        }
    }
}


extension Binding {
    /// Execute block when value is changed.
    ///
    /// Example:
    ///
    ///     Slider(value: $amount.didSet { print($0) }, in: 0...10)
    func didSet(execute: @escaping (Value) ->Void) -> Binding {
        return Binding(
            get: {
                return self.wrappedValue
        },
            set: {
                self.wrappedValue = $0
                execute($0)
        }
        )
    }
}
