//
//  TableViewGoodsCell.swift
//  WatsonMobileUI
//
//  Created by ibmuser on 16/7/6.
//  Copyright © 2016年. All rights reserved.
//

import UIKit

class TableViewGoodsCell: UITableViewCell {
    
    init(data:MessageItem, reuseIdentifier cellId:String)
    {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier:cellId)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        //设置加载中图片
        if (self.imageView?.image == nil) {
            self.imageView?.image = UIImage(named :"loading110")
            self.imageView?.frame = CGRectMake(20,2,85,55)
            self.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        }
        super.layoutSubviews()
        
    }
    
    
    // 让单元格宽度始终为屏幕宽
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.size.width = UIScreen.mainScreen().bounds.width
            super.frame = CGRectMake(frame.origin.x+50,frame.origin.y,frame.width-100, frame.height)
        }
    }
    
}
