//
//  UploadPhotosVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 28/11/24.
//

import UIKit
import TOCropViewController

class UploadPhotosVC: UIViewController{
    //MARK: - Outlets
    @IBOutlet var lblSelectedCount: UILabel!
    @IBOutlet var collVwImgs: UICollectionView!
    
    //MARK: - variables
    var callBack:((_ imgs:[Any])->())?
    var arrUploadImgs = [Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
                  swipeRight.direction = .right
                  view.addGestureRecognizer(swipeRight)
        lblSelectedCount.text = "\(arrUploadImgs.count) item selected"
            collVwImgs.reloadData()
        print("arrUploadImgs:--\(self.arrUploadImgs)")
        
    }
    @objc func handleSwipe() {
        self.navigationController?.popViewController(animated: true)
          }
    //MARK: - IBAction
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionUpload(_ sender: UIButton) {
        if arrUploadImgs.count > 0{
            Store.ServiceImg = arrUploadImgs
            self.navigationController?.popViewController(animated: true)
            callBack?(arrUploadImgs)
            
        }else{
            showSwiftyAlert("", "Upload any image", false)
        }
    }
    @IBAction func actionPlus(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddServiceImgPopOverVC") as! AddServiceImgPopOverVC
        vc.modalPresentationStyle = .popover
        vc.callBack = { index,title in
            print("index:- \(index)")
            if index == 0{
                self.openCamera()
            }else{
                self.openGallery()
            }
        }
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .up
        vc.preferredContentSize = CGSize(width: 185, height: 83)
        self.present(vc, animated: false)
    }

}
//MARK: - UICollectionViewDataSource,UICollectionViewDelegate
extension UploadPhotosVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrUploadImgs.count > 0{
            return arrUploadImgs.count
        }else{
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadPhotosCVC", for: indexPath) as! UploadPhotosCVC
        if arrUploadImgs.count > 0{
            let item = arrUploadImgs[indexPath.row]
                    
                    if let imageUrl = item as? String {
                        // Load image from URL string
                        cell.imgVwUpload.imageLoad(imageUrl: imageUrl)
                    } else if let image = item as? UIImage {
                        // Load UIImage directly
                        cell.imgVwUpload.image = image
                    }
                cell.btnDelete.tag = indexPath.row
                cell.btnDelete.addTarget(self, action: #selector(actionDelete), for: .touchUpInside)
        }
        return cell
    }
    
    //MARK: - UICollectionView actionDelete
    @objc func actionDelete(sender:UIButton){
        arrUploadImgs.remove(at: sender.tag)
        lblSelectedCount.text = "\(arrUploadImgs.count) item selected"
        collVwImgs.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collVwImgs.frame.size.width / 2 - 10, height: 150)
    }
}
// MARK: - Popup
extension UploadPhotosVC : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}
// MARK: - UIImagePickerControllerDelegate
extension UploadPhotosVC:UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            // Handle case where the camera is not available
            let alert = UIAlertController(title: "Camera Not Available", message: "Your device does not support the camera.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            // Handle case where the photo library is not available
            let alert = UIAlertController(title: "Gallery Not Available", message: "Your device does not support the gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            let cropViewController = TOCropViewController(image: image)
                    cropViewController.delegate = self
                    cropViewController.modalPresentationStyle = .fullScreen
                    picker.dismiss(animated: false) {
                        self.present(cropViewController, animated: true, completion: nil)
                    }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
// MARK: - TOCropViewControllerDelegate
extension UploadPhotosVC: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        self.arrUploadImgs.append(image)
        self.lblSelectedCount.text = "\(self.arrUploadImgs.count) item selected"
        self.collVwImgs.reloadData()
        cropViewController.dismiss(animated: true, completion: nil)
    }

    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
