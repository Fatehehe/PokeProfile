//
//  HomeViewController.swift
//  PokeProfile
//
//  Created by Fatakhillah Khaqo on 18/03/25.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import RxCocoa

class HomeViewController: UIViewController, IndicatorInfoProvider {

    private let disposeBag = DisposeBag()

    private let searchController = UISearchController(searchResultsController: nil)
    
    private let tableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .systemBackground
        tableview.allowsSelection = true
        tableview.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        return tableview
    }()

    var viewModel = HomeViewModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
        setupTB()
        bindUI()
        getPokemonApi()
    }
    
    func setupTB() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func setupSearchController() {
//        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pokemon..."

        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false

        tableView.tableHeaderView = searchController.searchBar
    }

    func bindUI() {
        searchController.searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)

        viewModel.filteredPokemonList
            .bind(to: tableView.rx.items(cellIdentifier: CustomCell.identifier, cellType: CustomCell.self)) { _, pokemon, cell in
                cell.configure(with: pokemon.url, and: pokemon.name)
            }
            .disposed(by: disposeBag)

        // Subscribe to when the Pokémon list is updated
        viewModel.pokemonUpdated
            .subscribe(onNext: { [weak self] in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(PokemonEntry.self)
            .subscribe(onNext: { pokemon in
                let url = pokemon.url
                self.fetchPokemonDetails(url: url)
            })
            .disposed(by: disposeBag)
        
//        tableView.rx.modelSelected(PokemonSelected.self)
//            .subscribe(onNext: { [weak self] in
//                self?.tableView.reloadData()
//            })
        viewModel.pokemonSelected
            .subscribe(onNext: { pokemonSelected in
                // Handle selected Pokémon (e.g., navigate to a detail view or update the UI)
//                print("Selected Pokémon: \(pokemonSelected.sprites.front_default)")
                // For example, you might update the UI with the selected Pokémon details
            })
            .disposed(by: disposeBag)
        
        tableView.rx.rowHeight.onNext(100)
    }

    func getPokemonApi() {
        PokeAPI().getData { pokemon in
            self.viewModel.updatePokemonList(pokemonList: pokemon)
        }
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Home")
    }
    
    func fetchPokemonDetails(url: String) {
        let pokemonApi = PokemonSelectedApi()
        pokemonApi.getData(url: url) { pokemonSelected in
            // Update the selected Pokémon in the ViewModel
            HomeViewModel.shared.updatePokemonSelected(pokemonSelected: pokemonSelected)
            for p in pokemonSelected.abilities {
                print("ability -> \(p.ability.name)")
            }
        }
    }
}


