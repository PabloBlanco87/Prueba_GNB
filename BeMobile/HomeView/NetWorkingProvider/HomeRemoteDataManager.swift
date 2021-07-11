//
//  PrincipalRemoteDataManager.swift
//  BeMobile
//
//  Created by pblancoh on 3/7/21.
//  
//

import Foundation
import Alamofire

class HomeRemoteDataManager:HomeRemoteDataManagerInputProtocol {
    
    // MARK: Properties

    var remoteRequestHandler: HomeRemoteDataManagerOutputProtocol?
    
    private let kExchangeUrl = "https://quiet-stone-2094.herokuapp.com/rates"
    private let kTransactionUrl = "https://quiet-stone-2094.herokuapp.com/transactions.json"
    private let kStatusOk = 200...299
    let headers : HTTPHeaders = ["Content-Type" : "application/json"]
    
    var transactions = [TransactionEntity]()
    var exchanges = [ExchangeEntity]()
    
    // MARK: Functions
    
    func externalGetTransactionData(success: @escaping (_ allTransactions: [TransactionEntity]) -> (), failure: @escaping (_ error: Error?) -> ()) {
        // Llama al servicio y obtiene los datos
        AF.request(kTransactionUrl , headers: self.headers).validate(statusCode: kStatusOk).responseJSON { (response) in
            guard let result = response.data else {return}
            do {
                self.transactions = try JSONDecoder().decode([TransactionEntity].self, from: result)
                // Enviamos de vuelta los datos al interactor
                success(self.transactions)
            }catch {
                failure(response.error)
            }
        }
    }
    
    func externalGetExchangeData(success: @escaping (_ allExchanges: [ExchangeEntity]) -> (), failure: @escaping (_ error: Error?) -> ()) {
        // Llama al servicio y obtiene los datos
        AF.request(kExchangeUrl , headers: self.headers).validate(statusCode: kStatusOk).responseJSON { (response) in
            guard let result = response.data else {return}
            do {
                self.exchanges = try JSONDecoder().decode([ExchangeEntity].self, from: result)
                // Enviamos de vuelta los datos al interactor
                success(self.exchanges)
            }catch {
                failure(response.error)
            }
        }
    }
}
