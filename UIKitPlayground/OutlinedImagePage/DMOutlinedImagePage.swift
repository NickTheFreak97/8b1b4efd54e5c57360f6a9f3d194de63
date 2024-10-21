import UIKit
import SnapKit
import SwiftSVG

public class DMOutlinedImagePage: DMImagePage, UIPopoverPresentationControllerDelegate {
    private let svgView: ZTronSVGView
    private let circle: CircleView
    private var colorPicker: UIColorPickerViewController!
    
    
    init(imageDescriptor: ZTronOutlinedImageDescriptor) {
        self.svgView = ZTronSVGView(imageDescriptor: imageDescriptor)
        
        self.colorPicker = UIColorPickerViewController()
        self.circle = CircleView(imageDescriptor: imageDescriptor)
        
        super.init(imageDescriptor: imageDescriptor)
        
        self.svgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.presentColorPicker(_:))))

        
        super.imageView.addSubview(self.svgView)
        super.imageView.addSubview(self.circle)
        
        super.scrollView.backgroundColor = .red
        colorPicker.delegate = self
        
        self.colorPicker.modalPresentationStyle = .popover
        self.colorPicker.popoverPresentationController?.sourceView = self.svgView
        self.colorPicker.popoverPresentationController?.delegate = self
    }
    
    required public init?(coder: NSCoder) {
        fatalError("Cannot init from storyboard")
    }
        
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.makePlaceablesConstraintsIfNeeded()
        
        self.view.layoutIfNeeded()
    }
        
    private final func makePlaceablesConstraintsIfNeeded() {
        let sizeThatFits = CGSize.sizeThatFits(containerSize: super.scrollView.bounds.size, containedAR: 16.0/9.0)
        
        self.svgView.snp.removeConstraints()
        
        self.svgView.snp.makeConstraints { make in
            make.left.equalTo(svgView.getOrigin(for: sizeThatFits).x)
            make.top.equalTo(svgView.getOrigin(for: sizeThatFits).y)
            make.width.equalTo(svgView.getSize(for: sizeThatFits).width)
            make.height.equalTo(svgView.getSize(for: sizeThatFits).height)
        }
        
        self.svgView.resize(for: sizeThatFits)
        
        
        self.circle.snp.removeConstraints()
        
        self.circle.snp.makeConstraints { make in
            make.left.equalTo(circle.getOrigin(for: sizeThatFits).x)
            make.top.equalTo(circle.getOrigin(for: sizeThatFits).y)
            make.width.equalTo(circle.getSize(for: sizeThatFits).width)
            make.height.equalTo(circle.getSize(for: sizeThatFits).height)
        }
        
        self.circle.resize(for: sizeThatFits)
    }
            
    @objc private func presentColorPicker(_ sender: UITapGestureRecognizer) {
        
        self.colorPicker.modalPresentationStyle = .popover
        self.colorPicker.popoverPresentationController?.sourceView = self.svgView
        self.colorPicker.popoverPresentationController?.delegate = self

        self.present(self.colorPicker, animated: true)
        self.svgView.isUserInteractionEnabled = false
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.svgView.updateForZoom(scrollView)
        self.circle.updateForZoom(scrollView)
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIDevice.current.userInterfaceIdiom == .pad ? .popover : .none
    }
    
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.svgView.isUserInteractionEnabled = true
    }

}

extension DMOutlinedImagePage: UIColorPickerViewControllerDelegate {
    public func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        self.svgView.strokeColor = color.cgColor
    }
    
    public func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        print("picker dismissal")
    }
}
