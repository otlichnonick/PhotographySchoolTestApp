//
//  Binding+Ext.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 01.04.2023.
//

import Foundation
import SwiftUI

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
