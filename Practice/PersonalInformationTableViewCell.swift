//
//  PersonalInformationTableViewCell.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/4.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class PersonalInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var Personalimg: UIImageView!
    @IBOutlet weak var Personaltitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
