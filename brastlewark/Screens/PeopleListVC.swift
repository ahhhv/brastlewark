//
//  PeopleListVC.swift
//  brastlewark
//
//  Created by Alex Hernández on 27/02/2021.
//

import UIKit

class PeopleListVC: BWDataLoadingVC {
    enum Section {
        case main
    }
    
    var username: String!
    var people: [Brastlewark] = []
    var filteredPeople: [Brastlewark]   = []
    var isSearching = false
    var isLoadingMorePeople = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Brastlewark>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearchController()
        getPeople()
        configureDataSource()
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.topRightIcon, style: .done, target: self, action: #selector(resetFilters))
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
    }
    
    @objc
    private func resetFilters() {
        resetingFilters()
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PeopleCell.self, forCellWithReuseIdentifier: PeopleCell.reuseID)

        collectionView.register(
          BWPeopleHeaderView.self,
          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
          withReuseIdentifier: BWPeopleHeaderView.reuseIdentifier
        )

        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    
    private func getPeople() {
        showLoadingView()
        isLoadingMorePeople = true
        
        NetworkManager.shared.getBrastleWarkCensus() { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let people):
                self.updateUI(with: people)
                
            case .failure(let error):
                self.presentBWAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "Ok")
            }
            
            self.isLoadingMorePeople = false
        }
    }
    
    private func updateUI(with people: [Brastlewark]) {
        self.people.append(contentsOf: people)
        
        if self.people.isEmpty {
            let message = "This town doesn't have any small people 😬"
            DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
            return
        }
        
        self.updateData(on: self.people)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Brastlewark>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, brastlewark) -> UICollectionViewCell? in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeopleCell.reuseID, for: indexPath) as? PeopleCell {
                cell.set(people: brastlewark)
                return cell
            }
            
            return UICollectionViewCell()
        })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            let view = collectionView.dequeueReusableSupplementaryView(
              ofKind: kind,
              withReuseIdentifier: BWPeopleHeaderView.reuseIdentifier,
              for: indexPath) as? BWPeopleHeaderView
            
            view?.pickerView.toolbarDelegate = self
            view?.pickerView.reloadAllComponents()
            
            return view
          }
    }
    
    private func updateData(on people: [Brastlewark]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Brastlewark>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(people)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }

    private func resetingFilters() {
        filteredPeople.removeAll()
        updateData(on: people)
        isSearching = false
        
        if let supplementaryView = collectionView.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at: IndexPath(row: 0, section: 0)) as? BWPeopleHeaderView {
            supplementaryView.professionsTextField.text = ""
            supplementaryView.hairColorTextField.text = ""
        }
    }
}

extension PeopleListVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else { return }
        let destVC = PeopleDetailVC(brastlewark: selectedItem)
        destVC.modalPresentationStyle = .overFullScreen
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

extension PeopleListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            resetingFilters()
            return
        }
        
        isSearching = true
        
        filteredPeople = people.filter({ brastlewark -> Bool in
            if let name = brastlewark.name {
                return name.lowercased().contains(filter.lowercased())
            }
            
            return false
        })
        
        updateData(on: filteredPeople)
    }
}

extension PeopleListVC: BWPickerViewDelegate {
    func didTapDone(selectedRow: Int) {
        if let supplementaryView = collectionView.supplementaryView(forElementKind: "UICollectionElementKindSectionHeader", at: IndexPath(row: 0, section: 0)) as? BWPeopleHeaderView {

            if supplementaryView.selectedFilterType == .profession {
                let selectedProfession = Profession.allCases[selectedRow]
                let professionsFilter = people.filter({$0.professions?.filter({$0 == selectedProfession}).count ?? 0 > 0 })
                supplementaryView.professionsTextField.text = selectedProfession.rawValue
                supplementaryView.hairColorTextField.text = ""
                updateData(on: professionsFilter)
            } else {
                let selectedHairColor = HairColor.allCases[selectedRow]
                let hairColorFilter = people.filter({$0.hairColor?.rawValue == HairColor.allCases[selectedRow].rawValue})
                supplementaryView.hairColorTextField.text = selectedHairColor.rawValue
                supplementaryView.professionsTextField.text = ""
                updateData(on: hairColorFilter)
            }
        }
        
    }
    
    func didTapCancel() {
        dismiss(animated: true)

        resetingFilters()
        return
    }
}
