//
//  RepositoryCell.swift
//  RxExample-1
//
//  Created by Giang Le Ngoc on 2/27/18.
//  Copyright © 2018 Giang Le Ngoc. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    
    
    func setName(_ name: String) {
        nameLabel.text = name
    }
    
    func setDescription(_ description: String) {
        descriptionLabel.text = description
    }
    
    func setStarsCount(_ starsCount: String) {
        starsCountLabel.text = starsCount
    }
    
}

