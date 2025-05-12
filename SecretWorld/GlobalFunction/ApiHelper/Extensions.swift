//
//  Extensions.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 24/01/24.
//

import Foundation
import UIKit
import Kingfisher
import NVActivityIndicatorView
import AVFoundation
//MARK: EXTENSION UI-TEXT-FIELD PASSWORD HIDE - SHOW
extension UITextField {
    func togglePasswordVisibility() {
        isSecureTextEntry = !isSecureTextEntry
        if let existingText = text, isSecureTextEntry {
            text = nil
            insertText(existingText)
            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }
    }
    func setInputViewDatePicker(target: Any, selector: Selector, for: UIControl.Event ) {
           let screenWidth = UIScreen.main.bounds.width
           let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
           datePicker.datePickerMode = .date //2
           datePicker.minimumDate = Date()
           if #available(iOS 14, *) {// Added condition for iOS 14
             datePicker.preferredDatePickerStyle = .wheels
             datePicker.sizeToFit()
           }
           self.inputView = datePicker //3
         
           // Create a toolbar and assign it to inputAccessoryView
           let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
//           let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
//           let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
//           toolBar.setItems([cancel, flexible, barButton], animated: false) //8
           self.inputAccessoryView = toolBar //9
       }
       
     
}

//MARK: EXTENSION UIVIEW - CONTROLLER
extension UIViewController{
    //GuestLoginAlert
    func guestLoginAlert(){
        
        let alert = UIAlertController(title: "Alert", message: "Please Login first.",   preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { action in

    let storyboard = AppStoryboard.Main.instance
            let vc = storyboard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
          
            let navControl = UINavigationController(rootViewController: vc)
            navControl.isNavigationBarHidden = true
            if let window = UIApplication.shared.windows.first{
                window.rootViewController = navControl
                window.makeKeyAndVisible()
            }

        }))
        alert.addAction(UIAlertAction(title: "Not now", style: .default, handler: { action in
//            self.dismiss(animated: true, completion: nil)
            self.tabBarController?.selectedIndex = 0

        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getPageCount(TotalCount : Int) -> Int{
        var num = TotalCount
        let reminder = num % 50
        print(reminder)
        if reminder != 0{
            num = TotalCount/50
            num = num + 1

        }else{
            num = TotalCount/50
        }
        return num
    }
    func calculatePercentage(value:Double,percentageVal:Double)->Double{
       let val = value * percentageVal
       return val / 100.0
   }

    func sendRequest(){
        
        let alert = UIAlertController(title: "Just Ask", message: "Please request for product.",   preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
           self.tabBarController?.selectedIndex = 0
        }))

        self.present(alert, animated: true, completion: nil)
    }
    func string_date_ToDateChatList(_ date:String?,currentFormat:dateFormat,requiredFormat:dateFormat) -> String
    {
        if let dateStr = date
        {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = currentFormat.rawValue
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let date = dateFormatter.date(from: dateStr)
            return dateConverter(date, format: requiredFormat)
        }
        return ""
    }
    func string_date_ToDate(_ date:String?,currentFormat:dateFormat,requiredFormat:dateFormat) -> String
    {
        if let dateStr = date
        {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = currentFormat.rawValue
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let date = dateFormatter.date(from: dateStr)
            return dateConverter(date, format: requiredFormat)
        }
        return ""
    }

    func dateConverter(_ date:Date?,format:dateFormat) -> String
    {
        if let date = date
        {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = format.rawValue
            let strDate = dateFormatter.string(from: date)
            return strDate
        }
        return ""
    }
    //POP VC
    @IBAction public func popViewController(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

extension String {
    
    func convertToDateFormate(current: String, convertTo: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = current
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        dateFormatter.dateFormat = convertTo
        return  dateFormatter.string(from: date)
    }

    
    var isBlank : Bool
    {
        if self.count == 0 || self.trimmingCharacters(in: .whitespaces).count == 0{
            return true
        }else{
            return false
        }
    }
    
    var intValue:     Int?        { return NumberFormatter().number(from: self)?.intValue    }
    var int8Value:    Int8?       { return NumberFormatter().number(from: self)?.int8Value   }
    var int16Value:   Int16?      { return NumberFormatter().number(from: self)?.int16Value  }
    var int32Value:   Int32?      { return NumberFormatter().number(from: self)?.int32Value  }
    var int64Value:   Int64?      { return NumberFormatter().number(from: self)?.int64Value  }
    var floatValue:   Float?      { return NumberFormatter().number(from: self)?.floatValue  }
    var doubleValue:  Double?     { return NumberFormatter().number(from: self)?.doubleValue }
    var boolValue:    Bool?       { return NumberFormatter().number(from: self)?.boolValue   }
    var decimalValue: Decimal?    { return NumberFormatter().number(from: self)?.decimalValue}
    var binaryValue:  Data?       { return self.data(using: .utf8)                           }
    
    var isAlphanumericWithWhiteSpace: Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Z0-9a-z ].*", options: [])
        if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
            return false
        }else{
            return true
        }
    }
    
    var isOnlyAlphanumeric: Bool {
        return !isEmpty && self.onlyNumbers && self.onlyAlphabet
    }
    
    var isAlphanumeric: Bool {
        
        let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9]", options: [])
        if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
            return false
        }else{
            return true
        }
        // return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    //MARK:-isValidPassword-
    var isValidPassword: Bool
    {
        if (self.isEmpty){return false}
        
        let passRegEx =  "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        
        //        let passRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,20}"
        let passwordTest=NSPredicate(format: "SELF MATCHES %@", passRegEx);
        return passwordTest.evaluate(with: self)
    }
    var removeWhiteSpace:String{
        return self.trimmingCharacters(in: .whitespaces)
    }
    var trimWhiteSpace: String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isValidEmail: Bool {
        get{
            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            return !emailPredicate.evaluate(with: self)
        }
    }
    
    var checkSpecial: Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9 ].*", options: [])
        if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
            return false
            
        }else{
            return true
        }
    }
    
    var checkAddress: Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9._@#/()-+*., ].*", options: [])
        if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
            return false
            
        }else{
            return true
        }
    }
    
    var onlyNumbers: Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^0-9].*", options: [])
        if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
            return false
        }else{
            return true
        }
    }
    var isPhoneNumber: Bool
    {
        let phone_regex = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phone_regex)
        return !self.isEmpty && phoneTest.evaluate(with: self)
    }
    var onlyNumbersExpressionPlus: Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^0-9+].*", options: [])
        if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
            return false
        }else{
            return true
        }
    }
    var onlyAlphabet: Bool{
        
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z].*", options: [])
        if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
            return false
        }else{
            return true
        }
    }
    var isAlphabetWithSpace: Bool{
        
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
        if regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil {
            return false
        }else{
            return true
        }
    }
    
    func safelyLimitedTo(length n: Int)->String {
        let c = String(self)
        if (c.count <= n) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
    
    // convert string date to Date
    func timeZoneDateFormatter(timeZone :String = "UTC", localFormat:String = "MM-dd-yyyy EEE,HH:mm:ss" , serverFormat:String = "yyyy-MM-dd,HH:mm:ss") -> (date:Date?,dateTimeStr:String?,timeStr:String?){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = serverFormat
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        let date = dateFormatter.date(from: self)// create date from string
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = localFormat
        dateFormatter.timeZone =  TimeZone.current
        
        let dateStamp = dateFormatter.string(from: date!)
        dateFormatter.dateFormat = "h:mm a"
        let time = dateFormatter.string(from: date!)
        return (date,dateStamp,time)
        
    }
    
    var urlQueryAllowed:String?{
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }

        func spacedDigits() -> String {
            var result = ""
            for character in self {
                if character.isNumber {
                    result.append(character)
                    result.append(" ")
                } else {
                    result.append(character)
                }
            }
            return result.trimmingCharacters(in: .whitespaces)
        }
    
}


//MARK: SHOW - IMAGE PICKER
extension UIImageView{
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
          let blurEffectView = UIVisualEffectView(effect: blurEffect)
          blurEffectView.frame = bounds
          blurEffectView.alpha = 0.3
          blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
          addSubview(blurEffectView)
    }
    func imageLoad(imageUrl:String)   {
        
        let url = URL(string:imageUrl)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "dummy"),
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    func LoadSocial(imageUrl:String)   {
        let base = imageURL
        let url = URL(string:  base + imageUrl)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url)
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "dummy"),
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    func loadCategoryImg(imageUrl:String)   {
       
        let url = URL(string: imageUrl)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "no-image"),
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    func imageLoadProfile(imageUrl:String)   {
        let url = URL(string:imageUrl)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "dummy"),
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    func loadWalkthroughImg(imageUrl:String)   {
        let url = URL(string:imageUrl)
        self.kf.indicatorType = .activity
        DispatchQueue.main.async {
            self.kf.setImage(
                with: url,
                placeholder: UIImage(named: "dummy"),
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        }
       
    }
}
extension Collection {
    public func chunk(n: IndexDistance) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            j = index(i, offsetBy: n, limitedBy: endIndex) ?? endIndex
            res.append(self[i..<j])
            i = j
        }
        return res
    }
}

extension String {
    func chunkFormatted(withChunkSize chunkSize: Int = 4,
        withSeparator separator: Character = " ") -> String {
        return filter { $0 != separator }.chunk(n: chunkSize)
            .map{ String($0) }.joined(separator: String(separator))
    }
}

extension String{
   
    func htmlAttributed(family: String?, size: CGFloat,textColor:UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(size)pt !important;" +
                "font-family: \(family ?? "Poppins"), Poppins !important;" +
                 "color: #FFFFFF !important;" +
                
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    var withoutHtmlTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}


//MARK: CONVERT TIME STAMP TO DATE
extension Int{
    func convertTimeStampToDate(timeStamp:Int) -> Date {
        var unixTimestamp = timeStamp
        if timeStamp == 0{
            unixTimestamp = 1576213261
        }
        let date = Date(timeIntervalSince1970: TimeInterval((unixTimestamp)))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let postDateString = dateFormatter.string(from: date)
        return dateFormatter.date(from: postDateString) ?? Date()
    }
}
extension Date {

func getElapsedInterval() -> String {

    let interval = Calendar.current.dateComponents([.year, .month, .day,.hour,.minute,.second], from: self, to: Date())

    if let year = interval.year, year > 0 {
        return year == 1 ? "\(year)" + " " + "year ago" :
            "\(year)" + " " + "years ago"
    } else if let month = interval.month, month > 0 {
        return month == 1 ? "\(month)" + " " + "month ago" :
            "\(month)" + " " + "months ago"
    } else if let day = interval.day, day > 0 {
        return day == 1 ? "\(day)" + " " + "day ago" :
            "\(day)" + " " + "days ago"
    } else if let hour = interval.hour, hour > 0 {
        return hour == 1 ? "\(hour)" + " " + "hour ago" :
            "\(hour)" + " " + "hours ago"
    }else if let min = interval.minute, min > 0 {
        return min == 1 ? "\(min)" + " " + "minute ago" :
            "\(min)" + " " + "minutes ago"
    }
    else if let second = interval.second, second > 0 {
        return second == 1 ? "\(second)" + " " + "second ago" :
            "\(second)" + " " + "seconds ago"
    }else{
        return "a moment ago"
    }
    
    }
}

//MARK: ADD SEPRATOR IN STRING
extension Collection {
    func unfoldSubSequences(limitedTo maxLength: Int) -> UnfoldSequence<SubSequence,Index> {
        sequence(state: startIndex) { start in
            guard start < self.endIndex else { return nil }
            let end = self.index(start, offsetBy: maxLength, limitedBy: self.endIndex) ?? self.endIndex
            defer { start = end }
            return self[start..<end]
        }
    }

    func every(n: Int) -> UnfoldSequence<Element,Index> {
        sequence(state: startIndex) { index in
            guard index < endIndex else { return nil }
            defer { index = self.index(index, offsetBy: n, limitedBy: endIndex) ?? endIndex }
            return self[index]
        }
    }
    var pairs: [SubSequence] { .init(unfoldSubSequences(limitedTo: 2)) }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    mutating func insert<S: StringProtocol>(separator: S, every n: Int) {
        for index in indices.every(n: n).dropFirst().reversed() {
            insert(contentsOf: separator, at: index)
        }
    }
    func inserting<S: StringProtocol>(separator: S, every n: Int) -> Self {
        .init(unfoldSubSequences(limitedTo: n).joined(separator: separator))
    }
}

//MARK: CARD TYPE
enum CardType: String {
    case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay
    
    static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay]
    
    var regex : String {
        switch self {
        case .Amex:
            return "^3[47][0-9]{5,}$"
        case .Visa:
            return "^4[0-9]{6,}([0-9]{3})?$"
        case .MasterCard:
            return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
        case .Diners:
            return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .Discover:
            return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .JCB:
            return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .UnionPay:
            return "^(62|88)[0-9]{5,}$"
        case .Hipercard:
            return "^(606282|3841)[0-9]{5,}$"
        case .Elo:
            return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
        default:
            return ""
        }
    }
}



extension UITextField
{
    func validateCreditCardFormat()-> (type: CardType, valid: Bool) {
        // Get only numbers from the input string
        let input = self.text!
        
        let numberOnly = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        var type: CardType = .Unknown
        var formatted = ""
        var valid = false
        
        // detect card type
        for card in CardType.allCards {
            if (matchesRegex(regex: card.regex, text: numberOnly)) {
                type = card
                break
            }
        }
        
        // check validity
        valid = luhnCheck(number: numberOnly)
        
        // format
        var formatted4 = ""
        for character in numberOnly {
            if formatted4.count == 4 {
                formatted += formatted4 + " "
                formatted4 = ""
            }
            formatted4.append(character)
        }
        
        formatted += formatted4 // the rest
        
        // return the tuple
        return (type, valid)
    }
    
    func matchesRegex(regex: String!, text: String!) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = text as NSString
            let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
            return (match != nil)
        } catch {
            return false
        }
    }
    
    func luhnCheck(number: String) -> Bool {
        var sum = 0
        let digitStrings = number.reversed().map { String($0) }
        
        for (index,tuple) in digitStrings.enumerated() {
            guard let digit = Int(tuple) else { return false }
            
            let odd = index % 2 == 1
            
            switch (odd, digit) {
            case (true, 9):
                sum += 9
            case (true, 0...8):
                sum += (digit * 2) % 9
            default:
                sum += digit
            }
        }
        
        return sum % 10 == 0
    }
}


extension UITableView{
    
    func scrollToBottom(animated: Bool) {
        
        DispatchQueue.main.async {
            
            if self.contentSize.height > self.frame.height {
                
                // First figure out how many sections there are
                let lastSectionIndex = self.numberOfSections - 1
                
                // Then grab the number of rows in the last section
                let lastRowIndex = self.numberOfRows(inSection: lastSectionIndex) - 1
                
                // Now just construct the index path
                let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
                
                // Make the last row visible
                self.scrollToRow(at: pathToLastRow as IndexPath, at: UITableView.ScrollPosition.bottom, animated: false)
            }
        }
    }
    
}
extension UIImage {
    func blurredImage(with context: CIContext, radius: CGFloat, atRect: CGRect) -> UIImage? {
        guard let ciImg = CIImage(image: self) else { return nil }

        let cropedCiImg = ciImg.cropped(to: atRect)
        let blur = CIFilter(name: "CIGaussianBlur")
        blur?.setValue(cropedCiImg, forKey: kCIInputImageKey)
        blur?.setValue(radius, forKey: kCIInputRadiusKey)
        
        if let ciImgWithBlurredRect = blur?.outputImage?.composited(over: ciImg),
           let outputImg = context.createCGImage(ciImgWithBlurredRect, from: ciImgWithBlurredRect.extent) {
            return UIImage(cgImage: outputImg)
        }
        return nil
    }
}

public extension UIApplication {
    /// Sweeter: `keyWindow` for scene-based apps
    var legacyKeyWindow: UIWindow? {
        if #available(iOS 13, *) {
            return windows.first { $0.isKeyWindow }
        } else {
            return keyWindow
        }
    }

    /// Sweeter: Returns the currently top-most view controller.
    class func topViewController(base: UIViewController? = UIApplication.shared.legacyKeyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }

    /// Sweeter: Show `viewController` over the top-most view controller.
    class func present(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            topViewController()?.present(viewController, animated: animated, completion: completion)
        }
    }
}

public extension UIView {
    
    private static let kLayerNameGradientBorder = "GradientBorderLayer"
    
    func setGradientBorder(
        width: CGFloat,
        colors: [UIColor],
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1)
    ) {
        let existedBorder = gradientBorderLayer()
        let border = existedBorder ?? CAGradientLayer()
        border.frame = bounds
        border.colors = colors.map { return $0.cgColor }
        border.startPoint = startPoint
        border.endPoint = endPoint
        
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = width
        
        border.mask = mask
        
        let exists = existedBorder != nil
        if !exists {
            layer.addSublayer(border)
        }
    }
    
    func removeGradientBorder() {
        self.gradientBorderLayer()?.removeFromSuperlayer()
    }
    
    private func gradientBorderLayer() -> CAGradientLayer? {
        let borderLayers = layer.sublayers?.filter { return $0.name == UIView.kLayerNameGradientBorder }
        if borderLayers?.count ?? 0 > 1 {
            fatalError()
        }
        return borderLayers?.first as? CAGradientLayer
    }
}
