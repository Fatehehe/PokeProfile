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
    
    var imageInfo = PublishSubject<String>()
    var nameInfo = PublishSubject<String>()
    var abilitiesInfo = PublishSubject<[Ability]>()

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

    func appendPokemonList(pokemonList: [PokemonEntry]) {
        // Append new entries to the existing list
        let currentList = self.pokemonList.value
        let newList = currentList + pokemonList
        self.pokemonList.accept(newList)
        filterPokemonList(searchText: searchText.value)
        pokemonUpdated.onNext(())
    }
    
    func updateSearchText(_ text: String) {
        searchText.accept(text)
    }

    func filterPokemonList(searchText: String) {
        if searchText.isEmpty {
            filteredPokemonList.accept(pokemonList.value)
        } else {
            let filtered = pokemonList.value.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            filteredPokemonList.accept(filtered)
        }
    }
}
