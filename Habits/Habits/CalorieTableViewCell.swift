//
//  CalorieTableViewCell.swift
//  Habits
//
//  Created by Agil Madinali on 9/28/20.
//

import UIKit

class CalorieTableViewCell: UITableViewCell {

    @IBOutlet weak var calorieRangeLabel: UILabel!
    
    static var identifier = "CalorieTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
