//
//  CameraViewModel.swift
//  MCCamera
//
//  Created by kyungbin on 2023/05/25.
//

//
//  CamearViewModel.swift
//  CustomCamera
//
//  Created by kyungbin on 2023/05/15.
//

//
//  CameraViewModel.swift
//  SwiftUI_JJaseCam
//
//  Created by 이영빈 on 2021/09/24.
//

import SwiftUI
import AVFoundation
import Combine

class CameraViewModel: ObservableObject {
    private let model: Camera
    private let session: AVCaptureSession
    private var subscriptions = Set<AnyCancellable>()
    private var isCameraBusy = false
    
    let cameraPreview: AnyView
    let hapticImpact = UIImpactFeedbackGenerator()
    
    // ✅ 추가: 줌 기능
    var currentZoomFactor: CGFloat = 1.0
    var lastScale: CGFloat = 1.0

    @Published var shutterEffect = false
    @Published var recentImage: Data?
    @Published var isFlashOn = false
    @Published var isSilentModeOn = true
    @Published var photoDatas : [Data]?
    
    // 초기 세팅
    func configure() {
        model.requestAndCheckPermissions()
    }
   
    // 플래시 온오프
    func switchFlash() {
        isFlashOn.toggle()
        model.flashMode = isFlashOn == true ? .on : .off
    }
    
    // 무음모드 온오프
    func switchSilent() {
        isSilentModeOn.toggle()
        model.isSilentModeOn = isSilentModeOn
    }
    
    // 사진 촬영
    func capturePhoto() {
        if isCameraBusy == false {
            hapticImpact.impactOccurred()
            withAnimation(.easeInOut(duration: 0.05)) {
                shutterEffect = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.05)) {
                    self.shutterEffect = false
                }
            }
            
            model.capturePhoto()
            print("[CameraViewModel]: Photo captured!")
        } else {
            print("[CameraViewModel]: Camera's busy.")
        }
    }
    
    func zoom(factor: CGFloat) {
        let delta = factor / lastScale
        lastScale = factor
        
        let newScale = min(max(currentZoomFactor * delta, 1), 5)
        model.zoom(newScale)
        currentZoomFactor = newScale
    }
    
    func zoomInitialize() {
        lastScale = 1.0
    }
    
    // 전후면 카메라 스위칭
    func changeCamera() {
        // ✅ 추가
        model.changeCamera()
        print("[CameraViewModel]: Camera changed!")
    }
    
    init() {
        model = Camera()
        session = model.session
        cameraPreview = AnyView(CameraPreviewView(session: session))
        
//        if model.photoData != nil {
//            self.photoDatas?.append(model.photoData)
//        }
       
        model.$photoData.sink { [weak self] (photoData) in
            if photoData == Data(count: 0){
                self?.photoDatas = nil
                return
            }
            
            
            if (self?.photoDatas?.append(photoData)) == nil {
                self?.photoDatas = [photoData]
            }
        }
        .store(in: &self.subscriptions)
        
        
        model.$recentImage.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            self?.recentImage = pic
        }
        .store(in: &self.subscriptions)
        
        model.$isCameraBusy.sink { [weak self] (result) in
            self?.isCameraBusy = result
        }
        .store(in: &self.subscriptions)
        
        
    }
}
