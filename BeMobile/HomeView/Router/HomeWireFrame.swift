//
//  PrincipalWireFrame.swift
//  BeMobile
//
//  Created by pblancoh on 3/7/21.
//  
//

import Foundation
import UIKit

class HomeWireFrame: HomeWireFrameProtocol {

    class func createHomeModule() -> UIViewController {
        let navController = mainStoryboard.instantiateViewController(withIdentifier: "idNavigation")
        if let view = navController.children.first as? HomeView {
            var presenter: HomePresenterProtocol & HomeInteractorOutputProtocol = HomePresenter()
            var interactor: HomeInteractorInputProtocol & HomeRemoteDataManagerOutputProtocol = HomeInteractor()
            var remoteDataManager: HomeRemoteDataManagerInputProtocol = HomeRemoteDataManager()
            let wireFrame: HomeWireFrameProtocol = HomeWireFrame()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireFrame = wireFrame
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDataManager
            remoteDataManager.remoteRequestHandler = interactor
            
            return navController
        }
        return UIViewController()
    }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "HomeView", bundle: Bundle.main)
    }
    
    func presentNewViewDetail(from view: HomeViewProtocol, withData: TransactionEntity, withAllTransactions: [TransactionEntity]) {
        // CREAR NUEVO MÓDULO E INSTANCIARLO
        let newDetailView = DetailWireFrame.createDetailModule(with: withData, allTransactions: withAllTransactions)
        
        if let newView = view as? UIViewController {
            newView.navigationController?.pushViewController(newDetailView, animated: true)
        }
    }
}
