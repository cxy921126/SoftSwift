//
//  HomeTableViewCell.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/19.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit
import SDWebImage

let cellOfImageCollectionView = "cellOfImageCollectionView"
let cellOfRetweetedPicsView = "cellOfRetweetedPicsView"

class HomeTableViewCell: UITableViewCell{
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var screen_name: UILabel!
    @IBOutlet weak var weibo_text: UILabel!
    @IBOutlet weak var verified_image: UIImageView!
    @IBOutlet weak var creat_at: UILabel!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var retweetedWeiboView: UIView!
    @IBOutlet weak var retweetedViewHeight: NSLayoutConstraint!
    ///图片预览布局
    lazy var collectionViewLayout:ImageCollectionLayout = ImageCollectionLayout()
    lazy var retweetedPicsLayout:RetweetedPicsLayout = RetweetedPicsLayout()
    
    var status:Status?{
        didSet{
            //头像
            profile_image.sd_setImageWithURL(NSURL(string: (status!.user?.profile_image_url)!) , placeholderImage: UIImage(named: "placeholder"))
            //昵称
            screen_name.text = status!.user?.name
            //时间
            creat_at.text = status!.created_at
            //微博正文
            weibo_text.text = status!.text
            //计算配图view的高度
            ensureImageCollectionViewHeight()
            
            imagesCollectionView.reloadData()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if status?.pic_urls != nil {
            retweetedViewHeight.constant = 0
        }
        
        for subview in retweetedWeiboView.subviews{
            subview.removeFromSuperview()
        }
    }
    
    func ensureImageCollectionViewHeight(){
        
        let imageCount = status?.pic_urls?.count
        
        //根据图片数量调整整个配图view的高度
        switch imageCount{
        case let imageCount where imageCount == 0:
            viewHeight.constant = 0
            //存在转发微博则布局该转发微博
            if status?.retweeted_weibo != nil {
                //计算文本的高度，赋值给高度约束
                let textStr = (status?.retweeted_weibo?.text)! as NSString
                let attributesDic = [NSFontAttributeName:UIFont.systemFontOfSize(13)]
                let textHeight = textStr.boundingRectWithSize(CGSize(width: UIScreen.mainScreen().bounds.width - 30, height: 999), options: .UsesLineFragmentOrigin, attributes: attributesDic, context: nil).height
                //retweetedViewHeight.constant = textHeight + 136//36
                
                //设置转发微博
                setRetweetedWeibo({ (picsHeight) in
                    self.retweetedViewHeight.constant = textHeight + picsHeight + 36
                })
            }
            break
        case let imageCount where imageCount == 1:
            let url = status?.pic_urls?.first!["thumbnail_pic"] as! String
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(url)
            viewHeight.constant = image.size.height
            break
        case let imageCount where imageCount >= 2 && imageCount <= 3:
            viewHeight.constant = 60//itemHeight + 5
            break
        case let imageCount where imageCount >= 4 && imageCount <= 6:
            viewHeight.constant = 130//itemHeight * 2 + 20
            break
        case let imageCount where imageCount >= 7 && imageCount <= 9:
            viewHeight.constant = 210//itemHeight * 3 + 30
            break
        default:
            viewHeight.constant = 0
            break
        }
        
    }
    
    //MARK: - 布局转发微博
    func setRetweetedWeibo(finished:(picsHeight:CGFloat)->()){
        ///转发的用户名
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFontOfSize(13)
        nameLabel.text = "@\((status?.retweeted_weibo?.user?.name)!):" ?? ""
        retweetedWeiboView.addSubview(nameLabel)
        ///转发的正文
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFontOfSize(13)
        textLabel.text = "\((status?.retweeted_weibo?.text)!)"
        retweetedWeiboView.addSubview(textLabel)
        
        //转发图片的配置
        let picCount = status?.retweeted_weibo?.pic_urls?.count
        var height:CGFloat = 0
        switch  picCount{
        case let picCount where picCount >= 1 && picCount <= 3:
            height = 60
            break
        case let picCount where picCount >= 4 && picCount <= 6:
            height = 130
            break
        case let picCount where picCount >= 7 && picCount <= 9:
            height = 210
            break
        default:
            height = 0
        }
        
        finished(picsHeight: height)
        let retViewFrame = CGRect(x: 0, y: 0, width: 200, height: height)
        let retweetedPicsView = UICollectionView(frame: retViewFrame, collectionViewLayout: retweetedPicsLayout)
        retweetedPicsView.tag = 998
        retweetedPicsView.dataSource = self
        retweetedPicsView.delegate = self
        retweetedPicsView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellOfRetweetedPicsView)
        retweetedPicsView.backgroundColor = UIColor.clearColor()
        retweetedWeiboView.addSubview(retweetedPicsView)
        
        nameLabel.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(nameLabel.superview!).offset(5)
            make.left.equalTo(nameLabel.superview!).offset(5)
            make.height.equalTo(21)
        })
        
        textLabel.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(nameLabel).offset(25)
            make.left.equalTo(textLabel.superview!).offset(5)
            //make.height.equalTo(21)
            make.width.lessThanOrEqualTo(UIScreen.mainScreen().bounds.width - 30)
        })
        
        retweetedPicsView.snp_makeConstraints { (make) in
            make.top.equalTo(textLabel.snp_bottom).offset(5)
            make.left.equalTo(retweetedPicsView.superview!).offset(5)
            make.width.equalTo(200)
            make.height.equalTo(height)
        }

    }
    
    //MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imagesCollectionView.backgroundColor = UIColor.clearColor()
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        imagesCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellOfImageCollectionView)
        imagesCollectionView.collectionViewLayout = collectionViewLayout
        imagesCollectionView.scrollEnabled = false
        selectionStyle = .None
        
    }
    
}
//MARK: - 实现collectionview的datasource代理方法
extension HomeTableViewCell:UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 998{
            if status?.retweeted_weibo?.pic_urls?.count != 0{
                return (status?.retweeted_weibo?.pic_urls?.count)!
            }
            else{
                return 0
            }
        }
        else{
            if status?.pic_urls?.count != 0{
                return (self.status?.pic_urls?.count)!
            }
            else{
                return 0
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView.tag == 998 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellOfRetweetedPicsView, forIndexPath: indexPath)
            cell.contentView.backgroundColor = UIColor.clearColor()
            
            let imageView = setPics((status?.retweeted_weibo?.pic_urls![indexPath.item]["thumbnail_pic"])!)
            cell.contentView.addSubview(imageView)
            
            return cell
        }
        else{
            let cell = imagesCollectionView.dequeueReusableCellWithReuseIdentifier(cellOfImageCollectionView, forIndexPath: indexPath)
            
            cell.contentView.backgroundColor = UIColor.clearColor()
            
            //将原有的子控件移除，防止cell复用而出现的叠加错误
            for view in cell.contentView.subviews {
                view.removeFromSuperview()
            }
            let imageView = setPics((status?.pic_urls?[indexPath.item]["thumbnail_pic"])!)
            
            cell.contentView.addSubview(imageView)
                
            return cell
        }
    }
    
    func setPics(urlObj:AnyObject) -> UIImageView{
        let urlStr = urlObj as! String
        let url = NSURL(string: urlStr)
        
        let imageView = UIImageView()
        imageView.sd_setImageWithURL(url)
        imageView.frame.size = collectionViewLayout.itemSize
        imageView.contentMode = .ScaleToFill
        
        return imageView
    }
}

//MARK: - 自定义collectionview的flowlayout布局
class ImageCollectionLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        itemSize = CGSize(width: 60, height: 60)
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
    }
}

class RetweetedPicsLayout : UICollectionViewFlowLayout{
    override func prepareLayout() {
        itemSize = CGSize(width: 60, height: 60)
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
    }
}

//MARK: - 实现imagecollectionview的代理方法
extension HomeTableViewCell: UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let picsVC = PicsViewController()
        if collectionView.tag == 998 {
            picsVC.urls = getAllMiddleImg((status?.retweeted_weibo!.pic_urls)!)
        }
        else{
            picsVC.urls = getAllMiddleImg((status?.pic_urls)!)
        }
        picsVC.index = indexPath.item
        //由对应的控制器进行present方法
        findTheController()?.presentViewController(picsVC, animated: true, completion: nil)
        
    }
    
    
    //获取所以的图片url
    func getAllMiddleImg(picUrls:[[String:AnyObject]]) -> [NSURL]{
        var bmiddle_urls = [NSURL]()
        for urlDic in picUrls{
            let thumbnail_urlStr = urlDic["thumbnail_pic"] as! NSString
            let bmiddle_urlStr = thumbnail_urlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
            let bmiddle_url = NSURL(string: bmiddle_urlStr)
            bmiddle_urls.append(bmiddle_url!)
        }
        return bmiddle_urls
    }
}
