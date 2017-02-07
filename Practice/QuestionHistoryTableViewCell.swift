//
//  QuestionHistoryTableViewCell.swift
//  Practice
//
//  Created by 新龙科技 on 2017/2/7.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class QuestionHistoryTableViewCell: UITableViewCell {


    @IBOutlet weak var Content: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var Hcontent: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
