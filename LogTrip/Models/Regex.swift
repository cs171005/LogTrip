//
//  Regex.swift
//  LogTrip
//
//  Created by 河野穣 on 2018/03/04.
//  Copyright © 2018年 河野穣. All rights reserved.
//

import Foundation

class regexTool{
    // 正規表現にマッチした文字列を格納した配列を返す
    class func getMatchStrings(targetString: String, pattern: String) -> [String] {
        
        var matchStrings:[String] = []
        
        do {
            
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let targetStringRange = NSRange(location: 0, length: (targetString as NSString).length)
            
            let matches = regex.matches(in: targetString, options: [], range: targetStringRange)
            
            for match in matches {
                
                // rangeAtIndexに0を渡すとマッチ全体が、1以降を渡すと括弧でグループにした部分マッチが返される
                let range = match.range(at: 0)
                let result = (targetString as NSString).substring(with: range)
                
                matchStrings.append(result)
            }
            
            return matchStrings
            
        } catch {
            print("error: getMatchStrings")
        }
        return []
    }
    
    // マッチした数を返す
    class func getMatchCount(targetString: String, pattern: String) -> Int {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            let targetStringRange = NSRange(location: 0, length: (targetString as NSString).length)
            
            return regex.numberOfMatches(in: targetString, options: [], range: targetStringRange)
            
        } catch {
            print("error: getMatchCount")
        }
        return 0
    }
    
    class func isMatchPattern(targetString: String, pattern: String) -> Bool {
        let mtccnt = getMatchCount(targetString: targetString, pattern: pattern)
        switch mtccnt {
        case 0:
            return false
        default:
            return true
        }
    }
}
