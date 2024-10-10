public enum VisualMedia {
    case image
    case video
}

public protocol VisualMediaDescriptor {
    var type: VisualMedia { get }
    
    func getAssetName() -> String 
}
