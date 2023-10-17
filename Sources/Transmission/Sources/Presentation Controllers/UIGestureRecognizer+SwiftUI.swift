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
// Created by: Ryan Mckinney on 10/11/23
//
////////////////////////////////////////////////////////////////////////////////
#if canImport(UIKit)
import ObjectiveC
import Foundation
import UIKit

public extension UIGestureRecognizer {
    var clsName: String {
        NSStringFromClass(type(of: self))
    }
    var isSwiftUIGesture: Bool {
//        let suiGName = "SwiftUI.UIKitGestureRecognizer"
        clsName == "SwiftUI.UIKitGestureRecognizer"
    }
}

#endif



#if canImport(UIKit)
import UIKit
import ObjectiveC

private var ViewIdentityKey: UInt8 = 0

extension UIView {
    var suiId: AnyHashable? {
        get {
            return objc_getAssociatedObject(self, &ViewIdentityKey) as? AnyHashable
        }
        set {
            objc_setAssociatedObject(self, &ViewIdentityKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


extension UIView {
    
    func backgroundIdentityView(with suiId: AnyHashable) -> UIView? {
        for subview in subviews {
            if let subViewId = subview.suiId {
                print("Bg identity view: \(subViewId as? String ?? "NONE")")
            }
            if subview.suiId == suiId {
                return subview
            }
        }
        return nil
    }
    
    
    func allSubviewIdentityIds(includeSelf: Bool = true) -> [AnyHashable] {
        var ids: [AnyHashable] = []
        if includeSelf { 
            if let myId = self.suiId {
                ids.append(myId)
            }
        }
        for subview in subviews {
            let subviewNested = subview.allSubviewIdentityIds(includeSelf: true)
            ids.append(contentsOf: subviewNested)
        }
        return ids
        
    }
}

#endif
