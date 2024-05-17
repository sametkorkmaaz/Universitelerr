//
//  InnerTableViewCellDelegate2.swift
//  Universiteler
//
//  Created by Samet Korkmaz on 16.04.2024.
//

import Foundation

// Bu protokol ile TableViewCellden gerçekleştiremediğimiz sayfa geçişleri ve veri aktarımı gibi işlevleri ait olduğu ViewController a protokol ile erişip kullanıyoruz
// Favorilere eklemek için
protocol InnerTableViewCellDelegate2: AnyObject {
    func addToFavoritesButtonPressed(withUniversityData universityData: UniversiteDetayData)
}
