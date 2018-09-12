//
//  LoadingCell.swift
//  CampaignBrowser
//
//  Created by Kuba Sokolowski on 12/09/2018.
//  Copyright © 2018 Westwing GmbH. All rights reserved.
//

import UIKit

final class LoadingCell: UICollectionViewCell {
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.startAnimating()
    }
}
