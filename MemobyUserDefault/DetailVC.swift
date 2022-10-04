//
//  DetailVC.swift
//  MemobyUserDefault
//
//  Created by Soo J on 2022/09/26.
//

import Foundation
import UIKit

struct Memo: Codable {
    var lastUpdatedtime: String
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
        if let memoDateList = defaults.value(forKey: "memoDateList") as? [String] {
            self.memoDateList = memoDateList
            var memoRange = 0...memoDateList.count
            if let row = indexRow, memoRange.contains(row){
                var memoStruct: Memo
                do {
                    if let jsonString: String = defaults.value(forKey: keyDate) as? String{
                        if let jsonData = jsonString.data(using: .utf8){
                            print("jsonData: \(jsonData)")

                            memoStruct = try JSONDecoder().decode(Memo.self, from: jsonData)
                            print("memoStruct: \(memoStruct)")
                            memoData = memoStruct
                        }
                    }
                } catch { print("cell에서 \(error)때문에 decode 할 수 없음") }
                
                print("memoData: \(memoData)")
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
        
    }
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var titleDetailView: UIView!
    @IBOutlet weak var titleDetailTextField: UITextField!
    @IBOutlet weak var contentsDetailView: UIView!
    @IBOutlet weak var contentsDetailTextView: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    
    var memoDateList: [String] = []
    var newDateArray: [String] = []
    var memoData: Memo?
    var indexRow: Int?
            
    var memoTitle: String?
    var memoContents: String?
    var memoDateforAdmin: String = "memoDateforAdmin"
    var memoDateforUser: String = "memoDateforUser"
    var keyDate: String?
    
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

    @IBAction func updateButtonTapped(_ sender: Any) {
        guard var memoDateList = defaults.value(forKey: "memoDateList") as? [String] else {return}
        var memoRange = 0...memoDateList.count
        var jsonString: String = ""
        var valueArray:[String] = []
        var titleText = titleDetailTextField.text
        var dateArray = recordNow()
        
        print("memoDateList: \(memoDateList)")
        //현재 날짜 저장
        memoDateforAdmin = dateArray[0]
        memoDateforUser = dateArray[1]
        
//        if let memoDateforAdmin = memoDateforAdmin, let memoDateforUser = memoDateforUser, let memoTitle = titleDetailTextField.text, let memoContents = contentsDetailTextView.text {
//
//        }
        
        var memo = Memo(memoDateforAdmin: memoDateforAdmin, memoDateforUser: memoDateforUser, lastUpdatedtime: <#String#>, memoTitle: titleDetailTextField.text ?? "", memoContents: contentsDetailTextView.text )
        print("현재 시각: \(memoDateforAdmin)")
        print("입력한 메모: \(memo)")
        
        //기존과 같은 내용이라면 업데이트 없음
        if memo.memoTitle == memoData?.memoTitle, memo.memoContents == memoData?.memoContents {
            self.navigationController?.popViewController(animated: true)
        } else { //기존과 다른 내용이라면 업데이트 함
            //수정화면(교체)
            if let row = indexRow, memoRange.contains(row) {
                memoDateList[row] = memo.memoDateforAdmin
                defaults.removeObject(forKey: keyDate)
                defaults.setValue(memo, forKey: memoDateList[row])
            } else {
                // 생성화면이라면 추가
                newDateArray = memoDateList + [memo.memoDateforAdmin]
                print("DetailVC.memoDateList = \(memoDateList)")
                print("입력한 메모 추가된 날짜 리스트: \(newDateArray)")
            }
            
            do {
                //struct to jsonData
                let encodedData = try JSONEncoder().encode(memo)
                //"memo"키로 값 저장
//                defaults.setValue(encodedData, forKey: memo.memoDateforAdmin)
                print("encodedData: \(encodedData)")
               
                //jsonData to jsonString
                let jsonString: String = String.init(data: encodedData, encoding: .utf8) ?? "err"
                print("jsonString: \(jsonString)")

                updateMemoList(newMemoList: newDateArray, updatedRecord: memo.memoDateforAdmin, newData: jsonString){self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }
            } catch {
                print("Unable to Encode/Decode Note due to \(error)")
            }
        }
        
        
        
        
    }
    
    func updateMemoList(newMemoList: [String], updatedRecord: String, newData: String, completion: @escaping () -> Void){
        //날짜 옵셔널 바인딩
        if let keyDate = keyDate {
            print("리스트 길이 변함없음")
            defaults.setValue(memoDateList, forKey: "memoDateList")
            print("userdefault에 날짜 리스트 저장 완료")
            defaults.setValue(newData, forKey: updatedRecord)
            print("userdefault에 memo 저장 완료")
            completion()
        } else {
            memoDateList = newMemoList
            defaults.setValue(memoDateList, forKey: "memoDateList")
            defaults.setValue(newData, forKey: updatedRecord)
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
