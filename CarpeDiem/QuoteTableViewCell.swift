//
//  QuoteTableViewCell.swift
//  CarpeDiem
//
//  Created by Eric Mao on 2/12/17.
//  Copyright © 2017 Eric Mao. All rights reserved.
//

import UIKit

class QuoteTableViewCell: UITableViewCell {
    
    //MARK: Properties
    /* Old labels
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
     */
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
