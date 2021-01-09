//
//  PortfolioTableViewCell.swift
//  workshopAmu
//
//  Created by Bojana Kuzeva on 1/8/21.
//  Copyright © 2021 Bojana Kuzeva. All rights reserved.
//

import UIKit

class PortfolioTableViewCell: UITableViewCell {

    @IBOutlet weak var zavrsenaRabotaSlika: UIImageView!
    
    @IBOutlet weak var datumZavrsuvanje: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
