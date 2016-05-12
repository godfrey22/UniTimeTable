//
//  SemesterCell.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/9.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit

class SemesterCell: UITableViewCell {

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var numberOfClassesLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
