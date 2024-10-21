import UIKit

internal class CircleView: UIView, PlaceableView {
    weak private var circleLayer: CAShapeLayer? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(
            arcCenter: self.center,
            radius: self.bounds.size.width / 2,
            startAngle: 0,
            endAngle: 2*CGFloat.pi,
            clockwise: true
        ).cgPath
        
        circleLayer.lineWidth = 2.0
        circleLayer.strokeColor = .init(red: 1.0, green: 0, blue: 0, alpha: 1)
        circleLayer.fillColor = .none
        
        self.layer.addSublayer(circleLayer)
    
        self.circleLayer = circleLayer
    }
    
    required init?(coder: NSCoder) {
        fatalError("Cannot initialize from storyboards")
    }
    
    func getOrigin(for containerSize: CGSize) -> CGPoint {
        return .zero
    }
    
    func getSize(for containerSize: CGSize) -> CGSize {
        return .zero
    }
    
    func updateForZoom(_ scrollView: UIScrollView) {
        
    }
    
    
}
