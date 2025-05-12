//
//  AnalysisVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 02/01/25.
//

import UIKit
import Charts

class AnalysisVC: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblTotalCount: UILabel!
    @IBOutlet var btnBartChartTYpe: UIButton!
    @IBOutlet var lblBarChartTYpe: UILabel!
    @IBOutlet var heightVwLineGraph: NSLayoutConstraint!
    @IBOutlet var btnProductAnalysis: UIButton!
    @IBOutlet var viewStoreGraph: BarChartView!
    @IBOutlet var viewProductGraph: LineChartView!
    @IBOutlet weak var lblProduct: UILabel!
    
    //MARK: - variables
    var arrMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var arrWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var arrYear = ["2021","2022","2023","2024","2025"]
    var weeklyData = [0, 0, 0, 0, 0, 0, 0]
    var monthlyData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var yearlyData = [0,0,0,0,0]
    var viewModel = AnalyticsVM()
    var serviceId = ""
    var arrProduct = [ServiceDetail]()
    var viewModelProduct = AddServiceVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSet()
    }
    func uiSet(){
        getAnalyticsApi(period: "weekly")
        getProductApi()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    @objc func handleSwipe() {
        navigationController?.popViewController(animated: true)
    }
    func getDayFromString(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // The format of the input date string
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "EE" // Full day name (e.g., Monday, Tuesday)
            return dateFormatter.string(from: date)
        }
        return nil
    }
    func getMonthFromString(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MM"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func getYearFromString(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func getAnalyticsApi(period:String){
        viewModel.AnalyticsApi(type: 3, period: period,serviceId: "") { data in
            self.lblTotalCount.text = "\(data?.totalCount ?? 0)"
            self.imgVwUser.imageLoad(imageUrl: data?.profile_photo ?? "")
            self.weeklyData = [0,0,0,0,0,0,0]
            self.monthlyData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            self.yearlyData = [0,0,0,0,0]
            if period == "weekly"{
                for i in data?.hitCounts ?? [] {
                    let dateString = i.date ?? ""
                    if let dayName = self.getDayFromString(dateString: dateString) {
                        print("The day is \(dayName)")
                        let dayIndexMap: [String: Int] = [
                            "Mon": 0,
                            "Tue": 1,
                            "Wed": 2,
                            "Thu": 3,
                            "Fri": 4,
                            "Sat": 5,
                            "Sun": 6
                        ]
                        
                        if let dayIndex = dayIndexMap.first(where: { dayName.contains($0.key) })?.value {
                            self.weeklyData.remove(at: dayIndex)
                            self.weeklyData.insert(i.count ?? 0, at: dayIndex)
                        }
                    } else {
                        print("Invalid date format")
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                    self.setBarChartData(dataPoints: self.arrWeek, values: self.weeklyData)
                    
                }
            }else if period == "monthly"{
                for i in data?.hitCounts ?? [] {
                    let dateString = i.date ?? ""
                    if let dayName = self.getMonthFromString(dateString: dateString) {
                        print("The Month is \(dayName)")
                        let dayIndexMap: [String: Int] = [
                            "01": 0,
                            "02": 1,
                            "03": 2,
                            "04": 3,
                            "05": 4,
                            "06": 5,
                            "07": 6,
                            "08": 7,
                            "09": 8,
                            "10": 9,
                            "11": 10,
                            "12": 11
                            
                        ]
                        
                        if let dayIndex = dayIndexMap.first(where: { dayName.contains($0.key) })?.value {
                            self.monthlyData.remove(at: dayIndex)
                            self.monthlyData.insert(i.count ?? 0, at: dayIndex)
                        }
                    } else {
                        print("Invalid date format")
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                    
                    self.setBarChartData(dataPoints: self.arrMonths, values: self.monthlyData)
                    
                }
                
            }else{
                for i in data?.hitCounts ?? [] {
                    let dateString = i.date ?? ""
                    if let dayName = self.getYearFromString(dateString: dateString) {
                        print("The Month is \(dayName)")
                        let dayIndexMap: [String: Int] = [
                            "2021": 0,
                            "2022": 1,
                            "2023": 2,
                            "2024": 3,
                            "2025": 4]
                        
                        if let dayIndex = dayIndexMap.first(where: { dayName.contains($0.key) })?.value {
                            self.yearlyData.remove(at: dayIndex)
                            self.yearlyData.insert(i.count ?? 0, at: dayIndex)
                        }
                    } else {
                        print("Invalid date format")
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                    
                    self.setBarChartData(dataPoints: self.arrYear, values: self.yearlyData)
                    
                }
            }
            
        }
    }
    func getProductAnalytics(period:String,serviceId:String){
        viewModel.AnalyticsApi(type: 4, period: period,serviceId: serviceId) { data in
            if data?.totalCount ?? 0 > 0{
                self.viewProductGraph.isHidden = false
            }else{
                self.viewProductGraph.isHidden = true
            }
            self.lblTotalCount.text = "\(data?.totalCount ?? 0)"
            self.weeklyData = [0,0,0,0,0,0,0]
            self.monthlyData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            self.yearlyData = [0,0,0,0,0]
            if period == "weekly"{
                for i in data?.hitCounts ?? [] {
                    let dateString = i.date ?? ""
                    if let dayName = self.getDayFromString(dateString: dateString) {
                        print("The day is \(dayName)")
                        let dayIndexMap: [String: Int] = [
                            "Mon": 0,
                            "Tue": 1,
                            "Wed": 2,
                            "Thu": 3,
                            "Fri": 4,
                            "Sat": 5,
                            "Sun": 6
                        ]
                        
                        if let dayIndex = dayIndexMap.first(where: { dayName.contains($0.key) })?.value {
                            self.weeklyData.remove(at: dayIndex)
                            self.weeklyData.insert(i.count ?? 0, at: dayIndex)
                        }
                    } else {
                        print("Invalid date format")
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                    self.setupLineChart(dataPoints: self.arrWeek, values: self.weeklyData)
                    
                }
            }else if period == "monthly"{
                for i in data?.hitCounts ?? [] {
                    let dateString = i.date ?? ""
                    if let dayName = self.getMonthFromString(dateString: dateString) {
                        print("The Month is \(dayName)")
                        let dayIndexMap: [String: Int] = [
                            "01": 0,
                            "02": 1,
                            "03": 2,
                            "04": 3,
                            "05": 4,
                            "06": 5,
                            "07": 6,
                            "08": 7,
                            "09": 8,
                            "10": 9,
                            "11": 10,
                            "12": 11
                            
                        ]
                        
                        if let dayIndex = dayIndexMap.first(where: { dayName.contains($0.key) })?.value {
                            self.monthlyData.remove(at: dayIndex)
                            self.monthlyData.insert(i.count ?? 0, at: dayIndex)
                        }
                    } else {
                        print("Invalid date format")
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                    self.setupLineChart(dataPoints: self.arrMonths, values: self.monthlyData)
                    
                }
                
            }else{
                for i in data?.hitCounts ?? [] {
                    let dateString = i.date ?? ""
                    if let dayName = self.getYearFromString(dateString: dateString) {
                        print("The Month is \(dayName)")
                        let dayIndexMap: [String: Int] = [
                            "2021": 0,
                            "2022": 1,
                            "2023": 2,
                            "2024": 3,
                            "2025": 4]
                        
                        if let dayIndex = dayIndexMap.first(where: { dayName.contains($0.key) })?.value {
                            self.yearlyData.remove(at: dayIndex)
                            self.yearlyData.insert(i.count ?? 0, at: dayIndex)
                        }
                    } else {
                        print("Invalid date format")
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                    self.setupLineChart(dataPoints: self.arrYear, values: self.yearlyData)
                    
                    
                }
            }
            
        }
    }
    func getProductApi(){
        viewModelProduct.getAllService(loader: false, offSet: 1, limit: 20) { data in
            self.arrProduct = data?.service ?? []
            
        }
    }
    //MARK: - Set Chart Data
    func setBarChartData(dataPoints: [String], values: [Int]) {
        let customRenderer = MyBarChartRenderer(dataProvider: viewStoreGraph,
                                                animator: viewStoreGraph.chartAnimator,
                                                viewPortHandler: viewStoreGraph.viewPortHandler)
        // Set the custom renderer
        viewStoreGraph.renderer = customRenderer
        
        var dataEntries: [BarChartDataEntry] = []
        var barColors: [UIColor] = []
        
        // Assign different colors to each weekday
        let colors: [UIColor] = [
            UIColor.red, // Monday
            UIColor.orange, // Tuesday
            UIColor.blue, // Wednesday
            UIColor.brown, // Thursday
            UIColor.blue, // Friday
            UIColor.purple, // Saturday
            UIColor.cyan // Sunday
        ]
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
            
            // Assign the color for the corresponding day
            barColors.append(colors[i % colors.count])
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Weekly Data")
        chartDataSet.colors = barColors // Set colors for each bar
        chartDataSet.drawValuesEnabled = true
        
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.barWidth = 0.5
        viewStoreGraph.isUserInteractionEnabled = false
        viewStoreGraph.data = chartData
        
        // Customize X-Axis
        let xAxis = viewStoreGraph.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        xAxis.granularity = 1
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        
        // Customize Left Y-Axis
        let leftAxis = viewStoreGraph.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = false
        
        // Disable Right Y-Axis
        viewStoreGraph.rightAxis.enabled = false
        
        // Customize Chart Appearance
        viewStoreGraph.legend.enabled = false
        viewStoreGraph.animate(yAxisDuration: 1.5)
    }
    
    
    //MARK: - Setup Line Chart with Gradient Fill
    func setupLineChart(dataPoints: [String], values: [Int]) {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "")
        chartDataSet.colors = [UIColor(hex: "#3E9C35")] // Line color
        chartDataSet.lineWidth = 2.0
        chartDataSet.drawCirclesEnabled = false // No circle at data points
        chartDataSet.mode = LineChartDataSet.Mode.horizontalBezier // Smooth curve
        chartDataSet.drawValuesEnabled = false // Hide data values
        
        // Gradient fill
        let gradientColors = [UIColor(hex: "#3E9C35").withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: [0.0, 1.0])!
        chartDataSet.fill = LinearGradientFill(gradient: gradient, angle: 90.0)
        chartDataSet.drawFilledEnabled = true
        
        let chartData = LineChartData(dataSet: chartDataSet)
        viewProductGraph.data = chartData
        
        // Customize X-Axis
        let xAxis = viewProductGraph.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        xAxis.granularity = 1
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = true
        xAxis.gridLineWidth = 0.5
        xAxis.gridColor = UIColor.lightGray
        
        // Customize Left Y-Axis
        let leftAxis = viewProductGraph.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.gridLineWidth = 0.5
        leftAxis.gridColor = UIColor.lightGray
        
        // Disable Right Y-Axis
        viewProductGraph.rightAxis.enabled = false
        
        // Customize Chart Appearance
        viewProductGraph.legend.enabled = false
        viewProductGraph.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        viewProductGraph.isUserInteractionEnabled = false
        viewProductGraph.backgroundColor = UIColor.white
    }
    
    @IBAction func actionStoreCHartType(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
        vc.type = "graphType"
        vc.callBack = {[weak self] type,title,id in
            guard let self = self else { return }
            self.lblBarChartTYpe.text = title
            switch title {
            case "Weekly":
                getAnalyticsApi(period: "weekly")
                if serviceId != "" {
                    getProductAnalytics(period: "weekly", serviceId: serviceId)
                }
            case "Monthly":
                getAnalyticsApi(period: "monthly")
                if serviceId != "" {
                    getProductAnalytics(period: "monthly", serviceId: serviceId)
                }
            case "Yearly":
                print("Yearly")
                getAnalyticsApi(period: "yearly")
                if serviceId != "" {
                    getProductAnalytics(period: "yearly", serviceId: serviceId)
                }
            default:
                break
            }
            
        }
        vc.modalPresentationStyle = .popover
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .up
        vc.preferredContentSize = CGSize(width: btnProductAnalysis.frame.size.width, height: 150)
        self.present(vc, animated: false)
        
    }
    @IBAction func actionProductAnalysis(_ sender: UIButton){
        view.endEditing(true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "GigPopOversVC") as! GigPopOversVC
        vc.type = "Product"
        vc.arrProduct = self.arrProduct
        vc.callBack = {[weak self] type,title,id in
            self?.lblProduct.text = title
            self?.serviceId = id
            switch self?.lblBarChartTYpe.text{
            case "Weekly":
                self?.getProductAnalytics(period: "weekly", serviceId: self?.serviceId ?? "")
            case "Monthly":
                self?.getProductAnalytics(period: "monthly", serviceId: self?.serviceId ?? "")
            case "Yearly":
                print("Yearly")
                self?.getProductAnalytics(period: "yearly", serviceId: self?.serviceId ?? "")
            default:
                break
            }
            
        }
        vc.modalPresentationStyle = .popover
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .any
        vc.preferredContentSize = CGSize(
            width: CGFloat(btnProductAnalysis.frame.size.width),
            height: CGFloat(arrProduct.count * 50)
        )
        self.present(vc, animated: false)
        
    }
    
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
// MARK: - Popup
extension AnalysisVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
}

//MARK: - BarChartRenderer
class MyBarChartRenderer: BarChartRenderer {
    override func drawDataSet(context: CGContext, dataSet: BarChartDataSetProtocol, index: Int) {
        guard let barDataProvider = dataProvider else { return }
        let trans = barDataProvider.getTransformer(forAxis: dataSet.axisDependency)
        var barRectBuffer = CGRect()
        
        context.saveGState()
        context.beginTransparencyLayer(auxiliaryInfo: .none)
        
        for i in stride(from: dataSet.entryCount - 1, through: 0, by: -1) {
            guard let e = dataSet.entryForIndex(i) as? BarChartDataEntry else { continue }
            
            let x = e.x
            let y = e.y
            let left = x - 0.2
            let right = x + 0.2
            let top = y >= 0.0 ? y : 0.0
            let bottom = y <= 0.0 ? y : 0.0
            
            barRectBuffer.origin.x = CGFloat(left)
            barRectBuffer.size.width = CGFloat(right - left)
            barRectBuffer.origin.y = CGFloat(top)
            barRectBuffer.size.height = CGFloat(bottom - top)
            
            trans.rectValueToPixel(&barRectBuffer)
            
            // Calculate the corner radius to make the bars fully rounded
            let cornerRadius = barRectBuffer.size.height / 2.0 // Make it fully rounded
            
            // Create a fully rounded rect path
            let path = UIBezierPath(roundedRect: barRectBuffer, cornerRadius: cornerRadius)
            
            context.addPath(path.cgPath)
            context.closePath()
            
            context.setFillColor(dataSet.color(atIndex: i).cgColor)
            context.drawPath(using: .fill)
            
            // Draw label on top of the bar
            let label = String(format: "%.0f", e.y)
            let labelAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.black
            ]
            
            let labelSize = (label as NSString).size(withAttributes: labelAttributes)
            let labelX = barRectBuffer.origin.x + (barRectBuffer.size.width - labelSize.width) / 2
            let labelY = barRectBuffer.origin.y - labelSize.height - 2 // A little padding above the bar
            
            let labelRect = CGRect(x: labelX, y: labelY, width: labelSize.width, height: labelSize.height)
            label.draw(in: labelRect, withAttributes: labelAttributes)
        }
        
        context.endTransparencyLayer()
        context.restoreGState()
    }
}
