import Foundation
import ZTronObservation

public final class ImagePageInteractionsManager: MSAInteractionsManager, @unchecked Sendable {
    weak private var owner: DMOutlinedImagePage?
    weak private var mediator: MSAMediator?
    
    public init(owner: DMOutlinedImagePage?, mediator: MSAMediator?) {
        self.owner = owner
        self.mediator = mediator
    }
    
    public func peerDiscovered(eventArgs: ZTronObservation.BroadcastArgs) {
        
    }
    
    public func peerDidAttach(eventArgs: ZTronObservation.BroadcastArgs) {
        
    }
    
    public func notify(args: ZTronObservation.BroadcastArgs) {
        
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
