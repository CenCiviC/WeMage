//
//  RoomView.swift
//  MCCamera
//
//  Created by kyungbin on 2023/05/25.
//

//
//  RoomView.swift
//  DesignTest
//
//  Created by kyungbin on 2023/05/19.
//

import SwiftUI

struct RoomView: View {
    @State private var isPresentingPair = false
    @EnvironmentObject var rpsSession: RPSMultipeerSession
    @Binding var isPresentingRoomView : Bool
   
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let albumSize = (UIScreen.screenWidth/2)-40
   // @State private var peerCount : Int =  0
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {isPresentingRoomView.toggle()}){
                    Image(systemName: "chevron.left")
                        .foregroundColor(.mainColor)
                }
                Spacer()
                
                Button("+ 친구 추가"){
                    isPresentingPair.toggle()
                }.foregroundColor(.mainColor)
                    .sheet(isPresented: $isPresentingPair){
                        PairView()
                            .environmentObject(rpsSession)
                    }
                
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
            .font(.system(size: 18, weight: .semibold))
            
          
            
//            Spacer()
//            Text("\(rpsSession.availablePeers.count)")
//
//
//            List(rpsSession.session.connectedPeers, id: \.self) { peer in
//                Text(peer.displayName)
//
//            }
            
            ScrollView {
                     LazyVGrid(columns: columns) {
                         ForEach(0..<20) { index in
                             VStack(alignment: .leading){
                                 Rectangle()
                                      .frame(width: albumSize, height: albumSize)
                                      .cornerRadius(10)
                                      .foregroundColor(.mainColor)
                                      
                                 HStack{
                                     Text("김수환")
                                         .font(.system(size: 15, weight: .semibold))
                                         .tracking(2)
                                         .foregroundColor(.black)
                                     Circle()
                                         .frame(width: 12, height: 12)
                                         .foregroundColor(index/2==0 ? .mainColor : .subYellow)
                                 }
                                
                                 Text("123")
                                     .font(.system(size: 15, weight: .regular))
                                     .tracking(2)
                                     .foregroundColor(.mainColor)
                                 
                             }
                             .padding(.bottom, 30)
                           
                             

                         }
                         
                  
                     }
                   
            }
            
            
            
            
            
            
           
//
//            if let image = rpsSession.receivedImage{
//                Image(uiImage: image)
//                    .resizable()
//                    .frame(width: 500, height: 500)
//            }
//            else{
//                Text("nothing")
//            }
//
//
//            Spacer()
//            MyView()
        }
  
        

    }
}

//
//
//struct RoomView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomView(currentView: )
//    }
//}