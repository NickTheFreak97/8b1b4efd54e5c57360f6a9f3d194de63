public protocol MediaFactory {
    func makeVideoPage(for videoDescriptor: ZTronVideoDescriptor) -> (any CountedUIViewController)?
    func makeImagePage(for imageDescriptor: ZTronImageDescriptor) -> CountedUIViewController
}
