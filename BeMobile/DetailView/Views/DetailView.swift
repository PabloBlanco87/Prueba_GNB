//
//  DetailView.swift
//  BeMobile
//
//  Created by pblancoh on 4/7/21.
//  
//

import Foundation
import UIKit

class DetailView: UIViewController {

    // MARK: Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: Properties
    
    var presenter: DetailPresenterProtocol?
    var arrayTransactions = [TransactionEntity]()
    var currentTransaction: TransactionEntity?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        self.setUpNavigationController()
    }
    
    func setUpNavigationController() {
        self.title = NSLocalizedString("BEMOBILE_HEADER", comment: "BEMOBILE_HEADER")
        navigationController?.navigationBar.tintColor = .blue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
    }
}

// MARK: Protocol

extension DetailView: DetailViewProtocol {
    
    func registerCell() {
        tableView.register(UINib(nibName: "DetailCellView", bundle: nil), forCellReuseIdentifier: "idDetailCell")
    }
    
    func showDataInLabel(data: TransactionEntity, allTransactions: [TransactionEntity]) {
        self.currentTransaction = data
        self.arrayTransactions = allTransactions.filter({$0.sku == data.sku})
        
    }
}

// MARK: Table -> Datasource & Delegate

extension DetailView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTransactions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idDetailCell", for: indexPath) as? DetailCellView
        
        if(indexPath.row > self.arrayTransactions.count-1){
            return UITableViewCell()
        }
              
        cell?.labelText.text = "\(String(describing: self.arrayTransactions[indexPath.row].amount!)) \(String(describing: self.arrayTransactions[indexPath.row].currency!))"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DetailView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        returnedView.backgroundColor = UIColor.red
        
        let label = UILabel(frame: CGRect(x: 16, y: 16, width: self.view.frame.size.width, height: 20))
        label.text = "\(String(describing: self.currentTransaction!.sku!)) -> \(String(describing: self.currentTransaction!.amount!)) €"
        label.textColor = .blue
        label.font = UIFont(name: "HiraMinProN-W3", size: 20.0)
        label.textAlignment = NSTextAlignment.center;
        returnedView.addSubview(label)
        
        return returnedView
    }
}


