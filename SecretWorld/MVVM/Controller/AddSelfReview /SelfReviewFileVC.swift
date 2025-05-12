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
    //rating image names: -  oneRating twoRating threeRating  fourRating fiveRating
    //arrow btn  name enable and disables : --leftEnablbtn rightEnableBtn leftDisableBtn rightDisableBtn
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
    var capturedImage: UIImage?
    var radarChartView: RadarChartView!
    let arrParts = ["Communication", "Speed", "Quality", "Attitude", "Reliability"]
    let arrValues = [1.0, 3.0, 5.0, 2.0, 5.0]
    var arrImgs = ["near","aboutServices","near","aboutServices","near","aboutServices"]

    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
        setupRadarChart()
        setChart(dataPoints: arrParts, values: arrValues)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Adjust table view height
        tblVwComments.layoutIfNeeded()
        heightTblvwComments.constant = tblVwComments.contentSize.height
        
        // Adjust collection view width
        adjustCollectionViewWidth()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func uiSet(){
        
        lblReviewCategory.font = UIFont(name: "Cinzel-Bold", size: 35.88)
        lblReviewType.font = UIFont(name: "DancingScript-Bold", size: 15)

        let nibImgs = UINib(nibName: "ReviewImagesCVC", bundle: nil)
        collVwImgs.register(nibImgs, forCellWithReuseIdentifier: "ReviewImagesCVC")
        collVwImgs.layer.shadowColor = UIColor.black.cgColor
        collVwImgs.layer.shadowOpacity = 0.1
        collVwImgs.layer.shadowOffset = CGSize(width: 0, height: 1)
        collVwImgs.layer.shadowRadius = 2
        collVwImgs.layer.masksToBounds = false
        collVwImgs.reloadData()
        adjustCollectionViewWidth()

        
        let nibComments = UINib(nibName: "ReviewCommentsTVC", bundle: nil)
        tblVwComments.register(nibComments, forCellReuseIdentifier: "ReviewCommentsTVC")
        tblVwComments.isScrollEnabled = false
        tblVwComments.rowHeight = UITableView.automaticDimension
        tblVwComments.estimatedRowHeight = 44
        tblVwComments.reloadData()
        tblVwComments.layoutIfNeeded()
        heightTblvwComments.constant = tblVwComments.contentSize.height
        
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
        radarChartView.yAxis.axisMaximum = 5
        radarChartView.yAxis.labelCount = 6
        radarChartView.yAxis.drawLabelsEnabled = false
        
        radarChartView.animate(yAxisDuration: 1.5)
    }
    
    //MARK: - IBAction
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
        return arrImgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewImagesCVC", for: indexPath) as! ReviewImagesCVC
        cell.imgVwReview.image = UIImage(named: arrImgs[indexPath.row])
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewReviewImagesVC") as! ViewReviewImagesVC
        vc.arrImgs = arrImgs
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCommentsTVC", for: indexPath) as! ReviewCommentsTVC
        
        return cell
    }
    
    
}
