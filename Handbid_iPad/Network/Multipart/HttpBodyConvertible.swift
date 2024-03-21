//Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

public protocol HttpBodyConvertible {
    func buildHttpBodyPart(boundary: String) -> Data
}
