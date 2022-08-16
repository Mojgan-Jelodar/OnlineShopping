//
//  File.swift
//  Balad
//
//  Created by mozhgan on 3/26/21.
//
import Alamofire

final class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
