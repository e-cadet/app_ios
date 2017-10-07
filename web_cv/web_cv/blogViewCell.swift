//
//  blogViewCell.swift
//  cv_web
//
//  Created by rouibah on 04/10/2017.
//  Copyright © 2017 rouibah. All rights reserved.
//

import UIKit

class blogViewCell: UITableViewCell {
    
    @IBOutlet weak var indicateur: UIActivityIndicatorView!
   
    @IBOutlet weak var jour: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    

//============================================= fin de code ==============================================
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
