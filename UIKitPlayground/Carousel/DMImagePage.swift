import UIKit
import SnapKit
import ISVImageScrollView

open class DMImagePage: UIViewController, UIScrollViewDelegate, CountedUIViewController {
    public var pageIndex: Int = 0
    
    private var image: String
    public let imageView: UIImageView!
    
    public let scrollView: ISVImageScrollView = {
        let scrollView = ISVImageScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 20.0
        scrollView.zoomScale = 1.0
        scrollView.contentOffset = .zero
        scrollView.bouncesZoom = true
        

        return scrollView
    }()
        

    init(imageDescriptor: ZTronImageDescriptor) {
        self.image = imageDescriptor.getAssetName()
                
        let image = UIImage(named: imageDescriptor.getAssetName())!
        let imageView = UIImageView(image: image)

        self.imageView = imageView

        super.init(nibName: nil, bundle: nil)
        scrollView.delegate = self

        scrollView.imageView = imageView
        self.view.addSubview(scrollView)
        self.view.backgroundColor = UIColor.black

        self.scrollView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }

    }
        
    required public init?(coder: NSCoder) {
        fatalError("Cannot init from storyboard")
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
