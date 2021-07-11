//
//  HomeCellViewTableViewCell.swift
//  BeMobile
//
//  Created by pblancoh on 7/7/21.
//

import UIKit

class HomeCellView: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet var skuLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var moneyImage: UIImageView!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        skuLabel.textColor = .red
        amountLabel.textColor = .blue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
