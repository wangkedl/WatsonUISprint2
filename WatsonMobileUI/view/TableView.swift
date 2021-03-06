import UIKit

enum ChatBubbleTypingType
{
    case Nobody
    case Me
    case Somebody
}

class TableView:UITableView,UITableViewDelegate, UITableViewDataSource
{
    
    var thumbQueue = NSOperationQueue()
    var bubbleSection:NSMutableArray!
    var chatDataSource:ChatDataSource!
    
    var  snapInterval:NSTimeInterval!
    var  typingBubble:ChatBubbleTypingType!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        self.snapInterval = 60 * 60 * 24;
        self.typingBubble = ChatBubbleTypingType.Nobody
        self.bubbleSection = NSMutableArray()
        
        super.init(frame:frame, style:style)
        self.backgroundColor = UIColor.clearColor()
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        self.delegate = self
        self.dataSource = self
    }
    
    // 重新刷新TableView
    override func reloadData()
    {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        super.reloadData()
        
        // 滑向最后一部分
        let row = self.chatDataSource.rowsForChatTable(self) - 1
        let indexPath =  NSIndexPath(forRow: row, inSection: 0)
        self.scrollToRowAtIndexPath(indexPath, atScrollPosition:UITableViewScrollPosition.Bottom,animated:true)
    }
    
    // 重新刷新TableView
    func reloadDataForWaitCell()
    {
        super.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView:UITableView)->Int
    {

        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        return self.chatDataSource.rowsForChatTable(self)

    }
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat
    {
        
        let item:MessageItem = self.chatDataSource.chatTableView(self, dataForRow:indexPath.row)
        var height:CGFloat = 40
        if(item.mtype == ChatType.Mine ||  item.mtype == ChatType.Someone){
            height  = item.insets!.top + max(item.view!.frame.size.height, 52) + item.insets!.bottom
        }else if(item.mtype == ChatType.wrapline){
            height = 20
        }else if(item.mtype == ChatType.GoodsList){
            height = 60
        }
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {

        let data:MessageItem = self.chatDataSource.chatTableView(self, dataForRow:indexPath.row)
        
        // 标准聊天Cell
        if(data.mtype == ChatType.Mine ||  data.mtype == ChatType.Someone){
            let cellId = "ChatCell"
            let cell = TableViewCell(data:data, reuseIdentifier:cellId)
            cell.backgroundColor = UIColor.clearColor()
            return cell
        }else if(data.mtype == ChatType.wrapline){
            let cellId = "wraplinecell"
            let cell = TableViewWrapLineCell(reuseIdentifier:cellId)
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        
        }
         // 标准商品一览Cell
        else{
            let cellId = "GoodsCell"
            let cell = TableViewGoodsCell(data:data, reuseIdentifier: cellId)
            
            let goods:Goods = data.goods!
            cell.backgroundColor = UIColor.whiteColor()
            cell.contentView.alpha = 0.9
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.lightGrayColor().CGColor
            
            cell.textLabel!.text = goods.name
            cell.detailTextLabel?.text = goods.price
            cell.detailTextLabel?.textColor = UIColor.blueColor()
            
            /*
            /// loadImage
            cell.imageView?.image = UIImage(named :"loading110")
            cell.imageView?.frame = CGRectMake(20,2,85,55)
            cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
            */
 
            let request = NSURLRequest(URL:NSURL.init(string: goods.imgurl)!)
            NSURLConnection.sendAsynchronousRequest(request, queue: thumbQueue, completionHandler: { response, data, error in
                if (error != nil) {
                    print(error)
                    
                } else {
                    let image = UIImage.init(data :data!)
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.imageView?.image = image
                    })
                }
            })
            
            return cell
        }
        
    }
    
    
    //选择一行
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        //print("goods Item selected")
        //tableView.delegate = self
        
        let data:MessageItem = self.chatDataSource.chatTableView(self, dataForRow:indexPath.row)
        if (data.goods != nil) {
            
            let detailView = DetailViewController()
            detailView.delegate = (self.window!.rootViewController) as! ViewController
            detailView.data = data.goods!
            
            self.window!.rootViewController!.presentViewController( detailView, animated: true, completion: nil )
        }

    }

}
