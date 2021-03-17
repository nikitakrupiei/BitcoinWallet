//
//  DecodableService.swift
//  BitcoinWallet
//
//  Created by admin on 16.03.2021.
//

import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}

// Service for decoding data
class DecodableService {
    
    static func decodeOne<Entity: Decodable>(data: Data, context: NSManagedObjectContext, success:@escaping((Entity)->()), fail:@escaping((Error)->())){
        do {
            let decoder = JSONDecoder()
            decoder.userInfo[.context] = context
            let result = try decoder.decode(Entity.self, from: data)
            success(result)
        } catch {
            fail(APIError.DecodeDataError(message: error.localizedDescription))
        }
    }
}
