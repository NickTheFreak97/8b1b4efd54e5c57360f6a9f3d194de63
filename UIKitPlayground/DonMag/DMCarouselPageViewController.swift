//
//  DMCarouselPageViewController.swift
//  UIKitPlayground
//
//  Created by Don Mag on 5/16/24.
//

import UIKit

class DMCarouselPageViewController: UIPageViewController {
	
	// let the "main" controller set this data
	//private let images = ["police", "shutters", "depot", "cakes", "sign"]
	
	public var images: [String] = ["step-1.hevc"]
	
	override init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey : Any]? = nil
    ) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		dataSource = self
		delegate = self
        
        self.view.clipsToBounds = false
		
        /*
		// instantiate and set the first page
		let vc = DMCarouselPage()
		vc.loadViewIfNeeded()
		vc.configure(with: images[0])
		vc.pageIndex = 0
		
		setViewControllers([vc], direction: .forward, animated: false, completion: nil)
         */
        
        guard let vc = DMVideoCarouselPage(video: images[0], extension: "mp4") else { fatalError("Unable to locate video resource \(images[0])") }
        vc.loadViewIfNeeded()
        vc.pageIndex = 0
        
        setViewControllers([vc], direction: .forward, animated: false, completion: nil)
	}
	
}

extension DMCarouselPageViewController: UIPageViewControllerDataSource {
	
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

		// guard let vc = viewController as? DMCarouselPage else { return nil }
        guard let vc = viewController as? DMVideoCarouselPage else { return nil }
        
        let n = (vc.pageIndex - 1 + images.count) % images.count

        guard let newVC = DMVideoCarouselPage(video: images[n], extension: "mp4") else { fatalError("Unable to locate video \(images[n])") }
        newVC.loadViewIfNeeded()
        
        newVC.pageIndex = n
        /*
		let newVC = DMCarouselPage()
		newVC.loadViewIfNeeded()
		newVC.configure(with: images[n])
		newVC.pageIndex = n
         */
		
		return newVC
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

		// guard let vc = viewController as? DMCarouselPage else { return nil }
        guard let vc = viewController as? DMVideoCarouselPage else { return nil }
        
        let n = (vc.pageIndex + 1) % images.count
        
        guard let newVC = DMVideoCarouselPage(video: images[n], extension: "mp4") else { fatalError("Unable to locate video \(images[n])") }
        newVC.pageIndex = n
        /*
		let newVC = DMCarouselPage()
		newVC.loadViewIfNeeded()
		newVC.configure(with: images[n])
		newVC.pageIndex = n
		*/
         
		return newVC
	}
}

extension DMCarouselPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        previousViewControllers.forEach { controller in
            guard let controller = (controller as? DMVideoCarouselPage) else { return }
            controller.dismantle()
        }
    }
}
