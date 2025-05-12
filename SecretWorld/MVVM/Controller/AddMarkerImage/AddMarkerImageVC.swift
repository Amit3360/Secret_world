//
//  AddMarkerImageVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 31/12/24.
//


import UIKit


class AddMarkerImageVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var collVwLogo: UICollectionView!
    @IBOutlet weak var txtFldAddText: UITextField!
    @IBOutlet weak var paintImageVw: PaintImageView!
    @IBOutlet weak var collVwColor: UICollectionView!
    @IBOutlet weak var collVwImage: UICollectionView!
    
    var color: [UIColor] = [.red, .blue, .green, .yellow, .brown,.orange,.purple,.systemPink]
    var image: [String] = ["building1", "building2","building3","building4","building5","building6","building7"]
    var arrLogo: [String] = ["logo1","logo2","logo3","logo4","logo5","logo6"]
    var selectedColor: UIColor = .red // Default selected color
    var textPosition = CGPoint(x: 50, y: 50)
    var textRotation: CGFloat = 0 // Default text rotation angle
    var textSize: CGFloat = 40 // Default text size
 
    var callBack:((_ image:UIImage?)->())?
    var viewModel = UploadImageVM()
    var addedLogoImageViews: [UIImageView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add pan gesture recognizer to the paintImageVw
        txtFldAddText.delegate = self
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        print("1111")
        let translation = gesture.translation(in: view)
        textPosition = CGPoint(x: textPosition.x + translation.x, y: textPosition.y + translation.y)
        
        if let baseImage = paintImageVw.baseImage { // Use the base image without text
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: textSize),
                .foregroundColor: selectedColor // Use selected color
            ]
            let updatedImage = baseImage.withText(txtFldAddText.text ?? "", at: textPosition, attributes: attributes, rotation: textRotation)
            paintImageVw.image = updatedImage
        }
        
        gesture.setTranslation(.zero, in: view)
    }

    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        print("2222")
        textSize = max(10, textSize * gesture.scale) // Prevent text size from becoming too small
        
        if let baseImage = paintImageVw.baseImage {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: textSize),
                .foregroundColor: selectedColor
            ]
            let updatedImage = baseImage.withText(txtFldAddText.text ?? "", at: textPosition, attributes: attributes, rotation: textRotation)
            paintImageVw.image = updatedImage
        }
        
        gesture.scale = 1
    }

    @objc func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        print("3333")
        textRotation += gesture.rotation
        
        if let baseImage = paintImageVw.baseImage {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: textSize),
                .foregroundColor: selectedColor
            ]
            let updatedImage = baseImage.withText(txtFldAddText.text ?? "", at: textPosition, attributes: attributes, rotation: textRotation)
            paintImageVw.image = updatedImage
        }
        
        gesture.rotation = 0
    }
    
    @IBAction func actionAddText(_ sender: UIButton) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
          paintImageVw.addGestureRecognizer(panGesture)
          paintImageVw.isUserInteractionEnabled = true
          
          let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
          paintImageVw.addGestureRecognizer(pinchGesture)
          
          let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:)))
          paintImageVw.addGestureRecognizer(rotationGesture)
          
          if let originalImage = paintImageVw.image {
              paintImageVw.baseImage = originalImage // Save the original image as the base image
              let attributes: [NSAttributedString.Key: Any] = [
                  .font: UIFont.boldSystemFont(ofSize: textSize),
                  .foregroundColor: selectedColor
              ]
              let updatedImage = originalImage.withText(txtFldAddText.text ?? "", at: textPosition, attributes: attributes, rotation: textRotation)
              paintImageVw.image = updatedImage
          }
    }
    func captureViewAsImage(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    @IBAction func actionSave(_ sender: UIButton) {
//        viewModel.uploadImageApi(image: [paintImageVw.image ?? UIImage()]) { data in
//            
//        }
        if let combinedImage = captureViewAsImage(view: paintImageVw) {
              self.navigationController?.popViewController(animated: true)
        callBack?(combinedImage)
          }
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
       
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

extension AddMarkerImageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwColor {
            return color.count
        } else if collectionView == collVwImage {
            return image.count
        } else{
            return arrLogo.count
        }
     
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVwColor {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCVC", for: indexPath) as! ColorCVC
            cell.colorVw.backgroundColor = color[indexPath.row]
            return cell
        } else if collectionView == collVwImage {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCVC", for: indexPath) as! ImageCVC
            cell.imgVwColor.image = UIImage(named: image[indexPath.row])
            
            return cell
        } else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCVC", for: indexPath) as! ImageCVC
            cell.imgVwColor.image = UIImage(named: arrLogo[indexPath.row])
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView == collVwColor ? CGSize(width: 50, height: 50) : CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collVwColor {
            selectedColor = color[indexPath.row]
            paintImageVw.newColor = color[indexPath.row]
            
            // Get the selected cell
            if let cell = collectionView.cellForItem(at: indexPath) as? ColorCVC {
                // Add animation (e.g., scale animation)
                UIView.animate(withDuration: 0.1, animations: {
                    cell.colorVw.transform = CGAffineTransform(scaleX: 0.1, y: 0.1) // Scale up
                }) { _ in
                    // Optionally, reset the animation back to the original size
                    UIView.animate(withDuration: 0.1) {
                        cell.colorVw.transform = CGAffineTransform.identity // Reset to original size
                    }
                }
            }
        } else if collectionView == collVwImage{
            paintImageVw.image = UIImage(named: image[indexPath.row])
        }else{
            
            
            guard let logoImage = UIImage(named: arrLogo[indexPath.row]) else { return }
                        
                       let logoImageView = UIImageView(image: logoImage)
                       let width = paintImageVw.frame.width * 0.3
                       let height = logoImage.size.height / logoImage.size.width * width
                        
                       logoImageView.frame = CGRect(x: paintImageVw.frame.width / 2 - width / 2,
                                                     y: paintImageVw.frame.height / 2 - height / 2,
                                                     width: width,
                                                     height: height)
                       logoImageView.isUserInteractionEnabled = true
                       logoImageView.contentMode = .scaleAspectFit
                        
                       // Add gesture recognizers to the logoImageView
                       let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleLogoPanGesture(_:)))
                       logoImageView.addGestureRecognizer(panGesture)
                       
                       let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handleLogoPinchGesture(_:)))
                       logoImageView.addGestureRecognizer(pinchGesture)
                       
                       let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleLogoRotationGesture(_:)))
                       logoImageView.addGestureRecognizer(rotationGesture)
                        
                       paintImageVw.addSubview(logoImageView)
        }
    }

    
       // Handle pan gesture to move the logo image
       @objc func handleLogoPanGesture(_ gesture: UIPanGestureRecognizer) {
           print("1111")
           guard let logoImageView = gesture.view else { return }
           
           let translation = gesture.translation(in: paintImageVw)
           logoImageView.center = CGPoint(x: logoImageView.center.x + translation.x, y: logoImageView.center.y + translation.y)
           
           gesture.setTranslation(.zero, in: paintImageVw)
       }
       
       // Handle pinch gesture to resize the logo image
       @objc func handleLogoPinchGesture(_ gesture: UIPinchGestureRecognizer) {
           print("2222")
           guard let logoImageView = gesture.view else { return }
           
           // Adjust the width and height based on the pinch scale
           let scale = gesture.scale
           logoImageView.transform = logoImageView.transform.scaledBy(x: scale, y: scale)
           
           // Reset the scale factor to 1 for continuous scaling
           gesture.scale = 1
       }
       
       // Handle rotation gesture to rotate the logo image
       @objc func handleLogoRotationGesture(_ gesture: UIRotationGestureRecognizer) {
           print("3333")
           guard let logoImageView = gesture.view else { return }
           
           // Adjust the rotation based on the gesture's rotation angle
           logoImageView.transform = logoImageView.transform.rotated(by: gesture.rotation)
           
           // Reset the rotation angle to 0 for continuous rotation
           gesture.rotation = 0
       }
  
    
}

extension UIImage {
    func withText(_ text: String, at point: CGPoint, attributes: [NSAttributedString.Key: Any], rotation: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        
        let rect = CGRect(origin: point, size: size)
        
        // Rotate the context before drawing the text
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: point.x, y: point.y)
        context?.rotate(by: rotation)
        context?.translateBy(x: -point.x, y: -point.y)
        
        text.draw(in: rect, withAttributes: attributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
