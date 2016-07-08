import UIKit

enum ChatBubbleTypingType
{
    case Nobody
    case Me
    case Somebody
}

class TableView:UITableView,UITableViewDelegate, UITableViewDataSource
{
    
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
    
    // 按日期排序方法
    func sortDate(m1: AnyObject!, m2: AnyObject!) -> NSComparisonResult {
        if((m1 as! MessageItem).date.timeIntervalSince1970 < (m2 as! MessageItem).date.timeIntervalSince1970)
        {
            return NSComparisonResult.OrderedAscending
        }
        else
        {
            return NSComparisonResult.OrderedDescending
        }
    }
    
    // 重新刷新TableView
    override func reloadData()
    {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bubbleSection = NSMutableArray()
        var count =  0
        if ((self.chatDataSource != nil))
        {
            count = self.chatDataSource.rowsForChatTable(self)
            if(count > 0)
            {
                let bubbleData =  NSMutableArray(capacity:count)
                for i in 0..<count{
                    let object =  self.chatDataSource.chatTableView(self, dataForRow:i)
                    bubbleData.addObject(object)
                }
                bubbleData.sortUsingComparator(sortDate)
                var last =  ""
                var currentSection = NSMutableArray()
                // 创建一个日期格式器
                let dformatter = NSDateFormatter()
                // 为日期格式器设置格式字符串
                dformatter.dateFormat = "dd"
                
                for i in 0..<count{
                    let data =  bubbleData[i] as! MessageItem
                    // 使用日期格式器格式化日期，日期不同，就新分组
                    let datestr = dformatter.stringFromDate(data.date)
                    if (datestr != last)
                    {
                        currentSection = NSMutableArray()
                        self.bubbleSection.addObject(currentSection)
                    }
                    self.bubbleSection[self.bubbleSection.count-1].addObject(data)
                    
                    last = datestr
                }
            }
        }
        super.reloadData()
        
        // 滑向最后一部分
        let secno = self.bubbleSection.count - 1
        let indexPath =  NSIndexPath(forRow:self.bubbleSection[secno].count,inSection:secno)
        self.scrollToRowAtIndexPath(indexPath, atScrollPosition:UITableViewScrollPosition.Bottom,animated:true)
    }
    
    func numberOfSectionsInTableView(tableView:UITableView)->Int
    {
        var result = self.bubbleSection.count
        if (self.typingBubble != ChatBubbleTypingType.Nobody)
        {
            result += 1;
        }
        return result;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if (section >= self.bubbleSection.count)
        {
            return 1
        }
        
        return self.bubbleSection[section].count+1
    }
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat
    {
        if (indexPath.row == 0)
        {
            return TableHeaderViewCell.getHeight()
        }
        let section  =  self.bubbleSection[indexPath.section] as! NSMutableArray
        let data = section[indexPath.row - 1]
        
        let item =  data as! MessageItem
        var height:CGFloat = 40
        if(item.mtype == ChatType.Mine ||  item.mtype == ChatType.Someone){
            height  = item.insets.top + max(item.view.frame.size.height, 52) + item.insets.bottom
        }
        return height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // 创建HeaderCell
        if (indexPath.row == 0)
        {
            let cellId = "HeaderCell"
            let hcell =  TableHeaderViewCell(reuseIdentifier:cellId)
            let section =  self.bubbleSection[indexPath.section] as! NSMutableArray
            let data = section[indexPath.row] as! MessageItem
            
            hcell.setDate(data.date)
            hcell.backgroundColor = UIColor.clearColor()
            return hcell
        }
        let section = self.bubbleSection[indexPath.section] as! NSMutableArray
        let data = section[indexPath.row - 1] as! MessageItem
        
        // 标准聊天Cell
        if(data.mtype == ChatType.Mine ||  data.mtype == ChatType.Someone){
            let cellId = "ChatCell"
            let cell = TableViewCell(data:data, reuseIdentifier:cellId)
            cell.backgroundColor = UIColor.clearColor()
            return cell
        }
        // 标准选择一览Cell
        else if(data.mtype == ChatType.ItemList){
            let cellId = "ItemCell"
            let cell = TableViewItemCell(data:data, reuseIdentifier: cellId)
            return cell
        // 标准商品一览Cell
        }else{
            let cellId = "ChatCell"
            let cell = TableViewGoodsCell(data:data, reuseIdentifier: cellId)
            cell.backgroundColor = UIColor.whiteColor()
            cell.layer.borderWidth = 1
            cell.contentView.alpha = 0.6
            cell.layer.borderColor = UIColor.lightGrayColor().CGColor
            cell.contentView.frame = CGRectMake(50, 50, 50, 30)
            cell.textLabel!.text = "tetst"
            cell.imageView?.image = UIImage(named: "pictures")
            return cell
        }
        
    }
}
