//
//  TeacherCell.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/16.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit

class TeacherCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
