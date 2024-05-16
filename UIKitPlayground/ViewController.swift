import UIKit

class ViewController: UICollectionViewController {
    private var currentPage: IndexPath? = nil
    
    //private let images = ["police", "shutters", "depot", "cakes", "sign"]
    private let images = ["police1", "shutters1", "depot1", "cakes1", "sign1"]
    
    init() {
        let compositionalLayout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            
            let absoluteW = environment.container.effectiveContentSize.width
            let absoluteH = environment.container.effectiveContentSize.height
            
            // Handle landscape
            if absoluteW > absoluteH {
                print("landscape")
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            } else {
                // Handle portrait
                
                print("portrait")
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(absoluteW * 9.0/16.0)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(absoluteW * 9.0/16.0)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        config.scrollDirection = .horizontal
        
        compositionalLayout.configuration = config
        
        super.init(collectionViewLayout: compositionalLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        // Register cell for reuse
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reuseIdentifier)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.reuseIdentifier, for: indexPath) as? CarouselCell else {
            fatalError()
        }
        
        let index : Int = (indexPath.section * self.images.count) + indexPath.row
        
        reusableCell.configure(with: self.images[index])
        
        return reusableCell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let theLastIndex = Int(self.collectionView.contentOffset.x / self.collectionView.bounds.width)
        coordinator.animate(
            alongsideTransition: { [unowned self] _ in
                self.collectionView.scrollToItem(at: IndexPath(item: theLastIndex, section: 0), at: .centeredHorizontally, animated: true)
            },
            completion: { [unowned self] _ in
                // if we want to do something after the size transition
            }
        )
    }

    
}

class CVSubVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var collectionView: UICollectionView!
	
	private let images = ["police1", "shutters1", "depot1", "cakes1", "sign1"]

	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemYellow
		
		let fl = UICollectionViewFlowLayout()
		fl.scrollDirection = .horizontal
		fl.minimumLineSpacing = 0.0
		fl.minimumInteritemSpacing = 0.0
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: fl)
		collectionView.isPagingEnabled = true
	
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(collectionView)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			// constrain collectionView to Top/Leading/Trailing of safe-area
			collectionView.topAnchor.constraint(equalTo: g.topAnchor, constant: 0.0),
			collectionView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 0.0),
			collectionView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0.0),
			
			collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 9.0 / 16.0),
		])
		
		collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reuseIdentifier)
		collectionView.dataSource = self
		collectionView.delegate = self

	}
	
	var cvWidth: CGFloat = 0.0
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if cvWidth != collectionView.frame.width {
			cvWidth = collectionView.frame.width
			if let fl = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
				let w: CGFloat = cvWidth
				let h: CGFloat = w * 9.0 / 16.0
				fl.itemSize = .init(width: w, height: h)
			}
		}
	}
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let c = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.reuseIdentifier, for: indexPath) as! CarouselCell
		c.configure(with: images[indexPath.item])
		return c
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		let theLastIndex = Int(self.collectionView.contentOffset.x / self.collectionView.bounds.width)
		coordinator.animate(
			alongsideTransition: { [unowned self] _ in
				self.collectionView.scrollToItem(at: IndexPath(item: theLastIndex, section: 0), at: .centeredHorizontally, animated: false)
			},
			completion: { [unowned self] _ in
				self.collectionView.scrollToItem(at: IndexPath(item: theLastIndex, section: 0), at: .centeredHorizontally, animated: false)
				// if we want to do something after the size transition
			}
		)
	}
}

class MyTestViewController: UIViewController {
	
	let myContainerView: UIView = {
		let v = UIView()
		v.translatesAutoresizingMaskIntoConstraints = false
		v.backgroundColor = .gray
		return v
	}()
	
	var thePageVC: MyPageViewController!
	
	var pgvcHeight: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// add myContainerView
		view.addSubview(myContainerView)
		
		let g = view.safeAreaLayoutGuide
		pgvcHeight = myContainerView.heightAnchor.constraint(equalTo: myContainerView.widthAnchor, multiplier: 9.0 / 16.0)
		NSLayoutConstraint.activate([
			myContainerView.topAnchor.constraint(equalTo: g.topAnchor, constant: 0.0),
			myContainerView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 0.0),
			myContainerView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0.0),
			pgvcHeight,
		])
		
		// instantiate MyPageViewController and add it as a Child View Controller
		thePageVC = MyPageViewController()
		addChild(thePageVC)
		
		// we need to re-size the page view controller's view to fit our container view
		thePageVC.view.translatesAutoresizingMaskIntoConstraints = false
		
		// add the page VC's view to our container view
		myContainerView.addSubview(thePageVC.view)
		
		// constrain it to all 4 sides
		NSLayoutConstraint.activate([
			thePageVC.view.topAnchor.constraint(equalTo: myContainerView.topAnchor, constant: 0.0),
			thePageVC.view.bottomAnchor.constraint(equalTo: myContainerView.bottomAnchor, constant: 0.0),
			thePageVC.view.leadingAnchor.constraint(equalTo: myContainerView.leadingAnchor, constant: 0.0),
			thePageVC.view.trailingAnchor.constraint(equalTo: myContainerView.trailingAnchor, constant: 0.0),
		])
		
		thePageVC.didMove(toParent: self)
	}
	var curWidth: CGFloat = 0.0
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if curWidth != view.frame.width {
			curWidth = view.frame.width
			pgvcHeight.isActive = false
			if view.frame.width > view.frame.height {
				print("land")
				pgvcHeight = myContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0.0)
			} else {
				print("port")
				pgvcHeight = myContainerView.heightAnchor.constraint(equalTo: myContainerView.widthAnchor, multiplier: 9.0 / 16.0)
			}
			pgvcHeight.isActive = true
		}
	}
}

class ExampleViewController: UIViewController {
	
	public var pageIndex: Int = 0
	
	let theImageView = UIImageView()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(theImageView)
		self.theImageView.snp.makeConstraints { make in
			make.left.top.right.bottom.equalToSuperview()
		}
	}
	
	func configure(with image: String) {
		if let img = UIImage(named: image) {
			self.theImageView.image = img
		}
	}
}

import ISVImageScrollView

class CarouselViewController: UIViewController, UIScrollViewDelegate {
	
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

// example Page View Controller
class MyPageViewController: UIPageViewController {
	
	private let images = ["police", "shutters", "depot", "cakes", "sign"]
	//private let images = ["police1", "shutters1", "depot1", "cakes1", "sign1"]
	
	override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
		super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		dataSource = self
		delegate = nil

//		let vc = ExampleViewController()
//		vc.configure(with: images[0])
//		vc.pageIndex = 0

		let vc = CarouselViewController()
		vc.loadViewIfNeeded()
		vc.configure(with: images[0])
		vc.pageIndex = 0

		setViewControllers([vc], direction: .forward, animated: false, completion: nil)
	}
	
}

extension MyPageViewController: UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		print(#function)
		//guard let vc = viewController as? ExampleViewController else { return nil }
		guard let vc = viewController as? CarouselViewController else { return nil }
		
		if vc.pageIndex == 0 { return nil }

		let n = vc.pageIndex - 1

		//let newVC = ExampleViewController()
		let newVC = CarouselViewController()
		newVC.loadViewIfNeeded()
		newVC.configure(with: images[n])
		newVC.pageIndex = n
		
		return newVC
		
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		print(#function)
		//guard let vc = viewController as? ExampleViewController else { return nil }
		guard let vc = viewController as? CarouselViewController else { return nil }

		if vc.pageIndex >= images.count - 1 { return nil }
		
		let n = vc.pageIndex + 1
		
		//let newVC = ExampleViewController()
		let newVC = CarouselViewController()
		newVC.loadViewIfNeeded()
		newVC.configure(with: images[n])
		newVC.pageIndex = n

		return newVC
		
	}

}
/*
// typical Page View Controller Data Source
extension MyPageViewController: UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
		
		let previousIndex = viewControllerIndex - 1
		
		guard previousIndex >= 0 else { return pages.last }
		
		guard pages.count > previousIndex else { return nil }
		
		return pages[previousIndex]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
		
		let nextIndex = viewControllerIndex + 1
		
		guard nextIndex < pages.count else { return pages.first }
		
		guard pages.count > nextIndex else { return nil }
		
		return pages[nextIndex]
	}
}
 */
/*
// typical Page View Controller Delegate
extension MyPageViewController: UIPageViewControllerDelegate {
	
	// if you do NOT want the built-in PageControl (the "dots"), comment-out these funcs
	
	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return pages.count
	}
	
	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		
		guard let firstVC = pageViewController.viewControllers?.first else {
			return 0
		}
		guard let firstVCIndex = pages.firstIndex(of: firstVC) else {
			return 0
		}
		
		return firstVCIndex
	}
}
*/
