//
//  File.swift
//  
//
//  Created by Timon Harz on 19.02.24.
//

import Foundation
import UIKit
import SwiftUI
import AVFoundation
import AVKit

struct CustomCameraRepresentable: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var didTapCapture: Bool

    func makeUIViewController(context: Context) -> CustomCameraController {
        let controller = CustomCameraController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ cameraViewController: CustomCameraController, context: Context) {

        if(self.didTapCapture) {
            cameraViewController.didTapRecord()
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
        let parent: CustomCameraRepresentable

        init(_ parent: CustomCameraRepresentable) {
            self.parent = parent
        }

        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

            parent.didTapCapture = false

            if let imageData = photo.fileDataRepresentation() {
                parent.image = UIImage(data: imageData)
            }
            
        }
    }
}

class CustomCameraController: UIViewController {

    var image: UIImage?

    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?

    //DELEGATE
    var delegate: AVCapturePhotoCaptureDelegate?

    func didTapRecord() {

        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: delegate!)

    }

    override func viewDidLoad() {
      orientationChanged()
        super.viewDidLoad()
        let orientation = UIDevice.current.orientation

        setup()
        setupOrientationObserver()
    }
  override func viewDidAppear(_ animated: Bool) {
    orientationChanged()
  }
  deinit {
          NotificationCenter.default.removeObserver(self)
      }
    func setup() {
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
  func setupOrientationObserver() {
         NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        // Begin generating device orientation notifications
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
     }
  @objc func orientationChanged() {
          if let connection =  self.cameraPreviewLayer?.connection {
            let orientation = UIDevice.current.orientation
            let previewLayerConnection: AVCaptureConnection = connection

            previewLayerConnection.videoOrientation = .landscapeRight
          }
      }
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }

    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: AVCaptureDevice.Position.unspecified)
        for device in deviceDiscoverySession.devices {

            switch device.position {
            case AVCaptureDevice.Position.front:
                self.frontCamera = device
            case AVCaptureDevice.Position.back:
                self.backCamera = device
            default:
                break
            }
        }

        self.currentCamera = self.backCamera
    }


    func setupInputOutput() {
        do {

            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)

        } catch {
            print(error)
        }

    }
    func setupPreviewLayer()
    {
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)

    }
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
}
