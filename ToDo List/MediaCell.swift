//
//  MediaCell.swift
//  ToDo List
//
//  Created by nassermac on 6/23/23.
//  Copyright © 2023 Nasser Co. All rights reserved.
//

import UIKit

class MediaCell: UITableViewCell {
  //var removeRowHandler: (() -> Void)?
   var note: Notes?
  var onDelete: (() -> Void)?

    @IBOutlet weak var imageNote: UIImageView!
    @IBOutlet weak var noteDatelabel: UILabel!
    @IBOutlet weak var noteNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
  @IBAction func deleteNotebtnTapped(_ sender: UIButton) {
    onDelete?()
    //showAlert()
   }
    func showAlert() {
        let alert = UIAlertController(title: "Sorry", message: "Are you Sure You want To Delete This ToDo?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Yes", style: .destructive, handler: nil)
        let action2 = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
   //self.listOfArtist.remove(at: indexPath.row)
  //  self.MediaTableView.reloadData()
    
}

