//
//  Friend.swift
//  MCCamera
//
//  Created by kyungbin on 2023/06/02.
//

import MultipeerConnectivity

class Friend : Identifiable, ObservableObject {
    public var peerId : MCPeerID
    
    
    @Published var images : [ImgType] = []
    @Published var isConnected : Bool
    
    init(isConnected: Bool, peerId: MCPeerID) {
        self.isConnected = isConnected
        self.peerId = peerId
    }
    
    func addImage(image: ImgType) {
        images.append(image)
    }
    
    func connect(){
        self.isConnected = true
    }
    func disconnect(){
        self.isConnected = false
    }
    
    func deleteAllImg(){
        images.removeAll(where: {$0.isStored == false})
    }
    
    func imgStore(){
        
        images.forEach({ img in
            if(img.isSelected){
                UIImageWriteToSavedPhotosAlbum(img.img, nil, nil, nil)
                img.storeImg()
                img.toggleSelect()
            }
            
        })
    }
    
}

extension Friend : Hashable{
    static func == (lhs: Friend, rhs: Friend) -> Bool {
        return lhs.peerId == rhs.peerId
     }
     
     func hash(into hasher: inout Hasher) {
         hasher.combine(peerId)
       
     }
}
