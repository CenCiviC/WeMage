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
    
    func connectionChange(){
        self.isConnected.toggle()
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
