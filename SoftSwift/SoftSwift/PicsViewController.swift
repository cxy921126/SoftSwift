//
//  PicsViewController.swift
//  SoftSwift
//
//  Created by Mac mini on 16/4/7.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "Cell"

class PicsViewController: UICollectionViewController {
    var urls : [NSURL]?
    var index : Int?
    
    init(){
        super.init(collectionViewLayout: PicsFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///关闭按钮
    lazy var closeBtn: UIButton={
        
        let btn = UIButton()
        btn.setTitle("Close", forState: .Normal)
        btn.backgroundColor = UIColor.init(white: 0.05, alpha: 0.7)
        btn.frame = CGRect(x: 20, y: UIScreen.mainScreen().bounds.height - 60, width: 60, height: 40)

        btn.addTarget(self, action: #selector(close), forControlEvents: .TouchUpInside)
        
        return btn
    }()
    
    func close(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        //进入时跳转到所选的图片
        collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: index!, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
        
        view.addSubview(closeBtn)
    }

    
//MARK: - UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (urls?.count)!
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        //添加scrollview，并在scrollview上面添加imageview
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        let imageView = setPics(indexPath.item) { (bounds) in
            scrollView.contentSize = CGSize(width: bounds.width, height: bounds.height + 20)
        }
        scrollView.backgroundColor = UIColor.whiteColor()
        
        //配置scrollview的缩放比例
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.5
        scrollView.addSubview(imageView)
        cell.contentView.addSubview(scrollView)
        
        // Configure the cell
    
        return cell
    }
    
    //MARK: - scrollView代理方法（缩放）
    override func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first
    }
    
    //缩放结束后图片居中
    override func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        //缩放即改变transform,不改变view的bounds,只能用frame
//        var offsetY = (UIScreen.mainScreen().bounds.height - (view?.frame.height)!)/2.0
//        var offsetX = (UIScreen.mainScreen().bounds.width - (view?.frame.width)!)/2.0
//        
//        offsetY = offsetY<0 ? 0:offsetY
//        offsetX = offsetX<0 ? 0:offsetX
//        
//        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
        
        view?.center = scrollView.center
    }
    
    //MARK: - 设置图片显示
    func setPics(urlIndex : Int, finished: (bounds:CGRect)->()) -> UIImageView{
        let imageView = UIImageView()
        imageView.sd_setImageWithURL(urls![urlIndex]) { (image, _, _, _) in
            //获取原图的宽高比
            let rate = image.size.height / image.size.width
            //图片显示高度为(屏幕宽度*宽高比)
            let displayHeight = UIScreen.mainScreen().bounds.width * rate
            
            //根据是否是长图片调整显示位置
            if displayHeight < UIScreen.mainScreen().bounds.height{
                imageView.frame = CGRect(x: 0, y: (UIScreen.mainScreen().bounds.height - displayHeight)/2, width: UIScreen.mainScreen().bounds.width, height: displayHeight)
                finished(bounds: imageView.bounds)
            }
            else{
                imageView.frame = CGRect(x: 0, y: 20, width: UIScreen.mainScreen().bounds.width, height: displayHeight)
                finished(bounds: imageView.bounds)
            }
        }
        return imageView
    }
}

//MARK: - FlowLayout
class PicsFlowLayout: UICollectionViewFlowLayout {

    override func prepareLayout() {
        itemSize = UIScreen.mainScreen().bounds.size
        scrollDirection = .Horizontal
        minimumLineSpacing = 0
        
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
    }

}
