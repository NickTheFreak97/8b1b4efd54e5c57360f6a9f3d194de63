import UIKit
import SnapKit
import SwiftSVG

public class DMOutlinedImagePage: DMImagePage {
    private var svgView: UIView!
    private let svgURL: URL
    private let normalizedAABB: CGRect
    private var svgLayer: SVGLayer!
    
    
    init(imageDescriptor: ZTronOutlinedImageDescriptor) {
        guard let url = Bundle.main.url(
            forResource: imageDescriptor.getOutlineAssetName(),
            withExtension: "svg"
        ) else { fatalError("No resource named \(imageDescriptor.getOutlineAssetName()).svg. Aborting.") }
                
        
        self.normalizedAABB = imageDescriptor.getOutlineBoundingBox()
        self.svgView = nil
        self.svgURL = url
        
        super.init(imageDescriptor: imageDescriptor)
        
        super.scrollView.backgroundColor = .red
    }
    
    required public init?(coder: NSCoder) {
        fatalError("Cannot init from storyboard")
    }
            
    override public func viewDidLayoutSubviews() {
        print(#function)
        super.viewDidLayoutSubviews()
        self.makeSVGConstraintsIfNeeded()
        self.view.layoutIfNeeded()
    }
        
    private final func makeSVGConstraintsIfNeeded() {
        let sizeThatFits = CGSize.sizeThatFits(containerSize: super.scrollView.bounds.size, containedAR: 16.0/9.0)

        if self.svgView == nil {
            self.svgView = SVGView(SVGURL: self.svgURL) { svgLayer in
                self.svgLayer = svgLayer
                
                svgLayer.resizeToFit(
                    CGRect(
                        x: super.scrollView.bounds.size.width * self.normalizedAABB.origin.x,
                        y: super.scrollView.bounds.size.height * self.normalizedAABB.origin.y,
                        width: super.scrollView.bounds.size.width * self.normalizedAABB.size.width,
                        height: super.scrollView.bounds.size.height * self.normalizedAABB.size.height
                    )
                )
                
                svgLayer.strokeColor = CGColor.init(red: 1.0, green: 0, blue: 0, alpha: 1.0)
                svgLayer.fillColor = .none
                svgLayer.lineWidth = 20.0
            }
            
            super.imageView.addSubview(self.svgView)
        } else {
            self.svgView.snp.removeConstraints()
            
            self.svgLayer.resizeToFit(
                CGRect(
                    x: sizeThatFits.width * self.normalizedAABB.origin.x,
                    y: sizeThatFits.height * self.normalizedAABB.origin.y,
                    width: sizeThatFits.width * self.normalizedAABB.size.width,
                    height: sizeThatFits.height * self.normalizedAABB.size.height
                )
            )
        }
        
        self.svgView.snp.makeConstraints { make in
            make.left.equalTo(super.imageView).offset(self.normalizedAABB.origin.x * sizeThatFits.width)
            make.top.equalTo(super.imageView).offset(self.normalizedAABB.origin.y * sizeThatFits.height)
            make.width.equalTo(sizeThatFits.width).multipliedBy(self.normalizedAABB.size.width)
            make.height.equalTo(sizeThatFits.height).multipliedBy(self.normalizedAABB.size.height)
        }
    }
            
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let svgLayer = self.svgLayer else { return }
        
        svgLayer.lineWidth = (10.0...50.0).larp(
            1 - (scrollView.zoomScale - scrollView.minimumZoomScale)/(scrollView.maximumZoomScale - scrollView.minimumZoomScale)
        )
    }
}
