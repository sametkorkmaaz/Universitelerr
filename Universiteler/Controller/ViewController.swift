//
//  ViewController.swift
//  Universiteler
//
//  Created by Samet Korkmaz on 30.03.2024.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var outerTableView: UITableView!
    
    var manager = UniversiteManager()
    var mevcutSayfa = 1
    var isLoading = false // Yükleme işlemi devam ediyor mu?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        manager.delegate = self
        manager.fetchUniversity(pageNO: mevcutSayfa)
    }
    // Web site ekranına geçerken veri aktarımı
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "websiteEkranı" {
                if let destinationVC = segue.destination as? WebSite_VC,
                   let data = sender as? (urlString: String, uniAdi: String) {
                    destinationVC.uniAdi = data.uniAdi
                    destinationVC.urlString = data.urlString
                }
            }
        }
}
// TableView protokolleri
extension ViewController : UITableViewDataSource, UITableViewDelegate {
    //Şehir satır sayısı
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.sehirData?.count ?? 0
    }
    // Satırların içerikleri
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OuterTableCell", for: indexPath) as? OuterTableCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.delegate2 = self
        cell.delegate3 = self
        cell.index = indexPath.row
        cell.sehirData = manager.sehirData?[indexPath.row]
        cell.helperDelegate = self
        // TableView ın son satırına gelince yükleme işlemini başlat
        if let count = manager.sehirData?.count, indexPath.row == count - 1 && !isLoading {
            isLoading = true
            mevcutSayfa += 1
            DispatchQueue.main.async {
                // Yükleme işlemini ana iş parçacığında başlat
                self.manager.fetchUniversity(pageNO: self.mevcutSayfa)
            }
        }
        return cell
    }
}
extension ViewController: InnerTableViewCellDelegate { // ana sayfadan web site butonuna basıldığında
    func websiteButtonPressed(withURL urlString: String, andUniAdi uniAdi: String) {
        // Sayfa geçişini gerçekleştir
        print(urlString)
        print(uniAdi)
        performSegue(withIdentifier: "websiteEkranı", sender: (urlString, uniAdi))
        
    }
}
extension ViewController: InnerTableViewCellDelegate2 {  // ana sayfadan favorilere ekleme
    func addToFavoritesButtonPressed(withUniversityData universityData: UniversiteDetayData) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Verinin daha önceden kaydedilip kaydedilmediğini kontrol etmek için bir sorgu
        let fetchRequest: NSFetchRequest<Favori> = Favori.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", universityData.uniAdi)
        
        do {
            // CoreData'de veriyi arayın
            let results = try context.fetch(fetchRequest)
            
            // Eğer sonuçlar bulunduysa, veri zaten kayıtlı demektir
            if !results.isEmpty {
                print("Zaten kayıtlı")
                return
            }
            
            // Eğer sonuçlar bulunmadıysa, veriyi kaydedin
            let favori = Favori(context: context)
            favori.name = universityData.uniAdi
            favori.fax = universityData.fax
            favori.email = universityData.email
            favori.adress = universityData.adress
            favori.rector = universityData.rector
            favori.phone = universityData.phone
            favori.website = universityData.website
            
            try context.save()
            
        } catch {
            print("Veri kaydedilirken hata oluştu: \(error.localizedDescription)")
        }
    }
    

}
extension ViewController: InnerTableViewCellDelegate3 { // içi dolu kalp butpnuna tekrar basıldığında
    
    func removeToFavoritesButtonPressed(withUniversityData universityData: UniversiteDetayData) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Silinecek veriyi bulmak için bir sorgu yapın
        let fetchRequest: NSFetchRequest<Favori> = Favori.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", universityData.uniAdi)
        
        do {
            // CoreData'de veriyi arayın
            let results = try context.fetch(fetchRequest)
            
            // Eğer sonuçlar bulunamadıysa, silinecek veri yok demektir
            if results.isEmpty {
                print("Silinecek veri bulunamadı")
                return
            }
            
            // Veriyi silme işlemini gerçekleştirin
            for result in results {
                context.delete(result)
            }
            
            try context.save()
            print("Veri başarıyla silindi")
            
        } catch {
            print("Veri silinirken hata oluştu: \(error.localizedDescription)")
        }
    }
    
}
extension ViewController: HelperDelegate { // Şehir satırı seçildiğinde genişlemesi
    
    func heightChanged(index: Int, value: Bool) {
        manager.sehirData?[index].isExpanded = value
        DispatchQueue.main.async {
                   self.outerTableView.performBatchUpdates(nil)
               }
    }
    
}
extension ViewController: UniversiteManagerDelegate { // Api den gelen verilerle iletişim
    func didFetchUniversityData() {
        // Yükleme tamamlandığında çağrılır
        isLoading = false
        DispatchQueue.main.async {
                    self.outerTableView.reloadData()
                }
    }
}
