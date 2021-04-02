//
//  FirebaseData.swift
//  MyApp
//
//  Created by Sameer Narang on 31/03/21.
//

import Foundation

struct FirebaseData: Encodable, Decodable {
    var start_date: String?
    var end_date: String?
    var tasks: String?
}
