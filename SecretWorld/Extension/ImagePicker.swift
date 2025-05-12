//
//  ImagePicker.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 22/12/23.
//

import Foundation
import UIKit
import TOCropViewController
import Photos
class ImagePicker: NSObject, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  var picker = UIImagePickerController()
  var alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet )
  var viewController: UIViewController?
  var pickImageCallback : ((UIImage) -> ())?
  override init(){
    super.init()
  }
    func pickCameraImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback
        self.viewController = viewController
        picker.sourceType = .camera
        picker.delegate = self
        viewController.present(picker, animated: true, completion: nil)
    }
    func pickGalleryImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback
        self.viewController = viewController
        
        // Check authorization status
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.presentPhotoLibrary()
                    } else {
                        print("denied")
                    }
                }
            }
        case .authorized:
            self.presentPhotoLibrary()
        case .denied, .restricted:
            print("denied")
        @unknown default:
            print("denied")
        }
    }
    private func presentPhotoLibrary() {
        picker.sourceType = .photoLibrary
        picker.delegate = self
        viewController?.present(picker, animated: true, completion: nil)
    }
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback
        self.viewController = viewController

        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.pickGalleryImage(viewController, callback)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view

        // iPad specific settings
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera() {
        alert.dismiss(animated: true, completion: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
//            // Handle the case where the camera is not available
//            let alert = UIAlertController(title: "Warning", message: "You don't have a camera", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            viewController?.present(alert, animated: true, completion: nil)
        }
    }

    func openGallery() {
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        if uploadDuplicateImg{
            arrDuplicationImage.append(info)
        }
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        // Use TOCropViewController to present the cropping interface
        let cropViewController = TOCropViewController(image: image)
        cropViewController.delegate = self
        
        viewController?.present(cropViewController, animated: true, completion: nil)
    }
  @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
  }
}
extension ImagePicker: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        pickImageCallback?(image)
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
