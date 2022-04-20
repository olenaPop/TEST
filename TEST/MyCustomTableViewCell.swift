//
//  MyCustomTableViewCell.swift
//  TEST
//
//  Created by Olena Makhobei on 19.04.2022.
//

import UIKit

class MyCustomTableViewCell: UITableViewCell {    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var textViewLbl: UILabel!
    @IBOutlet var likesLbl: UILabel!
    @IBOutlet var timesLbl: UILabel!
    @IBOutlet var expandBttn: UIButton!
    @IBAction func expandBttnAct(_ sender: Any) {
       let textLineCounter = textViewLbl.numberOfLines
        if textLineCounter != 0 {
            expandBttn.setTitle("Collapse", for: .normal)
            textViewLbl.numberOfLines = 0
            controller?.postsTableView.reloadData()
              }
        else  {
            expandBttn.setTitle("Expand", for: .normal)
            textViewLbl.numberOfLines = 2
            controller?.postsTableView.reloadData()
             }
    }
    
    var controller: ViewController? = nil
  
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
