//
//  SwiftUISlider.swift
//  eVu Senz
//
//  Created by Varun Naharia on 09/09/20.
//  Copyright © 2020 Logictrix. All rights reserved.
//

import Foundation
import SwiftUI

struct SwiftUISlider: UIViewRepresentable {
    var onChangeNotification:String = ""
    
    final class Coordinator: NSObject {
        // The class property value is a binding: It’s a reference to the SwiftUISlider
        // value, which receives a reference to a @State variable value in ContentView.
        var value: Binding<Double>
        
        // Create the binding when you initialize the Coordinator
        init(value: Binding<Double>) {
            self.value = value
        }
        
        // Create a valueChanged(_:) action
        @objc func valueChanged(_ sender: UISlider) {
            self.value.wrappedValue = Double(sender.value)
            
        }
    }
    
    var thumbColor: UIColor = .white
    var minTrackColor: UIColor?
    var maxTrackColor: UIColor?
    var thumbImage:String?
    var minValue:Float?
    var maxValue:Float?
    
    @Binding var value: Double
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.thumbTintColor = thumbColor
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor
        slider.value = Float(value)
        if(self.minValue != nil)
        {
            slider.minimumValue = self.minValue!
        }
        if(self.maxValue != nil)
        {
            slider.maximumValue = self.maxValue!
        }
        slider.setThumbImage(UIImage(named: self.thumbImage ?? ""), for: .normal)
        slider.setThumbImage(UIImage(named: self.thumbImage ?? ""), for: .focused)
        slider.setThumbImage(UIImage(named: self.thumbImage ?? ""), for: .highlighted)
        
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        
        return slider
    }
    
    func onValueChange(_ sender: UISlider) {
        
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        // Coordinating data between UIView and SwiftUI view
        uiView.value = Float(self.value)
    }
    
    func makeCoordinator() -> SwiftUISlider.Coordinator {
        Coordinator(value: $value)
    }
}

#if DEBUG
struct SwiftUISlider_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISlider(
            thumbColor: .white,
            minTrackColor: .blue,
            maxTrackColor: .green,
            value: .constant(0.5)
        )
    }
}
#endif
