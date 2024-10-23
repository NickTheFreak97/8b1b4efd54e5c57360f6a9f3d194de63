import UIKit
import SnapKit
import SwiftSVG

import ZTronObservation

public class DMOutlinedImagePage: DMImagePage, UIPopoverPresentationControllerDelegate, Component {
    public let id: String
    private var delegate: (any MSAInteractionsManager)?
    
    private var colorPicker: UIColorPickerViewController!
    private var placeables: [any PlaceableView] = []
    private let mediator: MSAMediator = MSAMediator()
    
    init(
        imageDescriptor: ZTronOutlinedImageDescriptor
    ) {
        self.id = imageDescriptor.getAssetName()
        
        let descriptors = imageDescriptor.getPlaceableDescriptors()
        let placeablesFactory = ZTronBasicPlaceableFactory(mediator: self.mediator)
                        
        self.colorPicker = UIColorPickerViewController()
                
        super.init(imageDescriptor: imageDescriptor)
        
        self.setDelegate(ImagePageInteractionsManager(owner: self, mediator: self.mediator))

        descriptors.forEach { descriptor in
            self.placeables.append(placeablesFactory.make(placeable: descriptor))
        }
        
        
        assert(self.placeables.count > 0)
        
        self.placeables.first!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.presentColorPicker(_:))))

        self.placeables.forEach {
            self.imageView.addSubview($0)
        }
        
        
        super.scrollView.backgroundColor = .red
        colorPicker.delegate = self
        
        self.colorPicker.modalPresentationStyle = .popover
        self.colorPicker.popoverPresentationController?.sourceView = self.placeables.first!
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
    
    public final func getDelegate() -> (any ZTronObservation.InteractionsManager)? {
        return self.delegate
    }
    
    public final func setDelegate(_ interactionsManager: (any ZTronObservation.InteractionsManager)?) {
        guard let interactionsManager = interactionsManager as? ImagePageInteractionsManager else {
            // Still it might be that interactionsmanager == nil
            if interactionsManager == nil {
                if let delegate = self.delegate {
                    delegate.detach()
                }
            } else {
                fatalError("Provide an interaction manager of type \(String(describing: ImagePageInteractionsManager.self))")
            }
            
            self.delegate = nil
            
            return
        }
                
        if let delegate = self.delegate {
            delegate.detach()
        }
        
        self.delegate = interactionsManager
        
        interactionsManager.setup()
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
