//
//  CameraModel.swift
//  MCCamera
//
//  Created by kyungbin on 2023/05/25.
//

//
//  CamearModel.swift
//  CustomCamera
//
//  Created by kyungbin on 2023/05/15.
//

import Foundation
import AVFoundation
import SwiftUI

class Camera: NSObject, ObservableObject {
    var session = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput!
    let output = AVCapturePhotoOutput()
    //var photoData = Data(count: 0)
    var isSilentModeOn = false
    var flashMode: AVCaptureDevice.FlashMode = .off
    
    @Published var recentImage: Data?
    @Published var isCameraBusy = false
    @Published var photoData = Data(count: 0)

    
    
    // 카메라 셋업 과정을 담당하는 함수,
    func setUpCamera() {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                for: .video, position: .back) {
            do { // 카메라가 사용 가능하면 세션에 input과 output을 연결
                videoDeviceInput = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(videoDeviceInput) {
                    session.addInput(videoDeviceInput)
                }
                
                if session.canAddOutput(output) {
                    //resolution
                    session.sessionPreset = .high
                    session.addOutput(output)
                    output.isHighResolutionCaptureEnabled = true
                    output.maxPhotoQualityPrioritization = .quality
                }
                session.startRunning() // 세션 시작
            } catch {
                print(error) // 에러 프린트
            }
        }
    }
    
    func requestAndCheckPermissions() {
        // 카메라 권한 상태 확인
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // 권한 요청
            AVCaptureDevice.requestAccess(for: .video) { [weak self] authStatus in
                if authStatus {
                    DispatchQueue.main.async {
                        self?.setUpCamera()
                    }
                }
            }
        case .restricted:
            break
        case .authorized:
            // 이미 권한 받은 경우 셋업
            setUpCamera()
        default:
            // 거절했을 경우
            print("Camera permession declined")
        }
    }
    
    func capturePhoto() {
        // 사진 옵션 세팅
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        photoSettings.flashMode = self.flashMode
        let photoSize = CGSize(width: 1920, height: 1440) // Adjust the size as needed
        
        photoSettings.previewPhotoFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: photoSettings.availablePreviewPhotoPixelFormatTypes.first!,
            kCVPixelBufferWidthKey as String: photoSize.width,
            kCVPixelBufferHeightKey as String: photoSize.height
        ]
        
        
        
        self.output.capturePhoto(with: photoSettings, delegate: self)
        print("[Camera]: Photo's taken")
    }
    
//    func cropPhotoToAspectRatio(_ image: UIImage, aspectRatio: CGSize) -> UIImage {
//        let newImage = image.preparingThumbnail(of: aspectRatio)
//        return newImage!
//    }
    
    func cropPhotoToAspectRatio(_ image: UIImage, aspectRatio: CGSize) -> UIImage? {
         let cgImage = image.cgImage!
         
         let width = CGFloat(cgImage.width)
         let height = CGFloat(cgImage.height)
         let originalAspectRatio = width / height
         
         var targetWidth: CGFloat
         var targetHeight: CGFloat
         
         if originalAspectRatio > aspectRatio.width / aspectRatio.height {
             targetHeight = height
             targetWidth = height * (aspectRatio.width / aspectRatio.height)
         } else {
             targetWidth = width
             targetHeight = width * (aspectRatio.height / aspectRatio.width)
         }
         
         let x = (width - targetWidth) / 2
         let y = (height - targetHeight) / 2
         
         let cropRect = CGRect(x: x, y: y, width: targetWidth, height: targetHeight)
        // let croppedCGImage = cgImage.cropping(to: cropRect)
        
       //  let croppedImage = UIImage(cgImage: croppedCGImage!)
        let croppedImage = image.preparingThumbnail(of: CGSize(width: targetWidth, height: targetHeight))
         return croppedImage
     }
    
    
    
    
    
//    func savePhoto(_ imageData: Data) {
//        let watermark = UIImage(named: "watermark")
//        guard let image = UIImage(data: imageData) else { return }
//
//        let newImage = image.overlayWith(image: watermark ?? UIImage())
//
//        //add newImage to ios camera album
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//
//        print("[Camera]: Photo's saved")
//    }
    
    func savePhoto(_ imageData: UIImage) {

        UIImageWriteToSavedPhotosAlbum(imageData, nil, nil, nil)
        
        print("[Camera]: Photo's saved")
    }
    
    
    
    func zoom(_ zoom: CGFloat){
        let factor = zoom < 1 ? 1 : zoom
        let device = self.videoDeviceInput.device
        
        do {
            try device.lockForConfiguration()
            device.videoZoomFactor = factor
            device.unlockForConfiguration()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func changeCamera() {
        let currentPosition = self.videoDeviceInput.device.position
        let preferredPosition: AVCaptureDevice.Position
        
        switch currentPosition {
        case .unspecified, .front:
            print("후면카메라로 전환합니다.")
            preferredPosition = .back
            
        case .back:
            print("전면카메라로 전환합니다.")
            preferredPosition = .front
            
        @unknown default:
            print("알 수 없는 포지션. 후면카메라로 전환합니다.")
            preferredPosition = .back
        }
        
        if let videoDevice = AVCaptureDevice
            .default(.builtInWideAngleCamera,
                     for: .video, position: preferredPosition) {
            do {
                let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                self.session.beginConfiguration()
                
                if let inputs = session.inputs as? [AVCaptureDeviceInput] {
                    for input in inputs {
                        session.removeInput(input)
                    }
                }
                if self.session.canAddInput(videoDeviceInput) {
                    self.session.addInput(videoDeviceInput)
                    self.videoDeviceInput = videoDeviceInput
                } else {
                    self.session.addInput(self.videoDeviceInput)
                }
            
                if let connection =
                    self.output.connection(with: .video) {
                    if connection.isVideoStabilizationSupported {
                        connection.preferredVideoStabilizationMode = .auto
                    }
                }
                
                output.isHighResolutionCaptureEnabled = true
                output.maxPhotoQualityPrioritization = .quality
                
                self.session.commitConfiguration()
            } catch {
                print("Error occurred: \(error)")
            }
        }
    }
}

extension Camera: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        self.isCameraBusy = true
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        if isSilentModeOn {
            print("[Camera]: Silent sound activated")
            AudioServicesDisposeSystemSoundID(1108)
        }
        
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        if isSilentModeOn {
            AudioServicesDisposeSystemSoundID(1108)
        }
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }

        
        
        print("[CameraModel]: Capture routine's done")
        //test
        let image = UIImage(data: imageData)!
     //  let croppedImage = cropPhotoToAspectRatio(image, aspectRatio: CGSize(width: 1, height: 1))
        //guard let newimageData = photo.fileDataRepresentation() else { return }
      //  guard let newimageData = croppedImage.fileDataRepresentation() else { return }
        
        self.photoData = imageData
        self.recentImage = imageData
        self.savePhoto(image)
        self.isCameraBusy = false
    }

    
    
}

extension UIImage {
    // 워터마크 오버레이 헬퍼 함수
    func overlayWith(image: UIImage) -> UIImage {
        let newSize = CGSize(width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        image.draw(in: CGRect(origin: CGPoint(x: size.width - 200, y: size.height - 100), size: image.size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
