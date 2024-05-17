//
//  InnerTableCell.swift
//  Universiteler
//
//  Created by Samet Korkmaz on 2.04.2024.
//

import UIKit
class InnerTableCell: UITableViewCell {
    
    weak var delegate: InnerTableViewCellDelegate? // ana sayfadan web site sayfasına
    weak var delegate2: InnerTableViewCellDelegate2? // ana sayfadan favorilere ekleme
    weak var delegate3: InnerTableViewCellDelegate3? // ana sayfadan favorilerden çıkarma
    
    @IBOutlet weak var webSiteButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton! //
    @IBOutlet weak var lblRector: UILabel!  //
    @IBOutlet weak var lblFax: UILabel! //
    @IBOutlet weak var verticalBottomLineView: UIView!
    @IBOutlet weak var lblAdres: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblUniAdi: UILabel! //
    
    @IBOutlet weak var detailView: UIView! {
        didSet {
            detailView.layer.cornerRadius = 8
            detailView.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var heartButton: UIButton!
    var isHeartFilled = false // Butonun dolu mu boş mu olduğunu izleyen değişken
    
    var universiteDetayData: UniversiteDetayData? = nil { // satırların içini doldurma
        didSet {
            lblUniAdi.attributedText = setAttributeString(title: "Üniversite: ", data: universiteDetayData?.uniAdi)
            phoneButton.setAttributedTitle(setAttributeString(title: "Phone: ", data: universiteDetayData?.phone), for: .normal)
            lblFax.attributedText = setAttributeString(title: "Fax: ", data: universiteDetayData?.fax)
            webSiteButton.setAttributedTitle(setAttributeString(title: "Website: ", data: universiteDetayData?.website), for: .normal)
            lblEmail.attributedText = setAttributeString(title: "Email: ", data: universiteDetayData?.email)
            lblAdres.attributedText = setAttributeString(title: "Adres: ", data: universiteDetayData?.adress)
            lblRector.attributedText = setAttributeString(title: "Rektör: ", data: universiteDetayData?.rector)
            
        }
    }
    func setAttributeString(title: String, data: String? = "") -> NSAttributedString {
        let fs: CGFloat = 14
        let titleAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fs, weight: .semibold)]
        let dataAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fs, weight: .regular)]
        
        let partOne = NSMutableAttributedString(string: title, attributes: titleAttribute)
        let partTwo = NSMutableAttributedString(string: data!, attributes: dataAttribute)
        
        let combination = NSMutableAttributedString()
        combination.append(partOne)
        combination.append(partTwo)
        return combination
    }
    
    @IBAction func heartButton(_ sender: Any) { // anasayfadan favorielre eklemek için
        if isHeartFilled {
            // Eğer kalp doluysa, dolu olmayan haline geri dön ve favorilerden sil
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            if let universityData = universiteDetayData {
                delegate3?.removeToFavoritesButtonPressed(withUniversityData: universityData)
            }
        } else {
            // Eğer kalp dolu değilse, dolu haline getir
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            if let universityData = universiteDetayData {
                delegate2?.addToFavoritesButtonPressed(withUniversityData: universityData)
            }
        }
        
        // Durumu tersine çevir
        isHeartFilled = !isHeartFilled

    }
    
    @IBAction func phoneButtonAction(_ sender: Any) { // anasayfadan telefon araması
        if let phone = universiteDetayData?.phone {
            let cleanedPhone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            let phoneNumber = "+90" + cleanedPhone
            print(phoneNumber)
            if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Telefon aramasını başlatma başarısız oldu
                print("Telefon aramasını başlatma başarısız oldu")
            }
        }
        
    }
    
    @IBAction func webSiteButtonAction(_ sender: Any) { // anasayfadan web sitesine gitmek için
        // Eğer website verisi "-" ise veya boş ise işlemi gerçekleştirme
        guard let urlString = universiteDetayData?.website, urlString != "-" && !urlString.isEmpty else {
            return
        }
        
        // Eğer website URL'i "www." ile başlıyorsa başına "https://" ekleyerek işlemi gerçekleştir
        var finalURLString = urlString
        if !finalURLString.hasPrefix("http://") && !finalURLString.hasPrefix("https://") {
            finalURLString = "https://" + finalURLString
        }
        print(finalURLString)
        // Değişikliklerden sonra, websiteButtonPressed fonksiyonunu çağır
        delegate?.websiteButtonPressed(withURL: finalURLString, andUniAdi: universiteDetayData?.uniAdi ?? "")
        
    }
}
