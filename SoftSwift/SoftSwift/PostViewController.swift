//
//  PostViewController.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/27.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit
import MBProgressHUD

class PostViewController: UIViewController {
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func post(sender: AnyObject) {
        let access_token = UserAccount.readAccount()?.access_token
        let statusText = textView.text
        let param = ["access_token":access_token, "status":statusText]
        NetworkTool.sharedNetworkTool().POST("2/statuses/update.json", parameters: param, progress: nil, success: { (_, _) in
            let hint = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hint.mode = .Text
            hint.labelText = "Success!"
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1*Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                
                print("POST SUCCESS")
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })
            }) { (_, error) in
                print(error)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        textView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
}

extension PostViewController: UITextViewDelegate{
    func textViewDidChange(textView: UITextView) {
        hintLabel.hidden = textView.hasText()
        postBtn.enabled = textView.hasText()
    }
}
