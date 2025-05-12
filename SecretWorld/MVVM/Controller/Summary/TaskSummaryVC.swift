//
//  TaskSummaryVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 10/04/25.
//

import UIKit
import AlignedCollectionViewFlowLayout
import MapboxMaps
import Solar

class TaskSummaryVC: UIViewController {

    @IBOutlet weak var lblSpotCount: UILabel!
    @IBOutlet weak var heightCollSkills: NSLayoutConstraint!
    @IBOutlet weak var imgVwTask: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var collVwSkills: UICollectionView!
    @IBOutlet weak var imgVwStatus: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
 
    @IBOutlet weak var mapVw: MapView!
    @IBOutlet weak var sliderVw: UISlider!
    @IBOutlet weak var collVwSpot: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    var viewModel = AddGigVM()
    var taskId:String = ""
    private var solar: Solar?
    var arrSkill = [Skills]()
    var descriptionText = ""
    private var isExpanded = false
    var arrParticiptant = [Participantzz]()
    var arrPointAnnotaion: [PointAnnotation] = []
    var pointAnnotationManagerPop: PointAnnotationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        if let solar = Solar(coordinate: CLLocationCoordinate2D(latitude: myCurrentLat, longitude: myCurrentLong)) {
            self.solar = solar
            let isDaytime = solar.isDaytime
            print(isDaytime ? "It's day time!" : "It's night time!")
            if isDaytime{
                if let styleURL = URL(string: "mapbox://styles/kevinzhang23a/cm2bod8mi00qg01pgepsohjq0") {
                    mapVw.mapboxMap.loadStyleURI(StyleURI(url: styleURL) ?? .light)
                }

            }else{
        if let styleURL = URL(string: "mapbox://styles/kevinzhang23a/cm2bod8mi00qg01pgepsohjq0") {
                           mapVw.mapboxMap.loadStyleURI(StyleURI(url: styleURL) ?? .light)
                       }
            }
            }
        mapVw.ornaments.scaleBarView.isHidden = true
        mapVw.ornaments.logoView.isHidden = true
        mapVw.ornaments.attributionButton.isHidden = true
        let nibSkill = UINib(nibName: "SkillToolsCVC", bundle: nil)
        collVwSkills.register(nibSkill, forCellWithReuseIdentifier: "SkillToolsCVC")
        let nibParticipant = UINib(nibName: "UserListCVC", bundle: nil)
        collVwSpot.register(nibParticipant, forCellWithReuseIdentifier: "UserListCVC")
        let alignedFlowLayoutCollVwDietry = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwSkills.collectionViewLayout = alignedFlowLayoutCollVwDietry
        setCollectionViewHeight()
        getUserGigDetailApi()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewHeights()
    }
    func setCollectionViewHeight(){
  
        let alignedFlowLayoutCollVwSpecializ = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        collVwSkills.collectionViewLayout = alignedFlowLayoutCollVwSpecializ
        
    
        if let flowLayout1 = collVwSkills.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout1.estimatedItemSize = CGSize(width: 0, height: 37)
            flowLayout1.itemSize = UICollectionViewFlowLayout.automaticSize
            //collVwSkills.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        }
       
        let heightDietry = self.collVwSkills.collectionViewLayout.collectionViewContentSize.height
        self.heightCollSkills.constant = heightDietry
        self.view.layoutIfNeeded()
    }
    private func updateCollectionViewHeights() {
    
        collVwSkills.layoutIfNeeded()
      
        let skillsHeight = collVwSkills.collectionViewLayout.collectionViewContentSize.height
        heightCollSkills.constant = skillsHeight
        
        view.layoutIfNeeded()
    }
    
    func getUserGigDetailApi(){
        
        viewModel.GetUserGigDetailApi(gigId: taskId, showLoader: true) { data in
            self.changeTimeStatus(data?.gig?.timeStatus ?? "")
            self.arrSkill.removeAll()
           
            self.arrParticiptant.removeAll()
            self.arrParticiptant = data?.participantsList ?? []
         
            self.collVwSpot.reloadData()
            
            for i in data?.gig?.skills ?? []{
                self.arrSkill.append(Skills(id: i.id ?? "", name: i.name ?? ""))
            }
          
            self.collVwSkills.reloadData()
            DispatchQueue.main.async {
                self.updateCollectionViewHeights()
            }
            self.lblName.text = "\(data?.gig?.title ?? "") \((data?.gig?.category?.name ?? ""))"
            self.lblUserName.text =  data?.gig?.user?.name ?? ""
         
            self.lblAddress.text = data?.gig?.address ?? ""
     
            self.descriptionText = data?.gig?.about ?? ""
            self.lblDescription.appendReadmore(after: self.descriptionText, trailingContent: .readmore)
           
            let value: Double = data?.gig?.price ?? 0
            let formattedValue = String(format: "%.2f", value)
            self.lblPrice.text = "$\(formattedValue)"
        
            var hour = 0
            var minute = 0

            let timeString = data?.gig?.serviceDuration ?? ""
            print("Service Duration------", timeString)
            if timeString.contains(":") {
                let components = timeString.split(separator: ":")
                if let h = Int(components[0]) {
                    hour = h
                }
                if components.count > 1, let m = Int(components[1].split(separator: " ")[0]) {
                    minute = m
                }
            } else if timeString.contains("hour") || timeString.contains("hours") {
                // Extract hour count from "2 hours" or "1 hour"
                let hourComponents = timeString.split(separator: " ")
                if let h = Int(hourComponents[0]) {
                    hour = h
                }
            }

            // Format the end time
            if let formattedTime = self.convertToDateFormat(data?.gig?.startDate ?? "",
                                                       dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                                       convertFormat: "Ha") {
                if hour > 1 {
                    self.lblTime.text = "\(formattedTime) (\(hour) H)"
                } else {
                    let totalMinutes = (hour * 60) + minute
                    print("\(totalMinutes) M") // Output in minutes
                    self.lblTime.text = "\(formattedTime) (\(totalMinutes) M)"
                }
            } else {
                print("Invalid date format")
            }
            
            if let formattedDate = self.convertToDateFormat(data?.gig?.startDate ?? "",
                                                       dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                                       convertFormat: "dd MMMM yyyy") {
             
                self.lblDate.text = formattedDate
                
            } else {
                print("Invalid date format")
            }
            self.mapVw.mapboxMap.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: data?.gig?.lat ?? 0, longitude: data?.gig?.long ?? 0),zoom: 11,bearing: 0,pitch: 0))
           
        
            if let rating = data?.gig?.user?.averageRating {
                switch rating {
                case .double(let value):
                    print("Average Rating as Double:", value)
                    self.lblRating.text = "\(value)"
                case .string(let value):
                    print("Average Rating as String:", value)
                    self.lblRating.text = "\(value)"
                }
            }
          
            if data?.gig?.image == "" || data?.gig?.image == nil{
                self.imgVwTask.image = UIImage(named: "taskIcon")

            }else{
                self.imgVwTask.imageLoad(imageUrl: data?.gig?.image ?? "")

            }

          
          
            self.lblAddress.text = data?.gig?.address ?? ""
          
      
            self.lblSpotCount.text = "Spots \(data?.participantsList?.count ?? 0)/\(data?.gig?.totalParticipants ?? 0)"
            self.sliderVw.minimumValue = 0
            self.sliderVw.maximumValue =  Float(data?.gig?.totalParticipants ?? 0)
            self.sliderVw.value = Float(data?.participantsList?.count ?? 0)
         
            self.downloadAnnotationImage(for: CLLocationCoordinate2D(latitude: data?.gig?.lat ?? 0, longitude: data?.gig?.long ?? 0))
        }
    }
    
    func downloadAnnotationImage(for coordinate: CLLocationCoordinate2D) {
        
     
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
       
      
            let image = self.combineImagesPopUp(overlayImage: UIImage(named: "redMarker") ?? UIImage(), overlaySize: CGSize(width: 14, height: 20))
            let pointAnnotation = self.createPointAnnotation(for: centerCoordinate, withImage: image ?? UIImage())
            self.updatePopUpAnnotations(with: pointAnnotation)
        
    }
    
    private func updatePopUpAnnotations(with pointAnnotation: PointAnnotation) {
 
        arrPointAnnotaion.append(pointAnnotation)
        
        
        DispatchQueue.main.async {
            self.pointAnnotationManagerPop = self.mapVw.annotations.makePointAnnotationManager()
            self.pointAnnotationManagerPop?.annotations = self.arrPointAnnotaion
        }
    }
    func createPointAnnotation(for coordinate: CLLocationCoordinate2D, withImage image: UIImage) -> PointAnnotation {
        var annotation = PointAnnotation(coordinate: coordinate)
        annotation.image = .init(image: image, name: "redMarker") // Ensure unique name
        return annotation
    }
    func combineImagesPopUp(
        overlayImage: UIImage,
        overlaySize: CGSize
    ) -> UIImage? {
        // Set up adjusted base size
        let adjustedBaseSize = CGSize(width: overlaySize.width, height: overlaySize.height)
        
        // Start graphics context
        UIGraphicsBeginImageContextWithOptions(adjustedBaseSize, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Failed to create graphics context.")
            return nil
        }
        
        // Define overlay position
        let overlayOrigin = CGPoint(x: 0, y: 0)
        let overlayRect = CGRect(origin: overlayOrigin, size: overlaySize)
  
        overlayImage.draw(in: overlayRect)
        context.restoreGState()
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return combinedImage
    }
    func convertToDateFormat(_ dateString: String,dateFormat:String,convertFormat:String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = dateFormat
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = convertFormat
            outputFormatter.timeZone = TimeZone.current // Adjust as needed
            
            return outputFormatter.string(from: date)
        }
        return nil // Return nil if parsing fails
    }
    private func changeTimeStatus(_ timeStatus: String) {
       
        switch timeStatus {
        case "Immediate!":
          
            imgVwStatus.image = UIImage(named: "fire") // Replace with your asset name
        case "Same Day!":
         
            imgVwStatus.image = UIImage(named: "sameDay") // Replace with your asset name
        case "Scheduled task!":
         
            imgVwStatus.image = UIImage(named: "sheduleTask") // Replace with your asset name
        default:
         
            imgVwStatus.image = UIImage(named: "fire") // Default icon
        }
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension TaskSummaryVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVwSkills{
        
            if arrSkill.count > 0{
                return  arrSkill.count
            }else{
                return 0
            }
        }else{
            if arrParticiptant.count > 0{
                return  arrParticiptant.count
            }else{
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        if collectionView == collVwSkills{
           
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillToolsCVC", for: indexPath) as! SkillToolsCVC
            guard indexPath.row < arrSkill.count else {
                fatalError("Index out of range for arrSkills at \(indexPath.row)")
            }
            cell.lblTitle.text = arrSkill[indexPath.row].name
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserListCVC", for: indexPath) as! UserListCVC
            cell.imgVwUser.layer.cornerRadius = 15
            cell.imgVwUser.imageLoad(imageUrl: arrParticiptant[indexPath.row].profilePhoto ?? "")
            return cell
        }
            
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVwSkills{
            return CGSize(width: 15, height: 15)
        }else{
            return CGSize(width: 30, height: 30)
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collVwSkills{
            return 5
        }else{
            return -10
        }
    }

    
}
