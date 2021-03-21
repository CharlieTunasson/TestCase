//
//  AppFont.swift
//  QapitalTestCase
//
//  Created by Charlie Tuna on 2021-03-18.
//

import UIKit

public extension UIFont {
    
    enum Style {
        case regular
        case light
        case medium
        case bold
        case kievit
    }

    enum Placement {
        case titleA
        case titleB
        case captionB
    }

    private static func appFont(_ style: Style, size: CGFloat) -> UIFont {
        switch style {
        case .regular:
            return UIFont(name: "BentonSans-Regular", size: size)!
        case .light:
            return UIFont(name: "BentonSans-Light", size: size)!
        case .medium:
            return UIFont(name: "BentonSans-Medium", size: size)!
        case .bold:
            return UIFont(name: "BentonSans-Bold", size: size)!
        case .kievit:
            return UIFont(name: "KievitCompPro-Exlig", size: size)!
        }
    }

    static func appFont(placement: Placement) -> UIFont {
        switch placement {
        case .titleA:
            return appFont(.medium, size: 16)
        case .titleB:
            return appFont(.regular, size: 16)
        case .captionB:
            return appFont(.regular, size: 12)
        }
    }
}
