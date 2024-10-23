import Foundation

public final class ZTronOutlinedImageDescriptor: ZTronImageDescriptor {
    private let placeablesDescriptors: [any PlaceableDescriptor]
    
    public init(
        assetName: String,
        placeables: [any PlaceableDescriptor]
    ) {
        self.placeablesDescriptors = placeables
        super.init(assetName: assetName)
    }
    
    public func getPlaceableDescriptors() -> [any PlaceableDescriptor] {
        return Array(self.placeablesDescriptors)
    }
}

public struct ZTronBoundingCircle: Sendable {
    internal let idleDiameter: Double?
    internal let normalizedCenter: CGPoint?

    init(idleDiameter: Double?, normalizedCenter: CGPoint?) {
        self.idleDiameter = idleDiameter
        self.normalizedCenter = normalizedCenter
    }
    
    internal func getIdleDiameter() -> Double? {
        return self.idleDiameter
    }
    
    internal func getNormalizedCenter() -> CGPoint? {
        return self.normalizedCenter
    }
}
