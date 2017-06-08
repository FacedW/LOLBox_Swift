//
//  LOLNewsCell.swift
//  SwiftTest
//
//  Created by 吴鼎 on 2017/6/1.
//  Copyright © 2017年 吴鼎. All rights reserved.
//

import UIKit

class LOLNewsCell: UITableViewCell {

    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    
    var model:NewestScrollImageModel?{
        didSet{
            imageV.kf_setImageWithURL(NSURL(string: model!.image_url_small!))
            titleL.text = model!.title
            contentL.text = model!.summary
            let rang = Range<String.Index>(start: (model!.publication_date?.startIndex.advancedBy(5))!, end: (model!.publication_date?.startIndex.advancedBy(10))!)
            timeL.text = model!.publication_date?.substringWithRange(rang)
        }
    }
    
    
}
