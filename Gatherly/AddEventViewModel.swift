//
//  AddEventViewModel.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/16/26.
//

import Foundation
import PhotosUI
import SwiftUI
import UIKit

@Observable
final class AddEventViewModel {
    var title: String = ""
    var location: String = ""
    var description: String = ""
    var timestamp: Date = Date()
    var base64String: String?
    var uiImage: UIImage?
    var image: Image? {
        if let uiImage = uiImage {
            return Image(uiImage: uiImage)
        }
        return nil
    }
    var selectedPhoto: PhotosPickerItem?
    var loadingState: LoadingState = .idle
    var isError: Bool = false
    var errorString: String = ""
    var didCreateEvent: Bool = false
    var isSubmitting: Bool = false

    var isLoading: Bool {
        if case .loading = loadingState {
            return true
        }
        return false
    }

    func loadImage() async {
        guard selectedPhoto != nil else {
            loadingState = .idle
            return
        }

        loadingState = .loading
        isError = false
        errorString = ""
        do {
            if let data = try await selectedPhoto?.loadTransferable(type: Data.self) {
                let loadedImage = UIImage(data: data)
                uiImage = loadedImage
                if let loadedImage, let imageData = loadedImage.jpegData(compressionQuality: 0.8) {
                    base64String = imageData.base64EncodedString()
                } else {
                    base64String = nil
                }
                loadingState = .success
            } else {
                throw ErrorType.codingError
            }
        } catch let error as ErrorType {
            loadingState = .failed(error)
            isError = true
            errorString = error.localizedDescription
        } catch {
            loadingState = .failed(.unknown)
            isError = true
            errorString = error.localizedDescription
        }
    }

    func createEvent() async {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            isError = true
            errorString = "Please fill out all fields."
            return
        }

        loadingState = .loading
        isError = false
        errorString = ""
        didCreateEvent = false
        isSubmitting = true

        do {
            let createdEvent = try await EventService.shared.createEvent(
                title: title,
                description: description,
                timestamp: timestamp,
                location: location,
                uiImage: uiImage
            )

            guard createdEvent != nil else {
                loadingState = .failed(.networkError)
                isError = true
                errorString = ErrorType.networkError.localizedDescription
                isSubmitting = false
                return
            }
            loadingState = .success
            didCreateEvent = true
            isSubmitting = false
        } catch let error as ErrorType {
            loadingState = .failed(error)
            isError = true
            errorString = error.localizedDescription
            isSubmitting = false
        } catch {
            loadingState = .failed(.unknown)
            isError = true
            errorString = error.localizedDescription
            isSubmitting = false
        }
    }
}
