//
//  SignInRecordTableViewCell.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/7.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class SignInRecordTableViewCell: UITableViewCell {
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var address: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
