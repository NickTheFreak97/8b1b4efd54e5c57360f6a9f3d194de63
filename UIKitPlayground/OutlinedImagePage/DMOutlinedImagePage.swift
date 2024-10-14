import UIKit
import SnapKit
import SwiftSVG

public class DMOutlinedImagePage: DMImagePage {
    private let normalizedAABB: CGRect
    private let svgView: ZTronSVGView!
    private var colorPicker: UIColorPickerViewController!
    
    
    init(imageDescriptor: ZTronOutlinedImageDescriptor) {        
        self.normalizedAABB = imageDescriptor.getOutlineBoundingBox()
        self.svgView = ZTronSVGView(imageDescriptor: imageDescriptor)
        
        self.colorPicker = UIColorPickerViewController()
        
        super.init(imageDescriptor: imageDescriptor)
        
        super.imageView.addSubview(self.svgView)
        super.scrollView.backgroundColor = .red
        colorPicker.delegate = self
        
        colorPicker.modalPresentationStyle = .popover
    }
    
    required public init?(coder: NSCoder) {
        fatalError("Cannot init from storyboard")
    }
        
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.makeSVGConstraintsIfNeeded()
        self.view.layoutIfNeeded()
    }
        
    private final func makeSVGConstraintsIfNeeded() {
        let sizeThatFits = CGSize.sizeThatFits(containerSize: super.scrollView.bounds.size, containedAR: 16.0/9.0)
        
        self.svgView.snp.removeConstraints()
        
        self.svgView.snp.makeConstraints { make in
            make.left.equalTo(svgView.getOrigin(for: sizeThatFits).x)
            make.top.equalTo(svgView.getOrigin(for: sizeThatFits).y)
            make.width.equalTo(svgView.getSize(for: sizeThatFits).width)
            make.height.equalTo(svgView.getSize(for: sizeThatFits).height)
        }
        
        self.svgView.resize(for: sizeThatFits)
    }
            
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.svgView.updateForZoom(scrollView)
    }
    
    @objc private func overlayDidTap(_ sender: UITapGestureRecognizer) {
        present(self.colorPicker, animated: true, completion: nil)
    }
}

extension DMOutlinedImagePage: UIColorPickerViewControllerDelegate {
    public func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        self.svgView.strokeColor = color.cgColor
    }
}
