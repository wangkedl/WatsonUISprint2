//
//  Goods.swift
//  WatsonMobileUI
//
//  Created by ibmuser on 16/7/12.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import Foundation

class Goods: NSObject {
    
    var id:String = ""
    var name:String = ""
    var price:String = ""
    var newPrice:String = ""
    var details:String = ""
    var imgurl:String = ""
    
    
    // 商品购买个数,默认0
    var count: Int = 1
    // 是否选中，默认没有选中
    var selected: Bool = true
    // 是否已经加入购物车
    var alreadyAddShoppingCart: Bool = false

    
    init(id:String, name:String, price:String, details:String, imgurl:String)
    {
        self.id = id
        self.name = name
        self.price = price
        self.details = details
        self.imgurl = imgurl
        self.newPrice = (price as NSString).substringFromIndex(1).stringByReplacingOccurrencesOfString(",", withString: "")
    }
    
    // 字典转模型
    init(dict: [String : AnyObject]) {
        super.init()
        
        // 使用kvo为当前对象属性设置值
        setValuesForKeysWithDictionary(dict)
    }
    
    // 防止对象属性和kvc时的dict的key不匹配而崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}

}
