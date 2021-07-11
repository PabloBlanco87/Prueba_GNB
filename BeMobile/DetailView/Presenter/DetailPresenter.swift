//
//  DetailPresenter.swift
//  BeMobile
//
//  Created by pblancoh on 4/7/21.
//  
//

import Foundation

class DetailPresenter: DetailPresenterProtocol {

    // MARK: Properties
    
    var view: DetailViewProtocol?
    var interactor: DetailInteractorInputProtocol?
    var wireFrame: DetailWireFrameProtocol?
    var receivedTransactionData: TransactionEntity?
    var receivedAllTransactionData: [TransactionEntity]?
    
    // MARK: Functions
    
    func viewDidLoad() {
        view?.registerCell()
        if let receivedData = receivedTransactionData, let allTransactionsDatas = receivedAllTransactionData {
            view?.showDataInLabel(data: receivedData, allTransactions: allTransactionsDatas)
        }
    }
}

// MARK: Protocol

extension DetailPresenter: DetailInteractorOutputProtocol {
    // TODO: implement interactor output methods
}
