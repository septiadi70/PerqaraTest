//
//  ListFavoritesViewController.swift
//  PerqaraTest
//
//  Created by Andi Septiadi on 15/08/23.
//

import UIKit
import Combine

class ListFavoritesViewController: UIViewController {
    private var viewModel: ListFavoritesViewModel
    private var bags = Set<AnyCancellable>()
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .lightGray
        control.addTarget(self, action: #selector(refreshControlDidValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    struct K {
        static let cellId = "CellId"
    }
    
    init(viewModel: ListFavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ListFavoritesViewController", bundle: Bundle(for: Self.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Favorite Games"

        configTable()
        configBinding()
        
        tableView.refreshControl?.beginRefreshing()
        refreshControlDidValueChanged(refreshControl)
    }

}

// MARK: - Helpers

extension ListFavoritesViewController {
    private func configTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100.0
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.register(GameTableViewCell.nib(), forCellReuseIdentifier: K.cellId)
    }
    
    private func configBinding() {
        viewModel
            .$games
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &bags)
        
        viewModel
            .$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if !isLoading {
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }
            .store(in: &bags)
    }
}

// MARK: - Actions

extension ListFavoritesViewController {
    @objc func refreshControlDidValueChanged(_ sender: UIRefreshControl) {
        viewModel.loadGames()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ListFavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: K.cellId, for: indexPath)
        guard let cell = aCell as? GameTableViewCell,
              let game = viewModel.getGame(index: indexPath.row)
        else { return aCell }
        cell.config(viewModel: GameViewModel(game: game))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let game = viewModel.getGame(index: indexPath.row) {
            let detailViewController = Injection.provideDetailGameViewController(gameId: game.id)
            detailViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
