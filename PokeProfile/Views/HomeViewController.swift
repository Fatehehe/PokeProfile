//
//  HomeViewController.swift
//  PokeProfile
//
//  Created by Fatakhillah Khaqo on 18/03/25.
//

import UIKit
import XLPagerTabStrip

class HomeViewController: UIViewController, IndicatorInfoProvider {
    
    //MARK: - variables
    
    //MARK: -UI Components
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let tableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .systemBackground
        tableview.allowsSelection = true
        tableview.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        return tableview
    }()
    
    private let testButton = UIButton()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPokemonApi()
        setupSearchController()
        setupTB()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - SETUP TABLE VIEW
    func setupTB(){
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func setupSearchController(){
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Pokemon..."
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func getPokemonApi(){
        PokeAPI().getData { pokemon in
            HomeViewModel.shared.pokemonList = pokemon
            self.tableView.reloadData() // Reload table after fetching data
        }
        PokemonSelectedApi().getData(url: "https://pokeapi.co/api/v2/pokemon/7/") { url in
            print("image is in \(url)")
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Home")
    }
}


//MARK: -SEARCH CONTROLLER FUNCTION
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        HomeViewModel.shared.updateSearchController(searchBarText: searchController.searchBar.text)
        tableView.reloadData()  // Reload table view when search text changes
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let inSearchMode = HomeViewModel.shared.inSearchMode(searchController)
        return inSearchMode ? HomeViewModel.shared.PokemonListFiltered.count : HomeViewModel.shared.pokemonList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else {
            fatalError("TableView couldn't dequeue CustomCell in ViewController")
        }
        
        let inSearchMode = HomeViewModel.shared.inSearchMode(searchController)
        
        // Determine which list to use based on search mode
        let pokemon: PokemonEntry
        if inSearchMode {
            pokemon = HomeViewModel.shared.PokemonListFiltered[indexPath.row]
        } else {
            pokemon = HomeViewModel.shared.pokemonList[indexPath.row]
        }
        
        cell.configure(with: pokemon.url, and: pokemon.name)
//        cell.configure(with: UIImage(systemName: "lasso.badge.sparkles")!, and: pokemon.name)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let inSearchMode = HomeViewModel.shared.inSearchMode(searchController)
        let pokemon = inSearchMode ? HomeViewModel.shared.PokemonListFiltered[indexPath.row] : HomeViewModel.shared.pokemonList[indexPath.row]
        
        // Navigate to details or handle selection as needed
    }
}
