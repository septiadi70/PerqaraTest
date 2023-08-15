//
//  ListFavoritesViewController.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 15/08/23.
//

import UIKit

class ListFavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct K {
        static let cellId = "CellId"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Favorite Games"

        configTable()
    }

}

// MARK: - Helpers

extension ListFavoritesViewController {
    private func configTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100.0
        tableView.separatorStyle = .none
        tableView.register(GameTableViewCell.nib(), forCellReuseIdentifier: K.cellId)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ListFavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: K.cellId, for: indexPath)
        guard let cell = aCell as? GameTableViewCell else { return aCell }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
