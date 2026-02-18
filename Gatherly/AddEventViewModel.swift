//
//  AddEventViewModel.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/16/26.
//

import Foundation

@Observable
final class AddEventViewModel {
    var title: String = ""
    var location: String = ""
    var description: String = ""
    var timestamp: Date = Date()
}
