// This is a UIViewController class, but I find it
//	more logical to think of it as a "Page"

import UIKit
import SnapKit
import ISVImageScrollView

class DMCarouselPage: UIViewController, UIScrollViewDelegate {
	
	public var pageIndex: Int = 0
	
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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(scrollView)
		self.scrollView.snp.makeConstraints { make in
			make.left.top.right.bottom.equalToSuperview()
		}
		
		scrollView.delegate = self
		scrollView.imageView = self.imageView
	}
	
	public func setImage(_ image: String) {
		self.image = image
	}
	
	func configure(with image: String) {
		self.setImage(image)
	}
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return self.imageView
	}
}
