//
//  MainVC.swift
//  MemobyUserDefault
//
//  Created by Soo J on 2022/09/26.
//

import UIKit

class MainVC: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
            MemoTableView.reloadData()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        do {
            if let jsonData = UserDefaults.standard.data(forKey: "memo") {
                MainVC.list = try JSONDecoder().decode(Lists.self, from: jsonData)
            }
        } catch { print(error)}
        
        MemoTableView.reloadData()
    
    }

    @IBOutlet weak var MemoTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    static var list: Lists = Lists()
    var memoDateList: [String?] = []
    
    @IBAction func tapAddButton(_ sender: Any) {
        performSegue(withIdentifier: "SegueToDeatailVC", sender: nil)
    }
    
    
    
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainVC.list.memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as? MemoTableViewCell else {return UITableViewCell()}
        var decodedMemo = MainVC.list.memos[indexPath.row]
        var memoData = [decodedMemo.memoTitle, decodedMemo.memoContents, decodedMemo.memoDateforAdmin, decodedMemo.memoDateforUser]
        cell.indexRow = indexPath.row
        //셀에 모델 전달
        cell.memoData = memoData
        
        //셀의 update 버튼이 눌렸을때 작동할 클로저
        cell.updateButtonPressed = { [weak self] (senderCell) in
            // 뷰컨트롤러에 있는 세그웨이의 실행
            self?.performSegue(withIdentifier: "SegueToDeatailVC", sender: indexPath)
        }
        return cell
    }
    
    
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SegueToDeatailVC", sender: nil)
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoTableViewCell
        cell.indexRow = indexPath.row
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // delete your item here and reload table view
                MainVC.list.memos.remove(at: indexPath.row)
                MemoTableView.deleteRows(at: [indexPath], with: .fade)
                
                do {
                    //Encode Memo
                    let encodedData = try JSONEncoder().encode(MainVC.list)
                    //"memo"키로 값 저장
                    UserDefaults.standard.setValue(encodedData, forKey: "memo")
                    UserDefaults.standard.synchronize()//동기화
                    var value = UserDefaults.standard.value(forKey: "memo")
                    print("갱신된 userdefault(forKey: memo): \(value)")
                } catch {
                    print("error:\(error)")
                }
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToDeatailVC" {
            let detailVC = segue.destination as! DetailVC
            guard let indexPath = sender as? IndexPath else {return}
            detailVC.memoDateList = self.memoDateList
            print("디테일VC -> 메인VC : 메모날짜 리스트 전달 완료")
            detailVC.indexRow = indexPath.row
            }
        }
    }

