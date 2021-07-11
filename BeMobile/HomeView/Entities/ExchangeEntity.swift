//
//  ExchangeEntity.swift
//  BeMobile
//
//  Created by pblancoh on 4/7/21.
//

import Foundation

struct ExchangeEntity: Decodable {
    // Opcionales en el caso que el servidor devuelva nulo, por seguridad
    let from: String?
    let to: String?
    let rate: String?
    
    enum CodingKeys: String, CodingKey {
        case from = "from"
        case to = "to"
        case rate = "rate"
    }
}
