//
//  ListGamesViewController.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 15/08/23.
//

import UIKit

class ListGamesViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .lightGray
        return control
    }()
    
    struct K {
        static let cellId = "CellId"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTable()
        configSearchBar()
    }

}

// MARK: - Helpers

extension ListGamesViewController {
    private func configTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100.0
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.register(GameTableViewCell.nib(), forCellReuseIdentifier: K.cellId)
    }
    
    private func configSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        searchBar.delegate = self
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ListGamesViewController: UITableViewDataSource, UITableViewDelegate {
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
        let detailViewController = DetailViewController()
        detailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ListGamesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
