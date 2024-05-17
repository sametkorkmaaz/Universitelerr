//
//  Extension.swift
//  Universiteler
//
//  Created by Samet Korkmaz on 2.04.2024.
//

import UIKit

extension UITableView {
    
    public override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return contentSize
    }
    
    public override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
}
