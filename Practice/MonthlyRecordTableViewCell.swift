//
//  MonthlyRecordTableViewCell.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/9.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class MonthlyRecordTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
