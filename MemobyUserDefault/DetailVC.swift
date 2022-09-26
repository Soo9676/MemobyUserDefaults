//
//  DetailVC.swift
//  MemobyUserDefault
//
//  Created by Soo J on 2022/09/26.
//

import Foundation
import UIKit

struct Memo: Codable {
    let memoTitle: String
    let memoContents: String
    let memoDate: Date
}

class DetailVC: UIViewController {
    override func viewDidLoad() {
    }
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var titleDetailView: UIView!
    @IBOutlet weak var titleDetailTextField: UITextField!
    @IBOutlet weak var contentsDetailView: UIView!
    @IBOutlet weak var contentsDetailTextView: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        if let title = titleDetailTextField.text {
            var memo = Memo(memoTitle: title, memoContents: contentsDetailTextView.text, memoDate: Date())
            do {
                //JSON Encoder 생성
                let encoder = JSONEncoder()
                
                //Encode Memo
                let data = try encoder.encode(memo)
            } catch {
                print("Unable to Encode Note due to \(error)")
            }
            
        }

        defaults
    }
}
