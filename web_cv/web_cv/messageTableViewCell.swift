//
//  messageTableViewCell.swift
//  Mysql_php
//
//  Created by rouibah on 04/10/2017.
//  Copyright © 2017 rouibah. All rights reserved.
//

import UIKit

class messageTableViewCell: UITableViewCell {
    
    
    
    
    
    

  
    @IBOutlet weak var message_label: UILabel!
    @IBOutlet weak var heure_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var tel_label: UILabel!
    @IBOutlet weak var email_label: UILabel!
    @IBOutlet weak var IP_label: UILabel!
    @IBOutlet weak var nom_label: UILabel!
    
    
    
//============================================= fin de code ==============================================
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
