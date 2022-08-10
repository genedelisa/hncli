// File:    File.swift
// Project: 
// Package: 
// Product: 
//
// Created by Gene De Lisa on 8/10/22
//
// Using Swift 5.0
// Running macOS 12.5
// Github: https://github.com/genedelisa/
// Product: https://rockhoppertech.com/
//
// Follow me on Twitter: @GeneDeLisaDev
//
// Licensed under the MIT License (the "License");
//
// You may not use this file except in compliance with the License.
//
// You may obtain a copy of the License at
//
// https://opensource.org/licenses/MIT


import Foundation
import SwiftUI

// Color has this:     public init(cgColor: CGColor)


extension Color {
    
    public static func random(includeAlpha: Bool = false) -> Color {
        let r = CGFloat.random(in: 0...255) / 255.0
        let g = CGFloat.random(in: 0...255) / 255.0
        let b = CGFloat.random(in: 0...255) / 255.0
        let a = includeAlpha ? 1 : CGFloat.random(in: 0...1)
        
        return Color(red: r, green: g, blue: b, opacity: a)
    }
    
//    public var complementaryColor: Color {
//        let rr = self.cgColor?.components
        
//        let r  = CGFloat(self.red * 255.0)
//        let g  = CGFloat(self.green * 255.0)
//        let b  = CGFloat(self.blue * 255.0)
//        return Color(red: (255.0 - r) / 255.0,
//                       green: (255.0 - g) / 255.0,
//                       blue: (255.0 - b) / 255.0,
//                     opacity: opacity)
//    }
    
}

#if os(iOS)
import UIKit

extension UIColor {
    
    /// Generates a random `UIColor` instance.
    /// - Parameters:
    ///   - randomizeAlpha: Whether the alpha channel should also be randomized. If set to false (default), the alpha will be set to 1.0.
    public static func random(randomizeAlpha: Bool = false) -> UIColor {
        let r = CGFloat.random(in: 0...255) / 255.0
        let g = CGFloat.random(in: 0...255) / 255.0
        let b = CGFloat.random(in: 0...255) / 255.0
        let a = randomizeAlpha ? 1 : CGFloat.random(in: 0...1)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    
    /// Computes the complementary color of the current color instance.
    /// Complementary colors are opposite on the color wheel.
    public var complementaryColor: UIColor {
        return UIColor(red: (255.0 - red255) / 255.0,
                       green: (255.0 - green255) / 255.0,
                       blue: (255.0 - blue255) / 255.0, alpha: alpha)
    }
    
    
    
    
}
#endif


#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color {
    #if canImport(UIKit)
    var asNative: UIColor { UIColor(self) }
    #elseif canImport(AppKit)
    var asNative: NSColor { NSColor(self) }
    #endif

    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = asNative.usingColorSpace(.deviceRGB)!
        var t = (CGFloat(), CGFloat(), CGFloat(), CGFloat())
        color.getRed(&t.0, green: &t.1, blue: &t.2, alpha: &t.3)
        return t
    }

    var hsva: (hue: CGFloat, saturation: CGFloat, value: CGFloat, alpha: CGFloat) {
        let color = asNative.usingColorSpace(.deviceRGB)!
        var t = (CGFloat(), CGFloat(), CGFloat(), CGFloat())
        color.getHue(&t.0, saturation: &t.1, brightness: &t.2, alpha: &t.3)
        return t
    }
}
