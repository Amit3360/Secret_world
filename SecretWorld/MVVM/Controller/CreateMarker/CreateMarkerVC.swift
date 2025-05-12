import UIKit
import ColorSlider

struct Pixel: Hashable {
    let x: Int
    let y: Int
}


class CreateMarkerVC: UIViewController, UIColorPickerViewControllerDelegate {

    @IBOutlet weak var vwCart: UIView!
    @IBOutlet weak var imgVwZoom: UIImageView!
    @IBOutlet weak var imgVwMove: UIImageView!
    @IBOutlet weak var imgVwCart: UIImageView!
    @IBOutlet weak var imgVwShape: UIImageView!
    @IBOutlet weak var colorSlider: UIView!
    @IBOutlet weak var vwSelectedColor: UIView!
    @IBOutlet weak var lblColorCode: UILabel!
   
    @IBOutlet weak var heightShapeImg: NSLayoutConstraint!
    @IBOutlet weak var widthShapeImg: NSLayoutConstraint!
    @IBOutlet weak var gradientColorVw: UIView!
    @IBOutlet weak var vwColor: UIView!
    @IBOutlet weak var vwShape: UIView!
    @IBOutlet weak var btnMarkerColor: UIButton!
    @IBOutlet weak var btnLogoShape: UIButton!
    @IBOutlet weak var collVwShapes: UICollectionView!
    
    private var arrShapes = ["shape1","shape2","shape3","shape4","shape5","shape6","shape7","shape8","shape9"]
    var filledPixels: Set<Pixel> = []
    var lastTouchPoint: CGPoint?
      var lastColor: UIColor = .red
    var imageHistory: [(UIImage, CGPoint, UIColor)] = []
    var redoHistory: [(UIImage, CGPoint, UIColor)] = [] // Store undone colors
      var originalImage: UIImage? // Store original image
    var shapedImg:UIImage?
    var changeSliderColor:UIColor?
    var viewModelUpload = UploadImageVM()
    var currentShape: ShapeType = .circle
    var callBack:((_ image:UIImage)->())?
    private var initialZoomScale: CGFloat = 1.0
    private var isZoomMove = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSet()
    }
    func uiSet(){
        if shapedImg == nil{
            imgVwShape.image = UIImage(named: "defaultPopIcon")
        }else{
            imgVwShape.image = shapedImg
        }
    
        originalImage = imgVwCart.image
        let colorSliders = ColorSlider(orientation: .vertical, previewSide: .left)
        let deviceHasNotch = UIApplication.shared.hasNotch
        if deviceHasNotch{
            if UIDevice.current.hasDynamicIsland {
                colorSliders.frame = CGRect(x: 0, y: 0, width: 20, height: 380)
            }else{
                colorSliders.frame = CGRect(x: 0, y: 0, width: 20, height: 280)
            }
        }else{
            colorSliders.frame = CGRect(x: 0, y: 0, width: 20, height: 140)
        }
     
         colorSliders.addTarget(self, action: #selector(colorChanged(_:)), for: .valueChanged)

         // Add slider to the view
        imgVwShape.applyShape(.circle)
         colorSlider.addSubview(colorSliders)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        applyGradient(to: gradientColorVw, baseColor: UIColor(hex: "#3e9c35"))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                imgVwCart.isUserInteractionEnabled = true
                imgVwCart.addGestureRecognizer(tapGesture)
     
        let imagePanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleImagePan(_:)))
        imgVwMove.isUserInteractionEnabled = true
        imgVwMove.addGestureRecognizer(imagePanGesture)
    
        vwCart.addSubview(imgVwZoom)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleZoomImagePan(_:)))
           imgVwZoom.isUserInteractionEnabled = true
           imgVwZoom.addGestureRecognizer(panGesture)
       
    }
  
   
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        if !isZoomMove{
            guard let image = imgVwCart.image else { return }
            
            let touchPoint = gesture.location(in: imgVwCart)
            lastTouchPoint = touchPoint  // Store last touch point
            lastColor = vwSelectedColor.backgroundColor ?? .red // Store last color
            
            imageHistory.append((image, touchPoint, lastColor))  // Save image state with touch point and color
            
            let hexColor = lblColorCode.text ?? ""
            
            let fillColor = hexToUIColor(hexColor)
            
            // Call floodFill with hex-based color
            if let newImage = floodFill(image: image, at: touchPoint, with: fillColor) {
                imgVwCart.image = newImage
            }
            
        }
    }
 
    @objc func handleZoomImagePan(_ gesture: UIPanGestureRecognizer) {
        isZoomMove = true
        guard let zoomView = gesture.view else { return }

        let translation = gesture.translation(in: imgVwCart)

        // Calculate new position
        var newCenter = CGPoint(x: zoomView.center.x + translation.x, y: zoomView.center.y + translation.y)

        // Reset gesture translation
        gesture.setTranslation(.zero, in: imgVwCart)

        // Define movement boundaries
        let minX = zoomView.bounds.width / 2
        let maxX = imgVwCart.bounds.width - minX
        let minY = zoomView.bounds.height / 2

        let extraBottomSpace: CGFloat = 8
        let maxY = imgVwCart.bounds.height - minY + extraBottomSpace

        newCenter.x = max(minX, min(newCenter.x, maxX))
        newCenter.y = max(minY, min(newCenter.y, maxY))

        // Apply new position
        zoomView.center = newCenter

        // Fill color at the center of imgVwZoom after gesture ends
        if gesture.state == .ended {
            isZoomMove = false
            guard let image = imgVwCart.image else { return }
            let zoomCenterInCart = imgVwCart.convert(zoomView.center, from: zoomView.superview)
            let touchPoint = gesture.location(in: imgVwCart)
                     lastTouchPoint = touchPoint  // Store last touch point
                     lastColor = vwSelectedColor.backgroundColor ?? .red // Store last color

                     imageHistory.append((image, touchPoint, lastColor))  // Save image state with touch point and color

            if let image = imgVwCart.image {
                let imageBounds = imgVwCart.bounds
                
                // Adjusting the zoom center point
                let offsetx: CGFloat = 5
                let offsety: CGFloat = -10  // Adjust this value as needed
                let adjustedZoomCenter = CGPoint(x: zoomCenterInCart.x + offsetx, y: zoomCenterInCart.y + offsety)
                
                if adjustedZoomCenter.x >= 0, adjustedZoomCenter.x <= imageBounds.width,
                   adjustedZoomCenter.y >= 0, adjustedZoomCenter.y <= imageBounds.height {

                    if let selectedColor = vwSelectedColor.backgroundColor {
                        if let filledImage = floodFill(image: image, at: adjustedZoomCenter, with: selectedColor) {
                            imgVwCart.image = filledImage
                        }
                    }
                } else {
                    print("Adjusted zoom center is outside image bounds. Ignoring flood fill.")
                }
            }
        }
    }
    
    @objc func handleImagePan(_ gesture: UIPanGestureRecognizer) {
        guard let gradientView = gradientColorVw else { return }
        
        let location = gesture.location(in: gradientView)
        
        // Ensure location is within bounds
        let minX = imgVwMove.bounds.width / 2
        let maxX = gradientView.bounds.width - minX
        let minY = imgVwMove.bounds.height / 2
        let maxY = gradientView.bounds.height - minY
        
        var newCenter = CGPoint(x: location.x, y: location.y)
        newCenter.x = max(minX, min(newCenter.x, maxX))
        newCenter.y = max(minY, min(newCenter.y, maxY))
        
        // Move marker
        imgVwMove.center = newCenter
        
        // Get color from new position after a slight delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if let color = self.getPixelColor(from: gradientView, at: newCenter) {
                self.vwSelectedColor.backgroundColor = color
                self.lblColorCode.text = self.colorToHex(color)
            }
        }
    }
    
    func getPixelColor(from gradientView: UIView, at point: CGPoint) -> UIColor? {
        guard let gradientLayer = gradientView.layer.sublayers?.compactMap({ $0 as? CAGradientLayer }).first else {
            return nil
        }

        let colors = gradientLayer.colors as? [CGColor] ?? []
        guard colors.count > 1 else { return nil }

        let startPoint = gradientLayer.startPoint
        let endPoint = gradientLayer.endPoint

        // Normalize the touch location based on gradient coordinates
        let relativeX = point.x / gradientView.bounds.width
        let relativeY = point.y / gradientView.bounds.height

        // Calculate gradient position along the direction
        let gradientPosition = startPoint.y + (endPoint.y - startPoint.y) * relativeY
        let position = CGFloat(gradientPosition)

        // Determine the two closest colors
        let index = Int(position * CGFloat(colors.count - 1))
        let startColor = UIColor(cgColor: colors[max(0, index)])
        let endColor = UIColor(cgColor: colors[min(colors.count - 1, index + 1)])

        // Interpolate between the two colors
        let ratio = position * CGFloat(colors.count - 1) - CGFloat(index)
        return interpolateColor(from: startColor, to: endColor, ratio: ratio)
    }
    
    func interpolateColor(from color1: UIColor, to color2: UIColor, ratio: CGFloat) -> UIColor {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let r = r1 + (r2 - r1) * ratio
        let g = g1 + (g2 - g1) * ratio
        let b = b1 + (b2 - b1) * ratio
        let a = a1 + (a2 - a1) * ratio
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    
    func floodFill(image: UIImage, at point: CGPoint, with fillColor: UIColor) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }

        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let imageSize = bytesPerRow * height
        let mutableData = malloc(imageSize)
        // Create a bitmap context
        guard let context = CGContext(
            data: mutableData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        ) else { return nil }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let pixelData = context.data else { return nil }

        let pixels = pixelData.assumingMemoryBound(to: UInt32.self)

        let pixelX = Int(point.x * CGFloat(width) / imgVwCart.bounds.width)
        let pixelY = Int(point.y * CGFloat(height) / imgVwCart.bounds.height)

        if pixelX < 0 || pixelX >= width || pixelY < 0 || pixelY >= height {
            print("Flood fill aborted: Point is out of image bounds.")
            return image
        }

        let index = pixelY * width + pixelX
        let targetColor = pixels[index]

        let replacementColor = colorToUInt32(fillColor)
        if targetColor == replacementColor { return image }

        // Variables to track the bounding box of the filled area
        var minX = pixelX, maxX = pixelX
        var minY = pixelY, maxY = pixelY

        // Queue-based Flood Fill (BFS)
        var queue: [(Int, Int)] = [(pixelX, pixelY)]
     

        while !queue.isEmpty {
            let (px, py) = queue.removeFirst()
            let index = py * width + px

            if pixels[index] == targetColor {
                pixels[index] = replacementColor
//                filledPixels.insert((px, py))
                filledPixels.insert(Pixel(x: px, y: py))
                // Update fill bounds
                minX = min(minX, px)
                maxX = max(maxX, px)
                minY = min(minY, py)
                maxY = max(maxY, py)

                if px > 0 { queue.append((px - 1, py)) }
                if px < width - 1 { queue.append((px + 1, py)) }
                if py > 0 { queue.append((px, py - 1)) }
                if py < height - 1 { queue.append((px, py + 1)) }
            }
        }

        let fillWidth = maxX - minX + 1
        let fillHeight = maxY - minY + 1

        // Prevent fill for restricted area sizes
//        let restrictedAreas: [(Int, Int)] = [(92, 246), (130, 29), (76, 246),(27, 30),(23, 30)]
        let restrictedAreas: [(Int, Int)] = [(46, 123), (65, 15), (39, 123),(13, 14),(11, 15),(92, 246), (130, 29), (76, 246),(27, 30),(23, 30)]
        if restrictedAreas.contains(where: { $0 == (fillWidth, fillHeight) }) {
            print("Skipped filling area: \(fillWidth)x\(fillHeight) pixels")
            return image
        }

        print("Filled Area Size: \(fillWidth)x\(fillHeight) pixels")

        guard let filledImage = context.makeImage() else { return nil }
        return UIImage(cgImage: filledImage)
    }

  
    @objc func colorChanged(_ slider: ColorSlider) {
        let selectedColor = slider.color
        vwSelectedColor.backgroundColor = selectedColor
        lblColorCode.text = colorToHex(selectedColor)
        changeSliderColor = selectedColor
        
        applyGradient(to: gradientColorVw, baseColor: selectedColor)
        
        imgVwMove.center = CGPoint(x: gradientColorVw.bounds.midX, y: gradientColorVw.bounds.midY)
    }
  
    func colorToHex(_ color: UIColor) -> String {
        guard let components = color.cgColor.components else { return "Unknown Color" }

        let r = Int((components[0] * 255).rounded())
        let g = Int((components[1] * 255).rounded())
        let b = Int((components[2] * 255).rounded())

        return String(format: "#%02X%02X%02X", r, g, b)
    }
    func applyGradient(to view: UIView, baseColor: UIColor) {
        // Ensure the view has a valid frame before applying the gradient
        guard view.bounds.width > 0, view.bounds.height > 0 else {
            print("Gradient view has zero bounds, skipping gradient update.")
            return
        }

        // Remove all previous gradient layers
        view.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds

        let lightColor = UIColor.white
        let mainColor = baseColor
        let darkColor = UIColor.black

        gradientLayer.colors = [lightColor.cgColor, mainColor.cgColor, darkColor.cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        view.layer.insertSublayer(gradientLayer, at: 0)

        print("Gradient applied with color: \(colorToHex(baseColor))")
    }
   

    @IBAction func actionBackColor(_ sender: UIButton) {
        guard let lastFill = imageHistory.popLast() else { return }
           
           redoHistory.append(lastFill) // Save the undone step for redo
           
           if let (previousImage, _, _) = imageHistory.last {
               imgVwCart.image = previousImage // Restore the last known state
           } else if let originalImage = originalImage {
               imgVwCart.image = originalImage // Reset to original if no history left
           }
    }
    
    @IBAction func actionNextColor(_ sender: UIButton) {
        guard let (redoImage, redoPoint, redoColor) = redoHistory.popLast() else { return }
        
        if let updatedImage = floodFill(image: redoImage, at: redoPoint, with: redoColor) {
            imgVwCart.image = updatedImage
            imageHistory.append((updatedImage, redoPoint, redoColor)) // Save redo step
        }
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        uploadCombinedImageWithShapeInsideCart(shape: .star, backgroundColor: .clear)
    }
    func getMaskedImage(originalImage: UIImage, shape: ShapeType) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: imgVwShape.bounds.size)
        return renderer.image { context in
            let path = shape.getPath(in: imgVwShape.bounds)
            path.addClip()
            originalImage.draw(in: CGRect(origin: .zero, size: imgVwShape.bounds.size))
        }
    }
    func combineImagesWithShapeInsideCart(shape: ShapeType, backgroundColor: UIColor) -> UIImage? {
        guard let cartImage = imgVwCart.image, let shapeImage = imgVwShape.image else { return nil }
        
        let cartSize = imgVwCart.bounds.size
        let shapeSize = imgVwShape.bounds.size
        
        let renderer = UIGraphicsImageRenderer(size: cartSize)
        
        return renderer.image { context in
            let cgContext = context.cgContext
            
            // Set the background color
            cgContext.setFillColor(backgroundColor.cgColor)
            cgContext.fill(CGRect(origin: .zero, size: cartSize))
            
            // Draw the background cart image
            cartImage.draw(in: CGRect(origin: .zero, size: cartSize))
            
            // Get the masked shape image
            if let maskedShape = getMaskedImage(originalImage: shapeImage, shape: shape) {
                let shapeX = (cartSize.width - shapeSize.width) / 2
                let shapeY = (cartSize.height - shapeSize.height) / 2
                let shapeRect = CGRect(x: shapeX, y: shapeY, width: shapeSize.width, height: shapeSize.height)
                
                // Draw the masked shape image inside the cart
                maskedShape.draw(in: shapeRect, blendMode: .normal, alpha: 1.0)
            }
        }
    }

    func uploadCombinedImageWithShapeInsideCart(shape: ShapeType, backgroundColor: UIColor) {
        guard let combinedImage = combineImagesWithShapeInsideCart(shape: shape, backgroundColor: backgroundColor) else { return }
        self.navigationController?.popViewController(animated: true)
        self.callBack?(combinedImage)
//        viewModelUpload.uploadProductImagesApi(Images: combinedImage) { data in
//            guard let imageUrl = data?.imageUrls?.first else { return }
//            print("Uploaded Combined Image URL:", imageUrl)
//        }
    }
    
    @IBAction func actionLogoShape(_ sender: UIButton) {
        vwShape.isHidden = false
        vwColor.isHidden = true
        btnLogoShape.setTitleColor(.white, for: .normal)
        btnLogoShape.backgroundColor = .app
        btnMarkerColor.setTitleColor(.white, for: .normal)
        btnMarkerColor.backgroundColor = UIColor(hex: "#E6F2E5")
        btnMarkerColor.setTitleColor(.black, for: .normal)
    }
    
    @IBAction func actionMarkerColor(_ sender: UIButton) {
        let selectedColor = UIColor(hex: "#3E9C35")
        vwSelectedColor.backgroundColor = selectedColor
        lblColorCode.text = colorToHex(selectedColor)

        // Ensure the view updates before applying the gradient
        gradientColorVw.setNeedsLayout()
        gradientColorVw.layoutIfNeeded()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.applyGradient(to: self!.gradientColorVw, baseColor: selectedColor)
        }

        vwShape.isHidden = true
        vwColor.isHidden = false
        btnMarkerColor.setTitleColor(.white, for: .normal)
        btnMarkerColor.backgroundColor = .app
        btnLogoShape.setTitleColor(.white, for: .normal)
        btnLogoShape.backgroundColor = UIColor(hex: "#E6F2E5")
        btnLogoShape.setTitleColor(.black, for: .normal)
    }
    
    @IBAction func actionPickColor(_ sender: UIButton) {
     
    }
   
   
}

extension CreateMarkerVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrShapes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarkerShapeCVC", for: indexPath) as! MarkerShapeCVC
        cell.imgVwShape.image = UIImage(named: arrShapes[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collVwShapes.frame.width/3-10, height:100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            imgVwShape.applyShape(.square)
            currentShape = .square
        case 1:
            imgVwShape.applyShape(.circle)
            currentShape = .circle
        case 2:
            imgVwShape.applyShape(.triangle)
            currentShape = .triangle
        case 3:
            imgVwShape.applyShape(.star)
            currentShape = .star
        case 4:
            imgVwShape.applyShape(.abstract)
            currentShape = .abstract
        case 5:
            currentShape = .roundedSquare
            imgVwShape.applyShape(.roundedSquare)
        case 6:
            imgVwShape.applyShape(.hexagon)
            currentShape = .hexagon
        case 7:
            imgVwShape.applyShape(.blob1)
            currentShape = .blob1
        case 8:
            imgVwShape.applyShape(.blob2)
            currentShape = .blob2
        default:
            break
        }
    }
}



     private func colorToUInt32(_ color: UIColor) -> UInt32 {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let r = UInt32(red * 255)
        let g = UInt32(green * 255)
        let b = UInt32(blue * 255)
        let a = UInt32(alpha * 255)
        return (a << 24) | (b << 16) | (g << 8) | r  // Swap R and B

    }

     private func hexToUIColor(_ hex: String) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let hasAlpha = hexSanitized.count == 8
        let red = CGFloat((rgb >> (hasAlpha ? 24 : 16)) & 0xFF) / 255.0
        let green = CGFloat((rgb >> (hasAlpha ? 16 : 8)) & 0xFF) / 255.0
        let blue = CGFloat((rgb >> (hasAlpha ? 8 : 0)) & 0xFF) / 255.0
        let alpha = hasAlpha ? CGFloat(rgb & 0xFF) / 255.0 : 1.0

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
