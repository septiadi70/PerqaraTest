//
//  DetailViewController.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 15/08/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var controllerImageView: UIImageView!
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = backBarButtonItem
        navigationItem.rightBarButtonItem = loveBarButtonItem
        
        starImageView.tintColor = .orange
        starImageView.image = UIImage(systemName: "star.fill")
        
        controllerImageView.tintColor = UIColor(named: "MainBlueTint")
        controllerImageView.image = UIImage(systemName: "gamecontroller")
    }

}

extension DetailViewController {
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func loveButtonTapped(_ sender: UIButton) {
        loveButton.isOn.toggle()
    }
}
