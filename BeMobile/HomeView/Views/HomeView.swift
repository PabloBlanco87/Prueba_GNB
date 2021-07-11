//
//  PrincipalView.swift
//  BeMobile
//
//  Created by pblancoh on 3/7/21.
//  
//

import Foundation
import UIKit

class HomeView: UIViewController {

    // MARK: Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: Views
    
    let spinner = UIActivityIndicatorView(style: .large)
    
    lazy var searchController: UISearchController = {
        let s = UISearchController(searchResultsController: nil)
        s.searchResultsUpdater = self
        s.obscuresBackgroundDuringPresentation = false
        s.searchBar.placeholder = NSLocalizedString("SEARCH_TRANSACTION", comment: "SEARCH_TRANSACTION")
        s.searchBar.sizeToFit()
        s.searchBar.searchBarStyle = .prominent
        s.searchBar.delegate = self
        s.searchBar.setValue(NSLocalizedString("CANCEL", comment: "CANCEL"), forKey: "cancelButtonText")
        return s
    }()
    
    // MARK: Properties
    
    var presenter: HomePresenterProtocol?
    var arrayViewTransactions = [TransactionEntity]()
    var filteredTransactions = [TransactionEntity]()

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Comunico a mi vista con el presenter
        presenter?.viewDidLoad()
        self.setupNavigationController()
    }
    
    // MARK: Functions
    
    func setupNavigationController() {
        self.title = NSLocalizedString("GNB_HEADER", comment: "GNB_HEADER")
        navigationController?.navigationBar.tintColor = .blue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
    }
    
    func filterContentForSearchText(searchText: String){
        filteredTransactions = arrayViewTransactions.filter({ (transaction: TransactionEntity) -> Bool in
      
            if (isSearchBarEmpty()) {
                return true
            } else {
                return transaction.sku!.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty() || searchBarScopeIsFiltering)
    }
}

// MARK: Protocol

extension HomeView: HomeViewProtocol {

    func registerCell() {
        tableView.register(UINib(nibName: "HomeCellView", bundle: nil), forCellReuseIdentifier: "myCustomCell")
    }
    
    func registerSearchController(){
        navigationItem.searchController = searchController
    }
   
    func presenterPushDataView(receivedData: [TransactionEntity]) {
        arrayViewTransactions = receivedData
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }        
    }
    
    func loadSpinner() {
        self.spinner.color = .blue
        self.spinner.startAnimating()
        tableView.backgroundView = self.spinner
        
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
    }
    
    func stopAndHideSpinner() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.spinner.hidesWhenStopped = true
        }
    }
}

// MARK: Table -> Datasource & Delegate

extension HomeView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {return filteredTransactions.count}
        return arrayViewTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCustomCell", for: indexPath) as? HomeCellView
        
        let currentTransaction: TransactionEntity
        
        if isFiltering() {
            currentTransaction = filteredTransactions[indexPath.row]
        } else {
            currentTransaction = arrayViewTransactions[indexPath.row]
        }
        
        cell?.skuLabel.text = currentTransaction.sku
        cell?.amountLabel.text = "\(String(describing: currentTransaction.amount ?? "0")) €"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HomeView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentTransaction: TransactionEntity
        
        if isFiltering() {
            currentTransaction = filteredTransactions[indexPath.row]
        } else {
            currentTransaction = arrayViewTransactions[indexPath.row]
        }
        presenter?.showDetailView(with: currentTransaction)
    }
}

// MARK: SearchBar -> Delegate & Updating

extension HomeView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!)
    }
}

extension HomeView: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
