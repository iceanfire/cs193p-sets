//
//  Array+Indentifiable.swift
//  Memorize
//
//  Created by Hadi Laasi on 05/06/2020.
//  Copyright © 2020 Hadi Laasi. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count{
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
}
