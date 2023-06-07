//
//  MCSession.swift
//  MCCamera
//
//  Created by kyungbin on 2023/05/24.
//

//
//  RPSMultipeerSession.swift
//  RPS
//
//  Created by Joe Diragi on 7/28/22.
//

import MultipeerConnectivity
import os

//caseiterable enum use liek array
// customstringconvertible struct, enum print
enum Move: String, CaseIterable, CustomStringConvertible {
    case rock, paper, scissors, unknown
    
    var description : String {
        switch self {
        case .rock: return "Rock"
        case .paper: return "Paper"
        case .scissors: return "Scissors"
        default: return "Thinking"
        }
      }
}

class RPSMultipeerSession: NSObject, ObservableObject {
    private let serviceType = "MCCamera"
    private var myPeerID: MCPeerID
    
    public let serviceAdvertiser: MCNearbyServiceAdvertiser
    public let serviceBrowser: MCNearbyServiceBrowser
    public let session: MCSession
    
    //add re-connection function
    //public var friendList: [Friend] = []
    
    public var friendList = Set<Friend>();
    
        
    private let log = Logger()
    
    
    @Published var availablePeers = Set<MCPeerID>()
    @Published var receivedMove: Move = .unknown
    @Published var receivedImage: UIImage? = nil
    @Published var recvdInvite: Bool = false
    @Published var recvdInviteFrom: MCPeerID? = nil
    @Published var paired: Bool = false
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?
    
    init(username: String) {
        let peerID = MCPeerID(displayName: username)
        self.myPeerID = peerID
        
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        super.init()
        
        session.delegate = self
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self
                
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
//    func send(move: Move) {
//
//        image?.jpegData(compressionQuality: 0.9)
//        if !session.connectedPeers.isEmpty {
//            log.info("sendMove: \(String(describing: move)) to \(self.session.connectedPeers[0].displayName)")
//            do {
//                try session.send(move.rawValue.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
//            } catch {
//                log.error("Error sending: \(String(describing: error))")
//            }
//        }
//    }
    
    //test
    func send(image: Data) {
        if !session.connectedPeers.isEmpty {
            log.info("sendMove: \(String(describing: image)) to \(self.session.connectedPeers[0].displayName)")
            do {
                
                
                
                try session.send(image, toPeers: session.connectedPeers, with: .reliable)
                print("send it gg")
            } catch {
                log.error("Error sending: \(String(describing: error))")
            }
        }
        else{
            print("can not send image i dont know why")
        }
    }
    
    //add
    
    func compare(){
        print("compare")
        for friend in friendList{
            print("compare2\n")
         
            for peer in availablePeers{
                if(friend.peerId.displayName == peer.displayName){
                    self.serviceBrowser.invitePeer(peer, to: self.session, withContext: nil, timeout: 30)
                    if (invitationHandler != nil) {
                        invitationHandler!(true, session)
                    }
                    self.recvdInvite = false
                }
            }
            
        }
    }
    
    func getName() -> String{
        return myPeerID.displayName
    }

}

extension RPSMultipeerSession: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        //TODO: Inform the user something went wrong and try again
        log.error("ServiceAdvertiser didNotStartAdvertisingPeer: \(String(describing: error))")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        log.info("didReceiveInvitationFromPeer \(peerID)")
        
        DispatchQueue.main.async {
            // Tell PairView to show the invitation alert
            self.recvdInvite = true
            // Give PairView the peerID of the peer who invited us
            self.recvdInviteFrom = peerID
            // Give PairView the `invitationHandler` so it can accept/deny the invitation
            self.invitationHandler = invitationHandler
        }
    }
}

extension RPSMultipeerSession: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        //TODO: Tell the user something went wrong and try again
        log.error("ServiceBroser didNotStartBrowsingForPeers: \(String(describing: error))")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        log.info("ServiceBrowser found peer: \(peerID)")
        // Add the peer to the list of available peers
        DispatchQueue.main.async {
            //self.availablePeers.append(peerID)
            self.availablePeers.insert(peerID)
            self.compare()
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        log.info("ServiceBrowser lost peer: \(peerID)")
        // Remove lost peer from list of available peers
        DispatchQueue.main.async {
//            self.availablePeers.removeAll(where: {
//                $0 == peerID
//            })
            self.availablePeers.remove(peerID)
        }
    }
}

extension RPSMultipeerSession: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        log.info("peer \(peerID) didChangeState: \(state.rawValue)")
        
        switch state {
        case MCSessionState.notConnected:
            // Peer disconnected
            DispatchQueue.main.async {
                self.paired = false
                for friend in self.friendList{
                    if(friend.peerId  == peerID){
                        friend.connectionChange()
                    }
                }
            }
            // Peer disconnected, start accepting invitaions again
            serviceAdvertiser.startAdvertisingPeer()
            break
        case MCSessionState.connected:
            // Peer connected
            DispatchQueue.main.async {
                self.paired = true
             
            }
            // We are paired, stop accepting invitations
            serviceAdvertiser.stopAdvertisingPeer()
            
            //add re-connection function
            let newFriend = Friend(isConnected: true, peerId: peerID)
            
            self.friendList.insert(newFriend)
            break
        default:
            // Peer connecting or something else
            DispatchQueue.main.async {
                self.paired = false
            }
            break
        }
    }
    
//    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        if let string = String(data: data, encoding: .utf8), let move = Move(rawValue: string) {
//            log.info("didReceive move \(string)")
//            // We received a move from the opponent, tell the GameView
//            DispatchQueue.main.async {
//                self.receivedMove = move
//            }
//        } else {
//            log.info("didReceive invalid value \(data.count) bytes")
//        }
//    }
    //test
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let img = UIImage(data: data){
            log.info("didReceive img from \(peerID)")
            // We received a move from the opponent, tell the GameView
            DispatchQueue.main.async {
                self.receivedImage = img
                print("receive it gg")
                
                let rvdImg = ImgType(img: img, isStored: false)
                
                for friend in self.friendList{
                    if(friend.peerId  == peerID){
                        friend.addImage(image: rvdImg)
                    }
                }
                
                
//                let newFriendList = friendList.map{
//                    if($0.peerId == peerID){
//                        $0.images?.append(rvdImg)
//                    }
//                }
//                friendList = newFriendList
                
                
                
            }
        } else {
            log.info("didReceive invalid value \(data.count) bytes")
        }
    }
    
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        log.error("Receiving streams is not supported")
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        log.error("Receiving resources is not supported")
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        log.error("Receiving resources is not supported")
    }
    
    public func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
}
