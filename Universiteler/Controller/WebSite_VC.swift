//
//  WebSite_VC.swift
//  Universiteler
//
//  Created by Samet Korkmaz on 30.03.2024.
//

import UIKit
import WebKit

class WebSite_VC: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var UniAdiBaslik: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var urlString: String?
    var uniAdi: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
 
        UniAdiBaslik.text = uniAdi
        webView.navigationDelegate = self
        
        if let urlString = urlString, let url = URL(string: urlString) {
                    let request = URLRequest(url: url)
                    webView.load(request)
                }
    }
    
    
    // Geldiğin sayfaya dönmek için
    @IBAction func WebSiteGeri_BTN(_ sender: Any) {
        dismiss(animated: true)
    }
    

}
