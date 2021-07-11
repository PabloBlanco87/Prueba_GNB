//
//  PrincipalPresenter.swift
//  BeMobile
//
//  Created by pblancoh on 3/7/21.
//  
//

import Foundation
import UIKit

class HomePresenter  {
    
    // MARK: Properties
    var view: HomeViewProtocol?
    var interactor: HomeInteractorInputProtocol?
    var wireFrame: HomeWireFrameProtocol?
    
}

extension HomePresenter: HomePresenterProtocol {

    // MARK: Lifecycle
    
    func viewDidLoad() {
        // DICE AL INTERACTOR QUE QUIERE TRAER UNOS DATOS        
        interactor?.interactorGetTransactionsData()
        view?.registerSearchController()
        view?.registerCell()
        view?.loadSpinner()
    }
    
    func showDetailView(with data: TransactionEntity) {
        let allTransactions = interactor?.getAllTransactionsArray()
        wireFrame?.presentNewViewDetail(from: view!, withData: data, withAllTransactions: allTransactions ?? [TransactionEntity]())
    }   
  
}

// MARK: Protocol

extension HomePresenter: HomeInteractorOutputProtocol {

    func interactorPushTransactionDataPresenter(receivedData: [TransactionEntity]) {
        // LE DECIMOS A LA VISTA QUE PINTE LOS DATOS
        view?.stopAndHideSpinner()
        view?.presenterPushDataView(receivedData: receivedData)
    }
}
