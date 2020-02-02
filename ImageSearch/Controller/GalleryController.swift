//
//  ViewController.swift
//  ImageSearch
//
//  Created by Joshua Geronimo on 2/1/20.
//  Copyright © 2020 Joshua Geronimo. All rights reserved.
//

import UIKit

class GalleryController: UICollectionViewController {
    
    fileprivate let photoCellReuseIdentifier = "PhotoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    fileprivate func initialSetup() {
        setupNavigationBar()
        registerCollectionViewCells()
    }
    
    fileprivate func setupNavigationBar() {
        /// setup navigation bar settings/param
        title = "Image Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        /// setup SearchController for the navigation bar
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    fileprivate func registerCollectionViewCells() {
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
 
        
        collectionView.register(UINib(nibName: photoCellReuseIdentifier, bundle: .main), forCellWithReuseIdentifier: photoCellReuseIdentifier)
    }
        
}

// MARK: CollectionView Delegate / Datasource
extension GalleryController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellReuseIdentifier, for: indexPath) as? PhotoCell {
            return cell
        }
        return PhotoCell()
    }
}

extension GalleryController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = self.view.frame.width
        let cellSize = screenWidth / 2
        return CGSize(width: cellSize, height: cellSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}



