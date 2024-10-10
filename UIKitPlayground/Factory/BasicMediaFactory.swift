public final class BasicMediaFactory: MediaFactory {
    public func makeVideoPage(for videoDescriptor: ZTronVideoDescriptor) -> (any CountedUIViewController)? {
        return DMVideoCarouselPage(videoDescriptor: videoDescriptor)
    }
    
    public func makeImagePage(for imageDescriptor: ZTronImageDescriptor) -> any CountedUIViewController {
        return DMImagePage(imageDescriptor: imageDescriptor)
    }
}
