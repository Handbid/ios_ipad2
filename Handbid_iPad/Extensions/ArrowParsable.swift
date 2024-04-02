// Copyright (c) 2024 by Handbid. All rights reserved.

import NetworkService
import Arrow

extension ArrowParsable where Self: NetworkingJSONDecodable {
    
    public static func decode(_ json: Any) throws -> Self {
        var t: Self = Self()
        if let arrowJSON = JSON(json) {
            t.deserialize(arrowJSON)
        }
        return t
    }
}
