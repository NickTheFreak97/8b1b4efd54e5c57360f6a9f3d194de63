import Foundation

public class ZTronOutlinedImageDescriptor: ZTronImageDescriptor {
    private let outlineAssetName: String
    private let outlineBoundingBox: CGRect
    
    public init(assetName: String, outlineAssetName: String, outlineBoundingBox: CGRect) {
        assert(outlineBoundingBox.origin.x >= 0 && outlineBoundingBox.origin.x <= 1)
        assert(outlineBoundingBox.origin.y >= 0 && outlineBoundingBox.origin.y <= 1)
        assert(outlineBoundingBox.size.width >= 0 && outlineBoundingBox.size.width <= 1)
        assert(outlineBoundingBox.size.height >= 0 && outlineBoundingBox.size.height <= 1)

        self.outlineAssetName = outlineAssetName
        self.outlineBoundingBox = outlineBoundingBox
        
        super.init(assetName: assetName)
    }
    
    public func getOutlineAssetName() -> String {
        return self.outlineAssetName
    }
    
    public func getOutlineBoundingBox() -> CGRect {
        return self.outlineBoundingBox
    }
}
