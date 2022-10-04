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
    
    var memoTitle: String?
    var memoContents: String?
    var memoDateforAdmin: String?
    var memoDateforUsers: String?
    
    var memoData: Memo? {
        didSet {
            configureUIwithData()
        }
    }
    
    let defaults = UserDefaults.standard
    var indexRow: Int?
    
    var updateButtonPressed: (MemoTableViewCell) -> Void = { (sender) in }
    
    //Read/Get Data
    func configureUIwithData() {
        memoTitle = memoData?.memoTitle
        memoContents = memoData?.memoContents
        memoDateforAdmin = memoData?.memoDateforAdmin
        memoDateforUsers = memoData?.memoDateforUser
        
        memoTitleLabel.text = memoTitle
        memoContentsLabel.text = memoContents
        dateLabel.text = memoDateforUsers
    }
    
    @IBAction func tapUpdateButton(_ sender: Any) {
        // 뷰컨트롤로에서 전달받은 클로저를 실행 (내 자신 Cell을 전달하면서) 
        updateButtonPressed(self)
//        performSegue(withIdentifier: "SegueToDeatailVC", sender: UIButton)
    }
    
    
        
}

