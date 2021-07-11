//
//  PrincipalProtocols.swift
//  BeMobile
//
//  Created by pblancoh on 3/7/21.
//  
//

import Foundation
import UIKit

protocol HomeViewProtocol {
    // PRESENTER -> VIEW
    var presenter: HomePresenterProtocol? { get set }
    func presenterPushDataView(receivedData: [TransactionEntity]);
    func registerCell()
    func registerSearchController()
    func loadSpinner()
    func stopAndHideSpinner()
}

protocol HomeWireFrameProtocol{
    // PRESENTER -> WIREFRAME
    static func createHomeModule() -> UIViewController
    func presentNewViewDetail(from view: HomeViewProtocol, withData: TransactionEntity, withAllTransactions: [TransactionEntity])
}

protocol HomePresenterProtocol {
    // VIEW -> PRESENTER
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorInputProtocol? { get set }
    var wireFrame: HomeWireFrameProtocol? { get set }
    
    func viewDidLoad()
    func showDetailView(with data: TransactionEntity)
}

protocol HomeInteractorOutputProtocol {
    // INTERACTOR -> PRESENTER
    func interactorPushTransactionDataPresenter(receivedData: [TransactionEntity])
}

protocol HomeInteractorInputProtocol{
    // PRESENTER -> INTERACTOR
    var presenter: HomeInteractorOutputProtocol? { get set }
    var remoteDatamanager: HomeRemoteDataManagerInputProtocol? { get set }
    
    // FUNCIÓN QUE PERMITE AL INTERACTOR GESTIONAR DATOS CON LA EJECUCION DE ESTA FUNCION DESDE EL PRESENTER
    func interactorGetTransactionsData()
    func interactorGetExchangeData()
    func getAllTransactionsArray() -> [TransactionEntity]
}

protocol HomeDataManagerInputProtocol {
    // INTERACTOR -> DATAMANAGER
}

protocol HomeRemoteDataManagerInputProtocol {
    // INTERACTOR -> REMOTEDATAMANAGER
    var remoteRequestHandler: HomeRemoteDataManagerOutputProtocol? { get set }
    func externalGetTransactionData(success: @escaping (_ allTransactions: [TransactionEntity]) -> (), failure: @escaping (_ error: Error?) -> ())
    func externalGetExchangeData(success: @escaping (_ allExchanges: [ExchangeEntity]) -> (), failure: @escaping (_ error: Error?) -> ())
}

protocol HomeRemoteDataManagerOutputProtocol {
    // REMOTEDATAMANAGER -> INTERACTOR
    func remoteDataManagerCallBackTransactionData(with category: [TransactionEntity])
    func remoteDataManagerCallBackExchangeData(with category: [ExchangeEntity])
}
