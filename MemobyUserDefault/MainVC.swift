//
//  MainVC.swift
//  MemobyUserDefault
//
//  Created by Soo J on 2022/09/26.
//

import UIKit

struct MemoDateList: Codable {
    var list:[String]
}

class MainVC: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
            MemoTableView.reloadData()
        
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        var strings = defaults.object(forKey: "memoDateList") as? [String] ?? []
        memoDateList = strings
//        memoContentsLabel.isHidden = true

        MemoTableView.reloadData()
    
    }

    @IBOutlet weak var MemoTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    var memoDateList: [String] = []
    var defaults = UserDefaults.standard
    
    @IBAction func tapAddButton(_ sender: Any) {
        performSegue(withIdentifier: "SegueToDeatailVC", sender: nil)
    }
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memoDateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as? MemoTableViewCell else {return UITableViewCell()}
        var keyDate = memoDateList[indexPath.row]
        var memoStruct: Memo
        do {
            if let jsonString: String = defaults.value(forKey: keyDate) as? String{
                if let jsonData = jsonString.data(using: .utf8){
                    print("jsonData: \(jsonData)")
                    
                    memoStruct = try JSONDecoder().decode(Memo.self, from: jsonData)
                    print("memoStruct: \(memoStruct)")
                    //셀에 모델 전달
                    cell.memoData = memoStruct
                }
            }
        } catch { print("cell에서 \(error)때문에 decode 할 수 없음") }
    
        
        cell.memoContentsLabel.isHidden = true
        cell.indexRow = indexPath.row
        
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
        var dateToEdit = memoDateList[indexPath.row]
            if editingStyle == .delete {
                // delete your item here and reload table view
                memoDateList.remove(at: indexPath.row)
                MemoTableView.deleteRows(at: [indexPath], with: .fade)
                print("before", defaults.value(forKey: dateToEdit))
                defaults.removeObject(forKey: dateToEdit)
                print("after", defaults.value(forKey: dateToEdit))
                
            } /*else if editingStyle == .insert {}*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToDeatailVC" {
            let detailVC = segue.destination as! DetailVC
            guard let indexPath = sender as? IndexPath else {return}
//            detailVC.memoDateList = self.memoDateList
            

            detailVC.indexRow = indexPath.row
            detailVC.keyDate = memoDateList[indexPath.row]
            print("keyDate 전달 완료")
        }
    }
    
}

