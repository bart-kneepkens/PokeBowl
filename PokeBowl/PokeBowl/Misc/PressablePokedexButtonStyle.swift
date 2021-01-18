//
//  PressablePokedexButtonStyle.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 16/01/2021.
//

import SwiftUI

fileprivate let defaultCornerRadius: CGFloat = 10

struct PressablePokedexButtonStyle: ButtonStyle {
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: defaultCornerRadius)
            .strokeBorder(lineWidth: 2)
            .foregroundColor(.black)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: defaultCornerRadius).foregroundColor(Color.black).opacity(0.5)
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        let offset = configuration .isPressed ? -1 : -3
        
        return ZStack {
            background
            ZStack {
                RoundedRectangle(cornerRadius: defaultCornerRadius)
                    .foregroundColor(Color("PokedexBlue"))
                    .overlay(borderOverlay)
                
                configuration.label
                    .monospaced()
                
            }
            .offset(x: CGFloat(offset), y: CGFloat(offset))
        }
    }
    
}

struct PressablePokedexButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Press me") {
            
        }.buttonStyle(PressablePokedexButtonStyle())
        .frame(width: 200, height: 64, alignment: .center)
    }
}

