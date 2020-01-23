//
//  SetsTableViewCell.swift
//  WorkoutTracker
//
//  Created by Will Chew on 2020-01-22.
//  Copyright © 2020 Will Chew. All rights reserved.
//

import UIKit

class SetsTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var repsTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var methodTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        repsTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    
    override func prepareForReuse() {
        repsTextField.text = nil
    }

}
