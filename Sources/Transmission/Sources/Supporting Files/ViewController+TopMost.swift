//////////////////////////////////////////////////////////////////////////////////
//
//  SYMBIOSE
//  Copyright 2023 Symbiose Technologies, Inc
//  All Rights Reserved.
//
//  NOTICE: This software is proprietary information.
//  Unauthorized use is prohibited.
//
// 
// Created by: Ryan Mckinney on 10/19/23
//
////////////////////////////////////////////////////////////////////////////////

#if os(iOS)
import Foundation
import UIKit


extension UIViewController {

  func topMostPresentedViewController() -> UIViewController? {

    if let presented = self.presentedViewController {
      return presented.topMostPresentedViewController()
    }
    
    if let navigation = self as? UINavigationController {
      return navigation.topViewController?.topMostPresentedViewController()
    }
    
    if let tab = self as? UITabBarController {
      return tab.selectedViewController?.topMostPresentedViewController()
    }
    
    return self
  }
    
    func topMostViewControllerBeforeBeingPresented() -> UIViewController? {
        
        if let presented = self.presentedViewController {
            return self
        }

        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewControllerBeforeBeingPresented()
        }

        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewControllerBeforeBeingPresented()
        }

        return self
    }

}

#endif
