//
//  PhotosCollectionViewController.swift
//  PhotoGallery
//
//  Created by Elena Pavlova on 26.10.2022.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
   
    private var photos: [Photo] = []
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(actionBarButtonTapped)
        )
    }()
    
    private lazy var organizeBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .organize,
            target: self,
            action: #selector(organizeBarButtonTapped)
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseId)
        collectionView.backgroundColor = .white
        setupNavigationBar()
        setupSearchBar()
    }
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseId, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        let photo = photos[indexPath.item]
        cell.photo = photo
        cell.backgroundColor = .systemGray
        return cell
    }
    
    // MARK: - Actions of navigation buttons
    @objc private func organizeBarButtonTapped() {
        print(#function)
    }
    
    @objc private func actionBarButtonTapped() {
        print(#function)
    }
    
    // MARK: - Setup UI Elements
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "PHOTOS"
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItems = [actionBarButtonItem, organizeBarButtonItem]
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
}

// MARK: - UISearchBarDelegate
extension PhotosCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            NetworkService.shared.fetchData(for: searchText) { [weak self] result in
                switch result {
                case .success(let searchResult):
                    self?.photos = searchResult.results
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
