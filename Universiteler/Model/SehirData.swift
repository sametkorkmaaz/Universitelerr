//
//  Model.swift
//  NestedTableview
//
//  Created by Kishan Barmawala on 02/08/23.
//

import Foundation
// TableView ı doldurmak için kullanacağımız veriler 
struct SehirData {
    var cityName: String
    var isExpanded: Bool
    var universiteDetayData: [UniversiteDetayData]
}

struct UniversiteDetayData {
    var uniAdi: String
    var phone: String
    var fax: String
    var website: String
    var email: String
    var adress: String
    var rector: String
}
