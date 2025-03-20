//
//  Pokemon.swift
//  PokeProfile
//
//  Created by Fatakhillah Khaqo on 20/03/25.
//

import Foundation
import Alamofire

struct Pokemon: Codable {
    var results: [PokemonEntry]
}

struct PokemonEntry: Codable, Identifiable{
    let id = UUID()
    var name : String
    var url : String
}

struct PokemonSelected: Codable {
    var sprites: PokemonSprites
    var weight: Int
}

struct PokemonSprites: Codable{
    var front_default: String
}

class PokemonSelectedApi {
    func getData(url: String, completion: @escaping (PokemonSprites) -> ()) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let pokemonSprite = try JSONDecoder().decode(PokemonSelected.self, from: data)
                    DispatchQueue.main.async {
                        completion(pokemonSprite.sprites)
                    }
                } catch {
                    print("Error decoding Pokemon sprites: \(error)")
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
}

//class PokemonSelectedApi {
//    func getData(url: String, completion: @escaping (PokemonSprites) -> ()){
//        guard let url = URL(string: url) else {return}
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data else {return}
//
//            let PokemonSprite = try! JSONDecoder().decode(PokemonSelected.self, from: data)
//
//            DispatchQueue.main.async{
//                completion(PokemonSprite.sprites)
//            }
//        }.resume()
//    }
//}

class PokeAPI {
    func getData(completion: @escaping ([PokemonEntry]) -> ()) {
        let url = "https://pokeapi.co/api/v2/pokemon?limit=151"
        
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let pokemonList = try JSONDecoder().decode(Pokemon.self, from: data)
                    DispatchQueue.main.async {
                        completion(pokemonList.results)
                    }
                } catch {
                    print("Error decoding Pokemon list: \(error)")
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
}


//class PokeAPI {
//    func getData(completion: @escaping ([PokemonEntry]) -> ()){
//        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151") else {
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data else {return}
//            let pokemonList = try! JSONDecoder().decode(Pokemon.self, from: data)
//            DispatchQueue.main.async{
//                completion(pokemonList.results)
//            }
//        }.resume()
//    }
//}
