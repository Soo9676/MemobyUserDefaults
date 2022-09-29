//
//  DetailVC.swift
//  MemobyUserDefault
//
//  Created by Soo J on 2022/09/26.
//

import Foundation
import UIKit

struct Memo: Codable {
    var memoDateforAdmin: String
    var memoDateforUser: String
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
    
    var memoDateList: [String?] = []
    var memoData: Memo?
    var indexRow: Int?
    var memoTitle: String?
    var memoContents: String?
    var memoDateforAdmin: String = "memoDateforAdmin"
    var memoDateforUser: String = "memoDateforUser"
    var memoRange = 0...MainVC.list.memos.count
//    var callbackResult: (() -> ())?
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        var jsonString: String = ""
        var valueArray:[String] = []
        var titleText = titleDetailTextField.text
        var dateArray = recordNow()
        //날짜 저장
        memoDateforAdmin = dateArray[0]
        memoDateforUser = dateArray[1]
        
//        if let memoDateforAdmin = memoDateforAdmin, let memoDateforUser = memoDateforUser, let memoTitle = titleDetailTextField.text, let memoContents = contentsDetailTextView.text {
//
//        }
        
        var memo = Memo(memoDateforAdmin: memoDateforAdmin, memoDateforUser: memoDateforAdmin, memoTitle: titleDetailTextField.text ?? "", memoContents: contentsDetailTextView.text )
        print("현재 시각: \(memoDateforAdmin)")
        print("입력한 메모: \(memo)")
        
        if let row = indexRow, memoRange.contains(row){
            memoDateList[row]  = memo.memoDateforAdmin
        } else {
            memoDateList.append(memo.memoDateforAdmin)
        }
        print("입력한 메모 추가된 날짜 리스트: \(memoDateList)")
        
        do {
            //Encode Memo
            let encodedData = try JSONEncoder().encode(memo)
            //"memo"키로 값 저장
            defaults.setValue(encodedData, forKey: memo.memoDateforAdmin)
            print("userdefault에 저장 완료")
            updateMemoList(newMemoList: MainVC.list.memos){self.navigationController?.popViewController(animated: true)
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            print("Unable to Encode/Decode Note due to \(error)")
        }
    }
    
    func recordNow() -> [String] {
        let today = Date.now
        var dateForAdmin = ""
        var dateForUser = ""
        //userDefaults에 저장될 시간
        var dateFormatterforAdmin = DateFormatter()
        dateFormatterforAdmin.dateFormat = "yyMMddhhmmss"
        dateForAdmin = dateFormatterforAdmin.string(from: today)
        //메인뷰 테이블에 보일 시간
        var dateFormatterforUser = DateFormatter()
        dateFormatterforUser.dateFormat = "yyyy.MM.dd, ahh:mm:ss"
        dateForUser = dateFormatterforUser.string(from: today)
        
        return [dateForAdmin, dateForUser]
    }
    
    func updateMemoList(newMemoList: [Memo], completion: @escaping () -> Void){
        //날짜 옵셔널 바인딩
        if newMemoList.count == memoDateList.count {
            print("리스트 길이 변함없음")
            completion()
        } else {
            var obj = defaults.object(forKey: memoDateforAdmin)
            var value = defaults.value(forKey: memoDateforUser)
            MainVC.list.memos = newMemoList
            
            defaults.synchronize()
            print("길이 다름, 동기화 완료")
            completion()
        }
    }
    
    //다른 곳을 터치하면 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
