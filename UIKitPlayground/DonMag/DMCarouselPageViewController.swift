//
//  DMCarouselPageViewController.swift
//  UIKitPlayground
//
//  Created by Don Mag on 5/16/24.
//

import UIKit

class DMCarouselPageViewController: UIPageViewController {
    public var medias: [any VisualMediaDescriptor] = []
    public var pageFactory: MediaFactory!
    
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


        var vc: (any CountedUIViewController)? = nil
        
        switch medias[0].type {
        case .image:
            vc = self.pageFactory.makeImagePage(for: self.medias[0] as! ZTronImageDescriptor)
        case .video:
            vc = self.pageFactory.makeVideoPage(for: self.medias[0] as! ZTronVideoDescriptor)
        }
        
        guard let vc = vc else { fatalError("Unable to locate video resource \(medias[0])") }
        vc.loadViewIfNeeded()
        vc.pageIndex = 0
        
        setViewControllers([vc], direction: .forward, animated: false, completion: nil)
	}
	
}

extension DMCarouselPageViewController: UIPageViewControllerDataSource {
	
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let vc = viewController as? CountedUIViewController else { return nil }
                
        let n = (vc.pageIndex - 1 + medias.count) % medias.count

        var newVC: (any CountedUIViewController)? = nil
        
        switch self.medias[n].type {
        case .image:
            newVC = self.pageFactory.makeImagePage(for: self.medias[n] as! ZTronImageDescriptor)
        case .video:
            newVC = self.pageFactory.makeVideoPage(for: self.medias[n] as! ZTronVideoDescriptor)
        }
        
        guard let newVC = newVC else { fatalError("Unable to locate video \(medias[n])") }
        newVC.loadViewIfNeeded()
        newVC.pageIndex = n

		return newVC
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let vc = viewController as? (any CountedUIViewController) else { return nil }
                
        let n = (vc.pageIndex + 1) % medias.count
        
        var newVC: (any CountedUIViewController)? = nil
        
        switch self.medias[n].type {
        case .image:
            newVC = self.pageFactory.makeImagePage(for: self.medias[n] as! ZTronImageDescriptor)
        case .video:
            newVC = self.pageFactory.makeVideoPage(for: self.medias[n] as! ZTronVideoDescriptor)
        }
        
        
        
        guard let newVC = newVC else { fatalError("Unable to locate video \(medias[n])") }
        newVC.loadViewIfNeeded()
        newVC.pageIndex = n
        
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
