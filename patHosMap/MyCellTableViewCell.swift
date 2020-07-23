//
//  MyCellTableViewCell.swift
//  patHosMap
//
//  Created by 123 on 2020/7/22.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit

class MyCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgPicture: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgPicture.clipsToBounds = true
        imgPicture.contentMode = .scaleAspectFill
        imgPicture.layer.cornerRadius = imgPicture.bounds.size.width / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
