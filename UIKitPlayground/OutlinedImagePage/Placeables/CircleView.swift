import UIKit

// TODO: Size multiplier only applies when the BoundingCircle of imageConfiguration is nil, larp between the specified and minimum bounding circle otherwise.
internal final class CircleView: UIView, PlaceableColoredView {
    
    static private let MIN_OUTLINE_SIZE: CGFloat = 0.05
    static private let MAX_OUTLINE_SIZE: CGFloat = 0.75
    
    static private let MIN_SIZE_MULTIPLIER: CGFloat = 1.0
    static private let MAX_SIZE_MULTIPLIER: CGFloat = 3
    
    weak private var circleLayer: CAShapeLayer?
    private let circleCenter: CGPoint
    private var radius: CGFloat
    private var sizeMultiplier: CGFloat {
        didSet {
            self.setNeedsLayout()
        }
    }
    private var containerSizeEstimate: CGSize?
    
    internal var strokeColor: CGColor = .init(red: 1, green: 0, blue: 1, alpha: 1) {
        didSet {
            guard let circleLayer = self.circleLayer else { return }
            circleLayer.strokeColor = self.strokeColor
        }
    }
    
    internal init (imageDescriptor: ZTronOutlinedImageDescriptor) {
        
        let bc = imageDescriptor.getOutlineBoundingCircle()
        var diameter = bc?.getIdleDiameter()
        
        
        if diameter == nil {
            // compute the diameter as the minimum bounding circle that contains the outline
            // the best idea I have now is to take the diameter as the diagonal of the bounding box
            
            // if no diameter is specified, at least Outline must be provided
            // assert(imageDescriptor.getOutlineBoundingBox() != nil)
            
            let boundingBox = imageDescriptor.getOutlineBoundingBox()
            let d = sqrt(
                boundingBox.size.width*boundingBox.size.width +
                boundingBox.size.height*boundingBox.size.height
            )
            
            diameter = d
        }
        
        var center = bc?.getNormalizedCenter()
        
        if center == nil {
            // if the center was not specified, use the center of the outline's bounding box
            let boundingBox = imageDescriptor.getOutlineBoundingBox()
            
            let normalizedCenter = CGPoint(
                x: boundingBox.origin.x + boundingBox.size.width/2.0,
                y: boundingBox.origin.y + boundingBox.size.height/2.0
            )
            
            center = normalizedCenter
        }
        
        
        self.circleCenter = center!
        self.radius = diameter!/2.0
        
        self.sizeMultiplier = Self.MAX_SIZE_MULTIPLIER
        self.containerSizeEstimate = nil
        
        super.init(frame: .zero)

        self.circleLayer = self.makeCircleLayer()

        self.isUserInteractionEnabled = false // Otherwise clicks inside won't propagate
    }
    
    
    @discardableResult private final func makeCircleLayer() -> CAShapeLayer? {
        self.layer.sublayers?.forEach {
            $0.isHidden = true
        }
        
        let circleLayer = CAShapeLayer()
                
        self.configureLayer(circleLayer)
        circleLayer.lineWidth = 0.5
        circleLayer.fillColor = .none
        
        self.layer.addSublayer(circleLayer)
            
        return circleLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let circleLayer = self.circleLayer else { return }
        self.configureLayer(circleLayer)
    }
    
    private final func configureLayer(_ circleLayer: CAShapeLayer) {
        circleLayer.frame = self.bounds
        
        let containerSize = self.containerSizeEstimate ?? self.bounds.size
        
        circleLayer.anchorPoint = CGPoint(x: 0, y: 0)
        circleLayer.position = CGPoint(
            x: self.bounds.size.width / 2.0,
            y: self.bounds.size.height / 2.0
        )
        
        circleLayer.path = UIBezierPath(
            arcCenter: .zero,
            radius: self.radius * self.sizeMultiplier * containerSize.width,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        ).cgPath
        
        circleLayer.strokeColor = self.strokeColor

    }
    
    required init?(coder: NSCoder) {
        fatalError("Cannot initialize from storyboards")
    }
    
    internal final func getOrigin(for containerSize: CGSize) -> CGPoint {
        self.containerSizeEstimate = containerSize
        
        let estimatedWidth = 2 * self.radius * sizeMultiplier * containerSize.width
        let estimatedHeight = 2 * self.radius * sizeMultiplier * containerSize.height
        
        let diameter = max(estimatedWidth, estimatedHeight)

        
        return CGPoint(
            x: (self.circleCenter.x * containerSize.width - diameter / 2.0),
            y: (self.circleCenter.y * containerSize.height  - diameter / 2.0)
        )
    }
    
    internal final func getSize(for containerSize: CGSize) -> CGSize {
        self.containerSizeEstimate = containerSize

        let estimatedWidth = 2 * self.radius * containerSize.width * sizeMultiplier
        let estimatedHeight = 2 * self.radius * containerSize.height * sizeMultiplier
        
        let diameter = max(estimatedWidth, estimatedHeight)
        
        return CGSize(
            width: diameter,
            height: diameter
        )
    }
    
    internal final func updateForZoom(_ scrollView: UIScrollView) {
        let zoomProgress = (scrollView.zoomScale - scrollView.minimumZoomScale)/(scrollView.maximumZoomScale - scrollView.minimumZoomScale)

        self.circleLayer?.lineWidth = max(
            Self.MIN_OUTLINE_SIZE,
            (Self.MIN_OUTLINE_SIZE...Self.MAX_OUTLINE_SIZE).larp(1 - zoomProgress)
        )
        
        self.sizeMultiplier = max(
            Self.MIN_SIZE_MULTIPLIER,
            (Self.MIN_SIZE_MULTIPLIER...Self.MAX_SIZE_MULTIPLIER).larp((1-zoomProgress)*(1-zoomProgress)*(1-zoomProgress))
        )
    }
    
    internal final func resize(for containerSize: CGSize) {
        self.containerSizeEstimate = containerSize

        let frameForSize = CGRect(
            origin: self.getOrigin(for: containerSize),
            size: self.getSize(for: containerSize)
        )
        
        self.bounds = CGRect(
            origin: .zero,
            size: frameForSize.size
        )
    }
    
    internal final func colorChanged(_ color: UIColor) {
        self.strokeColor = color.cgColor
    }
}

