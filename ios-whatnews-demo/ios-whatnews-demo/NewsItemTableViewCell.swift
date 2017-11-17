//
//  NewsItemTableViewCell.swift
//  ios-whatnews-demo
//
//  Created by lorilalonde on 2017-11-16.
//  Copyright © 2017 Lori Lalonde. All rights reserved.
//

import UIKit

class NewsItemTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
