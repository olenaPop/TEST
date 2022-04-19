//
//  MyCustomTableViewCell.swift
//  TEST
//
//  Created by Oleh Makhobei on 19.04.2022.
//

import UIKit

class MyCustomTableViewCell: UITableViewCell {
//
//    @IBAction func expandBttn(_ sender: Any) {
//        previewTxtLbl.numberOfLines = 3
//        controller?.postsTableView.reloadData()
//
//
//    }
//
//    @IBOutlet var expandBttn: UIButton!{
//        didSet{
//            expandBttn.isHidden = true
//        }
//    }
//    @IBOutlet var titleLbl: UILabel!
//    @IBOutlet var containerStackView: UIStackView!
//    @IBOutlet var timeshampLbl: UILabel!
//    @IBOutlet var previewTxtLbl: UILabel!
//
//    @IBOutlet var likesLbl: UILabel!
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var textViewLbl: UILabel!
    @IBOutlet var likesLbl: UILabel!
    @IBOutlet var timesLbl: UILabel!
    @IBOutlet var expandBttn: UIButton!
    @IBAction func expandBttnAct(_ sender: Any) {
        let height = textViewLbl.numberOfLines
        if height <= 2 {
            expandBttn.setTitle("Collapse", for: .normal)
            textViewLbl.numberOfLines = 99
            controller?.postsTableView.reloadData()
            controller?.postsTableView.reloadData()
        }
        else if height > 2 {
            expandBttn.setTitle("Expand", for: .normal)
            textViewLbl.numberOfLines = 2
            controller?.postsTableView.reloadData()
        }
        
    }
    
    var controller: ViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
