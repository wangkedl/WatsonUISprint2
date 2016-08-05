//
//  DetailViewController.swift
//  WatsonMobileUI
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UIViewController {
    var data:Goods?
    var mainView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let data = Goods.init(id: "15", name: "CITIZEN TITANIA LINE HAPPY FLIGHT", price: "¥575,000", details: "Citizen Watch Xc Happy Flight Titania Line Eco-drive Eco-drive Type Display Type Needle Receiving Station Multi-radio Clock Kitagawa Keiko Ad Wearing Model Media Model Ec1044-55w Women", imgurl: "http://fs.scene7.com/is/image/flagshop/v_243815_01.jpg?$500$")
        
        print("detailviewcontroller load.")
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        let mainView = UIView(frame:CGRectMake(0, 0, screenWidth, screenHeight))
        mainView.backgroundColor = UIColor.whiteColor()
        //mainView.alpha = 0
        
        //背景图片
        self.view.backgroundColor = UIColor.whiteColor()
        
        /*
        //返回按钮
        self.navigationItem.setHidesBackButton(true, animated: false)
        let leftBarBtn = UIBarButtonItem(title: "Back", style: .Plain, target: self,
                                         action: #selector(DetailViewController.backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        */
 
        //定义NSURL对象
        let url = NSURL(string: data!.imgurl)
        //从网络获取数据流
        let urlData = NSData(contentsOfURL: url!)
        //通过数据流初始化图片
        let newImage = UIImage(data: urlData!)
        let imageView = UIImageView(image:newImage);
        //imageView.frame.origin = CGPoint(x: 0, y: 0)
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 280)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        mainView.addSubview(imageView)
        
        
        let backImageButton = UIButton(frame:CGRectMake(5,5,35,35))
        backImageButton.alpha = 0.5
        backImageButton.addTarget(self, action:#selector(DetailViewController.backToPrevious) ,
                                   forControlEvents:UIControlEvents.TouchUpInside)
        backImageButton.setImage(UIImage(named:"arrow180"),forState:UIControlState.Normal)
        mainView.addSubview(backImageButton)

        
        let labelName: UILabel = UILabel()
        labelName.frame = CGRect(x:5, y:imageView.frame.height+10, width:(self.view.frame.size.width-10)*0.7, height:30)
        labelName.text = data!.name
        labelName.font = UIFont(name:"HelveticaNeue", size:20)
        labelName.textAlignment = NSTextAlignment.Center
        //labelName.backgroundColor = UIColor.cyanColor()
        labelName.adjustsFontSizeToFitWidth=true //自适应宽度
        //labelName.shadowColor=UIColor.grayColor()  //灰色阴影
        //labelName.shadowOffset=CGSizeMake(-2,2)  //阴影的偏移量
        mainView.addSubview(labelName)
        
        let labelPrice: UILabel = UILabel()
        labelPrice.frame = CGRect(x:(self.view.frame.size.width-10)*0.7, y:imageView.frame.height+25, width:(self.view.frame.size.width-10)*0.3, height:40)
        labelPrice.text = data!.price
        labelPrice.textAlignment = NSTextAlignment.Center
        labelPrice.highlighted = true
        labelPrice.font = UIFont(name:"HelveticaNeue", size:25)
        labelPrice.adjustsFontSizeToFitWidth=true //自适应宽度
        //labelPrice.backgroundColor = UIColor.orangeColor()
        labelPrice.textColor=UIColor.redColor()
        mainView.addSubview(labelPrice)
        
        
        let labelDetail: UILabel = UILabel()
        labelDetail.frame = CGRect(x:5, y:imageView.frame.height+40, width:(self.view.frame.size.width-10)*0.7, height:60)
        labelDetail.text = data!.details
        labelDetail.backgroundColor = UIColor.whiteColor()
        labelDetail.textAlignment = NSTextAlignment.Left
        labelDetail.font = UIFont(name:"HelveticaNeue", size:15)
        
        labelDetail.adjustsFontSizeToFitWidth=true //自适应宽度
        labelDetail.numberOfLines=0     //多行显示
        mainView.addSubview(labelDetail)
        
        let verticalLine = UIView()
        verticalLine.frame = CGRect(x:10+(self.view.frame.size.width-10)*0.7, y:imageView.frame.height+25, width:1, height:60)
        verticalLine.backgroundColor = UIColor.grayColor()
        mainView.addSubview(verticalLine)
        
        /*
        let horizontalLine = UIView()
        horizontalLine.frame = CGRect(x:5, y:imageView.frame.height+92, width:self.view.frame.size.width-10, height:1)
        horizontalLine.backgroundColor = UIColor.grayColor()
        mainView.addSubview(horizontalLine)
        */

        /*
        let turl = "http://www.100bangai.co.jp/wp-content/themes/twentyfifteen/images/floor_map_ant.png"
        
        //定义NSURL对象
        let mapUrl = NSURL(string: turl)
        //从网络获取数据流
        let mapUrlData = NSData(contentsOfURL: mapUrl!)
        //通过数据流初始化图片
        let mapImage = UIImage(data: mapUrlData!)
        let mapImageView = UIImageView(image:mapImage);
        */
        
        let mapImage:UIImage  = UIImage(named:"floor_map.png")!
        let mapImageView:UIImageView = UIImageView(image:mapImage)
        mapImageView.frame = CGRectMake(50, imageView.frame.height+130, self.view.frame.size.width-100, 200)
        mapImageView.contentMode = UIViewContentMode.ScaleAspectFit
        mainView.addSubview(mapImageView)
        
        //创建一个ContactAdd类型的按钮
        let button:UIButton = UIButton(type:.System)
        //设置按钮位置和大小
        button.frame=CGRectMake(self.view.frame.width/2 - 100, imageView.frame.height+360, 200, 30)
        //设置按钮文字
        button.backgroundColor = UIColor.groupTableViewBackgroundColor()
        button.setTitle("Add to shopCat", forState:UIControlState.Normal)
        button.layer.cornerRadius = 5   //圆角
        button.setTitleShadowColor(UIColor.blackColor(), forState: UIControlState.Normal)   //text阴影
        button.addTarget(self,action:#selector(tapped(_:)),forControlEvents:.TouchUpInside)
        
        mainView.addSubview(button)
        
        self.view.addSubview(mainView)
        
    }
    
    override func prefersStatusBarHidden()->Bool{
        return true
    }
    
    func tapped(button:UIButton){
        print("tapped")
        self.dismissViewControllerAnimated( true, completion : nil )
    }
    
    func backToPrevious() {
        //print("点击了返回键")
        self.dismissViewControllerAnimated( true, completion : nil )
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
   }