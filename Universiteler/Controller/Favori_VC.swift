//
//  Favori_VC.swift
//  Universiteler
//
//  Created by Samet Korkmaz on 30.03.2024.
//

import UIKit
import CoreData

class Favori_VC: UIViewController {
    
    var InnerTableManager = InnerTableCell() // InnerTableCell de bulunan fonksiyonları kullanmak için nesne
    @IBOutlet weak var tableView_Favori: UITableView!
    var favori : Favori? // Favori türünde nesnemiz
    var favorilerListesi : [Favori]? // Favori türünde verilerimizi tutacak listemiz
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FavorilerGetir()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        //favoriEkle()
        FavorilerGetir()
    }
    // Favori sayfasından web stesi sayfasına geçerken veri aktarımı
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoridenweb" {
            if let destinationVC = segue.destination as? WebSite_VC,
               let data = sender as? (urlString: String, uniAdi: String) {
                destinationVC.uniAdi = data.uniAdi
                destinationVC.urlString = data.urlString
            }
        }
    }
    
    func FavorilerGetir(){ // CoreData Entity mizden verilerimizi getiriyoruz
        
        let fr : NSFetchRequest<Favori> = Favori.fetchRequest()
        
        do{
            favorilerListesi = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(fr)
            
            tableView_Favori.reloadData()
        }
        catch{}
    }
    
    
    @IBAction func button_favoriTOwebsite(_ sender: Any) { // favori sayfasındaki üniversitelerin web sayfası butonuna basıldığında
        // Butona basıldığında, butonun içinde bulunduğu hücrenin indexPath'ini al
        if let button = sender as? UIButton {
            let point = button.convert(CGPoint.zero, to: tableView_Favori)
            if let indexPath = tableView_Favori.indexPathForRow(at: point) {
                let selectedWebsite = favorilerListesi![indexPath.row].website
                
                // Website varsa ve geçerliyse işlemi gerçekleştir
                if let website = selectedWebsite, !website.isEmpty && website != "-" {
                    var finalURLString = website
                    if !finalURLString.hasPrefix("http://") && !finalURLString.hasPrefix("https://") {
                        finalURLString = "https://" + finalURLString
                    }
                    performSegue(withIdentifier: "favoridenweb", sender: (finalURLString, favorilerListesi![indexPath.row].name!))
                } else {
                    print("Web sitesi bulunamadı veya geçersiz.")
                }
            } else {
                print("Hücrenin indexPath'i bulunamadı.")
            }
        }
        
    }
    @IBAction func btn_favoriTOphone(_ sender: Any) { // favoriler sayfasındaki telefon butonuna basıldığında
        // Butona basıldığında, butonun içinde bulunduğu hücrenin indexPath'ini al
        let point = (sender as AnyObject).convert(CGPoint.zero, to: tableView_Favori)
        if let indexPath = tableView_Favori.indexPathForRow(at: point) {
            // Seçilen hücrenin telefon numarasını al
            if let phone = favorilerListesi?[indexPath.row].phone {
                let cleanedPhone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                let phoneNumber = "+90" + cleanedPhone
                if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Telefon aramasını başlatma başarısız oldu
                    print("Telefon aramasını başlatma başarısız oldu")
                }
            } else {
                // Telefon numarası bulunamadı
                print("Telefon numarası bulunamadı")
            }
        } else {
            // Hücrenin indexPath'i bulunamadı
            print("Hücrenin indexPath'i bulunamadı.")
        }
    }
    
    @IBAction func btn_favoridenCikar(_ sender: Any) { // favoriler sayfasındaki üniversiteleri favoriden çıkarmak için
        // Butona basıldığında, butonun içinde bulunduğu hücrenin indexPath'ini al
        if let button = sender as? UIButton {
            let point = button.convert(CGPoint.zero, to: tableView_Favori)
            if let indexPath = tableView_Favori.indexPathForRow(at: point) {
                // CoreData'den kaldırma işlemi
                if let favoriToRemove = favorilerListesi?[indexPath.row] {
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    context.delete(favoriToRemove)
                    
                    do {
                        try context.save()
                        print("Favori başarıyla kaldırıldı.")
                        
                        // Favori listesinden kaldırılan öğeyi favoriler listesinden de çıkar
                        favorilerListesi?.remove(at: indexPath.row)
                        
                        // Tabloyu yeniden yükle
                        tableView_Favori.reloadData()
                    } catch {
                        print("Favori kaldırılırken hata oluştu: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Hücrenin indexPath'i bulunamadı.")
            }
        }
    }
    // Geldiğin ekrana geri dönüş
    @IBAction func favoriGeri_BTN(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    
}
// Favori sayfası tableView protokolleri
extension Favori_VC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favorilerListesi != nil { // favoriler boş değilse
            return favorilerListesi!.count
        }
        return 0 // hiç favori yoksa
    }
    // Favori satırların içeriklerine CoreData üzerinden erişip satırlara veriyoru<
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InnerTableCell", for: indexPath) as? InnerTableCell else {
            return UITableViewCell()
        }
        cell.lblUniAdi.attributedText = InnerTableManager.setAttributeString(title: "Üniversite: ", data: favorilerListesi![indexPath.row].name!)
        let phoneAttributedTitle = NSAttributedString(string: "Phone: \(favorilerListesi![indexPath.row].phone!)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        cell.phoneButton.setAttributedTitle(phoneAttributedTitle, for: .normal)
        cell.lblFax.attributedText = InnerTableManager.setAttributeString(title: "Fax: ", data: favorilerListesi![indexPath.row].fax!)
        let websiteAttributedTitle = NSAttributedString(string: "Website: \(favorilerListesi![indexPath.row].website!)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        cell.webSiteButton.setAttributedTitle(websiteAttributedTitle, for: .normal)
        cell.lblRector.attributedText = InnerTableManager.setAttributeString(title: "Rektör: ", data: favorilerListesi![indexPath.row].rector!)
        cell.lblEmail.attributedText = InnerTableManager.setAttributeString(title: "Email: ", data: favorilerListesi![indexPath.row].email!)
        cell.lblAdres.attributedText = InnerTableManager.setAttributeString(title: "Adres: ", data: favorilerListesi![indexPath.row].adress!)
        cell.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        return cell
    }
    
    
}
