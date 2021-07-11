//
//  PrincipalInteractor.swift
//  BeMobile
//
//  Created by pblancoh on 3/7/21.
//  
//

import Foundation
import UIKit

class HomeInteractor: HomeInteractorInputProtocol {
    
    // MARK: Properties
    var presenter: HomeInteractorOutputProtocol?
    var remoteDatamanager: HomeRemoteDataManagerInputProtocol?
    var arrayTransactions = [TransactionEntity]()
    var arrayExchanges = [ExchangeEntity]()
    var arrayTransactionsFinal = [TransactionEntity]()

    // MARK: Functions
    
    func interactorGetTransactionsData() {
        // DICE A LA CAPA DE CONEXION EXTERNA (EXTERNAL DATA MANAGER) QUE TIENE QUE TRAER UNOS DATOS
        remoteDatamanager?.externalGetTransactionData(success: { (allTransactions) in
            self.arrayTransactions = allTransactions
            self.finalSuccesTransactionData()
            
        }, failure: { (error) in
            print(error?.localizedDescription ?? NSLocalizedString("OCURRED_ERROR", comment: "OCURRED_ERROR"))
        })
    }
    
    func interactorGetExchangeData() {
        remoteDatamanager?.externalGetExchangeData(success: { (allExchanges) in
            self.arrayExchanges = allExchanges
            self.remoteDataManagerCallBackExchangeData(with: self.arrayExchanges)
        }, failure: { (error) in
            print(error?.localizedDescription ?? NSLocalizedString("OCURRED_ERROR", comment: "OCURRED_ERROR"))
        })
    }
    
    func finalSuccesTransactionData() {
        self.interactorGetExchangeData()
    }
    
    func getAllTransactionsArray() -> [TransactionEntity] {
        return self.arrayTransactions
    }
}

// MARK: Protocol

extension HomeInteractor: HomeRemoteDataManagerOutputProtocol {
    
    func remoteDataManagerCallBackTransactionData(with allTransactions: [TransactionEntity]) {
        // Pasamos los datos al presenter
        presenter?.interactorPushTransactionDataPresenter(receivedData: allTransactions)
    }
    
    func remoteDataManagerCallBackExchangeData(with allExchanges: [ExchangeEntity]) {
        self.getCurrencyInEuros(currentTransaction: self.arrayTransactions)
        self.unifyTransactionsBySku()
        self.remoteDataManagerCallBackTransactionData(with: arrayTransactionsFinal)
    }
    
    func getCurrencyInEuros(currentTransaction: [TransactionEntity]) {
        
        for var transaction in currentTransaction {
            if isAmountInEur(currencyCoin: transaction.currency ?? "") {
                // No se hace nada porque ya viene en Euros
            } else {
                if self.existDirectMoneyConversion(currentTransaction: transaction) {
                    transaction.amount = self.getDirectConversionInEuros(currentTransaction: transaction)
                } else {
                    transaction.amount = self.getIndirectConversionInEuros(currentTransaction: transaction, allExchanges: self.arrayExchanges)
                }
                transaction.currency = "EUR"
            }
        }
    }
    
    func isAmountInEur(currencyCoin:String) -> Bool {
        if currencyCoin == "EUR" {
            return true
        }
        return false
    }
    
    func existDirectMoneyConversion(currentTransaction: TransactionEntity) -> Bool{
        guard let _ = self.arrayExchanges.first(where: {$0.from == currentTransaction.currency && $0.to == "EUR"}) else {
            return false
        }
        return true
    }
    
    func getIndirectConversionInEuros(currentTransaction: TransactionEntity, allExchanges: [ExchangeEntity]) -> String {
   
        let arrayExchangeEuros = self.arrayExchanges.filter({ $0.to == "EUR"})
    
        for exchange in self.arrayExchanges {
            for exchangeEuro in arrayExchangeEuros {
                if exchange.to == exchangeEuro.from {
                    let finalRating = Double(exchange.rate!) ?? 0
                    let finalAmount = Double(currentTransaction.amount!) ?? 0
                    let finalConversionEuros = Double(exchangeEuro.rate!) ?? 0
                    return (finalRating * (finalAmount * 1) * finalConversionEuros).roundBankers(numberOfDecimals: 2)
                }
            }
        }
        return "0"
    }
  
    func getDirectConversionInEuros(currentTransaction: TransactionEntity) -> String {
        guard let finalRate = self.arrayExchanges.first(where: {$0.from == currentTransaction.currency && $0.to == "EUR"}) else {
            return "0"
        }//Devuelve el elemento del array donde se cumplan estas dos condiciones
        
        let finalRating = Double(finalRate.rate!) ?? 0
        let finalAmount = Double(currentTransaction.amount!) ?? 0
        return (finalRating * (finalAmount * 1)).roundBankers(numberOfDecimals: 2)
    }
    
    func unifyTransactionsBySku() {
        self.arrayTransactions.forEach { it in
            if let index = self.arrayTransactionsFinal.firstIndex(where: {$0.sku == it.sku}) {
                let actualAmount = Double(it.amount ?? "0")
                let operatorAmount = Double(arrayTransactionsFinal[index].amount ?? "0")
                let finalAmount = actualAmount! + operatorAmount!
                arrayTransactionsFinal[index].amount! = finalAmount.roundBankers(numberOfDecimals: 2)
            } else {
                arrayTransactionsFinal.append(it)
            }
        }
    }
}

// MARK: Double -> Custom Function Extension

extension Double {
    func roundBankers(numberOfDecimals: Int) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = numberOfDecimals
        formatter.roundingMode = .halfEven
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
