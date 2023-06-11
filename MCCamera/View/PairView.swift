//
//  PairView.swift
//  MCCamera
//
//  Created by kyungbin on 2023/05/24.
//

//
//  PairView.swift
//  RPS
//
//  Created by Joe Diragi on 7/29/22.
//

import SwiftUI
import os
import MultipeerConnectivity

struct PairView: View {
    @EnvironmentObject var rpsSession: RPSMultipeerSession
    @Environment(\.dismiss) var dismiss
    @State var btnClick : MCPeerID?

    
   //@Binding var currentView: Int
    
    var logger = Logger()
    
    let listWidth = UIScreen.screenWidth-100
    let listHeight  = 40.0
    
    var body: some View {
        VStack{
            HStack{
//                Button(action : {dismiss()}){
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(.mainColor)
//                }
          
                
                Spacer()
                Text("주변 사람들")
                    .font(.system(size: 18, weight: .bold))
                    .tracking(2)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 30)
                .padding(.top, 20)
                .padding(.bottom, 50)


            
            
            
            
            ForEach( Array(rpsSession.availablePeers), id: \.self){ peer in
                
                HStack{
                    Button(action:  {
                        rpsSession.serviceBrowser.invitePeer(peer, to: rpsSession.session, withContext: nil, timeout: 30)
                        btnClick = peer
                    }){

                        if(btnClick == peer){
                            Rectangle()
                                .frame(width: listWidth, height: listHeight)
                                .cornerRadius(10)
                                .foregroundColor(.mainColor)
                                .overlay(
                                    Text(peer.displayName)
                                        .font(.system(size: 16, weight: .bold))
                                        .tracking(2)
                                        .foregroundColor(.white)
                                )
                        }else{
                            Rectangle()
                                .stroke(lineWidth: 2)
                                .foregroundColor(.mainColor)
                                .cornerRadius(10)
                                .frame(width: listWidth, height: listHeight)
                                .overlay(
                                    Text(peer.displayName)
                                        .font(.system(size: 16, weight: .bold))
                                        .tracking(2)
                                        .foregroundColor(.mainColor)
                                )
                        }


                    }
                }
                
 
            }
            
            Spacer()
            

   
            

            
        }
        .alert("\(rpsSession.recvdInviteFrom?.displayName ?? "에러")에게 친구 추가가 왔습니다!", isPresented: $rpsSession.recvdInvite) {
            Button("추가") {
                if (rpsSession.invitationHandler != nil) {
                    rpsSession.invitationHandler!(true, rpsSession.session)
                }
            }
            Button("거절") {
                if (rpsSession.invitationHandler != nil) {
                    rpsSession.invitationHandler!(false, nil)
                }
            }
        }
    
    }
}
