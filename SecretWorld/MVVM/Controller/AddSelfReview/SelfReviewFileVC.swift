//
//  SelfReviewFileVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 29/04/25.
//

import UIKit
import Charts
import TOCropViewController


class SelfReviewFileVC: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet var lblReviewCategory: UILabel!
    @IBOutlet var lblReviewType: UILabel!
    @IBOutlet var imgVwReviewType: UIImageView!
    @IBOutlet var viewReviewtype: UIView!
    @IBOutlet var imgVwBackLogo: UIImageView!
    @IBOutlet var widthCollVwImgs: NSLayoutConstraint!
    @IBOutlet var heightTblvwComments: NSLayoutConstraint!
    @IBOutlet var tblVwComments: UITableView!
    @IBOutlet var collVwImgs: UICollectionView!
    @IBOutlet var btnRight: UIButton!
    @IBOutlet var btnScreenShot: UIButton!
    @IBOutlet var btnLeft: UIButton!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var viewSpiderGraph: UIView!
    
    //MARK: - variables
    var descriptionText = ""
    var isExpanded = false
    var capturedImage: UIImage?
    var radarChartView: RadarChartView!
    let arrParts = ["Communication", "Speed", "Quality", "Attitude", "Reliability"]
    var arrImgs = [ReviewMedia]()
    var viewModel = SelfReviewVM()
    var arrComments = [ReviewComment]()
    var currentPage = 1
    var totalPages = 1 // Set this value when the API response is received
    var isLoading = false

    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSpiderGraph.isUserInteractionEnabled = false
        lblDescription.isUserInteractionEnabled = true
        lblDescription.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleDescription)))

        uiSet()
        getReviewApi { valuesDict in
            self.setupRadarChart()
            let valuesArray: [Double] = [
                valuesDict["avgCommunication"] ?? 0.0,
                valuesDict["avgSpeed"] ?? 0.0,
                valuesDict["avgQuality"] ?? 0.0,
                valuesDict["avgAttitude"] ?? 0.0,
                valuesDict["avgReliability"] ?? 0.0
            ]

            self.setChart(dataPoints: self.arrParts, values: valuesArray)

            self.getMediaApi(page: 1, limit: 100) {
                self.getCommentsApi(page:self.currentPage, limit: 100) {
                }
            }
        }


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lblDescription.isUserInteractionEnabled = true // ← Add this line
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDescription))
        lblDescription.addGestureRecognizer(tapGesture)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tblVwComments.layoutIfNeeded()
        let contentHeight = tblVwComments.contentSize.height
        heightTblvwComments.constant = min(contentHeight, 150) // Max height = 200

      //  heightTblvwComments.constant = tblVwComments.contentSize.height
        adjustCollectionViewWidth()
    }
    private func uiSet(){
        lblReviewCategory.font = UIFont(name: "Cinzel-Bold", size: 34)
        lblReviewType.font = UIFont(name: "DancingScript-Bold", size: 15)
        
        let nibImgs = UINib(nibName: "ReviewImagesCVC", bundle: nil)
        collVwImgs.register(nibImgs, forCellWithReuseIdentifier: "ReviewImagesCVC")
        collVwImgs.layer.shadowColor = UIColor.black.cgColor
        collVwImgs.layer.shadowOpacity = 0.1
        collVwImgs.layer.shadowOffset = CGSize(width: 0, height: 1)
        collVwImgs.layer.shadowRadius = 2
        collVwImgs.layer.masksToBounds = false

        
        let nibComments = UINib(nibName: "ReviewCommentsTVC", bundle: nil)
        tblVwComments.register(nibComments, forCellReuseIdentifier: "ReviewCommentsTVC")
        tblVwComments.indicatorStyle = .black
        tblVwComments.isScrollEnabled = true
        tblVwComments.rowHeight = UITableView.automaticDimension
        tblVwComments.estimatedRowHeight = 44
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    private func setupRadarChart() {
        // Initialize radar chart
        radarChartView = RadarChartView()
        radarChartView.translatesAutoresizingMaskIntoConstraints = false
        viewSpiderGraph.addSubview(radarChartView)
        
        // Pin radar chart to all edges of viewSpiderGraph
        NSLayoutConstraint.activate([
            radarChartView.topAnchor.constraint(equalTo: viewSpiderGraph.topAnchor),
            radarChartView.bottomAnchor.constraint(equalTo: viewSpiderGraph.bottomAnchor),
            radarChartView.leadingAnchor.constraint(equalTo: viewSpiderGraph.leadingAnchor),
            radarChartView.trailingAnchor.constraint(equalTo: viewSpiderGraph.trailingAnchor),
        ])
    }
    
    private func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [RadarChartDataEntry] = []
        for value in values {
            dataEntries.append(RadarChartDataEntry(value: value))
        }
        
        let chartDataSet = RadarChartDataSet(entries: dataEntries, label: "Performance")
        chartDataSet.fillColor = UIColor(hex: "#3E9C35").withAlphaComponent(0.5)
        chartDataSet.drawFilledEnabled = true
        chartDataSet.lineWidth = 2
        chartDataSet.colors = [.app]
        
        
        let chartData = RadarChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        
        radarChartView.data = chartData
        radarChartView.rotationEnabled = false
        radarChartView.legend.enabled = false
        
        radarChartView.webLineWidth = 1.70
        radarChartView.innerWebLineWidth = 1.70
        radarChartView.webColor = UIColor(hex: "#C4C4C4")
        
        //change color
        radarChartView.innerWebColor = UIColor(hex: "#C4C4C4")
        
        // X axis (labels like arrParts)
        
        radarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        radarChartView.xAxis.labelFont = .systemFont(ofSize: 12)
        radarChartView.xAxis.labelTextColor = UIColor(hex: "#2A2A2A")
        
        // Y axis
        radarChartView.yAxis.axisMinimum = 0
        radarChartView.yAxis.axisMaximum = 80
        radarChartView.yAxis.labelCount = 5
        radarChartView.yAxis.drawLabelsEnabled = false
        
        radarChartView.animate(yAxisDuration: 1.5)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.radarChartView.notifyDataSetChanged()
        })
    }

    func getReviewApi(completion: @escaping ([String: Double]) -> Void) {
        viewModel.getUserMomentReviews(userId: Store.UserDetail?["userId"] as? String ?? "") { data in
            let avgCommunication = Double(data?.averageRatings?.avgCommunication ?? 0)
            let avgSpeed = Double(data?.averageRatings?.avgSpeed ?? 0)
            let avgQuality = Double(data?.averageRatings?.avgQuality ?? 0)
            let avgAttitude = Double(data?.averageRatings?.avgAttitude ?? 0)
            let avgReliability = Double(data?.averageRatings?.avgReliability ?? 0)

            let values: [String: Double] = [
                "avgCommunication": avgCommunication,
                "avgSpeed": avgSpeed,
                "avgQuality": avgQuality,
                "avgAttitude": avgAttitude,
                "avgReliability": avgReliability
            ]

            // Print each value with one decimal place
            for (key, value) in values {
                print(String(format: "%@ = %.1f", key, value))
            }
            let rating = data?.averageRatings?.overallAverage ?? 0
            let colors = self.colorsForRating(rating)
            self.descriptionText = data?.averageRatings?.selfReview ?? ""
            self.lblDescription.appendReadmore(after: data?.averageRatings?.selfReview ?? "", trailingContent: .readmore)
            self.lblReviewType.textColor = colors.textColor
            self.viewReviewtype.borderCol = colors.borderColor
            self.viewReviewtype.backgroundColor = colors.backgroundColor

            self.lblReviewType.text = self.getRatingLabel(score: data?.averageRatings?.overallAverage ?? 0)  // Convert Float to Double
            if let ratingImageName = self.getRatingImageName(score: data?.averageRatings?.overallAverage ?? 0) {
                self.imgVwReviewType.image = UIImage(named: ratingImageName)
            } else {
                self.imgVwReviewType.image = UIImage(named: "meh") // Replace with your default image
            }

            completion(values)
        }
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

    func colorsForRating(_ rating: Double) -> (textColor: UIColor, borderColor: UIColor, backgroundColor: UIColor) {
        switch rating {
        case 20...40:
            return (UIColor(hex: "#4CAF50"), UIColor(hex: "#4CAF50"), UIColor(hex: "#DAFFDC")) // Green shades
        case 40...60:
            return (UIColor(hex: "#FFD700"), UIColor(hex: "#FFD700"), UIColor(hex: "#FFF8D3")) // Gold shades
        case 60...80:
            return (UIColor(hex: "#FF4210"), UIColor(hex: "#FF4210"), UIColor(hex: "#FFE4DD")) // Deep Orange shades
        case 80...100:
            return (UIColor(hex: "#3F51B5"), UIColor(hex: "#3F51B5"), UIColor(hex: "#D5DCFF")) // Indigo shades
        default:
            return (UIColor(hex: "#A0A0A0"), UIColor(hex: "#A0A0A0"), UIColor(hex: "#F0F0F0")) // Gray shades
        }
    }

    private func getRatingLabel(score: Double) -> String {
        switch score {
        case 0...20:
            return "Meh"
        case 20...40:
            return "Okayish"
        case 40...60:
            return "Good"
        case 60...80:
            return "Fire"
        case 80...100:
            return "Awesome"
        default:
            return "Unknown"
        }
    }

    private func getRatingImageName(score: Double) -> String? {
        switch score {
        case 0...20:
            return "meh"          // Replace with actual asset name
        case 21...40:
            return "okayish"
        case 41...60:
            return "good"
        case 61...80:
            return "ic_fire"
        case 81...100:
            return "awesome"
        default:
            return nil
        }
    }


    func getMediaApi(page: Int, limit: Int, completion: @escaping () -> Void) {
        viewModel.getMediaApi(page: page, limit: limit) { data in
            
            self.arrImgs = data?.reviewMedia ?? []
            self.collVwImgs.reloadData()
            self.adjustCollectionViewWidth()

            completion()
        }
    }
    func getCommentsApi(page: Int, limit: Int, completion: @escaping () -> Void) {
        viewModel.getCommentsApi(page: page, limit: limit) { data in
            if let newComments = data?.reviewComments {
                self.arrComments.append(contentsOf: newComments)
            }

            self.totalPages = data?.totalPages ?? 0
            self.tblVwComments.reloadData()
            self.tblVwComments.layoutIfNeeded()

            // Dynamically set height based on content
           // self.heightTblvwComments.constant = self.tblVwComments.contentSize.height
            self.heightTblvwComments.constant = min(self.tblVwComments.contentSize.height, 150)

            self.isLoading = false
            completion()
        }
    }

    func adjustCollectionViewWidth() {
        let cellWidth: CGFloat = 52
        let spacing: CGFloat = 0
        let maxVisibleItems = 5

        let itemCount = min(arrImgs.count, maxVisibleItems)
        let totalSpacing = CGFloat(itemCount - 1) * spacing
        let totalWidth = CGFloat(itemCount) * cellWidth + totalSpacing

        widthCollVwImgs.constant = totalWidth
        collVwImgs.layoutIfNeeded()
    }


    //MARK: - IBAction
    @IBAction func actionEditSelfReview(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddSelfReviewVC") as! AddSelfReviewVC
        vc.isEdit = true
        vc.isComing = true
        vc.callBack = {[weak self] in
            guard let self = self else { return }
            viewDidLoad()
        }
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func actionScreenShot(_ sender: UIButton) {
        takeScreenshotAndCrop()
    }
    private func takeScreenshotAndCrop() {
        let renderer = UIGraphicsImageRenderer(size: self.view.bounds.size)
        let image = renderer.image { ctx in
            self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        }
        self.capturedImage = image
        let cropVC = TOCropViewController(image: image)
        cropVC.delegate = self
        cropVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(cropVC, animated: false)
        
    }
    
    @IBAction func actionLeftArrow(_ sender: UIButton) {
    }
    @IBAction func actionRightArrow(_ sender: UIButton) {
    }
    
    @IBAction func actionBAck(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: - UICollectionViewDelegate
extension SelfReviewFileVC:TOCropViewControllerDelegate{
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: false) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            showSwiftyAlert("Saved", "Cropped image saved to Photos.",true)
            self.navigationController?.popViewController(animated: false)
        }
    }
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: false) {
            self.navigationController?.popViewController(animated: false)
        }
    }

}
//MARK: - UICollectionViewDelegate
extension SelfReviewFileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrImgs.count > 0{
            return arrImgs.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewImagesCVC", for: indexPath) as! ReviewImagesCVC
        cell.imgVwReview.imageLoad(imageUrl: arrImgs[indexPath.row].media ?? "")
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewReviewImagesVC") as! ViewReviewImagesVC
        vc.arrImgs = arrImgs
        vc.index = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
}
//MARK: -UITableViewDelegate
extension SelfReviewFileVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrComments.count > 0{
            return arrComments.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCommentsTVC", for: indexPath) as! ReviewCommentsTVC
        cell.lblComment.text = arrComments[indexPath.row].comment ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
//    // ✅ Pagination trigger
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        if indexPath.row == arrComments.count - 1 && currentPage < totalPages && isLoading == false {
//            isLoading = true
//            currentPage += 1
//            getCommentsApi(page: currentPage, limit: 5) {
//                self.tblVwComments.reloadData()
//            }
//        }
//    }

    
}
