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
	
	public var images: [String] = []
	
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
		
		// instantiate and set the first page
		let vc = DMCarouselPage()
		vc.loadViewIfNeeded()
		vc.configure(with: images[0])
		vc.pageIndex = 0
		
		setViewControllers([vc], direction: .forward, animated: false, completion: nil)
	}
	
}

extension DMCarouselPageViewController: UIPageViewControllerDataSource {
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

		guard let vc = viewController as? DMCarouselPage else { return nil }
		
		if vc.pageIndex == 0 { return nil }
		
		let n = vc.pageIndex - 1
		
		let newVC = DMCarouselPage()
		newVC.loadViewIfNeeded()
		newVC.configure(with: images[n])
		newVC.pageIndex = n
		
		return newVC
		
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

		guard let vc = viewController as? DMCarouselPage else { return nil }
		
		if vc.pageIndex >= images.count - 1 { return nil }
		
		let n = vc.pageIndex + 1
		
		let newVC = DMCarouselPage()
		newVC.loadViewIfNeeded()
		newVC.configure(with: images[n])
		newVC.pageIndex = n
		
		return newVC
		
	}
	
}
