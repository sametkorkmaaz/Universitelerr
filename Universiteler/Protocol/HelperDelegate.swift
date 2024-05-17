//
//  HelperDelegate.swift
//  Universiteler
//
//  Created by Samet Korkmaz on 2.04.2024.
//

import Foundation

// TableView ın genişlemesini daralmasını sağlayan protokol 
protocol HelperDelegate {
    func heightChanged(index: Int, value: Bool)
}
