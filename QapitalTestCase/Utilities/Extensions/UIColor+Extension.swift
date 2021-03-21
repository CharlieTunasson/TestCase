//
//  UIColor+Extension.swift
//  QapitalTestCase
//
//  Created by Charlie Tuna on 2021-03-20.
//

import UIKit

extension UIColor {
    static let title = UIColor(named: "title")!
    static let background = UIColor(named: "background")!
    static let amount = UIColor(named: "amount")!
    static let passiveText = UIColor(named: "passiveText")!
    static let boldText = UIColor(named: "boldText")!

    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return NSString(format:"#%06x", rgb) as String
    }
}
