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
    var memoDate: String? {
        didSet {
            configureUIwithData()
        }
    }
    
    let defaults = UserDefaults.standard
    var indexRow: Int?
    
    //Read/Get Data
    func configureUIwithData() {
        memoTitleLabel.text = memoTitle
        memoContentsLabel.text = memoContents
        dateLabel.text = memoDate
    }
        
}

