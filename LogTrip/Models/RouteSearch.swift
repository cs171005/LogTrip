//
//  RouteSearch.swift
//  LogTrip
//
//  Created by 河野穣 on 2018/03/04.
//  Copyright © 2018年 河野穣. All rights reserved.
//

import Foundation
import APIKit
import SwiftyJSON
import UIKit

class staDetail {
    var NBStations: [String] = []
    var score: Int = 0
    var routeStations: [String] = []
    
    init(NB:[String]) {
        NBStations = NB
    }
    
    func updateScore(newScore:Int){
        score = newScore
    }
}

class RouteSearch{
    let defaults = UserDefaults.standard
    
    var StationTitleToSameAsDict :[String:String] = [:]
    
    
    
    class func searchRoute(origin:String,destination:String,isOutputAsStationNames:Bool)->[String]{
        let defaults = UserDefaults.standard
        let NBStationDictList :[String:[String]] = defaults.object(forKey:"NB_STATION_LIST") as! [String:[String]]
        //init data
        var stations:[String:staDetail] = [:]
        
        //input origin and destination
        let origin = origin
        let destination = destination
        
        NBStationDictList.forEach({
            stations[$0.key] = staDetail(NB: $0.value)
        })
        
        (stations.filter { $0.key != origin }).forEach({
            $0.value.updateScore(newScore: 10000)
        })
        
        var allRoute :[String] = []
        var targetStations : [String] = [origin]
        while targetStations.count != 0 {
            let targetStation = targetStations.remove(at: 0)
            stations[targetStation]?.NBStations.forEach{
                if stations[$0]?.score == 0 || (stations[targetStation]?.score)! + 1 < (stations[$0]?.score)!{
                    stations[$0]?.score = (stations[targetStation]?.score)! + 1
                    targetStations.append($0)
                    stations[$0]?.routeStations = (stations[targetStation]?.routeStations)! + [targetStation]
                    //print(stations[$0]?.routeStations)
                }
            }
        }
        if stations[destination]?.routeStations.count != 0{
            stations[destination]?.routeStations.append(destination)
            allRoute = (stations[destination]?.routeStations)!
        }
        print(allRoute)
        if isOutputAsStationNames{
            return allRoute
        }else{
            var passedRailwayList : [String] = []
            
            //出発駅内出発前乗り換えを除去
            if (allRoute.first!).components(separatedBy: ".").last! == (allRoute[1]).components(separatedBy: ".").last!{
                allRoute.removeFirst()
            }
            //目的駅内到着後乗り換えを除去
            if (allRoute.last!).components(separatedBy: ".").last! == (allRoute[allRoute.count - 2]).components(separatedBy: ".").last!{
                allRoute.removeLast()
            }
            
            for eachSta in allRoute{
                let railwayAndSta = eachSta.components(separatedBy: ":").last!
                let operatorAndRailWay = "odpt.Railway:" + railwayAndSta.components(separatedBy: ".")[0] + "." + railwayAndSta.components(separatedBy: ".")[1]
                passedRailwayList.append(operatorAndRailWay)
            }
            let orderedSet = NSOrderedSet(array: passedRailwayList)
            passedRailwayList = orderedSet.array as! [String]
            return passedRailwayList
        }
        
    }
    
    
    private func getTransferOthersLines(value: String, dictionary: [String: String]) ->[String]?{
        var sameAsArr : [String] = []
        for (sameAs, stationTitle) in dictionary
        {
            if(stationTitle == dictionary[value]){
                //print(sameAs,stationTitle,value,dictionary[value]!)
                sameAsArr.append(sameAs)
            }
        }
        
        if (!sameAsArr.isEmpty)
        {
            return sameAsArr.filter({$0 != value})
        }else{
            return nil
        }
    }
    
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
    
    var MinTetsuMetropolitanAreaRailwayList:[String] = [
        "odpt.Railway:TokyoMetro.Chiyoda",
        "odpt.Railway:TokyoMetro.Yurakucho",
        "odpt.Railway:TokyoMetro.Hibiya",
        "odpt.Railway:TokyoMetro.Namboku",
        "odpt.Railway:TokyoMetro.Ginza",
        "odpt.Railway:TokyoMetro.Hanzomon",
        "odpt.Railway:TokyoMetro.Marunouchi",
        "odpt.Railway:TokyoMetro.MarunouchiBranch",
        "odpt.Railway:TokyoMetro.Tozai",
        "odpt.Railway:TokyoMetro.Fukutoshin",
        "odpt.Railway:Keisei.Kanamachi",
        "odpt.Railway:Keisei.Chihara",
        "odpt.Railway:Keisei.Oshiage",
        "odpt.Railway:Keisei.NaritaSkyAccess",
        "odpt.Railway:Keisei.HigashiNarita",
        "odpt.Railway:Keisei.Chiba",
        "odpt.Railway:Keisei.Main",
        "odpt.Railway:Tokyu.DenEnToshi",
        "odpt.Railway:Tokyu.Oimachi",
        "odpt.Railway:Tokyu.Ikegami",
        "odpt.Railway:Tokyu.Toyoko",
        "odpt.Railway:Tokyu.Meguro",
        "odpt.Railway:Tokyu.Setagaya",
        "odpt.Railway:Tokyu.Kodomonokuni",
        "odpt.Railway:Tokyu.TokyuTamagawa",
        "odpt.Railway:Keikyu.Zushi",
        "odpt.Railway:Keikyu.Airport",
        "odpt.Railway:Keikyu.Kurihama",
        "odpt.Railway:Keikyu.Main",
        "odpt.Railway:Keikyu.Daishi",
        "odpt.Railway:Seibu.Toshima",
        "odpt.Railway:Seibu.SeibuChichibu",
        "odpt.Railway:Seibu.Kokubunji",
        "odpt.Railway:Seibu.Sayama",
        "odpt.Railway:Seibu.Haijima",
        "odpt.Railway:Seibu.Seibuen",
        "odpt.Railway:Seibu.Tamagawa",
        "odpt.Railway:Seibu.Yamaguchi",
        "odpt.Railway:Seibu.SeibuYurakucho",
        "odpt.Railway:Seibu.Ikebukuro",
        "odpt.Railway:Seibu.Shinjuku",
        "odpt.Railway:Seibu.Tamako",
        "odpt.Railway:Keio.Keio",
        "odpt.Railway:Keio.KeioNew",
        "odpt.Railway:Keio.Keibajo",
        "odpt.Railway:Keio.Dobutsuen",
        "odpt.Railway:Keio.Sagamihara",
        "odpt.Railway:Keio.Takao",
        "odpt.Railway:Keio.Inokashira",
        "odpt.Railway:Odakyu.Odawara",
        "odpt.Railway:Odakyu.Enoshima",
        "odpt.Railway:Odakyu.Tama",
        "odpt.Railway:Toei.Oedo",
        "odpt.Railway:Toei.Mita",
        "odpt.Railway:Toei.NipporiToneri",
        "odpt.Railway:Toei.Asakusa",
        "odpt.Railway:Toei.Shinjuku",
        "odpt.Railway:Toei.Arakawa",
        "odpt.Railway:TWR.Rinkai",
        "odpt.Railway:Tobu.Kameido",
        "odpt.Railway:Tobu.Sano",
        "odpt.Railway:Tobu.Daishi",
        "odpt.Railway:Tobu.Nikko",
        "odpt.Railway:Tobu.Utsunomiya",
        "odpt.Railway:Tobu.Ogose",
        "odpt.Railway:Tobu.Tojo",
        "odpt.Railway:Tobu.Isesaki",
        "odpt.Railway:Tobu.Koizumi",
        "odpt.Railway:Tobu.TobuUrbanPark",
        "odpt.Railway:Tobu.Kinugawa",
        "odpt.Railway:Tobu.Kiryu",
        "odpt.Railway:Tobu.KoizumiBranch",
        "odpt.Railway:Tobu.TobuSkytreeBranch",
        "odpt.Railway:Tobu.TobuSkytree",
        "odpt.Railway:Yurikamome.Yurikamome",
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
    
    static let railWayColor:[String:UIColor] = [
        "odpt.Railway:TokyoMetro.Chiyoda" : UIColor(hex: "009933"),
        "odpt.Railway:TokyoMetro.Yurakucho" : UIColor(hex: "C5C544"),
        "odpt.Railway:TokyoMetro.Hibiya" : UIColor(hex: "89A1AD"),
        "odpt.Railway:TokyoMetro.Namboku" : UIColor(hex: "00ADA9"),
        "odpt.Railway:TokyoMetro.Ginza" : UIColor(hex: "F7931D"),
        "odpt.Railway:TokyoMetro.Hanzomon" : UIColor(hex: "A757A8"),
        "odpt.Railway:TokyoMetro.Marunouchi" : UIColor(hex: "E60012"),
        "odpt.Railway:TokyoMetro.MarunouchiBranch" : UIColor(hex: "E60012"),
        "odpt.Railway:TokyoMetro.Tozai" : UIColor(hex: "00A7DB"),
        "odpt.Railway:TokyoMetro.Fukutoshin" : UIColor(hex: "BB6633"),
        "odpt.Railway:Keisei.Kanamachi" : UIColor(hex: "3366FF"),
        "odpt.Railway:Keisei.Chihara" : UIColor(hex: "3366FF"),
        "odpt.Railway:Keisei.Oshiage" : UIColor(hex: "3366FF"),
        "odpt.Railway:Keisei.NaritaSkyAccess" : UIColor(hex: "FF6600"),
        "odpt.Railway:Keisei.HigashiNarita" : UIColor(hex: "3366FF"),
        "odpt.Railway:Keisei.Chiba" : UIColor(hex: "3366FF"),
        "odpt.Railway:Keisei.Main" : UIColor(hex: "3366FF"),
        "odpt.Railway:Tokyu.DenEnToshi" : UIColor(hex: "20A288"),
        "odpt.Railway:Tokyu.Oimachi" : UIColor(hex: "F18C43"),
        "odpt.Railway:Tokyu.Ikegami" : UIColor(hex: "EE86A7"),
        "odpt.Railway:Tokyu.Toyoko" : UIColor(hex: "DA0442"),
        "odpt.Railway:Tokyu.Meguro" : UIColor(hex: "009CD2"),
        "odpt.Railway:Tokyu.Setagaya" : UIColor(hex: "FCC70D"),
        "odpt.Railway:Tokyu.Kodomonokuni" : UIColor(hex: "0068B7"),
        "odpt.Railway:Tokyu.TokyuTamagawa" : UIColor(hex: "E0378"),
        "odpt.Railway:Keikyu.Zushi" : UIColor(hex: "00CCFF"),
        "odpt.Railway:Keikyu.Airport" : UIColor(hex: "00CCFF"),
        "odpt.Railway:Keikyu.Kurihama" : UIColor(hex: "00CCFF"),
        "odpt.Railway:Keikyu.Main" : UIColor(hex: "00CCFF"),
        "odpt.Railway:Keikyu.Daishi" : UIColor(hex: "00CCFF"),
        "odpt.Railway:Seibu.Toshima" : UIColor(hex: "F17900"),
        "odpt.Railway:Seibu.SeibuChichibu" : UIColor(hex: "F17900"),
        "odpt.Railway:Seibu.Kokubunji" : UIColor(hex: "00BB00"),
        "odpt.Railway:Seibu.Sayama" : UIColor(hex: "F17900"),
        "odpt.Railway:Seibu.Haijima" : UIColor(hex: "00A6C0"),
        "odpt.Railway:Seibu.Seibuen" : UIColor(hex: "00A6C0"),
        "odpt.Railway:Seibu.Tamagawa" : UIColor(hex: "F17900"),
        "odpt.Railway:Seibu.Yamaguchi" : UIColor(hex: "FF69B4"),
        "odpt.Railway:Seibu.SeibuYurakucho" : UIColor(hex: "9370DB"),
        "odpt.Railway:Seibu.Ikebukuro" : UIColor(hex: "F17900"),
        "odpt.Railway:Seibu.Shinjuku" : UIColor(hex: "00A6C0"),
        "odpt.Railway:Seibu.Tamako" : UIColor(hex: "FFA500"),
        "odpt.Railway:Keio.Keio" : UIColor(hex: "CA2D73"),
        "odpt.Railway:Keio.KeioNew" : UIColor(hex: "CA2D73"),
        "odpt.Railway:Keio.Keibajo" : UIColor(hex: "CA2D73"),
        "odpt.Railway:Keio.Dobutsuen" : UIColor(hex: "CA2D73"),
        "odpt.Railway:Keio.Sagamihara" : UIColor(hex: "CA2D73"),
        "odpt.Railway:Keio.Takao" : UIColor(hex: "CA2D73"),
        "odpt.Railway:Keio.Inokashira" : UIColor(hex: "CA2D73"),
        "odpt.Railway:Odakyu.Odawara" : UIColor(hex: "3c8cc8"),
        "odpt.Railway:Odakyu.Enoshima" : UIColor(hex: "3c8cc8"),
        "odpt.Railway:Odakyu.Tama" : UIColor(hex: "3c8cc8"),
        "odpt.Railway:Toei.Oedo" : UIColor(hex: "B6007A"),
        "odpt.Railway:Toei.Mita" : UIColor(hex: "0079C2"),
        "odpt.Railway:Toei.NipporiToneri" : UIColor(hex: "FF69B4"),
        "odpt.Railway:Toei.Asakusa" : UIColor(hex: "E85298"),
        "odpt.Railway:Toei.Shinjuku" : UIColor(hex: "6CBB5A"),
        "odpt.Railway:Toei.Arakawa" : UIColor(hex: "FF69B4"),
        "odpt.Railway:TWR.Rinkai" : UIColor(hex: "0000FF"),
        "odpt.Railway:Tobu.Kameido" : UIColor(hex: "0f6cc3"),
        "odpt.Railway:Tobu.Sano" : UIColor.red,
        "odpt.Railway:Tobu.Daishi" : UIColor(hex: "0f6cc3"),
        "odpt.Railway:Tobu.Nikko" : UIColor.orange,
        "odpt.Railway:Tobu.Utsunomiya" : UIColor.orange,
        "odpt.Railway:Tobu.Ogose" : UIColor(hex: "FF00FF"),
        "odpt.Railway:Tobu.Tojo" : UIColor(hex: "FF00FF"),
        "odpt.Railway:Tobu.Isesaki" : UIColor(hex: "FF00FF"),
        "odpt.Railway:Tobu.Koizumi" : UIColor.red,
        "odpt.Railway:Tobu.TobuUrbanPark" : UIColor(hex: "FF00FF"),
        "odpt.Railway:Tobu.Kinugawa" : UIColor.orange,
        "odpt.Railway:Tobu.Kiryu" : UIColor.red,
        "odpt.Railway:Tobu.KoizumiBranch" : UIColor.red,
        "odpt.Railway:Tobu.TobuSkytreeBranch" : UIColor(hex: "0f6cc3"),
        "odpt.Railway:Tobu.TobuSkytree" : UIColor(hex: "0f6cc3"),
        "odpt.Railway:Yurikamome.Yurikamome" : UIColor(hex: "27404E"),
        "odpt.Railway:JR-East.Tokaido" : UIColor(hex: "F68B1E"),
        "odpt.Railway:JR-East.Yokosuka" : UIColor(hex: "000080"),
        "odpt.Railway:JR-East.Itsukaichi" : UIColor(hex: "F15A22"),
        "odpt.Railway:JR-East.Uchibo" : UIColor(hex: "00B2E5"),
        "odpt.Railway:JR-East.Kawagoe" : UIColor(hex: "00B48D"),
        "odpt.Railway:JR-East.Keiyo" : UIColor(hex: "C9252F"),
        "odpt.Railway:JR-East.Sagami" : UIColor(hex: "2BA19C"),
        "odpt.Railway:JR-East.ShonanShinjuku" : UIColor(hex: "E21F26"),
        "odpt.Railway:JR-East.UenoTokyo" : UIColor(hex: "800080"),
        "odpt.Railway:JR-East.Hachiko" : UIColor(hex: "A8A39D"),
        "odpt.Railway:JR-East.Mito" : UIColor(hex: "007AC0"),
        "odpt.Railway:JR-East.Musashino" : UIColor(hex: "FF4500"),
        "odpt.Railway:JR-East.Yokohama" : UIColor(hex: "9ACD32"),
        "odpt.Railway:JR-East.Saikyo" : UIColor(hex: "008000"),
        "odpt.Railway:JR-East.Ito" : UIColor(hex: "F68B1E"),
        "odpt.Railway:JR-East.Utsunomiya" : UIColor(hex: "F79123"),
        "odpt.Railway:JR-East.Ome" : UIColor(hex: "F15A22"),
        "odpt.Railway:JR-East.JobanRapid" : UIColor(hex: "00B261"),
        "odpt.Railway:JR-East.JobanLocal" : UIColor(hex: "00B261"),
        "odpt.Railway:JR-East.SobuRapid" : UIColor(hex: "000080"),
        "odpt.Railway:JR-East.Sobu" : UIColor(hex: "FFC500"),
        "odpt.Railway:JR-East.Sotobo" : UIColor(hex: "DC4534"),
        "odpt.Railway:JR-East.Takasaki" : UIColor(hex: "F79123"),
        "odpt.Railway:JR-East.ChuoSobuLocal" : UIColor(hex: "FFD400"),
        "odpt.Railway:JR-East.ChuoRapid" : UIColor(hex: "F15A22"),
        "odpt.Railway:JR-East.Tsurumi" : UIColor(hex: "FFFF00"),
        "odpt.Railway:JR-East.Togane" : UIColor(hex: "F15F2B"),
        "odpt.Railway:JR-East.Joban" : UIColor(hex: "007AC0"),
        "odpt.Railway:JR-East.Nikko" : UIColor(hex: "008000"),
        "odpt.Railway:JR-East.Ryomo" : UIColor(hex: "FFFF00"),
        "odpt.Railway:JR-East.Nambu" : UIColor(hex: "FFD600"),
        "odpt.Railway:JR-East.KeihinTohokuNegishi" : UIColor(hex: "00BAE8"),
        "odpt.Railway:JR-East.NambuBranch" : UIColor(hex: "FFD600"),
        "odpt.Railway:JR-East.Chuo" : UIColor(hex: "0000FF"),
        "odpt.Railway:JR-East.Narita" : UIColor(hex: "4CBA6C"),
        "odpt.Railway:JR-East.Yamanote" : UIColor(hex: "99CC00")
    ]
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat) {
        let v = hex.map { String($0) } + Array(repeating: "0", count: max(6 - hex.count, 0))
        let r = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }
}
