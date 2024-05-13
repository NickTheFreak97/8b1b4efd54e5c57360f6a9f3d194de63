import UIKit
import SnapKit
import ISVImageScrollView

class CarouselCell: UICollectionViewCell, SelfConfiguringCell, UIScrollViewDelegate {
    static var reuseIdentifier: String = "carousel.cell"
    
    internal var image: String = "placeholder" {
        didSet {
            self.imageView = UIImageView(image: UIImage(named: image))
            self.scrollView.imageView = self.imageView
        }
    }
    
    fileprivate let scrollView: ISVImageScrollView = {
        let scrollView = ISVImageScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 30.0
        scrollView.zoomScale = 1.0
        scrollView.contentOffset = .zero
        scrollView.bouncesZoom = true
        

        return scrollView
    }()
    
    fileprivate var imageView: UIImageView = {
        let image = UIImage(named: "afterlife.door")!
        let imageView = UIImageView(image: image)

        return imageView
    }()
    
    public func setImage(_ image: String) {
        self.image = image
    }
    
    func configure(with image: String) {
        self.setImage(image)
        
        self.scrollView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(contentView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.black
        scrollView.delegate = self

        scrollView.imageView = self.imageView
        contentView.addSubview(scrollView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Cannot init from storyboard")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
