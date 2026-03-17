//
//  EditEventViewModel.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/16/26.
//

import Foundation
import PhotosUI
import SwiftUI
import UIKit

@Observable
final class EditEventViewModel {
    private let eventID: String?
    let existingImageURL: String?
    var title: String
    var location: String
    var description: String
    var timestamp: Date
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
    var didSaveEvent: Bool = false
    var isSubmitting: Bool = false

    var isLoading: Bool {
        if case .loading = loadingState {
            return true
        }
        return false
    }

    init(event: Event) {
        self.eventID = event.id
        self.existingImageURL = event.image_url
        self.title = event.title
        self.location = event.location
        self.description = event.description
        self.timestamp = event.timestamp
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

    func editEvent() async {
        guard let id = eventID else {
            isError = true
            errorString = "Missing event id."
            return
        }

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
        didSaveEvent = false
        isSubmitting = true

        do {
            try await EventService.shared.editEvent(
                id: id,
                title: title,
                description: description,
                timestamp: timestamp,
                location: location,
                uiImage: uiImage
            )
            loadingState = .success
            didSaveEvent = true
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
