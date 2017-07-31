//
//  ViewController.swift
//  FeedBack
//
//  Created by ayy on 2017/7/31.
//  Copyright © 2017年 aoyy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let impact = UIImpactFeedbackGenerator() //1
    @IBAction func onePressed(_ sender: Any) {
        impact.impactOccurred(); //2
    }
    
    let selection = UISelectionFeedbackGenerator()
    @IBAction func twoPressed(_ sender: Any) {
        selection.selectionChanged()
    }
    
    let notification = UINotificationFeedbackGenerator()
    @IBAction func successPressed(_ sender: Any) {
        notification.notificationOccurred(.success)
    }
    
    @IBAction func warningPressed(_ sender: Any) {
         notification.notificationOccurred(.warning)
    }
    
    @IBAction func errorPressed(_ sender: Any) {
         notification.notificationOccurred(.error)
    }
    
}

