//
//  HomeViewModel.swift
//  PokeProfile
//
//  Created by Fatakhillah Khaqo on 18/03/25.
//

import Foundation
import UIKit

class HomeViewModel {
    static let shared = HomeViewModel()
    var pokemonUpdated : (()->Void)?
    
    var pokemonList = [PokemonEntry]()
    var PokemonListFiltered = [PokemonEntry]()
    
    public func inSearchMode(_ searchController: UISearchController) -> Bool {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        
        return isActive && !searchText.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        self.PokemonListFiltered = pokemonList  // Start by showing all data
        
        // Only filter when there is text in the search bar
        if let searchText = searchBarText?.lowercased(), !searchText.isEmpty {
            self.PokemonListFiltered = self.pokemonList.filter({
                $0.name.lowercased().contains(searchText)
            })
        }

        self.pokemonUpdated?()  // Update the view when the list is filtered
    }

}
