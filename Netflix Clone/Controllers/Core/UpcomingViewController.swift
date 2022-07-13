//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Jean Ricardo Cesca on 11/07/22.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    public var titles: [Title] = []
    
    private let upComingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(upComingTable)

        view.backgroundColor = .systemBackground
        
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        upComingTable.delegate = self
        upComingTable.dataSource = self
        
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upComingTable.frame = view.bounds
    }
    
    private func fetchUpcoming() {
        APICaller.shared.getUpComingMovies { result in
            switch result {
            case .success(let titles):
                self.titles = titles
                DispatchQueue.main.async {
                    self.upComingTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.original_title ?? title.original_name ?? "Unknown title name", posterURL: title.poster_path ?? "")
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height / 6
    }
    
}
