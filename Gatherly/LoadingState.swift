//
//  LoadingState.swift
//  Gatherly
//
//  Created by Devon Arnone on 3/10/26.
//

enum LoadingState {
    case idle
    case loading
    case success
    case failed(ErrorType)
}
