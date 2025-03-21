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

    private let searchController : UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.placeholder = "Search Pokemon..."
        return search
    }()
    
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
        setupUI()
        bindUI()
        getPokemonApi()
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        tableView.scrollsToTop = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
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

        viewModel.pokemonUpdated
            .subscribe(onNext: { [weak self] in
                self?.tableView.reloadData()
                print("reloaded")
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(PokemonEntry.self)
            .subscribe(onNext: { [weak self] pokemon in
                self?.searchController.dismiss(animated: true, completion: nil)
                let url = pokemon.url
                self?.fetchPokemonDetails(url: url)
                let detailVC = PokemonDetailViewController()
                detailVC.configureDetail(with: pokemon.url, and: pokemon.name)
                self?.present(detailVC, animated: true)
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
            HomeViewModel.shared.updatePokemonSelected(pokemonSelected: pokemonSelected)
            for p in pokemonSelected.abilities {
                print("ability -> \(p.ability.name)")
            }
            
            self.viewModel.abilitiesInfo.onNext(pokemonSelected.abilities)
        }
    }
}
