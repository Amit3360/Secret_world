//
// NewReviewVC.swift
// SecretWorld
//
// Created by IDEIO SOFT on 30/04/25.
//
import UIKit
import TOCropViewController
class NewReviewVC: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet var heightVwRatingTitle: NSLayoutConstraint!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var lblJudgeHustsle: UILabel!
    @IBOutlet var lblLeaveAfact: UILabel!
    @IBOutlet var viewComment: UIView!
    @IBOutlet var txtFldAddComment: UITextField!
    @IBOutlet var viewUploadedImg: UIView!
    @IBOutlet var imgVwDummy: UIImageView!
    @IBOutlet var imgVwCross: UIImageView!
    @IBOutlet var imgVwComment: UIImageView!
    @IBOutlet var sliderQuality: SliderForReview!
    @IBOutlet var sliderCommunication: SliderForReview!
    @IBOutlet var sliderAttitude: SliderForReview!
    @IBOutlet var sliderSpeed: SliderForReview!
    @IBOutlet var viewReliabilitySlider: SliderForReview!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblNAme: UILabel!
    
    //MARK: - varibales
    var descriptionText = ""
    var isExpanded = false
    var viewModel = SelfReviewVM()
    var addRatingModel = RatingModel()
    var isImageUploaded: Bool = false
    var viewModelUploadImg = UploadImageVM()
    var imageUrl:String?
    var momentId:String?
    var taskId:String?
    var appliedUserId:String?
    var callBack:(()->())?
    var isEdit = false
    var arrReviews = [ReviewDataa]()
    var indexx = 0
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    
    private func uiSet(){
        lblDescription.isUserInteractionEnabled = true
        lblDescription.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleDescription)))

        if isEdit{
            getReviewDetails()
        }else{
            imgVwDummy.isHidden = false
            viewUploadedImg.isHidden = true
            imgVwDummy.isUserInteractionEnabled = true
            imgVwDummy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openImagePicker)))
        }
        getSelfReviewApi(selectedUserId: appliedUserId ?? "")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeImage))
        imgVwCross.isUserInteractionEnabled = true
        imgVwCross.addGestureRecognizer(tapGesture)
        let sliders = [sliderQuality, sliderCommunication, sliderAttitude, sliderSpeed, viewReliabilitySlider]
        for slider in sliders {
            slider?.minimumValue = 0
            slider?.maximumValue = 100
            slider?.addTarget(self, action: #selector(ratingSlidervalueChanged(_:)), for: .valueChanged)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lblDescription.isUserInteractionEnabled = true // ← Add this line
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDescription))
        lblDescription.addGestureRecognizer(tapGesture)
    }
    @objc private func toggleDescription() {
        isExpanded.toggle()
        if lblDescription.text?.contains("Read More") ?? false || lblDescription.text?.contains("Read Less") ?? false{
            if isExpanded {
                lblDescription.appendReadLess(after: descriptionText, trailingContent: .readless)
            } else {
                lblDescription.appendReadmore(after: descriptionText, trailingContent: .readmore)
            }
            
            
        }
        
    }

    func getReviewDetails() {
        heightVwRatingTitle.constant = 50
        lblJudgeHustsle.isHidden = true
        lblLeaveAfact.isHidden = true
        btnSubmit.setTitle("Request to delete", for: .normal)
        btnSubmit.backgroundColor = UIColor(hex: "#FF4210")
        viewComment.borderWid = 0
        viewComment.backgroundColor = UIColor(hex: "#D8EBD7")
        txtFldAddComment.isUserInteractionEnabled = false
        let sliders: [UISlider] = [
            sliderQuality,
            sliderCommunication,
            sliderAttitude,
            sliderSpeed,
            viewReliabilitySlider
        ]
        sliders.forEach { $0.isUserInteractionEnabled = false }

        if let media = arrReviews[indexx].media, !media.isEmpty {
            imgVwDummy.isHidden = true
            viewUploadedImg.isHidden = false
            imgVwComment.imageLoad(imageUrl: media)
        } else {
            imgVwDummy.isHidden = false
            viewUploadedImg.isHidden = true
        }

        txtFldAddComment.text = arrReviews[indexx].comment ?? ""
        let rating = arrReviews[indexx].rating

        DispatchQueue.main.async {
            self.sliderQuality.value = Float(rating?.quality ?? 0)
            self.sliderCommunication.value = Float(rating?.communication ?? 0)
            self.sliderAttitude.value = Float(rating?.attitude ?? 0)
            self.sliderSpeed.value = Float(rating?.speed ?? 0)
            self.viewReliabilitySlider.value = Float(rating?.reliability ?? 0)
            sliders.forEach { $0.setNeedsDisplay() }
        }

        addRatingModel.quality = rating?.quality
        addRatingModel.communication = rating?.communication
        addRatingModel.attitude = rating?.attitude
        addRatingModel.speed = rating?.speed
        addRatingModel.reliability = rating?.reliability
    }

    private func getSelfReviewApi(selectedUserId:String){
        viewModel.getSelfReviewApi(userId: selectedUserId) { data in
            self.lblNAme.text = "@\(data?.review?.name ?? "")"
            if data?.review?.selfReview?.isEmpty == true {
                self.lblDescription.text = "--No Self Review--"
            }else{
                self.lblDescription.text = data?.review?.selfReview ?? ""
                self.descriptionText = data?.review?.selfReview ?? ""
                self.lblDescription.appendReadmore(after: data?.review?.selfReview ?? "", trailingContent: .readmore)

            }
            self.imgVwUser.imageLoad(imageUrl: data?.review?.profilePhoto ?? "")
            
        }
    }

    @objc func removeImage() {
        view.endEditing(true)
        imgVwComment.image = nil // Removes the image from imgVwComment
        imgVwCross.isHidden = true
        imgVwDummy.isHidden = false
        viewUploadedImg.isHidden = true
    }
    @objc func openImagePicker() {
        view.endEditing(true)
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCamera()
        })
        alert.addAction(UIAlertAction(title: "Gallery", style: .default) { _ in
            self.openGallery()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = false
        self.navigationController?.pushViewController(picker, animated: true)
    }
    func openGallery() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        present(picker, animated: true)
    }
    @objc func ratingSlidervalueChanged(_ sender: SliderForReview) {
        let sliders: [(slider: SliderForReview, name: String)] = [
            (sliderQuality, "quality"),
            (sliderCommunication, "communication"),
            (sliderAttitude, "attitude"),
            (sliderSpeed, "speed"),
            (viewReliabilitySlider, "reliability")
        ]
        if addRatingModel == nil {
            addRatingModel = RatingModel()
        }
        for (itemSlider, name) in sliders {
            if sender == itemSlider {
                let intValue = Int(sender.value)
                print("Slider Changed - \(name): \(intValue)")
                switch name {
                case "quality":
                    addRatingModel.quality = intValue
                case "communication":
                    addRatingModel.communication = intValue
                case "attitude":
                    addRatingModel.attitude = intValue
                case "speed":
                    addRatingModel.speed = intValue
                case "reliability":
                    addRatingModel.reliability = intValue
                default:
                    break
                }
                break
            }
        }
    }
    //MARK: - IBAction
    @IBAction func actionSubmit(_ sender: UIButton) {
        view.endEditing(true)
        if !isEdit{
            let rating = addRatingModel
            print("Rating Submitted:")
            print("Reliability: \(rating.reliability ?? 0)")
            print("Speed: \(rating.speed ?? 0)")
            print("Attitude: \(rating.attitude ?? 0)")
            print("Communication: \(rating.communication ?? 0)")
            print("Quality: \(rating.quality ?? 0)")
            if !(txtFldAddComment.text ?? "").isEmpty, !(txtFldAddComment.text ?? "").isValidInput {
                showSwiftyAlert("", "Invalid Input: your comment should contain meaningful text", false)
            }else{
                viewModel.addReviewApi(momentId: momentId ?? "", taskId: taskId ?? "", businessUserId: appliedUserId ?? "", comment: txtFldAddComment.text ?? "", media: imageUrl ?? "", rating: rating) {[weak self] message in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelfReviewSavedVC") as! SelfReviewSavedVC
                        vc.isSelect = 1
                        vc.callBack = { [weak self] in
                            guard let self = self else { return }
                            self.navigationController?.popViewController(animated: true)
                            self.callBack?()
                        }
                        vc.modalPresentationStyle = .overFullScreen
                        self.navigationController?.present(vc, animated: true)
                        
                    }
                }
            }
        }
    }
    @IBAction func actionBAck(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - UIImagePickerControllerDelegate TOCropViewControllerDelegate
extension NewReviewVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let selectedImage = info[.originalImage] as? UIImage {
                let cropVC = TOCropViewController(image: selectedImage)
                cropVC.delegate = self
                cropVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(cropVC, animated: false)
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false, completion: nil)
    }
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: false) {
            
            self.viewModelUploadImg.uploadProductImagesApi(Images: image){ data in
                self.imgVwComment.imageLoad(imageUrl: data?.imageUrls?.first ?? "")
                self.imageUrl = data?.imageUrls?.first ?? ""
            }
            self.imgVwCross.isHidden = false
            self.imgVwDummy.isHidden = true
            self.viewUploadedImg.isHidden = false
            // Optionally store image in your model or upload
            self.navigationController?.popViewController(animated: false)
        }
    }
}
