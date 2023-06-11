//
//  Image.swift
//  MCCamera
//
//  Created by kyungbin on 2023/06/02.
//

import Foundation
import AVFoundation
import SwiftUI
//bool data type whether in gallery
class ImgType : ObservableObject {
    
    public var img : UIImage
    @Published var isStored : Bool
    @Published var isSelected : Bool = false
    
    func storeImg(){
        self.isStored = true
    }
    func toggleSelect(){
        self.isSelected.toggle()
    }
    
    init(img: UIImage, isStored: Bool) {
        self.img = img
        self.isStored = isStored
        
    }
    
}

extension ImgType : Hashable{
    static func == (lhs: ImgType, rhs: ImgType) -> Bool {
        return lhs.img == rhs.img
     }
     
     func hash(into hasher: inout Hasher) {
         hasher.combine(img)
       
     }
}
