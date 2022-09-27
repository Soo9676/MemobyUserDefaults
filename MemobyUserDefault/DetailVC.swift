//
//  DetailVC.swift
//  MemobyUserDefault
//
//  Created by Soo J on 2022/09/26.
//

import Foundation
import UIKit

struct Memo: Codable {
    let memoDate: String
    let memoTitle: String
    let memoContents: String
}

struct Lists: Codable {
    let memos: [Memo]
}

class DetailVC: UIViewController {
    override func viewDidLoad() {
        memoData = MainVC.list?.memos[indexRow ?? 0]
        titleDetailTextField.text = memoData?.memoTitle
        contentsDetailTextView.text = memoData?.memoContents

    }
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var titleDetailView: UIView!
    @IBOutlet weak var titleDetailTextField: UITextField!
    @IBOutlet weak var contentsDetailView: UIView!
    @IBOutlet weak var contentsDetailTextView: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    
    var memoData: Memo?
    var indexRow: Int?
    var memoTitle: String?
    var memoContents: String?
    var memoDate: String?
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        var value: String = ""
        var date = Date()
        var dateFormatter = DateFormatter()
        var hours = (Calendar.current.component(.hour, from: date))
        var minutes = (Calendar.current.component(.minute, from: date))
        var seconds = (Calendar.current.component(.second, from: date))
        if let titleText = titleDetailTextField.text {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            var today = dateFormatter.string(from: date)
            memoDate = "\(today), \(hours):\(minutes):\(seconds)"
            var memo = Memo(memoDate: memoDate ?? "", memoTitle: titleText, memoContents: contentsDetailTextView.text)
            do {
                //Encode Memo
                let jsonData = try JSONEncoder().encode(MainVC.list)
                value = String(data: jsonData, encoding: .utf8) ?? ""
                print(value)
                defaults.set(jsonData, forKey: "memo") //"memo"키로 값 저장
            } catch {
                print("Unable to Encode/Decode Note due to \(error)")
            }
        }
        
        
        defaults.synchronize() //동기화
    }
    //다른 곳을 터치하면 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
