import APIKit
import SwiftyJSON

protocol TokyoChallengeAPIRequest: Request {
    var params: [String: Any] { get set }
}

extension TokyoChallengeAPIRequest {
    var baseURL: URL {
        return URL(string: "https://api-tokyochallenge.odpt.org/api/v4/")!
    }
    var parameters: Any? {
        var params = self.params
        // ACL_CONSUMERKEYを取得したアクセストークンで置き換える
        params["acl:consumerKey"] = "CONSUMER_KEY"
        return params
    }
    var method: HTTPMethod {
        return .get
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> JSON {
        return JSON(object)
    }
}

enum TokyoChallengeAPI {
    /// 鉄道乗降車数情報
    struct PassengerSurvey: TokyoChallengeAPIRequest {
        typealias Response = JSON

        var params: [String : Any] = [:]

        var path: String {
            return "odpt:PassengerSurvey"
        }

        init(sameAs: String) {
            params["owl:sameAs"] = sameAs
        }

        init(operatorID: String) {
            params["odpt:operator"] = operatorID
        }

        init(railwayID: String) {
            params["odpt:railway"] = railwayID
        }

        init(stationID: String) {
            params["odpt:station"] = stationID
        }
    }

    /// 鉄道路線情報
    struct Railway: TokyoChallengeAPIRequest {
        typealias Response = JSON

        var params: [String : Any] = [:]

        var path: String {
            return "odpt:Railway"
        }

        init(sameAs: String) {
            params["owl:sameAs"] = sameAs
        }

        init(operatorID: String) {
            params["odpt:operator"] = operatorID
        }

        init(railwayID: String) {
            params["odpt:railway"] = railwayID
        }

        init(title: String) {
            params["dc:title"] = title
        }

        init(lineCode: String) {
            params["odpt:lineCode"] = lineCode
        }
    }

    /// 鉄道運賃
    struct RailwayFare: TokyoChallengeAPIRequest {
        typealias Response = JSON

        var params: [String : Any] = [:]

        var path: String {
            return "odpt:RailwayFare"
        }

        init(sameAs: String) {
            params["owl:sameAs"] = sameAs
        }

        init(operatorID: String) {
            params["odpt:operator"] = operatorID
        }

        init(fromStationID: String, toStationID: String) {
            params["odpt:fromStation"] = fromStationID
            params["odpt:toStation"] = toStationID
        }
    }

    /// 駅情報
    struct Station: TokyoChallengeAPIRequest {
        typealias Response = JSON

        var params: [String : Any] = [:]

        var path: String {
            return "odpt:Station"
        }

        init(sameAs: String) {
            params["owl:sameAs"] = sameAs
        }

        init(operatorID: String) {
            params["odpt:operator"] = operatorID
        }

        init(railwayID: String) {
            params["odpt:railway"] = railwayID
        }

        init(title: String) {
            params["dc:title"] = title
        }

        init(stationCode: String) {
            params["odpt:stationCode"] = stationCode
        }
        
        init(characterIncluded: String) {
            
        }
    }

    /// 駅時刻表
    struct StationTimetable: TokyoChallengeAPIRequest {
        typealias Response = JSON

        var params: [String : Any] = [:]

        var path: String {
            return "odpt:StationTimetable"
        }

        init(sameAs: String) {
            params["owl:sameAs"] = sameAs
        }

        init(operatorID: String) {
            params["odpt:operator"] = operatorID
        }

        init(railwayID: String) {
            params["odpt:railway"] = railwayID
        }

        init(stationID: String) {
            params["odpt:station"] = stationID
        }
    }

    /// 列車情報
    struct Train: TokyoChallengeAPIRequest {
        typealias Response = JSON

        var params: [String : Any] = [:]

        var path: String {
            return "odpt:Train"
        }

        init(operatorID: String) {
            params["odpt:operator"] = operatorID
        }

        init(railwayID: String) {
            params["odpt:railway"] = railwayID
        }
    }

    /// 列車運行情報
    struct TrainInformation: TokyoChallengeAPIRequest {
        typealias Response = JSON

        var params: [String : Any] = [:]

        var path: String {
            return "odpt:TrainInformation"
        }

        init(operatorID: String) {
            params["odpt:operator"] = operatorID
        }

        init(railwayID: String) {
            params["odpt:railway"] = railwayID
        }
    }

    /// 列車時刻表
    struct TrainTimetable: TokyoChallengeAPIRequest {
        typealias Response = JSON

        var params: [String : Any] = [:]

        var path: String {
            return "odpt:TrainTimetable"
        }

        init(sameAs: String) {
            params["owl:sameAs"] = sameAs
        }

        init(operatorID: String) {
            params["odpt:operator"] = operatorID
        }

        init(railwayID: String) {
            params["odpt:railway"] = railwayID
        }

        init(trainID: String) {
            params["odpt:train"] = trainID
        }
    }

    /// バスロケーション情報
    struct Bus: TokyoChallengeAPIRequest {
        typealias Response = JSON

        var params: [String : Any] = [:]

        var path: String {
            return "odpt:Bus"
        }

        init(sameAs: String) {
            params["owl:sameAs"] = sameAs
        }

        init(operatorID: String) {
            params["odpt:operator"] = operatorID
        }

        init(routePatternID: String) {
            params["odpt:busroutePattern"] = routePatternID
        }
    }

    /// バス時刻表
    struct BusTimetable: TokyoChallengeAPIRequest {
        typealias Response = JSON

        var params: [String : Any] = [:]

        var path: String {
            return "odpt:BusTimetable"
        }

        init(sameAs: String) {
            params["owl:sameAs"] = sameAs
        }

        init(operatorID: String) {
            params["odpt:operator"] = operatorID
        }

        init(routePatternID: String) {
            params["odpt:busroutePattern"] = routePatternID
        }

        init(title: String) {
            params["dc:title"] = title
        }
    }

    /// バス路線情報
    struct BusroutePattern: TokyoChallengeAPIRequest {
        typealias Response = JSON

        var params: [String : Any] = [:]

        var path: String {
            return "odpt:BusroutePattern"
        }

        init(sameAs: String) {
            params["owl:sameAs"] = sameAs
        }

        init(operatorID: String) {
            params["odpt:operator"] = operatorID
        }

        init(routeID: String) {
            params["odpt:busroute"] = routeID
        }

        init(title: String) {
            params["dc:title"] = title
        }
    }

    /// バス運賃情報
    struct BusroutePatternFare: TokyoChallengeAPIRequest {
        typealias Response = JSON

        var params: [String : Any] = [:]

        var path: String {
            return "odpt:BusroutePatternFare"
        }

        init(sameAs: String) {
            params["owl:sameAs"] = sameAs
        }

        init(operatorID: String) {
            params["odpt:operator"] = operatorID
        }

        init(routePatternID: String) {
            params["odpt:busroutePattern"] = routePatternID
        }

        init(fromPoleID: String, toPoleID: String) {
            params["odpt:fromBusstopPole"] = fromPoleID
            params["odpt:toBusstopPole"] = toPoleID
        }
    }

    /// バス停情報
    struct BusstopPole: TokyoChallengeAPIRequest {
        typealias Response = JSON

        var params: [String : Any] = [:]

        var path: String {
            return "odpt:BusstopPole"
        }

        init(sameAs: String) {
            params["owl:sameAs"] = sameAs
        }

        init(operatorID: String) {
            params["odpt:operator"] = operatorID
        }

        init(routePatternID: String) {
            params["odpt:busroutePattern"] = routePatternID
        }
    }
    /// バス停時刻表情報
    struct BusstopPoleTimetable: TokyoChallengeAPIRequest {
        typealias Response = JSON

        var params: [String : Any] = [:]

        var path: String {
            return "odpt:BusstopPoleTimetable"
        }

        init(sameAs: String) {
            params["owl:sameAs"] = sameAs
        }

        init(operatorID: String) {
            params["odpt:operator"] = operatorID
        }

        init(routeID: String) {
            params["odpt:busroute"] = routeID
        }

        init(poleID: String) {
            params["odpt:busstopPole"] = poleID
        }
    }

    /// フライト到着情報
    struct FlightInformationArrival: TokyoChallengeAPIRequest {
        typealias Response = JSON

        var params: [String : Any] = [:]

        var path: String {
            return "odpt:FlightInformationArrival"
        }

        init(sameAs: String) {
            params["owl:sameAs"] = sameAs
        }

        init(airportID: String) {
            params["odpt:destinationAirport"] = airportID
        }
    }

    /// フライト出発情報
    struct FlightInformationDeparture: TokyoChallengeAPIRequest {
        typealias Response = JSON

        var params: [String : Any] = [:]

        var path: String {
            return "odpt:FlightInformationDeparture"
        }

        init(sameAs: String) {
            params["owl:sameAs"] = sameAs
        }

        init(airportID: String) {
            params["odpt:departureAirport"] = airportID
        }
    }

    /// 空港時刻表
    struct FlightSchedule: TokyoChallengeAPIRequest {
        typealias Response = JSON

        var params: [String : Any] = [:]

        var path: String {
            return "odpt:FlightSchedule"
        }

        init(sameAs: String) {
            params["owl:sameAs"] = sameAs
        }

        init(operatorID: String) {
            params["odpt:operator"] = operatorID
        }
        
        init(airportID: String) {
            params["odpt:airport"] = airportID
        }
    }

}
