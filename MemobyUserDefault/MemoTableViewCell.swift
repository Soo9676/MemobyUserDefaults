//
//  MemoTableViewCell.swift
//  MemobyUserDefault
//
//  Created by Soo J on 2022/09/26.
//

import UIKit

class MemoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var memoStack: UIStackView!
    @IBOutlet weak var memoTitleLabel: UILabel!
    @IBOutlet weak var memoContentsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    let defaults = UserDefaults.standard
    
    //Read/Get Data
    if let data = UserDefaults.standard.data(forKey: "memo"){
        //JSON Decoder 생성
        let decoder = JSONDecoder()
        //Decode Memo
        let memo = try decoder.decode(Memo.self, from: data)
    } catch {
        print("Unable to Decode Memo due to \(error)")
    }
}

extension MemoTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}

extension MemoTableViewCell: UITableViewDelegate {
    
}
