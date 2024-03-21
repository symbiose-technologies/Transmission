//////////////////////////////////////////////////////////////////////////////////
//
//  SYMBIOSE
//  Copyright 2023 Symbiose Technologies, Inc
//  All Rights Reserved.
//
//  NOTICE: This software is proprietary information.
//  Unauthorized use is prohibited.
//

import Foundation

#if canImport(UIKit)
import UIKit

public class PassThroughWindow: UIWindow {
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
      guard let hitView = super.hitTest(point, with: event) else { return nil }
      return rootViewController?.view == hitView ? nil : hitView
    }
}


#endif
