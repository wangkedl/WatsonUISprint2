//
//  TableViewItemCell.swift
//  WatsonMobileUI
//
//  Created by ibmuser on 16/7/8.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit

class TableViewWrapLineCell: UITableViewCell {
    
    var msgItem:MessageItem!
    
    init(reuseIdentifier cellId:String)
    {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // 设定单元格高度宽度
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            super.frame = CGRectMake(newFrame.origin.x, newFrame.origin.y,newFrame.width, 10)
        }
    }
    
}
