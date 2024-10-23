import Foundation

public final class ZTronBasicPlaceableFactory: ZTronPlaceableFactory {
    public func make(placeable: PlaceableBoundingCircleDescriptor) -> any PlaceableView {
        return CircleView(descriptor: placeable)
    }
    
    public func make(placeable: PlaceableOutlineDescriptor) -> any PlaceableView {
        return ZTronSVGView(descriptor: placeable)
    }
}
