//
//  DetailWireFrame.swift
//  BeMobile
//
//  Created by pblancoh on 4/7/21.
//  
//

import Foundation
import UIKit

class DetailWireFrame: DetailWireFrameProtocol {

    static func createDetailModule(with data: TransactionEntity, allTransactions: [TransactionEntity]) -> UIViewController {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "idDetailView")
        if let view = viewController as? DetailView {
            var presenter: DetailPresenterProtocol & DetailInteractorOutputProtocol = DetailPresenter()
            var interactor: DetailInteractorInputProtocol & DetailRemoteDataManagerOutputProtocol = DetailInteractor()
            var remoteDataManager: DetailRemoteDataManagerInputProtocol = DetailRemoteDataManager()
            let wireFrame: DetailWireFrameProtocol = DetailWireFrame()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireFrame = wireFrame
            presenter.interactor = interactor
            presenter.receivedTransactionData = data
            presenter.receivedAllTransactionData = allTransactions
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDataManager
            remoteDataManager.remoteRequestHandler = interactor
            
            return viewController
        }
        return UIViewController()
    }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "DetailView", bundle: Bundle.main)
    }
    
}
