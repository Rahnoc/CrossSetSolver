//
//  CssArray2D.swift
//  CssLib
//
//  Created by Rahnoc on 2018/10/22.
//  Copyright © 2019 CupsailorStudio. All rights reserved.
//

import Foundation


// 尺寸初始後即固定。
/// 2-dim array, width and height must both bigger than 0. Minimal dim is (1, 1).
/// 具備index出界檢查的，初始尺寸固定的二維陣列。
///
/// 特性:
/// * 大小(dim)於宣告後固定不變。
/// * 每一格有初始值
public class CssArray2D<T>: CustomStringConvertible {
    private var data: Array<T>
    private var _dim: CssXy<Int>
    
    
    // -----------------
    // Initializer
    // -----------------
    
    /// 指定的大小二維陣列中，每一格均填入相同值。
    /// 若初始大小不合理(至少大小要 1x1)，回傳 nil。
    ///
    /// - parameter x: 寬
    /// - parameter y: 高
    /// - parameter repeating: 填入用物件
    public init?(x:Int, y:Int, repeating:T) {
        guard (x>0) && (y>0) else {
            print( "minimal size is (1,1). input=(\(x),\(y))" )
            return nil
        }
        
        self._dim = CssXy(x, y)
        self.data = Array<T>(repeating: repeating, count: x * y)
    }
    
    
    /// 指定的大小二維陣列中，以 row first 的方式填入指定陣列的內容。
    /// 若初始大小不合理(至少大小要 1x1)，或尺寸不合，則回傳 nil。
    ///
    /// - parameter x: 寬
    /// - parameter y: 高
    /// - parameter tiles: 填入用陣列
    public init?(x:Int, y:Int, tiles: Array<T>) {
        guard (x>0) && (y>0) else {
            print( "minimal size is (1,1). input=(\(x),\(y))" )
            return nil
        }
        guard (x*y == tiles.count) else {
            print( "size dismatch. input=(\(x),\(y)), tiles.count=\(tiles.count)." )
            return nil
        }
        
        self._dim = CssXy(x, y)
        self.data = Array<T>( tiles )
    }
    
    
    // ----------------------
    
    /// Dimension (width, height)
    public var dim:(x:Int, y:Int) {
        get {
            return self._dim.tuple
        }
    }
    
    // ----------------------
    // Subscript
    // ----------------------
    
    // 透過下標 arr2d[(x, y)] 存取目標格。
    // 由於初始時每一格有給值，加上存取index有邊界檢查，故不會有某格 nil 的情況。
    public subscript(index: (x:Int, y:Int)) -> T {
        get {
            let fIdx = self.fold(x: index.x, y: index.y)
            if (fIdx == nil) {
                assertionFailure("CssArray2D::subscript: index out of bound.")
            }
            
            return self.data[ fIdx! ]
        }
        
        set {
            let fIdx = self.fold(x: index.x, y: index.y)
            if (fIdx == nil) {
                assertionFailure("CssArray2D::subscript: index out of bound.")
            }
            
            self.data[ fIdx! ] = newValue
        }
    }
    
    // ----------------------
    
    public var description: String {
        get {
            return self.toString(showComma: true)
        }
    }
    
    public func toString(showComma:Bool) -> String {
        var rtStr = "CssArray2D dim=\(self._dim)"
        for y in (0 ..< self._dim.y) {
            rtStr += "\n"
            for x in (0 ..< self._dim.x) {
                if( x != 0) {
                    rtStr += (showComma ? ", " : " ")
                }
                rtStr += "\(self[(x, y)])"
            }
        }
        
        return rtStr
    }
    
    // ----------------------
    // Index manipulate
    // ----------------------
    
    // 檢測 index 分量是否出界。
    private func indexIsValid(x:Int, y:Int) -> Bool {
        return (x >= 0) && (x < self._dim.x) && (y >= 0) && (y < self._dim.y)
    }
    
    // 2-Dim index 轉 1-Dim index (row first).
    private func fold(x:Int, y:Int) -> Int? {
        guard self.indexIsValid(x: x, y: y) else {
            print( "index out of bound, idx(\(x), \(y)). dim=\(self._dim)." )
            return nil
        }
        
        return x + (y * self._dim.x)
    }
    
    // 1-Dim index 轉 2-Dim index (row first).
    private func expend(index:Int) -> (x:Int, y:Int)? {
        let x = index % self._dim.x
        let y = index / self._dim.x
        
        guard self.indexIsValid(x: x, y: y) else {
            print( "index out of bound, idx(\(x), \(y)). dim=\(self._dim)." )
            return nil
        }
        
        return (x, y)
    }
    
}
