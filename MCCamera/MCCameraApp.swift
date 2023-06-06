//
//  MCCameraApp.swift
//  MCCamera
//
//  Created by kyungbin on 2023/05/24.
//

import SwiftUI

@main
struct MCCameraApp: App {
    var body: some Scene {
        WindowGroup {
          StartView()
        }
    }
}


//struct ContentView: View {
//    @StateObject private var cameraModelView = CameraViewModel()
//    
//    var body: some View {
//        TabView{
//            GalleryView()
//                .environmentObject(cameraModelView)
//                .tabItem {
////                    Image(systemName: "1.circle")
////                    Text("Page 1")
//                }
//
//            Text("Page 2")
//                .tabItem {
////                    Image(systemName: "2.circle")
////                    Text("Page 2")
//                }
//
//            CameraView()
//                 .environmentObject(cameraModelView)
//                .tabItem {
////                    Image(systemName: "3.circle")
////                    Text("Page 3")
//                }
//        }
//        .tabViewStyle(.page) // Apply PageTabViewStyle to enable swiping between pages
//    }
//}
