//
//  TransactionEntity.swift
//  BeMobile
//
//  Created by pblancoh on 4/7/21.
//

import Foundation

struct TransactionEntity: Decodable, Hashable {
    // Opcionales en el caso que el servidor devuelva nulo, por seguridad
    let sku: String?
    var amount: String?
    var currency: String?
    
    enum CodingKeys: String, CodingKey {
        case sku = "sku"
        case amount = "amount"
        case currency = "currency"
    }
}
