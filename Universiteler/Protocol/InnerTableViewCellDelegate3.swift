//
//  InnerTableViewCellDelegate3.swift
//  Universiteler
//
//  Created by Samet Korkmaz on 16.04.2024.
//

import Foundation

// Bu protokol ile TableViewCellden gerçekleştiremediğimiz sayfa geçişleri ve veri aktarımı gibi işlevleri ait olduğu ViewController a protokol ile erişip kullanıyoruz
// Ana sayfada dolu olan kalp butonuna basarak favorilerden üniversiteyi çıkarmak için 
protocol InnerTableViewCellDelegate3: AnyObject {
    func removeToFavoritesButtonPressed(withUniversityData universityData: UniversiteDetayData)
}
