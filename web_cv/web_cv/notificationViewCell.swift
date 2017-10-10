//
//  blogViewCell.swift
//  cv_web
//
//  Created by rouibah on 04/10/2017.
//  Copyright © 2017 rouibah. All rights reserved.
//

import UIKit

class notificationViewCell: UITableViewCell {
    
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var jour_label: UILabel!
    @IBOutlet weak var notification_label: UILabel!
    
    

  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
