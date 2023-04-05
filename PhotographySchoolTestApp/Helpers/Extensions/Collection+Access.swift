//
//  Collection+Access.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 01.04.2023.
//

import Foundation

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
