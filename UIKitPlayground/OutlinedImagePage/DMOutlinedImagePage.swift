import UIKit
import SnapKit
import SwiftSVG

public class DMOutlinedImagePage: DMImagePage, UIPopoverPresentationControllerDelegate {
    private let svgView: ZTronSVGView
    private var colorPicker: UIColorPickerViewController!
    
    
    init(imageDescriptor: ZTronOutlinedImageDescriptor) {
        self.svgView = ZTronSVGView(imageDescriptor: imageDescriptor)
        
        self.colorPicker = UIColorPickerViewController()
        
        super.init(imageDescriptor: imageDescriptor)
        
        self.svgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.presentColorPicker(_:))))

        
        super.imageView.addSubview(self.svgView)
        super.scrollView.backgroundColor = .red
        colorPicker.delegate = self
        
        self.colorPicker.modalPresentationStyle = .popover
        self.colorPicker.popoverPresentationController?.sourceView = self.svgView
        self.colorPicker.popoverPresentationController?.delegate = self
        
        let testCircle = CircleView(
            frame: CGRect(
                origin: .zero,
                size: CGSize(width: 44, height: 44)
            )
        )
        
        self.view.addSubview(testCircle)
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
            
    @objc private func presentColorPicker(_ sender: UITapGestureRecognizer) {
        self.colorPicker.modalPresentationStyle = .popover
        self.colorPicker.popoverPresentationController?.sourceView = self.svgView
        self.colorPicker.popoverPresentationController?.delegate = self

        self.present(self.colorPicker, animated: true) {
            print("Color picker is presenting")
        }
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.svgView.updateForZoom(scrollView)
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIDevice.current.userInterfaceIdiom == .pad ? .popover : .none
    }

}

extension DMOutlinedImagePage: UIColorPickerViewControllerDelegate {
    public func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        self.svgView.strokeColor = color.cgColor
    }    
}
