//
//  DetailProtocols.swift
//  BeMobile
//
//  Created by pblancoh on 4/7/21.
//  
//

import Foundation
import UIKit

protocol DetailViewProtocol {
    // PRESENTER -> VIEW
    var presenter: DetailPresenterProtocol? { get set }
    
    func showDataInLabel(data: TransactionEntity, allTransactions: [TransactionEntity])
    func registerCell()
}

protocol DetailWireFrameProtocol {
    // PRESENTER -> WIREFRAME
    static func createDetailModule(with data: TransactionEntity, allTransactions: [TransactionEntity]) -> UIViewController
}

protocol DetailPresenterProtocol {
    // VIEW -> PRESENTER
    var view: DetailViewProtocol? { get set }
    var interactor: DetailInteractorInputProtocol? { get set }
    var wireFrame: DetailWireFrameProtocol? { get set }
    var receivedTransactionData: TransactionEntity? {get set}
    var receivedAllTransactionData: [TransactionEntity]? {get set}
    
    func viewDidLoad()
}

protocol DetailInteractorOutputProtocol {
    // INTERACTOR -> PRESENTER
}

protocol DetailInteractorInputProtocol {
    // PRESENTER -> INTERACTOR
    var presenter: DetailInteractorOutputProtocol? { get set }
    var remoteDatamanager: DetailRemoteDataManagerInputProtocol? { get set }
}

protocol DetailDataManagerInputProtocol {
    // INTERACTOR -> DATAMANAGER
}

protocol DetailRemoteDataManagerInputProtocol {
    // INTERACTOR -> REMOTEDATAMANAGER
    var remoteRequestHandler: DetailRemoteDataManagerOutputProtocol? { get set }
}

protocol DetailRemoteDataManagerOutputProtocol {
    // REMOTEDATAMANAGER -> INTERACTOR
}
