import Foundation

public final class PlaceableOutlineDescriptor: PlaceableDescriptor, Sendable {
    public let descriptorType: DescriptorType
    
    private let outlineAssetName: String
    private let normalizedBoundingBox: CGRect
    
    public init(
        outlineAssetName: String,
        outlineBoundingBox: CGRect
    ) {
        assert(outlineBoundingBox.origin.x >= 0 && outlineBoundingBox.origin.x <= 1)
        assert(outlineBoundingBox.origin.y >= 0 && outlineBoundingBox.origin.y <= 1)
        assert(outlineBoundingBox.size.width >= 0 && outlineBoundingBox.size.width <= 1)
        assert(outlineBoundingBox.size.height >= 0 && outlineBoundingBox.size.height <= 1)

        self.outlineAssetName = outlineAssetName
        self.normalizedBoundingBox = outlineBoundingBox
        
        self.descriptorType = DescriptorType(rawValue: DescriptorType.outline)!
    }
    
    
    public func getOutlineAssetName() -> String {
        return self.outlineAssetName
    }
    
    public func getOutlineBoundingBox() -> CGRect {
        return self.normalizedBoundingBox
    }
}
