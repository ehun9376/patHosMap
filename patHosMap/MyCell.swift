//
//  MyCell.swift
//  patHosMap
//
//  Created by 123 on 2020/7/22.
//  Copyright © 2020 陳逸煌. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell
{

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgPicture: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        //<方法二>取大頭照圓角
        imgPicture.clipsToBounds = true
        imgPicture.contentMode = .scaleAspectFill
        imgPicture.layer.cornerRadius = imgPicture.bounds.size.width / 2

    }

    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
