//
//  PokemonDetailViewController.swift
//  PokeProfile
//
//  Created by Fatakhillah Khaqo on 20/03/25.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class PokemonDetailViewController: UIViewController {

    private let pokemonImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 48, weight: .medium)
        return label
    }()
    
    private let abilityLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.text = "abilities :"
        return label
    }()
    
    private let abilitiesStackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        setupUI()
    }
    
    func setupUI() {
        self.view.addSubview(pokemonImageView)
        self.view.addSubview(nameLabel)
        self.view.addSubview(abilityLabel)
        self.view.addSubview(abilitiesStackView)
        
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        abilitiesStackView.translatesAutoresizingMaskIntoConstraints = false
        abilityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            pokemonImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            pokemonImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 300),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 300),
            
            abilityLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 20),
            abilityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            abilitiesStackView.topAnchor.constraint(equalTo: abilityLabel.bottomAnchor, constant: 20),
            abilitiesStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureDetail(with url: String, and name: String) {
        nameLabel.text = name
        
        var tempString: String?
        PokemonSelectedApi().getData(url: url) { pokemon in
            tempString = pokemon.sprites.front_default
            
            guard let imageUrl = URL(string: tempString!) else { return }
            
            self.pokemonImageView.kf.setImage(with: imageUrl, placeholder: UIImage(systemName: "questionmark"), options: [.cacheOriginalImage]) { result in
                    switch result {
                    case .success(let value):
                        print("Image fetched successfully: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Error fetching image: \(error.localizedDescription)")
                }
            }
            
        }
        
        let pokemonApi = PokemonSelectedApi()
        pokemonApi.getData(url: url) { pokemonSelected in
            HomeViewModel.shared.updatePokemonSelected(pokemonSelected: pokemonSelected)
            for p in pokemonSelected.abilities {
                //make the abilitieslabel text set to p.ability.name
                let abilityLabel : UILabel = {
                    let label = UILabel()
                    label.textColor = .label
                    label.font = .systemFont(ofSize: 24, weight: .thin)
                    return label
                }()
                abilityLabel.text = p.ability.name
                self.abilitiesStackView.addArrangedSubview(abilityLabel)
//                self.abilitiesLabels.append(abilityLabel)
            }
        }
    }
    
}

