//
//  HomeViewModel.swift
//  PokeProfile
//
//  Created by Fatakhillah Khaqo on 18/03/25.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {

    static let shared = HomeViewModel()

    private let disposeBag = DisposeBag()

    var pokemonList = BehaviorRelay<[PokemonEntry]>(value: [])
    var filteredPokemonList = BehaviorRelay<[PokemonEntry]>(value: [])
    var pokemonSelected = PublishSubject<PokemonSelected>()

    var searchText = BehaviorRelay<String>(value: "")

    var pokemonUpdated = PublishSubject<Void>()

    private init() {
        searchText.asObservable()
            .subscribe(onNext: { [weak self] searchText in
                self?.filterPokemonList(searchText: searchText)
            })
            .disposed(by: disposeBag)
    }
    
    func updatePokemonSelected(pokemonSelected: PokemonSelected){
        self.pokemonSelected.onNext(pokemonSelected)
    }

    func updatePokemonList(pokemonList: [PokemonEntry]) {
        self.pokemonList.accept(pokemonList)
        filterPokemonList(searchText: searchText.value)
        pokemonUpdated.onNext(())
    }

    func updateSearchText(_ text: String) {
        searchText.accept(text)
    }

    private func filterPokemonList(searchText: String) {
        if searchText.isEmpty {
            filteredPokemonList.accept(pokemonList.value)
        } else {
            let filteredList = pokemonList.value.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            filteredPokemonList.accept(filteredList) 
        }
    }
}
