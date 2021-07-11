//
//  DetailInteractor.swift
//  BeMobile
//
//  Created by pblancoh on 4/7/21.
//  
//

import Foundation

class DetailInteractor: DetailInteractorInputProtocol {

    // MARK: Properties
    
    var presenter: DetailInteractorOutputProtocol?
    var remoteDatamanager: DetailRemoteDataManagerInputProtocol?

}

extension DetailInteractor: DetailRemoteDataManagerOutputProtocol {
    // TODO: Implement use case methods
}
