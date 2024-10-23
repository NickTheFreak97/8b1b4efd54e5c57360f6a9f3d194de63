import Foundation
import ZTronObservation

public final class BoundingCircleInteractionsManager: MSAInteractionsManager, @unchecked Sendable {
    weak private var owner: CircleView?
    weak private var mediator: MSAMediator?
    
    init(owner: CircleView? = nil, mediator: MSAMediator) {
        self.owner = owner
        self.mediator = mediator
    }
    
    
    public func peerDiscovered(eventArgs: ZTronObservation.BroadcastArgs) {
        guard let owner = self.owner else { return }
        
        if let image = eventArgs.getSource() as? DMOutlinedImagePage {
            self.mediator?.signalInterest(owner, to: image)
        }
    }
    
    public func peerDidAttach(eventArgs: ZTronObservation.BroadcastArgs) {
        
    }
    
    public func notify(args: ZTronObservation.BroadcastArgs) {
        if let image = args.getSource() as? DMOutlinedImagePage {
            print("Updating outline color")
            self.owner?.setStrokeColor(image.getSelectedColor().cgColor)
        }
    }
    
    public func willCheckout(args: ZTronObservation.BroadcastArgs) {
        
    }
    
    public func getOwner() -> (any ZTronObservation.Component)? {
        return self.owner
    }
    
    public func getMediator() -> (any ZTronObservation.Mediator)? {
        return self.mediator
    }
}
