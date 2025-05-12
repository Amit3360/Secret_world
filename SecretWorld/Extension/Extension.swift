//
//  Extension.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 24/01/24.
//

import Foundation
import UIKit


//MARK: - UIImageView
extension UIImageView {
    static func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
              let source = CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        
        var images = [UIImage]()
        var duration: Double = 0
        
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil),
               let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [CFString: Any],
               let gifProperties = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any],
               let delayTime = gifProperties[kCGImagePropertyGIFDelayTime] as? Double {
                duration += delayTime
                images.append(UIImage(cgImage: image))
            }
        }
        
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        gifImageView.animationDuration = duration
        gifImageView.startAnimating()
        return gifImageView
    }
    

}
//MARK: - Textfield
extension UITextField{
    
    //MARK: - Validations
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func isValidPhone(phone: String) -> Bool {
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phoneTest.evaluate(with: phone)
        }
    @IBInspectable var cornerRadi: CGFloat {
       get {
         return layer.cornerRadius
       }
       set {
         layer.cornerRadius = newValue
         layer.masksToBounds = newValue > 0
       }
     }
    @IBInspectable override var borderWid: CGFloat {
       get {
         return layer.borderWidth
       }
       set {
         layer.borderWidth = newValue
       }
     }
    @IBInspectable override var borderCol: UIColor? {
       get {
         return UIColor(cgColor: layer.borderColor!)
       }
       set {
         layer.borderColor = newValue?.cgColor
       }
     }
    @IBInspectable var paddingLeftCustom: CGFloat {
         get {
             return leftView!.frame.size.width
         }
         set {
             let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
             leftView = paddingView
             leftViewMode = .always
         }
     }

     @IBInspectable var paddingRightCustom: CGFloat {
         get {
             return rightView!.frame.size.width
         }
         set {
             let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
             rightView = paddingView
             rightViewMode = .always
         }
     }
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    func setupRightImage(imageName:String){
      let imageView = UIImageView(frame: CGRect(x: 20, y: 12, width: 15, height: 15))
      imageView.image = UIImage(named: imageName)
      let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
      imageContainerView.addSubview(imageView)
      rightView = imageContainerView
      rightViewMode = .always
      self.tintColor = .lightGray
  }
}

//MARK: - Button

extension UIButton{
    
    @IBInspectable var cornerRadi: CGFloat {
       get {
         return layer.cornerRadius
       }
       set {
         layer.cornerRadius = newValue
         layer.masksToBounds = newValue > 0
       }
     }
    func removeBackgroundImage(for state: UIControl.State) {
           setBackgroundImage(nil, for: state)
       }
    @IBInspectable override var borderWid: CGFloat {
       get {
         return layer.borderWidth
       }
       set {
         layer.borderWidth = newValue
       }
     }
    @IBInspectable override var borderCol: UIColor? {
       get {
         return UIColor(cgColor: layer.borderColor!)
       }
       set {
         layer.borderColor = newValue?.cgColor
       }
     }
       func underline() {
         guard let text = self.titleLabel?.text else { return }
         let attributedString = NSMutableAttributedString(string: text)
         //NSAttributedStringKey.foregroundColor : UIColor.blue
         attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
         attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
         attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
         self.setAttributedTitle(attributedString, for: .normal)
       }
   }
//MARK: - LABLE
extension UILabel{
    @IBInspectable var cornerRadius: CGFloat {
       get {
         return layer.cornerRadius
       }
       set {
         layer.cornerRadius = newValue
         layer.masksToBounds = newValue > 0
       }
     }
    
    
   }

//MARK: - UIView
extension UIView{
    
    func animateRefreshAndRecenter() {
            UIView.animate(
                withDuration: 0.15,
                delay: 0,
                options: [.curveEaseInOut],
                animations: {
                    self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                },
                completion: { _ in
                    UIView.animate(withDuration: 0.15) {
                        self.transform = .identity // Return to original state
                    }
                }
            )
        }
    @IBInspectable var sbothTopcornerRadibotton: CGFloat {
            get {
                return layer.cornerRadius
            }
            set {
                layer.cornerRadius = newValue
                layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            }
        }
    @IBInspectable var sbothBottomCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    @IBInspectable var sRightBottomCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMaxXMaxYCorner]
            clipsToBounds = true  // Ensure the content doesn't exceed the rounded corners
        }
    }
    @IBInspectable var sLeftBottomCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMinXMaxYCorner]
            clipsToBounds = true  // Ensure the content doesn't exceed the rounded corners
        }
    }
    @IBInspectable var sRightTopCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMaxXMinYCorner]
            clipsToBounds = true  // Ensure the content doesn't exceed the rounded corners
        }
    }
    @IBInspectable var cornerRadiusView: CGFloat {
       get {
         return layer.cornerRadius
       }
       set {
         layer.cornerRadius = newValue
         layer.masksToBounds = newValue > 0
       }
     }
    @IBInspectable var borderWid: CGFloat {
      get {
        return layer.borderWidth
      }
      set {
        layer.borderWidth = newValue
      }
    }
    @IBInspectable var borderCol: UIColor? {
      get {
        return UIColor(cgColor: layer.borderColor!)
      }
      set {
        layer.borderColor = newValue?.cgColor
      }
    }
    
   }

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var startColor: UIColor = .white {
        didSet {
            updateGradient()
        }
    }
    
    @IBInspectable var endColor: UIColor = .black {
        didSet {
            updateGradient()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    private func updateGradient() {
        guard let gradientLayer = layer as? CAGradientLayer else { return }
               gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
               
               // Set the startPoint and endPoint for a horizontal gradient
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
          gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
}

@IBDesignable
class GradientButton: UIButton {
    
    // Define the colors for the gradient
    @IBInspectable var startColor: UIColor = UIColor.red {
        didSet {
            updateGradient()
        }
    }
    @IBInspectable var endColor: UIColor = UIColor.yellow {
        didSet {
            updateGradient()
        }
    }
    // Create gradient layer
    let gradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        // Set the gradient frame
        gradientLayer.frame = rect
        
        // Set the colors
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        // Gradient is linear from left to right
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        // Add gradient layer into the button
        layer.insertSublayer(gradientLayer, at: 0)
        
        // Round the button corners
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
    }

    func updateGradient() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
  
}



extension UIViewController{
    func applyGradientColor(to label: UILabel, with targetText: String, gradientColors: [Any]) {
          // Create a mutable attributed string
          let attributedString = NSMutableAttributedString(string: label.text ?? "")

          // Find the range of the target text
          let range = (label.text as NSString?)?.range(of: targetText)

          if let range = range {
              // Create a gradient layer
              let gradientLayer = CAGradientLayer()
              gradientLayer.frame = label.bounds
              gradientLayer.colors = gradientColors

           
              UIGraphicsBeginImageContext(gradientLayer.bounds.size)
              gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
              let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
              UIGraphicsEndImageContext()

          
              attributedString.addAttribute(.foregroundColor, value: UIColor(patternImage: gradientImage!), range: range)

              label.attributedText = attributedString
          }
      }
    func getGradientLayer(bounds : CGRect) -> CAGradientLayer{
    let gradient = CAGradientLayer()
    gradient.frame = bounds
    //order of gradient colors
    gradient.colors = [UIColor.red.cgColor,UIColor.blue.cgColor, UIColor.green.cgColor]
    // start and end points
    gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
    return gradient
    }
    func linearGradientColor(from colors: [UIColor], locations: [CGFloat], size: CGSize) -> UIColor {
        let image = UIGraphicsImageRenderer(bounds: CGRect(x: 0, y: 0, width: size.width, height: size.height)).image { context in
            let cgColors = colors.map { $0.cgColor } as CFArray
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: cgColors,
                locations: locations
            )!
            context.cgContext.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: size.width, y:0),
                options:[]
            )
        }
        return UIColor(patternImage: image)
    }
}

class GradientBorderColorView: UIView {
    func setGradientBorderColor(startColor: UIColor, endColor: UIColor, borderWidth: CGFloat) {
        // Create a gradient layer for the border
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        // Create a shape layer to be used as a mask for the gradient
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(rect: bounds).cgPath

        // Set the mask for the gradient layer
        gradientLayer.mask = maskLayer

        // Create a shape layer for the border
        let borderLayer = CAShapeLayer()
        borderLayer.path = UIBezierPath(rect: bounds).cgPath
        borderLayer.strokeColor = UIColor.black.cgColor  // Default border color
        borderLayer.lineWidth = borderWidth
        borderLayer.fillColor = nil

        // Add the border layer to the view's layer
        layer.addSublayer(borderLayer)

        // Add the gradient layer to the view's layer
        layer.addSublayer(gradientLayer)
    }
}

extension UIView{
    func gradiantView(startColor: UIColor, endColor: UIColor) {

        let button: UIButton = UIButton(frame: self.bounds)
       
        let gradient = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
        self.mask = button

    }
    func gradientButton(_ buttonText: String, startColor: UIColor, endColor: UIColor, textSize: CGFloat, fontFamily: String) {

        let button: UIButton = UIButton(frame: self.bounds)
        button.setTitle(buttonText, for: .normal)
        button.titleLabel?.font = UIFont(name: fontFamily, size: textSize) // Set font size and family

        let gradient = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
        self.mask = button

        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1.0
    }
 
    func addTopShadow(shadowColor : UIColor, shadowOpacity : Float,shadowRadius : Float,offset:CGSize){
          self.layer.shadowColor = shadowColor.cgColor
          self.layer.shadowOffset = offset
          self.layer.shadowOpacity = shadowOpacity
          self.layer.shadowRadius = CGFloat(shadowRadius)
          self.clipsToBounds = false
      }
    @discardableResult
       func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat, color: CGColor) -> CALayer {
           let borderLayer = CAShapeLayer()

           borderLayer.strokeColor = color
           borderLayer.lineWidth = 2
           borderLayer.lineDashPattern = pattern
           borderLayer.frame = bounds
           borderLayer.fillColor = nil
           borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath

           layer.addSublayer(borderLayer)
           return borderLayer
       }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
      
}

extension CALayer {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}


//MARK: - UISegmentedControl
extension UISegmentedControl{
    func removeBorder(){
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)

        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
    }

    func addUnderlineForSelectedSegment(){
        removeBorder()
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 4.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 2.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor.app
        underline.tag = 1
        self.addSubview(underline)
    }

    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
}

extension UIImage{

    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}


//MARK: - Textfield MaxLenth
private var kAssociationKeyMaxLength: UInt8 = 0
private var kAssociationKeyMinLength: UInt8 = 1

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int ?? Int.max
        }
        set {
            let length = max(0, newValue) // Ensure non-negative value
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, length, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @IBInspectable var minLength: Int {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyMinLength) as? Int ?? 0
        }
        set {
            let length = max(0, newValue) // Ensure non-negative value
            objc_setAssociatedObject(self, &kAssociationKeyMinLength, length, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = textField.text, prospectiveText.count > maxLength else { return }
        
        let selection = textField.selectedTextRange
        let indexEnd = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        textField.text = String(prospectiveText[..<indexEnd])
        textField.selectedTextRange = selection
    }
    
    /// Function to validate minLength on demand, since we cannot enforce it on each character entry.
    func isValidMinLength() -> Bool {
        return (text?.count ?? 0) >= minLength
    }
}
class CustomSlide: UISlider {

     @IBInspectable var trackHeight: CGFloat = 10

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
         //set your bounds here
         return CGRect(origin: bounds.origin, size: CGSizeMake(bounds.width, trackHeight))



       }
}
class RectangularDashedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}
extension UITextField {
    func setInputViewDatePickerPop(target: Any, selector: Selector, isSelectType: String) {
        
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        
        // Configure the date picker based on the isSelectType parameter
        switch isSelectType {
        case "time":
            datePicker.minimumDate = Calendar.current.date(byAdding: .hour, value: 3, to: Date())
            datePicker.datePickerMode = .time
            datePicker.locale = Locale(identifier: "en_US_POSIX")
        default:
            break
        }

        // iOS 14 and above
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }

        // Add target-action pair to detect value change
        datePicker.addTarget(target, action: selector, for: .valueChanged)
        
        self.inputView = datePicker
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let done = UIBarButtonItem(title: "Done", style: .plain, target: nil, action:  #selector(tapDone))
        toolBar.setItems([cancel, flexible, done], animated: false)
        self.inputAccessoryView = toolBar
        
    }
    
    @objc func tapDone() {
        if let datePicker = self.inputView as? UIDatePicker {
            let formatter = DateFormatter()
            if datePicker.datePickerMode == .time {
                formatter.dateFormat = "hh:mm a" // <- Updated here
            } else {
                formatter.dateFormat = "dd-MM-yyyy"
            }
            self.text = formatter.string(from: datePicker.date)
        }
        self.resignFirstResponder()
    }

    @objc func tapCancel() {
        print("cancel")
        self.resignFirstResponder()
    }
    
}

extension UILabel {

    func addTrailing(with trailingText: String, moreText: String, lessText: String, moreTextFont: UIFont, moreTextColor: UIColor, lessTextFont: UIFont, lessTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        let readLessText: String = trailingText + lessText

        let lengthForVisibleString: Int = self.visibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        let readLessAttributed = NSMutableAttributedString(string: lessText, attributes: [NSAttributedString.Key.font: lessTextFont, NSAttributedString.Key.foregroundColor: lessTextColor])
        
        answerAttributed.append(self.isTruncated ? readLessAttributed : readMoreAttributed)
        self.attributedText = answerAttributed
    }

    var isTruncated: Bool {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes)
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

        return boundingRect.size.height > labelHeight
    }

    var visibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes)
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}
extension Date {
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }
    
}
//MARK: - String
extension String {
    var isValidInput: Bool {
        let trimmedText = self.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return false }
        let containsLetter = trimmedText.range(of: "[a-zA-Z]", options: .regularExpression) != nil
        let containsNumber = trimmedText.range(of: "[0-9]", options: .regularExpression) != nil
        let containsSpecialCharacter = trimmedText.range(of: "[^a-zA-Z0-9]", options: .regularExpression) != nil
        return containsLetter || (!containsNumber && !containsSpecialCharacter)
    }
    func timeAgoSinceDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: self) {
            let timeDifference = Date().timeIntervalSince(date)
                return date.timeAgo()
        } else {
            return "Unknown"
        }
    }

}

enum TrailingContent {
    case readmore
    case readless

    var text: String {
        switch self {
        case .readmore: return " ...Read More"
        case .readless: return " ...Read Less"
        }
    }
}

extension UILabel {

    private var minimumLines: Int { return 4 }
    private var highlightColor: UIColor { return UIColor(hex: "#3E9C35") }

    private var attributes: [NSAttributedString.Key: Any] {
        return [.font: UIFont(name: "Nunito-Regular", size: 15) ?? .systemFont(ofSize: 15)]
    }
    
    public func requiredHeight(for text: String) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = minimumLines
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
      }

    func highlight(_ text: String, color: UIColor) {
        guard let labelText = self.text else { return }
        let range = (labelText as NSString).range(of: text)

        let mutableAttributedString = NSMutableAttributedString.init(string: labelText)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.attributedText = mutableAttributedString
    }

    func appendReadmore(after text: String, trailingContent: TrailingContent) {
        self.numberOfLines = minimumLines
        let fourLineText = "\n\n\n"
        let fourlineHeight = requiredHeight(for: fourLineText)
        let sentenceText = NSString(string: text)
        let sentenceRange = NSRange(location: 0, length: sentenceText.length)
        var truncatedSentence: NSString = sentenceText
        var endIndex: Int = sentenceRange.upperBound
        let size: CGSize = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        while truncatedSentence.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size.height >= fourlineHeight {
            if endIndex == 0 {
                break
            }
            endIndex -= 1

            truncatedSentence = NSString(string: sentenceText.substring(with: NSRange(location: 0, length: endIndex)))
            truncatedSentence = (String(truncatedSentence) + trailingContent.text) as NSString

        }
        self.text = truncatedSentence as String
        self.highlight(trailingContent.text, color: highlightColor)
    }

    func appendReadLess(after text: String, trailingContent: TrailingContent) {
        self.numberOfLines = 0
        self.text = text + trailingContent.text
        self.highlight(trailingContent.text, color: highlightColor)
    }
}

extension UITapGestureRecognizer {

    func didTap(label: UILabel, inRange targetRange: NSRange) -> Bool {
        
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}

extension UIImageView {
    
    /// Apply shape mask to UIImageView
    func applyShape(_ shape: ShapeType) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = shape.getPath(in: bounds).cgPath
        layer.mask = maskLayer
    }
}

/// Enum defining various shape types
enum ShapeType {
    case square, circle, triangle, star, hexagon, roundedSquare, blob1, blob2, abstract
    
    /// Returns a `UIBezierPath` corresponding to the shape type
    func getPath(in rect: CGRect) -> UIBezierPath {
        switch self {
        case .square:
            return createSquarePath(in: rect)
        case .roundedSquare:
            return createRoundedSquarePath(in: rect)
        case .circle: return UIBezierPath(ovalIn: rect)
        case .triangle: return createTrianglePath(in: rect)
        case .star: return createStarPath(in: rect, points: 5)
        case .hexagon: return createHexagonPath(in: rect)
            
        case .blob1: return createBlobPath1(in: rect)
        case .blob2: return createBlobPath2(in: rect)
        case .abstract: return createAbstractPath(in: rect)
        }
    }
    
    /// Creates a triangle path
    private func createTrianglePath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY)) // Top center
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // Bottom right
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // Bottom left
        path.close()
        return path
    }
    
    /// Creates a star shape
    private func createStarPath(in rect: CGRect, points: Int) -> UIBezierPath {
        let path = UIBezierPath()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4 // Adjust inner radius for better shape
        let angleIncrement = CGFloat.pi * 2 / CGFloat(points * 2) // Twice the points for inner & outer
        
        for i in 0..<(points * 2) {
            let angle = CGFloat(i) * angleIncrement - .pi / 2
            let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius // Alternate between outer and inner points
            let point = CGPoint(x: center.x + cos(angle) * radius, y: center.y + sin(angle) * radius)
            
            i == 0 ? path.move(to: point) : path.addLine(to: point)
        }
        
        path.close()
        return path
    }
    
    /// Creates a hexagon shape
    private func createHexagonPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let side = rect.width / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let points = (0..<6).map { i -> CGPoint in
            let angle = CGFloat(i) * .pi / 3
            return CGPoint(x: center.x + cos(angle) * side, y: center.y + sin(angle) * side)
        }
        
        path.move(to: points.first!)
        for point in points.dropFirst() { path.addLine(to: point) }
        path.close()
        return path
    }
    
    /// Creates a smooth blob shape (variant 1)
    private func createBlobPath1(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let w = rect.width, h = rect.height
        
        path.move(to: CGPoint(x: w * 0.5, y: 0))
        path.addCurve(to: CGPoint(x: w, y: h * 0.3),
                      controlPoint1: CGPoint(x: w * 0.8, y: -h * 0.1),
                      controlPoint2: CGPoint(x: w * 1.1, y: h * 0.2))
        
        path.addCurve(to: CGPoint(x: w * 0.7, y: h),
                      controlPoint1: CGPoint(x: w * 0.9, y: h * 0.5),
                      controlPoint2: CGPoint(x: w * 0.8, y: h * 0.9))
        
        path.addCurve(to: CGPoint(x: w * 0.2, y: h * 0.85),
                      controlPoint1: CGPoint(x: w * 0.5, y: h * 1.1),
                      controlPoint2: CGPoint(x: w * 0.3, y: h * 0.95))
        
        path.addCurve(to: CGPoint(x: 0, y: h * 0.3),
                      controlPoint1: CGPoint(x: -w * 0.1, y: h * 0.7),
                      controlPoint2: CGPoint(x: w * 0.05, y: h * 0.4))
        
        path.close()
        return path
    }
    /// Creates a perfectly centered square
    private func createSquarePath(in rect: CGRect) -> UIBezierPath {
        let side = min(rect.width, rect.height) // Use the smallest side
        let squareRect = CGRect(
            x: rect.midX - side / 2,
            y: rect.midY - side / 2,
            width: side,
            height: side
        )
        return UIBezierPath(rect: squareRect)
    }
    
    /// Creates a perfectly centered rounded square
    private func createRoundedSquarePath(in rect: CGRect) -> UIBezierPath {
        let side = min(rect.width, rect.height) // Use the smallest side
        let squareRect = CGRect(
            x: rect.midX - side / 2,
            y: rect.midY - side / 2,
            width: side,
            height: side
        )
        return UIBezierPath(roundedRect: squareRect, cornerRadius: side / 6)
    }
    /// Creates an asymmetrical blob shape (variant 2)
    private func createBlobPath2(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let w = rect.width, h = rect.height
        
        path.move(to: CGPoint(x: w * 0.4, y: 0))
        path.addCurve(to: CGPoint(x: w * 0.9, y: h * 0.2),
                      controlPoint1: CGPoint(x: w * 0.6, y: -h * 0.1),
                      controlPoint2: CGPoint(x: w * 1.1, y: h * 0.1))
        
        path.addCurve(to: CGPoint(x: w * 0.7, y: h * 0.9),
                      controlPoint1: CGPoint(x: w * 0.85, y: h * 0.4),
                      controlPoint2: CGPoint(x: w * 0.75, y: h * 0.75))
        
        path.addCurve(to: CGPoint(x: w * 0.1, y: h * 0.7),
                      controlPoint1: CGPoint(x: w * 0.6, y: h * 1.1),
                      controlPoint2: CGPoint(x: w * 0.2, y: h * 1.0))
        
        path.close()
        return path
    }
    
    /// Creates an abstract shape
    private func createAbstractPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        // Start from the bottom center (balloon knot)
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        
        // Create the left side curve with a rounder shape
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.midY),
                      controlPoint1: CGPoint(x: rect.midX * 0.4, y: rect.maxY * 0.9),  // Adjusted for smooth transition
                      controlPoint2: CGPoint(x: rect.minX * 1.1, y: rect.midY * 1.2))  // Pulled control point outward
        
        // Create the top curve with a rounder arch
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.midY),
                      controlPoint1: CGPoint(x: rect.minX - rect.width * 0.1, y: rect.minY * 0.6),  // Pulled outwards for roundness
                      controlPoint2: CGPoint(x: rect.maxX + rect.width * 0.1, y: rect.minY * 0.6))
        
        // Create the right side curve with a rounder transition
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.maxY),
                      controlPoint1: CGPoint(x: rect.maxX * 0.95, y: rect.midY * 1.2),  // Adjusted for symmetry
                      controlPoint2: CGPoint(x: rect.midX * 1.6, y: rect.maxY * 0.85))  // Pulled closer for smoothness
        
        // Close the shape
        path.close()
        
        // Apply 35-degree rotation around the center
        let angle = -35 * (CGFloat.pi / 180) // Use CGFloat.pi to avoid ambiguity
        let transform = CGAffineTransform(translationX: rect.midX, y: rect.midY)
            .rotated(by: angle) // Rotate by -35 degrees (clockwise)
            .translatedBy(x: -rect.midX, y: -rect.midY)
        
        path.apply(transform)
        
        return path
    }
}
