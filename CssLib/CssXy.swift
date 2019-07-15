//
//  CssXy.swift
//  CssLib
//
//  Created by Rahnoc on 2015/5/13.
//  Copyright (c) 2015年 Cupsailor Studio. All rights reserved.
//

import Foundation
import SpriteKit


// -------------------------
// Generic Tuple Family.
// -------------------------
// Generic類別繼承與 NSObject 會有衝突，故針對各形態(Int, Float, Double)，均實作對應XY類別。
// 各wrapped過的XY tuple類別，皆內含一個generic CssXy成員來放置資料。
// WrappedXY 均繼承NSObject 實作NSCoding，可以作為Unarchiving資料使用。
//

/// Generic X Y tuple. 基本Tuple容器類別。
///
open class CssXy<T: Equatable>: CustomStringConvertible {
    var x:T
    var y:T
    
    public init(_ x:T, _ y:T) {
        self.x = x
        self.y = y
    }
    
    /// 用Tuple初始。
    ///
    /// - parameter xy: xy tuple.
    public convenience init(xy:(x:T, y:T)) {
        self.init(xy.x, xy.y)
    }
    
    open var description:String {
        get { return "(\(self.x), \(self.y))" }
    }
    
    open var tuple:(x:T, y:T) {
        get { return (x:self.x, y:self.y) }
        
        set {
            self.x = newValue.x
            self.y = newValue.y
        }
    }
    
    open var array:[T] {
        get { return [self.x, self.y] }
    }
}

public func ==<T>(lhs: CssXy<T>, rhs: CssXy<T>) -> Bool {
    return (lhs.x == rhs.x) && (lhs.y == rhs.y)
}

// ------------------------------
// Wrapped Xy Tuple classes.
// ------------------------------

/// Wrapped Int Xy tuple class.
open class CssXyInt: NSObject, NSSecureCoding {
    public class var supportsSecureCoding:Bool { return true }
    
    open var xy:CssXy<Int>
    
    public init(_ x:Int, _ y:Int) {
        self.xy = CssXy(x,y)
    }
    
    public convenience init(xy:(x:Int, y:Int)) {
        self.init(xy.x, xy.y)
    }
    
    // -------------------------
    // NSSecureCoding protocol.
    // -------------------------
    
    public required init?(coder aDecoder: NSCoder) {
        guard aDecoder.containsValue(forKey: "x") else {
            print( "decode fail, no key 'x'." )
            return nil
        }
        
        guard aDecoder.containsValue(forKey: "y") else {
            print( "decode fail, no key 'y'." )
            return nil
        }
        
        let x = aDecoder.decodeInteger(forKey: "x")
        let y = aDecoder.decodeInteger(forKey: "y")
        self.xy = CssXy<Int>(x,y)
    }
    
    open func encode(with encoder: NSCoder) {
        encoder.encode(self.xy.x, forKey: "x")
        encoder.encode(self.xy.y, forKey: "y")
    }
    
    open override var description:String {
        get { return self.xy.description }
    }
    
    // ------------------
    // NSObject comform.
    // ------------------
    
    // NSObject equatable protocol.
    // The == Operator implement would result in != error with NSObject's sub-class in Swift 2, use isEqual instead.
    override open func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? CssXyInt {
            return self.xy == rhs.xy
        }
        
        return false
    }
    
    // ---------------------
    // Typecast about.
    // ---------------------
    
    open var tuple:(x:Int,y:Int) {
        get { return self.xy.tuple }
        set { self.xy.tuple = newValue }
    }
    
    open var array:[Int] {
        get { return self.xy.array }
    }
}

/// Wrapped Float Xy tuple class.
open class CssXyFloat: NSObject, NSSecureCoding {
    public class var supportsSecureCoding:Bool { return true }
    
    open var xy:CssXy<Float>
    
    public init(_ x:Float, _ y:Float) {
        self.xy = CssXy(x,y)
    }
    
    public convenience init(size:CGSize) {
        self.init( Float(size.width), Float(size.height) )
    }
    
    public convenience init(pt:CGPoint) {
        self.init( Float(pt.x), Float(pt.y) )
    }
    
    public convenience init(xy:(x:Float, y:Float)) {
        self.init(xy.x, xy.y)
    }
    
    // -------------------------
    // NSSecureCoding protocol.
    // -------------------------
    
    public required init?(coder aDecoder: NSCoder) {
        guard aDecoder.containsValue(forKey: "x") else {
            print( "decode fail, no key 'x'." )
            return nil
        }
        
        guard aDecoder.containsValue(forKey: "y") else {
            print( "decode fail, no key 'y'." )
            return nil
        }
        
        let x = aDecoder.decodeFloat(forKey: "x")
        let y = aDecoder.decodeFloat(forKey: "y")
        self.xy = CssXy<Float>(x,y)
    }
    
    open func encode(with encoder: NSCoder) {
        encoder.encode(self.xy.x, forKey: "x")
        encoder.encode(self.xy.y, forKey: "y")
    }
    
    open override var description:String {
        get { return self.xy.description }
    }
    
    // ------------------
    // NSObject comform.
    // ------------------
    
    // NSObject equatable protocol.
    // The == Operator implement would result in != error with NSObject's sub-class in Swift 2, use isEqual instead.
    override open func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? CssXyFloat {
            return self.xy == rhs.xy
        }
        
        return false
    }
    
    // ---------------------
    // Typecast about.
    // ---------------------
    
    open var tuple:(x:Float,y:Float) {
        get { return self.xy.tuple }
        set { self.xy.tuple = newValue }
    }
    
    open var array:[Float] {
        get { return self.xy.array }
    }
}

/// Wrapped Double Xy tuple class.
open class CssXyDouble: NSObject, NSSecureCoding {
    public class var supportsSecureCoding:Bool { return true }
    
    open var xy:CssXy<Double>
    
    public init(_ x:Double, _ y:Double) {
        self.xy = CssXy(x,y)
    }
    
    public convenience init(xy:(x:Double, y:Double)) {
        self.init(xy.x, xy.y)
    }
    
    // -------------------------
    // NSSecureCoding protocol.
    // -------------------------
    
    public required init?(coder aDecoder: NSCoder) {
        guard aDecoder.containsValue(forKey: "x") else {
            print( "decode fail, no key 'x'." )
            return nil
        }
        
        guard aDecoder.containsValue(forKey: "y") else {
            print( "decode fail, no key 'y'." )
            return nil
        }
        
        let x = aDecoder.decodeDouble(forKey: "x")
        let y = aDecoder.decodeDouble(forKey: "y")
        self.xy = CssXy<Double>(x,y)
    }
    
    open func encode(with encoder: NSCoder) {
        encoder.encode(self.xy.x, forKey: "x")
        encoder.encode(self.xy.y, forKey: "y")
    }
    
    open override var description:String {
        get { return self.xy.description }
    }
    
    // ------------------
    // NSObject comform.
    // ------------------
    
    // NSObject equatable protocol.
    // The == Operator implement would result in != error with NSObject's sub-class in Swift 2, use isEqual instead.
    override open func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? CssXyDouble {
            return self.xy == rhs.xy
        }
        
        return false
    }
    
    // ---------------------
    // Typecast about.
    // ---------------------
    
    open var tuple:(x:Double,y:Double) {
        get { return self.xy.tuple }
        set { self.xy.tuple = newValue }
    }
    
    open var array:[Double] {
        get { return self.xy.array }
    }
}
