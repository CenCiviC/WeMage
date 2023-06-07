//
//  CameraView.swift
//  CustomCamera
//
//  Created by kyungbin on 2023/05/15.
//
//


import SwiftUI
import AVFoundation

struct CameraView: View {
    @EnvironmentObject private var viewModel : CameraViewModel
    @EnvironmentObject var rpsSession: RPSMultipeerSession
    
    
    @Binding var currentView: Int
    
    let screenRect = UIScreen.main.bounds
    var body: some View {
        NavigationStack{
            ZStack {
              
                viewModel.cameraPreview.ignoresSafeArea()
                    .onAppear {
                        viewModel.configure()
                    }
                    .frame(width: screenRect.width, height: screenRect.width)
                // ✅ 추가: 줌 기능
                    .gesture(MagnificationGesture()
                        .onChanged { val in
                            viewModel.zoom(factor: val)
                        }
                        .onEnded { _ in
                            viewModel.zoomInitialize()
                        }
                    )
                
                VStack {
                    CameraUpperView()
                        .environmentObject(viewModel)
                    Spacer()
                  
                  //  CameraMidView()
                    CameraLowerView()
                        .environmentObject(viewModel)
                        .environmentObject(rpsSession)
                    
                 
                }
             //   .foregroundColor(.mainColor)
            }
            .opacity(viewModel.shutterEffect ? 0 : 1)
        }
    }
}


struct CameraPreviewView: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        
        let screenRect = UIScreen.main.bounds
        print("hi?")
        print(screenRect.size.width)
        print(screenRect.size.height)
        
        view.videoPreviewLayer.session = session
        view.backgroundColor = .red
       
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        view.videoPreviewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.width)
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.connection?.videoOrientation = .portrait
        
        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        
    }
}

//view 추가

struct CameraUpperView: View{
    @EnvironmentObject private var viewModel : CameraViewModel
    @State var isPresentingRoomView = false
    var body: some View{
            HStack {
                Spacer()
                // 셔터사운드 온오프
                Button(action: {viewModel.switchSilent()}) {
                    Image(systemName: viewModel.isSilentModeOn ?
                          "speaker.fill" : "speaker")
                    
                }
                
                Spacer()
                
                // 플래시 온오프
                Button(action: {viewModel.switchFlash()}) {
                    Image(systemName: viewModel.isFlashOn ?
                          "bolt.fill" : "bolt")
            
                }
                Spacer()
                
                Button(action:{isPresentingRoomView.toggle()}){
                    Text("공유방")
                }
                .fullScreenCover(isPresented: $isPresentingRoomView){
                    RoomView(isPresentingRoomView: $isPresentingRoomView)
                        .environmentObject(viewModel)
                }
                
                Spacer()
            }
         //  .padding([.horizontal], 50)
           .padding(.bottom, 20)
           .foregroundColor(.mainColor)


    }
}


struct CameraArea: View{
    var body: some View{
        Text("Camera View")
            .padding()
            .background(Color.red)
    }
}

struct CameraMidView: View{
    var body: some View{
        HStack{
            Text("x1")
                .background(Circle().foregroundColor(Color.black).frame(width:40, height: 40))
                .foregroundColor(.white)
            Spacer()
            Text("3:4")
                .background(
                    Rectangle()
                        .stroke(Color.black ,lineWidth: 3)
                        .frame(width: 60, height: 80)
                )
                .foregroundColor(.black)
        
        }
        
        .font(.system(size: 15, weight: .semibold))
        .padding(.horizontal, 50)
    }
        
}

struct CameraLowerView: View{
    @EnvironmentObject private var viewModel : CameraViewModel
    @EnvironmentObject var rpsSession: RPSMultipeerSession
    @State private var isPresentingGallery = false
    
    
    var body: some View{
        VStack{
            
            //사진, 동영상 btn
            Text("사진")
                .foregroundColor(.mainColor)
                .font(.system(size: 15, weight: .bold))
                .tracking(2)
                .padding(.vertical, 15)
                
            
            //preview img, shutter btn, transfrom btn
            HStack{
                //preview
                Button(action: {isPresentingGallery.toggle()}){
                    if let previewImage = viewModel.recentImage {
                        Image(uiImage: UIImage(data: previewImage)!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 46, height: 46)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .aspectRatio(1, contentMode: .fit)
                    }
                    else {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.mainColor)
                            .frame(width: 46, height: 46)
                    }

                }
                
                .fullScreenCover(isPresented: $isPresentingGallery){
                    GalleryView(isPresentingGallery: $isPresentingGallery, userName: rpsSession.getName())
                        .environmentObject(viewModel)
                }
              
                
           
                Spacer()
             
                
                //shutter
                Button(action: {
                    viewModel.capturePhoto()
//                    if let image = viewModel.recentImage {
//                        rpsSession.send(image: image)
//                    }
               
                    
                    
                }){
                    Circle()
                        .fill(Color.white)
                        .frame(width:80, height: 80)
                        .background(
                            Circle()
                                .stroke(Color.mainColor,lineWidth: 4)
                               // .frame(width:60, height: 60)
                        )
                }
                
                Spacer()
                
                
                //transfrom
                
                Button(action: {viewModel.changeCamera()}) {
//                    Circle()
//                        .fill(Color.white)
//                        .frame(width:55, height: 55)
////                        .background(
////                            Circle()
////                                .stroke(Color.mainColor,lineWidth: 4)
////                               // .frame(width:60, height: 60)
////                        )
//                        .overlay(
//
//                        )
                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 34)
                        .foregroundColor(.mainColor)
                    
                
                    
                }
                .frame(width: 46, height: 46)
            

            }
            .padding(.horizontal, 30)
        
        }
        
        .padding([.bottom], 20)
        .padding(.top, 30)
        .background(Color.white)
    
    }
}




//
//struct CameraView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        CameraView()
//            .environmentObject(CameraViewModel())
//    }
//}
