//
//  ViewController.swift
//  SwiftCoding
//
//  Created by luomeng on 16/4/21.
//  Copyright © 2016年 luomeng. All rights reserved.
//

import UIKit
import Crashlytics

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let button = UIButton(type: UIButtonType.RoundedRect)
        button.frame = CGRectMake(20, 350, 100, 30)
        button.setTitle("Crash", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(crashButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        
    }
    
    @IBAction func crashButtonTapped(sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func showAlert(sender: AnyObject) {
        
        let boAlertView = BOAlertView.init(title: "Title", contentText: "helloleft block actionleft block actionleft block actionleft block actionleft block actionhelloleft block actionleft block actionleft block actionleft block actionleft block actionhelloleft block actionleft block actionleft block actionleft block actionleft block action", leftTitle: "Cancel", rightTitle: "OK")
        boAlertView.showAlertView()
        boAlertView.leftBlock =  {
            print("left block action")
        }
        boAlertView.rightBlock = {
            print("right block action")
        }
        boAlertView.dismissBlock = {
            print("dismissBlock action")
        }
    }
}

