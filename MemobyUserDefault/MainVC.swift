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
        do {
            if let jsonData = UserDefaults.standard.data(forKey: "memo") {
                MainVC.list = try JSONDecoder().decode(Lists.self, from: jsonData)
            }
        } catch { print(error)}
        
        MemoTableView.reloadData()
    
    }

    @IBOutlet weak var MemoTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    static var list: Lists?
//    var memos: [Memo] = []
    static var dates: [Date] = []
    
    @IBAction func tapAddButton(_ sender: Any) {
        performSegue(withIdentifier: "SegueToDeatailVC", sender: nil)
    }
    
    
    
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoTableViewCell
        var decodedMemo = MainVC.list?.memos[indexPath.row]
        cell.indexRow = indexPath.row
        cell.memoTitle = decodedMemo?.memoTitle
        cell.memoContents = decodedMemo?.memoContents
        cell.memoDate = decodedMemo?.memoDate
        //셀에 모델 전달
        let defaults = UserDefaults.standard
        
        return UITableViewCell()
    }
    
    
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SegueToDeatailVC", sender: nil)
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoTableViewCell
        cell.indexRow = indexPath.row
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToDeatailVC" {
            let detailVC = segue.destination as! DetailVC
            guard let indexPath = sender as? IndexPath else {return}
//            var decodedMemo = MainVC.list?.memos[indexPath.row]
//            detailVC.memoData = decodedMemo
        }
    }
}
