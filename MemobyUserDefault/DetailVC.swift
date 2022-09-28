//
//  DetailVC.swift
//  MemobyUserDefault
//
//  Created by Soo J on 2022/09/26.
//

import Foundation
import UIKit

struct Memo: Codable {
    var memoDate: String
    var memoTitle: String
    var memoContents: String
}

struct Lists: Codable {
    var memos: [Memo] = []
}


class DetailVC: UIViewController {
    override func viewDidLoad() {
        setup()
    }
    
    func setup(){
        if let row = indexRow, memoRange.contains(row){
            memoData = MainVC.list.memos[row]
            titleDetailTextField.text = memoData?.memoTitle
            contentsDetailTextView.text = memoData?.memoContents
            updateButton.setTitle("update", for: .normal)
            
            self.title = "메모 수정하기"
        } else {
            titleDetailTextField.placeholder = "새로운 메모를 입력하세요"
            contentsDetailTextView.text = ""
            updateButton.setTitle("create", for: .normal)
            self.title = "메모 생성하기"
        }
    }
    
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var titleDetailView: UIView!
    @IBOutlet weak var titleDetailTextField: UITextField!
    @IBOutlet weak var contentsDetailView: UIView!
    @IBOutlet weak var contentsDetailTextView: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    
    var memoList: [Any?] = []
    var memoData: Memo?
    var indexRow: Int?
    var memoTitle: String?
    var memoContents: String?
    var memoDate: String?
    var memoRange = 0...MainVC.list.memos.count
//    var callbackResult: (() -> ())?
    
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
            print("입력한 메모: \(memo)")
            if let row = indexRow, memoRange.contains(row){
                MainVC.list.memos[row] = memo
            } else {
                MainVC.list.memos.append(memo)
            }
            print("입력한 메모 추가된 리스트: \(MainVC.list.memos)")
            
            do {
                //Encode Memo
                let encodedData = try JSONEncoder().encode(MainVC.list)
                //"memo"키로 값 저장
                defaults.setValue(encodedData, forKey: "memo")
                print("userdefault에 저장 완료")
                updateMemoList(newMemoList: MainVC.list.memos){self.navigationController?.popViewController(animated: true)
//                    self.callbackResult?()
                    self.navigationController?.popViewController(animated: true)
                }
                
                
                
            } catch {
                print("Unable to Encode/Decode Note due to \(error)")
            }
        }
    }
    
    func updateMemoList(newMemoList: [Memo], completion: @escaping () -> Void){
        //날짜 옵셔널 바인딩
        if newMemoList.count == memoList.count {
            print("리스트 길이 변함없음")
            completion()
        } else {
            var obj = defaults.object(forKey: "memo")
            var value = defaults.value(forKey: "memo")
            MainVC.list.memos = newMemoList
            
            defaults.synchronize()
            print("다름 동기화 완료")
            completion()
        }
    }
    //다른 곳을 터치하면 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
