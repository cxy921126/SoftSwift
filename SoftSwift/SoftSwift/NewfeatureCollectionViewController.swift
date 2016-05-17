//
//  NewfeatureCollectionViewController.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/15.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
let featureCount = 4

class NewfeatureCollectionViewController: UICollectionViewController {
    var layout = NewfeatureLayout()
    
    init(){
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.registerClass(NewfeatureColletionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return featureCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewfeatureColletionViewCell
        cell.index = indexPath.item
        // Configure the cell
    
        return cell
    }
}

class NewfeatureColletionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.frame = UIScreen.mainScreen().bounds
        imageView.backgroundColor = UIColor.whiteColor()
    }
    
    override func prepareForReuse() {
        //避免重用出现button重用
        for subview in contentView.subviews {
            if subview.classForCoder == UIButton.classForCoder() {
                subview.removeFromSuperview()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageView = UIImageView()
    
    var index : Int?{
        didSet{
            imageView.image = UIImage(named: "new_feature_\(index!+1)")
            setInBtn()
        }
    }
    
    func setInBtn(){
        let btn = UIButton()
        btn.frame = CGRect(x: UIScreen.mainScreen().bounds.width / 2 - 65, y: UIScreen.mainScreen().bounds.height - 200, width: 130.0, height: 30.0)
        btn.setImage(UIImage(named: "new_feature_button"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: #selector(NewfeatureColletionViewCell.intoWeibo), forControlEvents: UIControlEvents.TouchUpInside)
        if index == 3{
            contentView.addSubview(btn)
        }
    }
    
    func intoWeibo(){
        NSNotificationCenter.defaultCenter().postNotificationName(userHasLoginNote, object: "toWeibo")
    }
}

class NewfeatureLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        minimumLineSpacing = 0
        itemSize = UIScreen.mainScreen().bounds.size
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.showsHorizontalScrollIndicator = true
        collectionView?.pagingEnabled = true
    }
}

