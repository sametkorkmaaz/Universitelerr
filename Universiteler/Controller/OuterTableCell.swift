//
//  OuterTableCell.swift
//  Universiteler
//
//  Created by Samet Korkmaz on 2.04.2024.
//

import UIKit

class OuterTableCell: UITableViewCell{
    
    var delegate: InnerTableViewCellDelegate? // web site
    var delegate2: InnerTableViewCellDelegate2? // favorilere ekleme
    var delegate3: InnerTableViewCellDelegate3? // ana sayfadan favoriden çıkarma
    var helperDelegate: HelperDelegate?
    
    @IBOutlet weak var paddingView: UIView!
    @IBOutlet weak var verticalLineView: UIView!
    @IBOutlet weak var innerTableView: UITableView!
    @IBOutlet weak var lblSchoolName: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var stackView: UIStackView! {
        didSet {
            stackView.layer.cornerRadius = 8
            stackView.layer.borderWidth = 1
        }
    }
    
    var index = Int()

    var sehirData: SehirData? = nil {
        didSet {
            if let _sehirData = sehirData {
                innerTableView.isHidden = !_sehirData.isExpanded
                lblSchoolName.text = _sehirData.cityName
                verticalLineView.isHidden = _sehirData.isExpanded ? false : true
                innerTableView.dataSource = self
                innerTableView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        addTapEvent()
        // Initialization code
    }

    func addTapEvent() {
        let panGesture = UITapGestureRecognizer(target: self, action: #selector(handleActon))
        headerView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handleActon() {
        guard let isExpanded = sehirData?.isExpanded else {
            print("isExpanded variable not initialized")
            return
        }
        innerTableView.isHidden = isExpanded
        paddingView.isHidden = isExpanded
        verticalLineView.isHidden = isExpanded
        UIView.animate(withDuration: 0.3) {
            self.stackView.setNeedsLayout()
            self.helperDelegate?.heightChanged(index: self.index, value: !isExpanded)
        }
        sehirData?.isExpanded = !isExpanded
    }

}
// Dış tableViewın satır işlemlerini yapan protokoller
extension OuterTableCell: UITableViewDataSource {
    // Şehirlerin altındaki üniversite sayılarına göre satır sayısı
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sehirData?.universiteDetayData.count ?? 0
    }
    // Satırlara InnerTableCell atama
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InnerTableCell", for: indexPath) as? InnerTableCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.delegate2 = self
        cell.delegate3 = self
        cell.universiteDetayData = sehirData?.universiteDetayData[indexPath.row]
        if let count = sehirData?.universiteDetayData.count {
            cell.verticalBottomLineView.isHidden = count - 1 == indexPath.row ? true : false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.invalidateIntrinsicContentSize()
        tableView.layoutIfNeeded()
    }
    
}

// EN İÇTEKİ TABLEVİEW ile ViewContoller arasında köprü olan protokoller
extension OuterTableCell : InnerTableViewCellDelegate {
    func websiteButtonPressed(withURL urlString: String, andUniAdi uniAdi: String) {
        delegate?.websiteButtonPressed(withURL: urlString, andUniAdi: uniAdi)
    }
}
extension OuterTableCell : InnerTableViewCellDelegate2 {
    func addToFavoritesButtonPressed(withUniversityData universityData: UniversiteDetayData) {
        delegate2?.addToFavoritesButtonPressed(withUniversityData: universityData)
    }
}
extension OuterTableCell : InnerTableViewCellDelegate3 {
    func removeToFavoritesButtonPressed(withUniversityData universityData: UniversiteDetayData) {
        delegate3?.removeToFavoritesButtonPressed(withUniversityData: universityData)
    }
}
