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
    var offset = 0
    let limit = 10
    var totalCount = 0
    var isFetching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
        loadPokemons()
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        
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

    func loadPokemons() {
         if isFetching || (totalCount > 0 && viewModel.pokemonList.value.count >= totalCount) {
             return
         }
         
         isFetching = true
         mbProgressHUD(label: "Loading", detailLabel: "Fetching Pokemon...")
         
         PokeAPI().getData(limit: limit, offset: offset) { [weak self] newPokemons, total in
             guard let self = self else { return }
             self.totalCount = total
             
             if self.offset == 0 {
                 self.viewModel.updatePokemonList(pokemonList: newPokemons)
             } else {
                 self.viewModel.appendPokemonList(pokemonList: newPokemons)
             }
             
             self.offset += self.limit
             self.isFetching = false
             self.hideMBProgressHUD()
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

extension HomeViewController {
    func mbProgressHUD(label: String, detailLabel: String){
        DispatchQueue.main.async{
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = label
            progressHUD.detailsLabel.text = detailLabel
            progressHUD.contentColor = .systemMint
        }
    }
    
    func hideMBProgressHUD(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            MBProgressHUD.hide(for: self.view, animated: false)
        }
    }
}

extension HomeViewController : UIScrollViewDelegate, UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let contentOffsetY = scrollView.contentOffset.y
        let height = scrollView.frame.size.height
        
        if contentOffsetY + height >= contentHeight + 50 {
            print("Reached the bottom of the table view")
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        print("Loading more data...")
        loadPokemons()
    }
}
