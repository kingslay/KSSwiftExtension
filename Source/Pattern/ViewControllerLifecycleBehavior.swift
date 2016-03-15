//
//  ViewControllerLifecycleBehavior.swift
//  KSSwiftExtension
//
//  Created by king on 16/3/15.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit
protocol ViewControllerLifecycleBehavior {
    func afterLoading(viewController: UIViewController)
    
    func beforeAppearing(viewController: UIViewController)
    
    func afterAppearing(viewController: UIViewController)
    
    func beforeDisappearing(viewController: UIViewController)
    
    func afterDisappearing(viewController: UIViewController)
    
    func beforeLayingOutSubviews(viewController: UIViewController)
    
    func afterLayingOutSubviews(viewController: UIViewController)
}
extension ViewControllerLifecycleBehavior {
    func afterLoading(viewController: UIViewController) {}
    
    func beforeAppearing(viewController: UIViewController) {}
    
    func afterAppearing(viewController: UIViewController) {}
    
    func beforeDisappearing(viewController: UIViewController) {}
    
    func afterDisappearing(viewController: UIViewController) {}
    
    func beforeLayingOutSubviews(viewController: UIViewController) {}
    
    func afterLayingOutSubviews(viewController: UIViewController) {}
}
struct HideNavigationBarBehavior: ViewControllerLifecycleBehavior {
    func beforeAppearing(viewController: UIViewController) {
        viewController.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func beforeDisappearing(viewController: UIViewController) {
        viewController.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
extension UIViewController {
    /**
     Add behaviors to be hooked into this view controller’s lifecycle.
     
     This method requires the view controller’s view to be loaded, so it’s best to call
     in `viewDidLoad` to avoid it being loaded prematurely.
     
     - parameter behaviors: Behaviors to be added.
     */
    func addBehaviors(behaviors: [ViewControllerLifecycleBehavior]) {
        let behaviorViewController = LifecycleBehaviorViewController(behaviors: behaviors)
        
        addChildViewController(behaviorViewController)
        view.addSubview(behaviorViewController.view)
        behaviorViewController.didMoveToParentViewController(self)
    }
    
    private final class LifecycleBehaviorViewController: UIViewController {
        private let behaviors: [ViewControllerLifecycleBehavior]
        
        // MARK: - Initialization
        
        init(behaviors: [ViewControllerLifecycleBehavior]) {
            self.behaviors = behaviors
            
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - UIViewController
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.hidden = true
            
            applyBehaviors { behavior, viewController in
                behavior.afterLoading(viewController)
            }
        }
        
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            
            applyBehaviors { behavior, viewController in
                behavior.beforeAppearing(viewController)
            }
        }
        
        override func viewDidAppear(animated: Bool) {
            super.viewDidAppear(animated)
            
            applyBehaviors { behavior, viewController in
                behavior.afterAppearing(viewController)
            }
        }
        
        override func viewWillDisappear(animated: Bool) {
            super.viewWillDisappear(animated)
            
            applyBehaviors { behavior, viewController in
                behavior.beforeDisappearing(viewController)
            }
        }
        
        override func viewDidDisappear(animated: Bool) {
            super.viewDidDisappear(animated)
            
            applyBehaviors { behavior, viewController in
                behavior.afterDisappearing(viewController)
            }
        }
        
        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            
            applyBehaviors { behavior, viewController in
                behavior.beforeLayingOutSubviews(viewController)
            }
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            
            applyBehaviors { behavior, viewController in
                behavior.afterLayingOutSubviews(viewController)
            }
        }
        
        // MARK: - Private
        
        private func applyBehaviors(@noescape body: (behavior: ViewControllerLifecycleBehavior, viewController: UIViewController) -> Void) {
            guard let parentViewController = parentViewController else { return }
            
            for behavior in behaviors {
                body(behavior: behavior, viewController: parentViewController)
            }
        }
    }
}