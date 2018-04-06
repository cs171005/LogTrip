//
//  StationInfo.swift
//  LogTrip
//
//  Created by 河野穣 on 2018/02/02.
//  Copyright © 2018年 河野穣. All rights reserved.
//

import Foundation
import APIKit
import SwiftyJSON

class StationInfo{
    
    class func initStationNameMaster()->[String:String]{
        var stationNameMaster: [String:String] = [:]
        var stationNameMasterTokyoKanto: [String:String] = [:]
        
        var kanjiArr: [String] = StationInfo.csvToArray(resourceFileName: "StationTitleKanji")
        var hiraganaArr: [String] = StationInfo.csvToArray(resourceFileName: "StationTitleHiragana")
        var kanjiArrTokyo: [String] = StationInfo.csvToArray(resourceFileName: "StationTitleKanji_TokyoKanto")
        
        //全国版の駅名辞書
        let orderedSet = NSOrderedSet(array: kanjiArrTokyo)
        kanjiArrTokyo = orderedSet.array as! [String]
        
        for index in (0..<kanjiArr.count){
            stationNameMaster[kanjiArr[index]] = hiraganaArr[index]
        }
        
        //関東版の駅名辞書
        for index in (0..<kanjiArrTokyo.count){
            let kanjiTitle = kanjiArrTokyo[index]
            if let hiraganaTitle = stationNameMaster[kanjiTitle]{
                stationNameMasterTokyoKanto[kanjiTitle] = hiraganaTitle
            }else{
                //print(kanjiTitle + "'s furigana does not exist.")
                stationNameMasterTokyoKanto[kanjiTitle] = ""
                
                let matchPattern = "^(" + kanjiTitle + ")((\\((東京|千葉|神奈川|長野|山梨|群馬|埼玉|栃木|茨城)(都|県)\\))|(停留場))$"
                let similarKeys = stationNameMaster.keys.filter({regexTool.isMatchPattern(targetString: $0, pattern: matchPattern)})
                
                switch similarKeys.count{
                case 0:
                    //完全一致なし
                    if kanjiTitle.hasPrefix("押上"){
                        //「押上」例外処理
                        stationNameMasterTokyoKanto[kanjiTitle] = "おしあげ (とうきょうスカイツリーまえ)"
                    }else if(kanjiTitle.contains("成田第")){
                        //「成田空港」例外処理
                        stationNameMasterTokyoKanto[kanjiTitle] = "なりたくうこう"
                    }else if(kanjiTitle == "泉"){
                        //「常磐線福島県区内」例外処理(1)
                        stationNameMasterTokyoKanto[kanjiTitle] = stationNameMaster["泉(福島市)"]
                    }else if(regexTool.isMatchPattern(targetString: kanjiTitle, pattern: "^(植田|草野|広野)$")){
                        //「常磐線福島県区内」例外処理(2)
                        stationNameMasterTokyoKanto[kanjiTitle] = stationNameMaster[(kanjiTitle + "(福島県)")]
                    }else if(kanjiTitle == "弘明寺"){
                        // 「弘明寺」例外処理
                        stationNameMasterTokyoKanto[kanjiTitle] = stationNameMaster["弘明寺(京急)"]
                        
                    }else{
                        stationNameMasterTokyoKanto[kanjiTitle] = ""
                    }
                    break
                    
                case 1:
                    for mtcptr in similarKeys{
                        //                                print("     -> " + mtcptr + ":" + stationNameMaster[mtcptr]!)
                        stationNameMasterTokyoKanto[kanjiTitle] = (stationNameMaster[mtcptr]!)
                        //print("     " + " " + kanjiTitle + " " + stationNameMasterTokyoKanto[kanjiTitle]! + "★")
                    }
                    break
                    
                default:
                    if ((regexTool.isMatchPattern(targetString: kanjiTitle, pattern: "^(赤坂|稲荷町|中野|平和台|末広町|千鳥町|有明|日野)$"))){
                        stationNameMasterTokyoKanto[kanjiTitle] = stationNameMaster[(kanjiTitle + "(東京都)")]
                    }else if((regexTool.isMatchPattern(targetString: kanjiTitle, pattern: "^(十日市場|中山)$"))){
                        stationNameMasterTokyoKanto[kanjiTitle] = stationNameMaster[(kanjiTitle + "(神奈川県)")]
                    }else if((regexTool.isMatchPattern(targetString: kanjiTitle, pattern: "^(石橋|大桑)$"))){
                        stationNameMasterTokyoKanto[kanjiTitle] = stationNameMaster[(kanjiTitle + "(栃木県)")]
                    }else if((regexTool.isMatchPattern(targetString: kanjiTitle, pattern: "^(井野)$"))){
                        stationNameMasterTokyoKanto[kanjiTitle] = stationNameMaster[(kanjiTitle + "(群馬県)")]
                    }else if((regexTool.isMatchPattern(targetString: kanjiTitle, pattern: "^(永田)$"))){
                        stationNameMasterTokyoKanto[kanjiTitle] = stationNameMaster[(kanjiTitle + "(千葉県)")]
                    }else{
                        switch kanjiTitle{
                        case "入谷":
                                stationNameMasterTokyoKanto[kanjiTitle] = "いりや"
                            break
                        case "大和":
                                stationNameMasterTokyoKanto[kanjiTitle] = "やまと"
                            break
                        case "小川町":
                            stationNameMasterTokyoKanto[kanjiTitle] = "おがわまち"
                            break
                        default:
                            print(kanjiTitle,similarKeys.count)
                            break
                        }
                    }
                    break
                }
            }
        }
        
        return stationNameMasterTokyoKanto
    }
    
    class func csvToArray (resourceFileName : String) -> [String]{
        var csvArr : [String] = []
        if let csvPath = Bundle.main.path(forResource: resourceFileName, ofType: "csv") {
            do {
                let csvStr = try String(contentsOfFile:csvPath, encoding:String.Encoding.utf8)
                csvArr = csvStr.components(separatedBy: .newlines)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        csvArr = csvArr.filter{!$0.isEmpty}
        return csvArr
    }
    
    class func KanjiTitleToSameAs(stationName:String){
        let request = TokyoChallengeAPI.Station(title:stationName)
        Session.send(request)
        {
            response in
            switch response {
                
            case .success(let responses):
                for block in responses {
                    let info = block.1["owl:sameAs"].string!
                    print(info)
                    //return info
                }
                //print(responses[0])
                
            case .failure(let error):
                print(error)
                //return "NO NAME"
            }
        }
    }
    
    class func AllstationList()->[String]{
        var staNameArr:[String] = []
        let operatorIDList:[String] = [
            "odpt.Operator:TokyoMetro",
            "odpt.Operator:Seibu",
            "odpt.Operator:Tokyu",
            "odpt.Operator:Odakyu",
            "odpt.Operator:Keisei",
            "odpt.Operator:Keikyu",
            "odpt.Operator:Keio",
            "odpt.Operator:MIR",
            "odpt.Operator:Toei",
            "odpt.Operator:TWR",
            "odpt.Operator:Tobu",
            "odpt.Operator:Yurikamome",
            ]
        
        let JREastMetropolitanAreaRailwayList:[String] = [
            "odpt.Railway:JR-East.Tokaido",
            "odpt.Railway:JR-East.Yokosuka",
            "odpt.Railway:JR-East.Itsukaichi",
            "odpt.Railway:JR-East.Uchibo",
            "odpt.Railway:JR-East.Kawagoe",
            "odpt.Railway:JR-East.Keiyo",
            "odpt.Railway:JR-East.Sagami",
            "odpt.Railway:JR-East.ShonanShinjuku",
            "odpt.Railway:JR-East.UenoTokyo",
            "odpt.Railway:JR-East.Hachiko",
            "odpt.Railway:JR-East.Mito",
            "odpt.Railway:JR-East.Musashino",
            "odpt.Railway:JR-East.Yokohama",
            "odpt.Railway:JR-East.Saikyo",
            "odpt.Railway:JR-East.Ito",
            "odpt.Railway:JR-East.Utsunomiya",
            "odpt.Railway:JR-East.Ome",
            "odpt.Railway:JR-East.JobanRapid",
            "odpt.Railway:JR-East.JobanLocal",
            "odpt.Railway:JR-East.SobuRapid",
            "odpt.Railway:JR-East.Sobu",
            "odpt.Railway:JR-East.Sotobo",
            "odpt.Railway:JR-East.Takasaki",
            "odpt.Railway:JR-East.ChuoSobuLocal",
            "odpt.Railway:JR-East.ChuoRapid",
            "odpt.Railway:JR-East.Tsurumi",
            "odpt.Railway:JR-East.Togane",
            "odpt.Railway:JR-East.Joban",
            "odpt.Railway:JR-East.Nikko",
            "odpt.Railway:JR-East.Ryomo",
            "odpt.Railway:JR-East.Nambu",
            "odpt.Railway:JR-East.KeihinTohokuNegishi",
            "odpt.Railway:JR-East.NambuBranch",
            "odpt.Railway:JR-East.Chuo",
            "odpt.Railway:JR-East.Narita",
            "odpt.Railway:JR-East.Yamanote"
        ]
        
        
        for Operator in operatorIDList{
            
            print(Operator)
            if Operator == "odpt.Operator:TokyoMetro"{
                staNameArr = staNameArr + stationsListTokyoMetro()
            }else{
                staNameArr = staNameArr +  stationsList(operatorID: Operator)
            }
        }
        
        for railWay in JREastMetropolitanAreaRailwayList{
            
            print(railWay)
            staNameArr = staNameArr + stationsList(sameAs: railWay)
            
        }
        return staNameArr
    }
    
    class func stationsList(sameAs:String)->[String]{
        var staNameArr:[String] = []
        let request = TokyoChallengeAPI.Railway(sameAs:sameAs)
        Session.send(request)
        {
            response in
            switch response {
            case .success(let responses):
                for block in responses {
                    for station in block.1["odpt:stationOrder"]{
                        print(station.1["odpt:stationTitle"])
                        staNameArr.append(station.1["odpt:stationTitle"].string!)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        return staNameArr
    }
    
    class func stationsList(operatorID:String)->[String]{
        var staNameArr:[String] = []
        let request = TokyoChallengeAPI.Railway(operatorID:operatorID)
        Session.send(request)
        {
            response in
            switch response {
            case .success(let responses):
                for block in responses {
                    for station in block.1["odpt:stationOrder"]{
                        print(station.1["odpt:stationTitle"])
                        staNameArr.append(station.1["odpt:stationTitle"].string!)
                    }
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
        return staNameArr
    }
    
    class func stationsListTokyoMetro()->[String]{
        var staNameArr:[String] = []
        let request = TokyoChallengeAPI.Station(operatorID:"odpt.Operator:TokyoMetro")
        Session.send(request)
        {
            response in
            switch response {
            case .success(let responses):
                for block in responses {
                    let info = block.1["dc:title"].string!
                    print(info)
                    staNameArr.append(info)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        return staNameArr
    }
    
    class func isExistStationInList(stationName:String)->Bool{
        var isExist:Bool = false
        let request = TokyoChallengeAPI.Station(title:stationName)
        Session.send(request)
        {
            response in
            switch response {
                
            case .success(let responses):
                for block in responses {
                    let info = block.1["dc:title"].string! + "(" + block.1["odpt:railway"].string!  + ")"
                    print(info)
                }
                isExist = true
                break
                
            case .failure(let error):
                print(error)
                print("encount error")
                isExist = false
            }
        }
        print(isExist)
        return isExist
    }
    
    class func SearchStationIncludingArgCharacters(character:String){
        let request = TokyoChallengeAPI.Station(title:character)
        Session.send(request)
        {
            response in
            switch response {
                
            case .success(let responses):
                for block in responses {
                    let info = block.1["dc:title"].string! + "(" + block.1["odpt:railway"].string!  + ")"
                    print(info)
                }
                print(responses[0])
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

