//
//  UniversiteManager.swift
//  Universiteler
//
//  Created by Samet Korkmaz on 30.03.2024.
//

import Foundation

class UniversiteManager {
    
    var sehirData: [SehirData]? // API'den alınan üniversite verilerini tutan dizi
    weak var delegate: UniversiteManagerDelegate? // Bu protokol ile Controller ile iletişim kuruyoruz
    var isLoading = false
    
    let universiteURL = "https://storage.googleapis.com/invio-com/usg-challenge/universities-at-turkey/page-" //1.json
    
    // Bu fonksiyon sayesinde URL e pageNo ekleyip istediğimiz URl i elde ediyoruz
    func fetchUniversity(pageNO: Int) {
        let urlString = "\(universiteURL)\(pageNO).json"
        print(urlString)
        // Oluşturduğumuz url i api ye istek atacağımız fonksiyona gönderiyoruz
        self.performRequest(urlString: urlString)
    }
    // Belirtilen URL üzerinden ağ isteği yapıyoruz ve veri almak için bir URLSession kullanıyoruz
    func performRequest(urlString: String){
        
        if let url = URL(string: urlString) { // URL geçerli mi?
            
            let session = URLSession(configuration: .default)
            // URLSession üzerinden bir veri alma işlemi başlatıyoruz
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data { // veriye ulaşıldı mı?
                    self.parseJSON(universiteData: safeData)
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(universiteData: Data) {
        let decoder = JSONDecoder()
        do {

      let decodedData = try decoder.decode(UniversiteData.self, from: universiteData) // json verimizi çözüyoruz
            // Boş bir dizi oluştur
            var schoolsData = [SehirData]()

            // Her bir "province" için verileri döngüye al
            for (_, province) in decodedData.data.enumerated() {
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
                    
                    // Yeni oluşturulan UniversiteDetayData örneğini SehirData'nın içindeki universiteDetayData dizisine ekliyoruz
                    cityData.universiteDetayData.append(universiteDetayData)
                }
                
                // Oluşturulan SehirData örneğini schoolsData dizisine ekle
                schoolsData.append(cityData)
            }
            
            if self.sehirData == nil { // daha önceden schoolsData nın içi boşsa
                self.sehirData = schoolsData
            } else {   // schoolsData nın içinde veri varsa üstüne eklemek için
                self.sehirData?.append(contentsOf: schoolsData)
            }
            // Yükleme işlemi tamamlandığında delegeni bildir
            DispatchQueue.main.async {
                self.delegate?.didFetchUniversityData()
            }
        } catch {
            print(error)
        }
    }
    
}
