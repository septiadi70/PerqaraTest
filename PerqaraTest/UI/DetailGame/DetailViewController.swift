//
//  DetailViewController.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 15/08/23.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    private var viewModel: DetailViewModel
    private var bags = Set<AnyCancellable>()
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var controllerImageView: UIImageView!
    @IBOutlet weak var playedCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    lazy var backBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(backButtonTapped(_:)))
        return item
    }()
    
    lazy var loveButton: LoveButton = {
        let button = LoveButton(type: .system)
        button.isOn = false
        button.addTarget(self, action: #selector(loveButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var loveBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(customView: loveButton)
        return item
    }()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "DetailViewController", bundle: Bundle(for: Self.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configBinding()
        viewModel.loadDetail()
    }

}

// MARK: - Helpers

extension DetailViewController {
    private func configureUI() {
        navigationItem.leftBarButtonItem = backBarButtonItem
        navigationItem.rightBarButtonItem = loveBarButtonItem
        
        starImageView.tintColor = .orange
        starImageView.image = UIImage(systemName: "star.fill")
        
        controllerImageView.tintColor = UIColor(named: "MainBlueTint")
        controllerImageView.image = UIImage(systemName: "gamecontroller")
    }
    
    private func reloadViews() {
        gameImageView.image = nil
        if let imageURL = viewModel.getBackgroundImageURL() {
            gameImageView.load(url: imageURL)
        }
        
        publisherLabel.text = viewModel.getPublishersName()
        nameLabel.text = viewModel.getName()
        releaseLabel.text = "Release Date \(viewModel.getReleased())"
        ratingLabel.text = String(viewModel.getRating())
        playedCountLabel.text = "\(viewModel.getPlayedCount()) played"
        descriptionLabel.text = viewModel.getDescription()
    }
    
    private func configBinding() {
        viewModel
            .$gameModel
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.reloadViews()
            }
            .store(in: &bags)
        
        viewModel
            .$localGameModel
            .receive(on: RunLoop.main)
            .sink { [ weak self] model in
                self?.loveButton.isOn = model != nil
            }
            .store(in: &bags)
        
        viewModel
            .$error
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let ws = self, let error else { return }
                Alert
                    .basicAlert(title: "Error", message: error.localizedDescription)
                    .present(at: ws)
            }
            .store(in: &bags)
    }
}

extension DetailViewController {
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func loveButtonTapped(_ sender: UIButton) {
        viewModel.favoriteGame()
    }
}
