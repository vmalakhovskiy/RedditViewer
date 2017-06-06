//
//  Random.swift
//  RageOn
//
//  Created by Vitaliy Malakhovskiy on 5/25/17.
//  Copyright © 2017 RageOn. All rights reserved.
//

import Foundation
import UIKit

protocol Random {
    static func random() -> Self
}

extension Array: Random {
    private static func randomElement() -> Element? {
        guard Element.self is Random.Type else {
            return nil
        }
        return (Element.self as? Random.Type)?.random() as? Element
    }

    static func random() -> [Element] {
        return (0...Int(arc4random() % 3))
            .map { _ in randomElement() }
            .flatMap { $0 }
    }
}

extension Optional: Random {
    private static func randomElement() -> Wrapped? {
        guard Wrapped.self is Random.Type else {
            return nil
        }
        return (Wrapped.self as? Random.Type)?.random() as? Wrapped
    }

    static func random() -> Wrapped? {
        return Int(arc4random() % 2) == 0
            ? nil
            : randomElement()
    }
}

extension String: Random {
    static func random() -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< 20 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}

extension Int: Random {
    static func random() -> Int {
        return Int(arc4random() % 200)
    }
}

extension Double: Random {
    static func random() -> Double {
        return Double(arc4random() % 1000) / 100
    }
}

extension Float: Random {
    static func random() -> Float {
        return Float(arc4random() % 1000) / 100
    }
}

extension Bool: Random {
    static func random() -> Bool {
        return arc4random() % 2 == 1
    }
}

extension UIImage {
    static func random() -> UIImage {
        let literal = Float(arc4random() % 255)
        let color = UIColor(colorLiteralRed: literal, green: literal, blue: literal, alpha: literal)
        let rect = CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!

        context.setFillColor(color.cgColor)
        context.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

extension NSError {
    static func random() -> NSError {
        return NSError(domain: .random(), code: .random(), userInfo: nil)
    }
}
