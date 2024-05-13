import Foundation

class ImageModel {
    private let imageAssetName: String
    private let outlineName: String
    
    init(imageAssetName: String, outlineName: String) {
        self.imageAssetName = imageAssetName
        self.outlineName = outlineName
    }
    
    public func getAssetImageName() -> String {
        return self.imageAssetName
    }
    
    public func getOutlineName() -> String {
        return self.outlineName
    }
}
