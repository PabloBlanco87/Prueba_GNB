//
//  DetailCellView.swift
//  BeMobile
//
//  Created by pblancoh on 10/7/21.
//

import UIKit

class DetailCellView: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet var labelText: UILabel!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
