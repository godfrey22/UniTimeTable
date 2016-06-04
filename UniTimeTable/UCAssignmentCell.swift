//
//  UCAssignmentCell.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/6/4.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit

class UCAssignmentCell: UITableViewCell {

    @IBOutlet var courseCode: UILabel!
    @IBOutlet var dueDate: UILabel!
    @IBOutlet var percentage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
