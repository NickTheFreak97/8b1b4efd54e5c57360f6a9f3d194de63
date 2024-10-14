import Foundation
import SwiftSVG
import SnapKit

public final class ZTronSVGView: UIView, PlaceableView {
    private var svgView: UIView!
    private let svgURL: URL
    private let normalizedAABB: CGRect
    private var svgLayer: SVGLayer!
    private var colorPicker: UIColorPickerViewController!
        
    public var lineWidth: CGFloat = 5.0 {
        didSet {
            guard let svgLayer = self.svgLayer else { return }
            svgLayer.lineWidth = self.lineWidth
        }
    }
    
    public var strokeColor: CGColor = CGColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0) {
        didSet {
            guard let svgLayer = self.svgLayer else { return }
            svgLayer.strokeColor = self.strokeColor
        }
    }
    
    public init(imageDescriptor: ZTronOutlinedImageDescriptor) {
        guard let url = Bundle.main.url(
            forResource: imageDescriptor.getOutlineAssetName(),
            withExtension: "svg"
        ) else { fatalError("No resource named \(imageDescriptor.getOutlineAssetName()).svg. Aborting.") }

        self.svgURL = url
        self.normalizedAABB = imageDescriptor.getOutlineBoundingBox()
        
        super.init(frame: .zero)
        
        self.svgView = SVGView(SVGURL: url) { svgLayer in
            self.svgLayer = svgLayer
            svgLayer.lineWidth = self.lineWidth
            svgLayer.strokeColor = self.strokeColor
            svgLayer.fillColor = .none
            self.svgLayer.resizeToFit(self.bounds)
        }
        
        self.addSubview(svgView)
        
        svgView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("Cannot instantiate from Storyboard. Aborting")
    }
    
    public final func resize(for containerSize: CGSize) {
        guard let svgView = self.svgView else { return }
        guard let svgLayer = self.svgLayer else { return }
        let newRect = CGRect(
            x: self.getOrigin(for: containerSize).x,
            y: self.getOrigin(for: containerSize).y,
            width: self.getSize(for: containerSize).width,
            height: self.getSize(for: containerSize).height
        )
        
        svgLayer.resizeToFit(newRect)
        svgView.bounds = CGRect(origin: .zero, size: newRect.size)
        
        self.layoutIfNeeded()
    }
    
    public final func getOrigin(for containerSize: CGSize) -> CGPoint {
        return CGPoint(
            x: containerSize.width * self.normalizedAABB.origin.x,
            y: containerSize.height * self.normalizedAABB.origin.y
        )
    }
    
    public final func getSize(for containerSize: CGSize) -> CGSize {
        return CGSize(
            width: containerSize.width * self.normalizedAABB.width,
            height: containerSize.height * self.normalizedAABB.height
        )
    }
    
    public func updateForZoom(_ scrollView: UIScrollView) {
        self.lineWidth = max(
            5,
            (5...50.0).larp(
                1 - (scrollView.zoomScale - scrollView.minimumZoomScale)/(scrollView.maximumZoomScale - scrollView.minimumZoomScale)
            )
        )
    }
    
}
