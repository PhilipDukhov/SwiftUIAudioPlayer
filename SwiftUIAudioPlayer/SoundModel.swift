//
//  SoundModel.swift
//  eVu Senz
//
//  Created by Varun Naharia on 13/10/20.
//  Copyright © 2020 Logictrix. All rights reserved.
//

import Foundation
import Combine

class SoundModel:ObservableObject, Identifiable
{
    @Published var file:String
    @Published var name:String
    @Published var fileExtension:String
    
    init(file:String, name:String, fileExtension:String) {
        self.file = file
        self.name = name
        self.fileExtension = fileExtension
    }
}
