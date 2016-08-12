//
//  JFShoppingCartCell.swift
//  shoppingCart
//
//  Created by liuke on 2016/08/08.
//  Copyright © 2016. All rights reserved.
//

import UIKit

protocol JFShoppingCartCellDelegate: NSObjectProtocol {
    
    func shoppingCartCell(cell: JFShoppingCartCell, button: UIButton, countLabel: UILabel)
    
    func reCalculateTotalPrice()
}

class JFShoppingCartCell: UITableViewCell {
    
    // MARK: - 属性
    /// 商品模型
    var goodModel: Goods? {
        didSet {
            
            // 选中状态
            selectButton.selected = goodModel!.selected
            
            goodCountLabel.text = "\(goodModel!.count)"
            
            if let iconName = goodModel?.imgurl {
                
                //iconView.image = UIImage(named: iconName)
                
                //图片
                let thumbQueue = NSOperationQueue()
                let request = NSURLRequest(URL:NSURL.init(string: iconName)!)
                NSURLConnection.sendAsynchronousRequest(request, queue: thumbQueue, completionHandler: { response, data, error in
                    if (error != nil) {
                        print(error)
                        
                    } else {
                        let image = UIImage.init(data :data!)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.iconView.image = image
                            
                        })
                    }
                })

                
            }
            
            if let title = goodModel?.name {
                titleLabel.text = title
            }
            
            if let newPrice = goodModel?.price {
                newPriceLabel.text = newPrice
            }
            
            // 重新布局，会更新frame
            layoutIfNeeded()
            
        }
    }
    
    /// 代理属性
    weak var delegate: JFShoppingCartCellDelegate?
    
    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 准备UI
        prepareUI()
    }
    
    /**
     准备UI
     */
    private func prepareUI() {
        
        // 添加子控件
        contentView.addSubview(selectButton)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(newPriceLabel)
        contentView.addSubview(horizontalLine)
        contentView.addSubview(addAndsubtraction)
        addAndsubtraction.addSubview(subtractionButton)
        addAndsubtraction.addSubview(goodCountLabel)
        addAndsubtraction.addSubview(addButton)
        
        // 约束子控件
        selectButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(5)
            make.centerY.equalTo(contentView.snp_centerY)
        }
        
        iconView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(30)
            make.top.equalTo(5)
            make.width.equalTo(100)
            make.height.equalTo(70)
        }
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp_top).offset(10)
            make.left.equalTo(iconView.snp_right).offset(5)
            make.width.equalTo(contentView.snp_width).offset(-140)
        }

        newPriceLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp_top).offset(30)
            make.right.equalTo(-12)
        }

        horizontalLine.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(78)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(0.4)
        }
        
        addAndsubtraction.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(132)
            make.top.equalTo(40)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        subtractionButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        goodCountLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(30)
            make.top.equalTo(0)
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
        
        addButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(70)
            make.top.equalTo(0)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
    }
    
    // MARK: - 响应事件
    /**
    被点击的按钮，tag10 减   tag11 加
    
    - parameter button: 按钮
    */
    @objc private func didTappedCalculateButton(button: UIButton) {
        delegate?.shoppingCartCell(self, button: button, countLabel: goodCountLabel)
    }
    
    /**
     选中了按钮后触发
     
     - parameter button: 被选中的按钮
     */
    @objc private func didSelectedButton(button: UIButton) {
        
        // 选中
        button.selected = !button.selected
        goodModel?.selected = button.selected
        
        // 重新计算价格
        delegate?.reCalculateTotalPrice()
    }
    
    // MARK: - 懒加载
    /// 选择按钮
    private lazy var selectButton: UIButton = {
        let selectButton = UIButton(type: UIButtonType.Custom)
        selectButton.setImage(UIImage(named: "check_n"), forState: UIControlState.Normal)
        selectButton.setImage(UIImage(named: "check_y"), forState: UIControlState.Selected)
        selectButton.addTarget(self, action: #selector(JFShoppingCartCell.didSelectedButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        selectButton.sizeToFit()
        return selectButton
    }()
    
    /// 商品图片
    private lazy var iconView: UIImageView = {
        //let iconView = UIImageView()
        let loadImage = UIImage(named:"loading110.png")!
        let iconView = UIImageView(image:loadImage);
        iconView.layer.cornerRadius = 5
        iconView.layer.masksToBounds = true
        return iconView
    }()
    
    /// 商品标题
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.adjustsFontSizeToFitWidth=true //自适应宽度
        return titleLabel
    }()
    
    /// 新价格标签
    private lazy var newPriceLabel: UILabel = {
        let newPriceLabel = UILabel()
        newPriceLabel.textColor = UIColor.redColor()
        return newPriceLabel
    }()
    
    // 加减操作的view
    private lazy var addAndsubtraction: UIView = {
        let addAndsubtraction = UIView()
        addAndsubtraction.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        return addAndsubtraction
    }()
    
    // 减号按钮
    private lazy var subtractionButton: UIButton = {
        let subtractionButton = UIButton(type: UIButtonType.Custom)
        subtractionButton.tag = 10;
        subtractionButton.setBackgroundImage(UIImage(named: "jian_icon"), forState: UIControlState.Normal)
        subtractionButton.addTarget(self, action: #selector(JFShoppingCartCell.didTappedCalculateButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return subtractionButton
    }()
    
    // 显示数量lbael
    private lazy var goodCountLabel: UILabel = {
        let goodCountLabel = UILabel()
        goodCountLabel.textAlignment = NSTextAlignment.Center
        return goodCountLabel
    }()
    
    // 加号按钮
    private lazy var addButton: UIButton = {
        let addButton = UIButton(type: UIButtonType.Custom)
        addButton.tag = 11
        addButton.setBackgroundImage(UIImage(named: "add_icon"), forState: UIControlState.Normal)
        addButton.addTarget(self, action: #selector(JFShoppingCartCell.didTappedCalculateButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return addButton
    }()
    
    //横线
    private lazy var horizontalLine:UIView = {
        
        let horizontalLine = UIView()
        horizontalLine.backgroundColor = UIColor.grayColor()
        return horizontalLine
    }()
    
}