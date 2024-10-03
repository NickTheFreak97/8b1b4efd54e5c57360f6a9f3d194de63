import UIKit
import SnapKit

class DMViewController: UIViewController {
	
	private let images = ["step-1.hevc"]// ["police", "shutters", "depot", "cakes", "sign"]
	
	// I created smaller, labeled images to make it easier to
	//	see the animation problem when using UICollectionView
	//private let images = ["police1", "shutters1", "depot1", "cakes1", "sign1"]
	
	// this will hold the page view controller
	private let myContainerView: UIView = {
		let v = UIView()
		v.backgroundColor = .black
		return v
	}()
	
	// we will add a UIPageViewController as a child VC
	private var thePageVC: DMCarouselPageViewController!
	
	// this will be used to change the page view controller height based on
	//	view width-to-height (portrait/landscape)
	// I know this could be done with a SnapKit object, but I don't use SnapKit...
	private var pgvcHeight: NSLayoutConstraint!
    private var pgvcWidth: NSLayoutConstraint!
    
	// track current view width
	private var curWidth: CGFloat = 0.0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// so we can see the view / page view controller framing
		view.backgroundColor = .systemBackground
		
		// add myContainerView
		myContainerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(myContainerView)
		
		myContainerView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
		}
        
        let size = self.computeContentSizeThatFits()
        
		// this will be updated in viewDidLayoutSubviews
        pgvcHeight = myContainerView.heightAnchor.constraint(equalToConstant: size.height)
		pgvcHeight.isActive = true

        pgvcWidth = myContainerView.widthAnchor.constraint(equalToConstant: size.width)
        pgvcWidth.isActive = true
        
		// instantiate DMCarouselPageViewController and add it as a Child View Controller
		thePageVC = DMCarouselPageViewController()
		addChild(thePageVC)
		
		// set the "data"
		thePageVC.images = self.images
		
		// we need to re-size the page view controller's view to fit our container view
		thePageVC.view.translatesAutoresizingMaskIntoConstraints = false
		
		// add the page VC's view to our container view
		myContainerView.addSubview(thePageVC.view)
		
		thePageVC.view.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(thePageVC.view.superview!.safeAreaLayoutGuide)
		}

		thePageVC.didMove(toParent: self)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		// only execute this code block if the view frame has changed
		//	such as on device rotation
		if curWidth != myContainerView.frame.width {
			curWidth = myContainerView.frame.width
			
			// cannot directly change a constraint multiplier, so
			//	deactivate / create new / reactivate
            let size = self.computeContentSizeThatFits()
			
            pgvcHeight.isActive = false
            pgvcHeight = self.myContainerView.heightAnchor.constraint(equalToConstant: size.height)
            pgvcHeight.isActive = true
            
            pgvcWidth.isActive = false
            pgvcWidth = self.myContainerView.widthAnchor.constraint(equalToConstant: size.width)
            pgvcWidth.isActive = true
		}
	}
    
    
    final func computeContentSizeThatFits() -> CGSize {
        return CGSize.sizeThatFits(containerSize: self.view.safeAreaLayoutGuide.layoutFrame.size, containedAR: 16.0/9.0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.view.layoutIfNeeded()
        
        coordinator.animate { _ in
            UIView.animate(withDuration: 0.25) {
                self.pgvcHeight.isActive = false
                self.pgvcHeight = self.myContainerView.heightAnchor.constraint(equalToConstant: size.height)
                self.pgvcHeight.isActive = true
                
                self.pgvcWidth.isActive = false
                self.pgvcWidth = self.myContainerView.widthAnchor.constraint(equalToConstant: size.width)
                self.pgvcWidth.isActive = true
                
                self.view.layoutIfNeeded()
            }
        }
    }
}

