import UIKit

internal final class CircleView: UIView, PlaceableView {
    weak private var circleLayer: CAShapeLayer?
    private let circleCenter: CGPoint
    private var radius: CGFloat
        
    
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
        
        super.init(frame: .zero)

        self.circleLayer = self.makeCircleLayer()

        self.isUserInteractionEnabled = false // Otherwise clicks inside won't propagate
        print("Circle: \(center!), r: \(radius)")
    }
    
    
    @discardableResult private final func makeCircleLayer() -> CAShapeLayer? {
        self.layer.sublayers?.forEach {
            $0.isHidden = true
        }
        
        let circleLayer = CAShapeLayer()
                
        circleLayer.path = UIBezierPath(
            arcCenter: self.center,
            radius: self.bounds.size.width / 2,
            startAngle: 0,
            endAngle: 2*CGFloat.pi,
            clockwise: true
        ).cgPath
        
        circleLayer.lineWidth = 0.5
        circleLayer.strokeColor = .init(red: 1.0, green: 0, blue: 0, alpha: 1)
        circleLayer.fillColor = .none
        
        self.layer.addSublayer(circleLayer)
            
        return circleLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let circleLayer = self.circleLayer else { return }
        
        circleLayer.frame = self.bounds
        
        circleLayer.anchorPoint = CGPoint(x: 0, y: 0)
        circleLayer.position = CGPoint(
            x: self.bounds.size.width / 2.0,
            y: self.bounds.size.height / 2.0
        )
        
        circleLayer.path = UIBezierPath(
            arcCenter: .zero,
            radius: self.bounds.size.width / 2.0,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        ).cgPath
        
        circleLayer.strokeColor = .init(red: 1, green: 0, blue: 1, alpha: 1)
        
        print(self.circleLayer!.frame, self.bounds)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Cannot initialize from storyboards")
    }
    
    internal final func getOrigin(for containerSize: CGSize) -> CGPoint {
        let estimatedWidth = 2 * self.radius * containerSize.width
        let estimatedHeight = 2 * self.radius * containerSize.height
        
        let diameter = max(estimatedWidth, estimatedHeight)

        
        let retval = CGPoint(
            x: (self.circleCenter.x * containerSize.width - diameter / 2.0),
            y: (self.circleCenter.y * containerSize.height  - diameter / 2.0)
        )
        
        print("Circle origin: \(retval)")
        return retval
    }
    
    internal final func getSize(for containerSize: CGSize) -> CGSize {
        let estimatedWidth = 2 * self.radius * containerSize.width
        let estimatedHeight = 2 * self.radius * containerSize.height
        
        let diameter = max(estimatedWidth, estimatedHeight)
        
        let retval = CGSize(
            width: diameter,
            height: diameter
        )
        
        print("Circle size: \(retval)")
        
        return retval
    }
    
    internal final func updateForZoom(_ scrollView: UIScrollView) {
        print(#function)
    }
    
    internal final func resize(for containerSize: CGSize) {
        print(#function)
        let frameForSize = CGRect(
            origin: self.getOrigin(for: containerSize),
            size: self.getSize(for: containerSize)
        )
        
        self.bounds = CGRect(
            origin: .zero,
            size: frameForSize.size
        )
    }
    
    
}
