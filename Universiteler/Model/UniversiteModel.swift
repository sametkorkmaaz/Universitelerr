//
//  UniversiteModel.swift
//  Universiteler
//
//  Created by Samet Korkmaz on 7.04.2024.
//

/*import Foundation

struct UniversiteModel {
    
    let cities : [String]
    let universityNames: [String]
    let phoneNumbers: [String]
    let faxNumbers: [String]
    let websites: [String]
    let emails: [String]
    let addresses: [String]
    let rectors: [String]
    let decodedData: [UniversiteData]
    
    
    // Boş bir dizi oluştur
    var schoolsData = [SehirData]()

    // Her bir "province" için verileri döngüye al
    for (index, province) in decodedData.data.enumerated() {
        // Yeni bir SehirData örneği oluştur
        var cityData = SehirData(cityName: province.province, isExpanded: false, universiteDetayData: [])
        
        // Her bir üniversite için verileri döngüye al
        for university in province.universities {
            // Her bir üniversite için gerekli verileri al ve yeni bir UniversiteDetayData örneği oluştur
            let universiteDetayData = UniversiteDetayData(
                uniAdi: university.name,
                phone: university.phone,
                fax: university.fax,
                website: university.website,
                email: university.email,
                adress: university.adress,
                rector: university.rector
            )
            
            // Yeni oluşturulan UniversiteDetayData örneğini SehirData'nın içindeki universiteDetayData dizisine ekle
            cityData.universiteDetayData.append(universiteDetayData)
        }
        
        // Oluşturulan SehirData örneğini schoolsData dizisine ekle
        schoolsData.append(cityData)
    }

    // schoolsData dizisi artık istediğiniz formatta hazır
    print(schoolsData)
    
} */
