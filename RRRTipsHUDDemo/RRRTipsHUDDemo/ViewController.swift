//
//  ViewController.swift
//  RRRTipsHUDDemo
//
//  Created by 任敬 on 2020/11/19.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            RRRTipsHUD.showSuccess("成功咯")
        }
    }


}

