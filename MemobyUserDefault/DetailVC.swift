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
        var jsonString: String = ""
        var valueArray:[String] = []
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
                let encodedData = try JSONEncoder().encode(memo)
                jsonString = String(data: encodedData, encoding: .utf8) ?? ""
                MainVC.list?.memos.append(memo)
                //MARK: print
                print("입력된 jsonString:\(jsonString)")
                //"memo"키로 값불러와서 비었는지 확인
                if let value = defaults.value(forKey: "memo") {
                    //value에 jsonString 추가
                    print("기존 value(forKey: 'memo'): \(value)")
                } else {
                    valueArray.append(jsonString)
                    print(valueArray)
                }
                //"memo"키로 값 저장
                defaults.setValue(MainVC.list, forKey: "memo")
                print("userdefault에 저장 완료")
                
                self.navigationController?.popViewController(animated: true)
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
