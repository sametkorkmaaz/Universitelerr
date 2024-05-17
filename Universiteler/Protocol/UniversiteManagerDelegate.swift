//
//  UniversiteManagerDelegate.swift
//  Universiteler
//
//  Created by Samet Korkmaz on 16.04.2024.
//

import Foundation

// Api den eriştiğimiz verileri ViewController da kullabilmek için kullancığımız protocol
protocol UniversiteManagerDelegate: AnyObject {
    func didFetchUniversityData()
}
