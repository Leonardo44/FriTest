//
//  MealTableViewCell.swift
//  FriTest
//
//  Created by Leo on 12/2/24.
//

import UIKit
import SDWebImage
import Nuke

class MealTableViewCell: UITableViewCell {
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealCategoryLabel: UILabel!
    @IBOutlet weak var youtubeLinkBtn: UIButton!
    private var meal: MealAPI?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        youtubeLinkBtn.setTitle("Youtube link", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupView(meal: MealAPI) {
        self.meal =  meal
        self.mealNameLabel.text = meal.name
        self.mealCategoryLabel.text = "\(meal.category) - \(meal.area)"
        self.youtubeLinkBtn.isHidden = meal.youtubeLink.isEmpty
        
        mealImageView.sd_setImage(with: URL(string: meal.thumbnail))
    }
    
    @IBAction func youtubeLinkBtnTapped() {
        if let youtubeLink = meal?.youtubeLink, let url = URL(string: youtubeLink) {
            UIApplication.shared.open(url)
        }
    }
}
