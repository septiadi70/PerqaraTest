//
//  GameTableViewCell.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 15/08/23.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!

    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: Self.self))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gameImageView.backgroundColor = .lightGray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gameImageView.layer.masksToBounds = true
        gameImageView.layer.cornerRadius = 4.0
        
        starImageView.tintColor = .orange
        starImageView.image = UIImage(systemName: "star.fill")
    }
    
    func config(viewModel: GameViewModel) {
        nameLabel.text = viewModel.getName()
        releaseLabel.text = "Release Date \(viewModel.getReleased())"
        ratingLabel.text = String(viewModel.getRating())
        
        gameImageView.image = nil
        if let imageURL = viewModel.getBackgroundImageURL() {
            gameImageView.load(url: imageURL)
        }
    }
    
}
