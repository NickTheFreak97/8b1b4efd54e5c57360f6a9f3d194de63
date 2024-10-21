import UIKit
import SnapKit
import SwiftSVG

public class DMOutlinedImagePage: DMImagePage, UIPopoverPresentationControllerDelegate {
    private var colorPicker: UIColorPickerViewController!
    private var placeables: [any PlaceableView] = []
    
    
    init(imageDescriptor: ZTronOutlinedImageDescriptor) {
        let theSVG = ZTronSVGView(imageDescriptor: imageDescriptor)
        self.placeables.append(theSVG)
        
        self.colorPicker = UIColorPickerViewController()
        
        if imageDescriptor.getOutlineBoundingCircle() != nil {
            self.placeables.append(CircleView(imageDescriptor: imageDescriptor))
        }
        
        super.init(imageDescriptor: imageDescriptor)
        
        theSVG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.presentColorPicker(_:))))

        self.placeables.forEach {
            self.imageView.addSubview($0)
        }
                
        super.scrollView.backgroundColor = .red
        colorPicker.delegate = self
        
        self.colorPicker.modalPresentationStyle = .popover
        self.colorPicker.popoverPresentationController?.sourceView = theSVG
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
        
        self.placeables.forEach { thePlaceable in
            thePlaceable.snp.removeConstraints()
            
            thePlaceable.snp.makeConstraints { make in
                make.left.equalTo(thePlaceable.getOrigin(for: sizeThatFits).x)
                make.top.equalTo(thePlaceable.getOrigin(for: sizeThatFits).y)
                make.width.equalTo(thePlaceable.getSize(for: sizeThatFits).width)
                make.height.equalTo(thePlaceable.getSize(for: sizeThatFits).height)
            }
            
            thePlaceable.resize(for: sizeThatFits)
        }
    }
            
    @objc private func presentColorPicker(_ sender: UITapGestureRecognizer) {
        self.colorPicker.modalPresentationStyle = .popover
        self.colorPicker.popoverPresentationController?.sourceView = self.placeables.first!
        self.colorPicker.popoverPresentationController?.delegate = self

        self.present(self.colorPicker, animated: true)
        self.placeables.first?.isUserInteractionEnabled = false
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.placeables.forEach {
            $0.updateForZoom(scrollView)
        }
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIDevice.current.userInterfaceIdiom == .pad ? .popover : .none
    }
    
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.placeables.first?.isUserInteractionEnabled = true
    }

}

extension DMOutlinedImagePage: UIColorPickerViewControllerDelegate {
    public func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        self.placeables.forEach { thePlaceable in
            if let thePlaceable = (thePlaceable as? any PlaceableColoredView) {
                thePlaceable.colorChanged(color)
            }
        }
    }
}
