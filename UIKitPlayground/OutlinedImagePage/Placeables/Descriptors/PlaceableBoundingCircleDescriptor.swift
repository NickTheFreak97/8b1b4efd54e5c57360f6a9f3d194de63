import Foundation

public final class PlaceableBoundingCircleDescriptor: PlaceableDescriptor, Sendable {
    public let descriptorType: DescriptorType
        
    private let boundingCircle: ZTronBoundingCircle
    private let boundingBox: CGRect?
    
    init(
        boundingCircle: ZTronBoundingCircle,
        normalizedBoundingBox: CGRect?
    ) {
        assert(boundingCircle.getIdleDiameter() != nil || boundingCircle.getIdleDiameter() == nil && normalizedBoundingBox != nil)
        
        if let normalizedBoundingBox = normalizedBoundingBox {
            assert(normalizedBoundingBox.origin.x >= 0 && normalizedBoundingBox.origin.x <= 1)
            assert(normalizedBoundingBox.origin.y >= 0 && normalizedBoundingBox.origin.y <= 1)
            assert(normalizedBoundingBox.size.width >= 0 && normalizedBoundingBox.size.width <= 1)
            assert(normalizedBoundingBox.size.height >= 0 && normalizedBoundingBox.size.height <= 1)
        }

        self.boundingCircle = boundingCircle
        self.boundingBox = normalizedBoundingBox
        
        self.descriptorType = DescriptorType(rawValue: DescriptorType.boundingCircle)!
    }
    
    public func getOutlineBoundingCircle() -> ZTronBoundingCircle  {
        return self.boundingCircle
    }
    
    public func getNormalizedBoundingBox() -> CGRect? {
        return self.boundingBox
    }
}
