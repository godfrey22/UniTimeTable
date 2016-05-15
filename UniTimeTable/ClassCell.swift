//
//  ClassCell.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/15.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit

class ClassCell: UITableViewCell {

    
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var teacherLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var weekLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
