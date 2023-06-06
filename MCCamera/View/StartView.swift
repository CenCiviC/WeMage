//
//  StartView.swift
//  MCCamera
//
//  Created by kyungbin on 2023/05/24.
//

//
//  StartView.swift
//  RPS
//
//  Created by Joe Diragi on 7/28/22.
//

import SwiftUI

struct StartView: View {
    @StateObject private var cameraViewModel = CameraViewModel()
    @State private var selectedTab = "1"
    @State var rpsSession: RPSMultipeerSession?
    @State var currentView = 10
    
    @State var username = ""
    var body: some View {
        switch currentView {
//        case 1:
//            GalleryView()
//                .environmentObject(cameraViewModel)
            
//            PairView(currentView: $currentView)
//                .environmentObject(rpsSession!)
            
        case 0:
            CameraView(currentView: $currentView)
                .environmentObject(rpsSession!)
                .environmentObject(cameraViewModel)
                

            


            
//        case 3:
//            StartTabView(currentView: $currentView)
//                .environmentObject(rpsSession!)
//                .environmentObject(cameraViewModel)
        case 4:
            test
            
        default:
            startViewBody
        }
    }
    
    var startViewBody: some View{
        VStack{
            Spacer()
            Image("logo")
                .padding(.bottom, 50)
            
            TextField("닉네임을 입력하세요", text: $username)
                .padding([.horizontal], 40.0)
                .background(
                    Rectangle()
                    .frame(height: 60)
                    .cornerRadius(25)
                    .foregroundColor(.white)
                )
                .padding(.horizontal, 40)
                
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 18, weight: .semibold))
                

                .foregroundColor(.mainColor)
              
            
                
            
            Button("계속 →") {
                rpsSession = RPSMultipeerSession(username: username)
                currentView = 0
            }.buttonStyle(BorderlessButtonStyle())
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .foregroundColor(.white)
                .background(username.isEmpty ? Color.accentColor : Color.blue)
                .cornerRadius(12)
                .disabled(username.isEmpty ? true : false)
                
             .padding(.top, 30)
           
            Spacer()
            
        }
        .background(Color.mainColor.ignoresSafeArea(.all))
        
    }
    
    var test : some View{
        VStack{
            HStack{
                Button(action: {print("fwe")}){
                    
                        Image(systemName: "speaker")
                        .resizable()
                        .frame(width: 20 ,height: 25)
                      
                    
                }
               
                Button("선택"){
                    
                }
            }
            .foregroundColor(.mainColor)
            .font(.system(size: 18, weight: .semibold))
            .padding(.horizontal, 30)
            
        }
    }
    

}


//struct StartTabView: View{
//    @EnvironmentObject var rpsSession: RPSMultipeerSession
//    @EnvironmentObject var cameraViewModel : CameraViewModel
//    
//    
//    @Binding var currentView: Int
//
//    var body : some View{
//        TabView {
//            CameraView()
//                .environmentObject(cameraViewModel)
//                .environmentObject(rpsSession)
//                .tabItem {
////                    Image(systemName: "1.circle")
////                    Text("Page 1")
//                }
//            
//            
//            RoomView()
//                .environmentObject(rpsSession)
//                .tabItem {
////                    Image(systemName: "3.circle")
////                    Text("Page 3")
//                }
//             
//        }
//        .tabViewStyle(.page) // Apply PageTabViewStyle to enable swiping between pages
// 
//    
//    }
//    
//}

//
//struct StartView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartView()
//    }
//}
