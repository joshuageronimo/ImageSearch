//
//  ViewController.swift
//  ImageSearch
//
//  Created by Joshua Geronimo on 2/1/20.
//  Copyright © 2020 Joshua Geronimo. All rights reserved.
//

import UIKit

class GalleryController: UICollectionViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate let errorMessageLabel = UILabel(text: "Oops... Something went wrong\nPlease check your internet connection",
                                           textColor: .white,
                                           fontSize: 25,
                                           fontWeight: .semibold,
                                           dynamicSize: true,
                                           numberOfLines: 3,
                                           textAlignment: .center)
    
    fileprivate let refreshButton: UIButton = {
        let button = UIButton(text: "Refresh",
                              textColor: .secondaryColor,
                              textSize: 14,
                              borderColor: .secondaryColor,
                              cornerRadius: 20)
        button.addTarget(self, action: #selector(handleRefreshButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate let loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    fileprivate let photoCellReuseIdentifier = "PhotoCell"
    fileprivate let loadingFooterReuseIdentifier = "LoadingFooterView"
    fileprivate var photos: [Photo] = []
    fileprivate var shouldLoadMoreImages = false
    fileprivate var numberOfPhotosBeenLoaded = 0 // keep track of number of photos loaded
    fileprivate var currentPage = 1 // keep track of page for pagination
    fileprivate var currentPhotoQuery = "happy" // keep track of current photo query
    
    /// different types of error message type when collectionview is empty
    enum EmptyCollectionViewMessageType {
        case apiResponseError
        case noSearchResult
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    fileprivate func initialSetup() {
        view.backgroundColor = .mainColor
        setupNavigationBar()
        registerCollectionViewCells()
        showLoadingIndicator()
        fetchPhotos(of: currentPhotoQuery, inPage: 1)
    }
    
    // MARK: USER INTERFACE
    
    fileprivate func setupNavigationBar() {
        /// setup navigation bar settings/param
        title = "Image Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        /// setup SearchController for the navigation bar
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    fileprivate func registerCollectionViewCells() {
        // collectionview cell
        collectionView.register(UINib(nibName: photoCellReuseIdentifier, bundle: .main), forCellWithReuseIdentifier: photoCellReuseIdentifier)
        // collectionview footer
        collectionView.register(UINib(nibName: loadingFooterReuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: loadingFooterReuseIdentifier)
    }
    
    func showEmptyCollectionViewMessage(_ showErrorMessage: Bool = true, messageType: EmptyCollectionViewMessageType) {
        switch messageType {
        case .apiResponseError:
            errorMessageLabel.text = "Oops... Something went wrong\nPlease check your internet connection"
        case .noSearchResult:
            errorMessageLabel.text = "No results for: \(currentPhotoQuery)"
        }
        
        if showErrorMessage {
            view.addSubview(errorMessageLabel)
            view.addSubview(refreshButton)
            errorMessageLabel.anchor(width: view.frame.width * 0.8, height: 0)
            errorMessageLabel.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
            refreshButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 20).isActive = true
            refreshButton.anchor(width: 150, height: 40)
            refreshButton.anchor(centerX: view.centerXAnchor, centerY: nil)
        } else {
            errorMessageLabel.removeFromSuperview()
            refreshButton.removeFromSuperview()
        }
    }
    
    // shows/remove a large white loading indicator in the middle of screen
    fileprivate func showLoadingIndicator(_ show: Bool = true) {
        if show {
            photos.removeAll()
            collectionView.reloadData()
            view.addSubview(loadingIndicator)
            loadingIndicator.anchor(centerX: view.centerXAnchor,
                                    centerY: view.centerYAnchor)
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.removeFromSuperview()
        }
        
    }
    
    // MARK: ACTIONS
    
    @objc func handleRefreshButton(sender: UIButton) {
        print("Refreshing")
        showEmptyCollectionViewMessage(false, messageType: .apiResponseError)
        fetchPhotos(of: currentPhotoQuery, inPage: 1)
    }
    
    // MARK: NETWORK
    
    fileprivate func fetchPhotos(of photoQuery: String, inPage page: Int) {
        currentPhotoQuery = photoQuery
        let param: [String: String] = ["q": photoQuery,
                                    "page": "\(page)"]
        print("Start Fetching Photos")
        NetworkService.shared.fetchData(apiEndPoint: "/search", parameters: param) { [weak self] (apiResponse: APIResponse?, error: Error?)  in
            self?.showLoadingIndicator(false)
            if let error = error {
                print("Failed to fetch photos: \(error)")
                DispatchQueue.main.async {
                    if self?.photos != nil {
                        self?.showEmptyCollectionViewMessage(messageType: .apiResponseError)
                    }
                }
                return
            }
            
            guard let apiResponse = apiResponse else {
                print("APIResponse is nil")
                DispatchQueue.main.async {
                    self?.showEmptyCollectionViewMessage(messageType: .noSearchResult)
                }
                return
            }
            self?.currentPage = page
            if self?.currentPage == 1 {
                self?.photos.removeAll()
                // don't add images without links
                self?.photos = apiResponse.getAllImages()?.filter({$0.getImageLink() != nil}) ?? []
                DispatchQueue.main.async {
                                    if self?.photos.count == 0 {
                        self?.showEmptyCollectionViewMessage(messageType: .noSearchResult)
                    } else {
                        self?.showEmptyCollectionViewMessage(false, messageType: .noSearchResult)
                    }
                }

            } else {
                if let newSetOfPhotos = apiResponse.getAllImages()?.filter({$0.getImageLink() != nil}) {
                    self?.photos.append(contentsOf: newSetOfPhotos)
                }
            }
            self?.numberOfPhotosBeenLoaded += apiResponse.getAllImages()?.count ?? 0
            
            if self?.numberOfPhotosBeenLoaded ?? 0 < apiResponse.getNumberOfResults() {
                self?.shouldLoadMoreImages = true
            }
            
            DispatchQueue.main.async {
                print("Reload CollectionView")
                self?.collectionView.reloadData()
            }
        }
    }
        
}

// MARK: CollectionView Delegate / Datasource
extension GalleryController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellReuseIdentifier, for: indexPath) as? PhotoCell {
            /// load more photos if available
            /// note - start fetching next batch of photos before it gets to the end of the collectionview
            if (photos.count - 10) == indexPath.item && shouldLoadMoreImages {
                shouldLoadMoreImages = false
                currentPage += 1
                fetchPhotos(of: currentPhotoQuery, inPage: currentPage)
            }
            
            /// set cell
            cell.setCellInfo(photo: photos[indexPath.item])
            return cell
            
        }
        return PhotoCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = PhotoDetailController()
        detailVC.photo = photos[indexPath.item]
        present(detailVC, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: loadingFooterReuseIdentifier, for: indexPath)
        return footerView
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let sizeToHideFooter = CGSize(width: 0, height: 0)
        let sizeToShowFooter = CGSize(width: view.frame.width, height: 60)
        return photos.count == 0 || !shouldLoadMoreImages ? sizeToHideFooter : sizeToShowFooter
    }
}

// MARK: UISearchBar Delegate Functions

extension GalleryController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Search Query: \(String(describing: searchBar.text))")
        guard let query = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            print("Nothing to query")
            return
        }
        
        // only fetch API for a different query and not empty
        if query != currentPhotoQuery && query != "" {
            showLoadingIndicator()
            fetchPhotos(of: query, inPage: 1)
        }
        searchController.isActive = false
        searchController.searchBar.text = query
    }
}



