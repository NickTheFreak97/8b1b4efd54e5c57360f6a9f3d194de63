public final class OutlinedMediaFactory: MediaFactory {
    public func makeVideoPage(for videoDescriptor: ZTronVideoDescriptor) -> (any CountedUIViewController)? {
        return DMVideoCarouselPage(videoDescriptor: videoDescriptor)
    }
    
    public func makeImagePage(for imageDescriptor: ZTronImageDescriptor) -> any CountedUIViewController {
        guard let outlinedDescriptor = imageDescriptor as? ZTronOutlinedImageDescriptor else { fatalError("Expected image descriptor to be an outlined image descriptor.") }
        return DMOutlinedImagePage(imageDescriptor: outlinedDescriptor)
    }
}
