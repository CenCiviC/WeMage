//
//  Theme.swift
//  MCCamera
//
//  Created by kyungbin on 2023/06/04.
//

import Foundation
import SwiftUI

extension Color{
    static let mainColor = Color("mainColor")
    static let subColor = Color("subColor")
    static let subYellow = Color("subYellow")
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
  static let screenSize = UIScreen.main.bounds.size
}


struct EnableToggleStyle: ToggleStyle {
  private let width = 60.0
  
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.label
      ZStack(alignment: configuration.isOn ? .trailing : .leading) {
        RoundedRectangle(cornerRadius: 12)
          .frame(width: width, height: width / 2)
          .foregroundColor(configuration.isOn ? .green : .red)
        
        RoundedRectangle(cornerRadius: 12)
          .frame(width: (width / 2) - 4, height: width / 2 - 6)
          .padding(4)
          .foregroundColor(.white)
          .onTapGesture {
            withAnimation {
              configuration.$isOn.wrappedValue.toggle()
            }
          }
      }
    }
  }
}
