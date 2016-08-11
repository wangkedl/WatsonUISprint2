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
    var showAddGoodButton:Bool = true
    
    var delegate : RegisterDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let data = Goods.init(id: "15", name: "CITIZEN TITANIA LINE HAPPY FLIGHT", price: "¥575,000", details: "Citizen Watch Xc Happy Flight Titania Line Eco-drive Eco-drive Type Display Type Needle Receiving Station Multi-radio Clock Kitagawa Keiko Ad Wearing Model Media Model Ec1044-55w Women", imgurl: "http://fs.scene7.com/is/image/flagshop/v_243815_01.jpg?$500$")
        
        print("detailviewcontroller load.")
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        let mainView = UIView(frame:CGRectMake(0, 0, screenWidth, screenHeight))
        mainView.backgroundColor = UIColor.whiteColor()
        
        //背景图片
        self.view.backgroundColor = UIColor.whiteColor()
 
        //图片
        let thumbQueue = NSOperationQueue()
        let newImage = UIImage(named:"loading110.png")!
        let iconImageView = UIImageView(image:newImage);
        iconImageView.frame = CGRectMake(50, 20, self.view.frame.size.width-100, 240)
        
        let request = NSURLRequest(URL:NSURL.init(string: data!.imgurl)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: thumbQueue, completionHandler: { response, data, error in
            if (error != nil) {
                print(error)
                
            } else {
                let image = UIImage.init(data :data!)
                dispatch_async(dispatch_get_main_queue(), {
                    iconImageView.image = image
                    iconImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 280)
                    
                })
            }
        })
        
        iconImageView.contentMode = UIViewContentMode.ScaleAspectFit
        mainView.addSubview(iconImageView)

        //商品名称
        let imgHight:CGFloat = 280
        let labelName: UILabel = UILabel()
        labelName.frame = CGRect(x:5, y:imgHight, width:(self.view.frame.size.width-10)*0.7, height:30)
        labelName.text = data!.name
        labelName.font = UIFont(name:"HelveticaNeue", size:20)
        labelName.textAlignment = NSTextAlignment.Center
        labelName.adjustsFontSizeToFitWidth=true //自适应宽度
        mainView.addSubview(labelName)
        
        //价格
        let labelPrice: UILabel = UILabel()
        labelPrice.frame = CGRect(x:(self.view.frame.size.width-10)*0.7, y:imgHight+25, width:(self.view.frame.size.width-10)*0.3, height:40)
        labelPrice.text = data!.price
        labelPrice.textAlignment = NSTextAlignment.Center
        labelPrice.highlighted = true
        labelPrice.font = UIFont(name:"HelveticaNeue", size:25)
        labelPrice.adjustsFontSizeToFitWidth=true //自适应宽度
        //labelPrice.backgroundColor = UIColor.orangeColor()
        labelPrice.textColor=UIColor.redColor()
        mainView.addSubview(labelPrice)
        
        //商品详细
        let labelDetail: UILabel = UILabel()
        labelDetail.frame = CGRect(x:5, y:imgHight+30, width:(self.view.frame.size.width-10)*0.7, height:60)
        labelDetail.text = data!.details
        labelDetail.backgroundColor = UIColor.whiteColor()
        labelDetail.textAlignment = NSTextAlignment.Left
        labelDetail.font = UIFont(name:"HelveticaNeue", size:15)
        
        labelDetail.adjustsFontSizeToFitWidth=true //自适应宽度
        labelDetail.numberOfLines=0     //多行显示
        mainView.addSubview(labelDetail)
        
        //竖线
        let verticalLine = UIView()
        verticalLine.frame = CGRect(x:10+(self.view.frame.size.width-10)*0.7, y:imgHight+25, width:1, height:60)
        verticalLine.backgroundColor = UIColor.grayColor()
        mainView.addSubview(verticalLine)
        
        /*
        //横线
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
        
        let txtLocation: UILabel = UILabel()
        txtLocation.frame = CGRect(x:5, y:imgHight+95, width:(self.view.frame.size.width-10), height:20)
        txtLocation.text = "Please follow the map of below to find this goods."
        txtLocation.backgroundColor = UIColor.whiteColor()
        txtLocation.textAlignment = NSTextAlignment.Left
        txtLocation.font = UIFont(name:"HelveticaNeue", size:15)
        mainView.addSubview(txtLocation)
        
        //地图
        let mapImage:UIImage  = UIImage(named:"floor_map.png")!
        let mapImageView:UIImageView = UIImageView(image:mapImage)
        mapImageView.frame = CGRectMake(20, imgHight+120, self.view.frame.size.width-40, 280)
        mapImageView.contentMode = UIViewContentMode.ScaleAspectFit
        mainView.addSubview(mapImageView)
        
        //制定位置图片
        let locationImage:UIImage  = UIImage(named:"google_map.png")!
        let locationImageView:UIImageView = UIImageView(image:locationImage)
        locationImageView.frame = CGRectMake(95, imgHight+150, 50, 50)
        locationImageView.contentMode = UIViewContentMode.ScaleAspectFit
        mainView.addSubview(locationImageView)
        
        
        let backImageButton = UIButton(frame:CGRectMake(50,imgHight+410,120,35))
        
        backImageButton.backgroundColor = UIColor.blueColor()
        backImageButton.setTitle("Back", forState:UIControlState.Normal)
        backImageButton.layer.cornerRadius = 5   //圆角
        backImageButton.alpha = 0.4
        //backImageButton.setImage(UIImage(named:"arrow180"),forState:UIControlState.Normal)
        backImageButton.addTarget(self, action:#selector(DetailViewController.backToPrevious) ,
                                  forControlEvents:UIControlEvents.TouchUpInside)
        

        mainView.addSubview(backImageButton)
        
        if self.showAddGoodButton == true {
            //创建加入购物车按钮
            let button:UIButton = UIButton(frame:CGRectMake(180, imgHight+410, 180, 35))
            //设置按钮文字
            button.backgroundColor = UIColor.purpleColor()
            button.setTitle("Add to shopCat", forState:UIControlState.Normal)
            button.layer.cornerRadius = 5   //圆角
            button.alpha = 0.6
            button.addTarget(self,action:#selector(tapped(_:)),forControlEvents:.TouchUpInside)
            mainView.addSubview(button)
            
        } else {
            //返回按钮居中表示
            backImageButton.frame.origin.x = (self.view.frame.size.width - 120) / 2
        }
        
        self.view.addSubview(mainView)
        
    }
    
    //隐藏顶部状态栏
    override func prefersStatusBarHidden()->Bool{
        return true
    }
    
    //加入购物车事件
    func tapped(button:UIButton){
        print("tapped")
        
        let addGood:Goods = Goods.init(id:data!.id, name: data!.name, price: data!.price, details: data!.details, imgurl: data!.imgurl)
        //购物车追加
        self.delegate!.registerName(addGood)
        self.dismissViewControllerAnimated( true, completion : nil )
    }
    
    //返回按钮
    func backToPrevious() {
        //print("点击了返回键")
        self.dismissViewControllerAnimated( true, completion : nil )
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
   }