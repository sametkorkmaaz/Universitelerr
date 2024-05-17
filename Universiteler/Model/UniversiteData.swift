//
//  UniversiteData.swift
//  Universiteler
//
//  Created by Samet Korkmaz on 30.03.2024.
//

import Foundation
// Bu satfada JSON formattaki verilermizi çözüyoruz
// Codable Encodable ve Decodable protokollerinin birleşimi
struct UniversiteData : Codable{
    let currentPage: Int
    let totalPage: Int
    let total: Int
    let itemPerPage: Int
    let pageSize: Int
    let data: [Data1] // [Data] olarak yazıldığında Data veri türü alğılandığı için Data1
}

struct Data1 : Codable{
    let id: Int
    let province: String
    let universities: [Universities]
}

struct Universities :Codable{
    let name: String
    let phone: String
    let fax: String
    let website: String
    let email: String
    let adress: String
    let rector: String
}
