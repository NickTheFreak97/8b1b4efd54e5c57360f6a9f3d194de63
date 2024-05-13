import UIKit
import ISVImageScrollView
import SnapKit

class UIScrollViewController: UIViewController, UIScrollViewDelegate {
    private let imageName: String
    
    lazy private var imageView: UIImageView = {
        guard let image = UIImage(named: imageName) else { fatalError() }
        
        let imgView = UIImageView(image: image)
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    
    lazy private var scrollView: ISVImageScrollView = { [unowned self] in
        let scrollView = ISVImageScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 20.0
        scrollView.delegate = self
        scrollView.imageView = self.imageView
        scrollView.backgroundColor = .systemRed
        
        return scrollView
    }()
    
    init(imageName: String) {
        self.imageName = imageName
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(view)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}
