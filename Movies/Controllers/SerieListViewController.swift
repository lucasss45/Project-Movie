//
//  SerieListViewController.swift
//  Movies
//
//  Created by ebonatto-macOS on 20/06/24.
//

import UIKit

class SerieListViewController: UIViewController {

    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Services
    var serieService = SerieService()
    
    // Search
    private let searchControllerSeries = UISearchController()
    private let defaultSearchName = "Game of Thrones"
    private var series: [Serie] = []
    private let segueIdentifier = "showSerieDetailVC"
    
    // Collection item parameters
    private let itemsPerRow = 2.0
    private let spaceBetweenItems = 6.0
    private let itemAspectRatio = 1.5
    private let marginSize = 32.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        loadSeries(withTitle: defaultSearchName)
    }
    
    private func setupViewController() {
        setupSearchController()
        setupCollectionView()
    }
    
    private func loadSeries(withTitle serieTitle: String) {
        serieService.searchSeries(withTitle: serieTitle) { series in
            DispatchQueue.main.async {
                self.series = series
                self.collectionView.reloadData()
            }
        }
    }
    
    private func setupSearchController() {
        searchControllerSeries.searchResultsUpdater = self
        searchControllerSeries.searchBar.placeholder = "Pesquisar"
        navigationItem.searchController = searchControllerSeries
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movieDetailVC = segue.destination as? MovieDetailViewController,
              let movie = sender as? Movie else {
            return
        }
        
        movieDetailVC.movieId = movie.id
        movieDetailVC.movieTitle = movie.title
    }
}

// MARK: - UICollectionViewDataSource

extension SerieListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        series.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let serie = series[indexPath.row]
//        cell.setup(movie: movie)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SerieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionWidth = collectionView.frame.size.width - marginSize
        let availableWidth = collectionWidth - (spaceBetweenItems * itemsPerRow)
        
        let itemWidth = availableWidth / itemsPerRow
        let itemHeight = itemWidth * itemAspectRatio
        
        return .init(width: itemWidth, height: itemHeight)
    }
}

// MARK: - UICollectionViewDelegate

extension SerieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSerie = series[indexPath.row]
//        performSegue(withIdentifier: segueIdentifier, sender: selectedSerie)
    }
}

// MARK: - UISearchResultsUpdating

extension SerieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            loadSeries(withTitle: defaultSearchName)
        } else {
            loadSeries(withTitle: searchText)
        }
        
        collectionView.reloadData()
    }
}
