//
//  InnerTableViewCellDelegate.swift
//  Universiteler
//
//  Created by Samet Korkmaz on 16.04.2024.
//

import Foundation

// Bu protokol ile TableViewCellden gerçekleştiremediğimiz sayfa geçişleri ve veri aktarımı gibi işlevleri ait olduğu ViewController a protokol ile erişip kullanıyoruz
// Basılan üniversitenin web sitesini açmak için 
protocol InnerTableViewCellDelegate: AnyObject {
    func websiteButtonPressed(withURL urlString: String, andUniAdi uniAdi: String)
}
