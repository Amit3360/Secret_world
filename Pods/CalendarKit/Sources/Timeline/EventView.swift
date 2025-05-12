import UIKit

open class EventView: UIView {
    public var descriptor: EventDescriptor?
    public var color = SystemColors.label
    public var heightConstraint: NSLayoutConstraint?
    public var contentHeight: Double {
        textView.frame.height
        
    }
    
    public private(set) lazy var textView: UITextView = {
        let view = UITextView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        view.isScrollEnabled = true
        view.clipsToBounds = true
         
        return view
    }()
    
    /// Resize Handle views showing up when editing the event.
    /// The top handle has a tag of `0` and the bottom has a tag of `1`
    public private(set) lazy var eventResizeHandles = [EventResizeHandleView(), EventResizeHandleView()]
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    

    private func configure() {
        // Add textView to the view
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
      
        // Set Auto Layout constraints
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
        
        // Add a height constraint for EventView
        heightConstraint = heightAnchor.constraint(equalToConstant: 100)
        heightConstraint?.isActive = true
    }

    public func updateHeight() {
        // Calculate the new height based on textView content
        let textViewContentHeight = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
        
        // Update the height constraint
        heightConstraint?.constant = textViewContentHeight  // Add padding
        setNeedsLayout()
        layoutIfNeeded()
    }
    public func setLineSpacing(_ spacing: CGFloat) {
        guard let text = textView.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing // Set the desired line spacing

        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text.count))
        
        textView.attributedText = attributedString
    }
    public func updateWithDescriptor(event: EventDescriptor) {
        // Update the text of textView
        textView.text = "\(event.text)\n\(event.description)"
    
        backgroundColor = .clear
        layer.backgroundColor = event.backgroundColor.cgColor
        layer.cornerRadius = 5
        color = event.color
        eventResizeHandles.forEach{
            $0.borderColor = event.color
            $0.isHidden = event.editedEvent == nil
        }
        drawsShadow = event.editedEvent != nil
        setLineSpacing(0)
        textView.setNeedsLayout()
       
        // Recalculate the intrinsic size
        invalidateIntrinsicContentSize()
    }

    
    public func animateCreation() {
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        func scaleAnimation() {
            transform = .identity
        }
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 10,
                       options: [],
                       animations: scaleAnimation,
                       completion: nil)
    }
    
    /**
     Custom implementation of the hitTest method is needed for the tap gesture recognizers
     located in the ResizeHandleView to work.
     Since the ResizeHandleView could be outside of the EventView's bounds, the touches to the ResizeHandleView
     are ignored.
     In the custom implementation the method is recursively invoked for all of the subviews,
     regardless of their position in relation to the Timeline's bounds.
     */
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for resizeHandle in eventResizeHandles {
            if let subSubView = resizeHandle.hitTest(convert(point, to: resizeHandle), with: event) {
                return subSubView
            }
        }
        return super.hitTest(point, with: event)
    }
    open override var intrinsicContentSize: CGSize {
        let textViewHeight = textView.sizeThatFits(CGSize(width: bounds.width - 16, height: CGFloat.greatestFiniteMagnitude)).height
        return CGSize(width: UIView.noIntrinsicMetric, height: textViewHeight) // Add padding
    }
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.interpolationQuality = .none
        context.saveGState()
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(3)
     
        context.setLineCap(.round)
        context.translateBy(x: 0, y: 0.5)
        let leftToRight = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .leftToRight
        let x: Double = leftToRight ? 0 : frame.width - 1.0  // 1 is the line width
        let y: Double = 0
        let hOffset: Double = 3
        let vOffset: Double = 5
        context.beginPath()
        context.move(to: CGPoint(x: x + 2 * hOffset, y: y + vOffset))
        context.addLine(to: CGPoint(x: x + 2 * hOffset, y: (bounds).height - vOffset))
        context.strokePath()
        context.restoreGState()
    }
    
    private var drawsShadow = false
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // Calculate textView's content height
        let textViewContentHeight = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
        
        // Adjust the frame of EventView based on textView content height
        var frame = self.frame
        frame.size.height = textViewContentHeight
        self.frame = frame
        
        // Update textView's frame to fit the new height
        textView.frame = CGRect(x: 0, y: 0, width: frame.width - 16, height: textViewContentHeight)
    }

    private func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: Double = 0,
        y: Double = 2,
        blur: Double = 4,
        spread: Double = 0)
    {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur / 2.0
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
