//
//  MainVC.swift
//  MemobyUserDefault
//
//  Created by Soo J on 2022/09/26.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        defaults.set(CGFloat.pi, forKey: "Pi")
    }

    @IBOutlet weak var MemoTableView: UITableView!
   
    
    
}

