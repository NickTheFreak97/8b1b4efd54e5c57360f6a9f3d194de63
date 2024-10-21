import Foundation

public class ZTronOutlinedImageDescriptor: ZTronImageDescriptor {
    private let outlineAssetName: String
    private let outlineBoundingBox: CGRect
    private let boundingCircle: ZTronBoundingCircle
    
    public init(
        assetName: String,
        outlineAssetName: String,
        outlineBoundingBox: CGRect,
        boundingCircle: ZTronBoundingCircle
    ) {
        assert(outlineBoundingBox.origin.x >= 0 && outlineBoundingBox.origin.x <= 1)
        assert(outlineBoundingBox.origin.y >= 0 && outlineBoundingBox.origin.y <= 1)
        assert(outlineBoundingBox.size.width >= 0 && outlineBoundingBox.size.width <= 1)
        assert(outlineBoundingBox.size.height >= 0 && outlineBoundingBox.size.height <= 1)

        self.outlineAssetName = outlineAssetName
        self.outlineBoundingBox = outlineBoundingBox
        self.boundingCircle = boundingCircle
        
        super.init(assetName: assetName)
    }
    
    public func getOutlineAssetName() -> String {
        return self.outlineAssetName
    }
    
    public func getOutlineBoundingBox() -> CGRect {
        return self.outlineBoundingBox
    }
    
    public func getOutlineBoundingCircle() -> ZTronBoundingCircle?  {
        return self.boundingCircle
    }
}

public struct ZTronBoundingCircle {
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
