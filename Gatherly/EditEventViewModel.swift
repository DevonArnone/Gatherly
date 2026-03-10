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
    var isSaving: Bool = false
    var errorMessage: String?

    init(event: Event) {
        self.eventID = event.id
        self.title = event.title
        self.location = event.location
        self.description = event.description
        self.timestamp = event.timestamp
    }

    func loadImage() async {
        if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
            let loadedImage = UIImage(data: data)
            uiImage = loadedImage
            if let loadedImage, let imageData = loadedImage.jpegData(compressionQuality: 0.8) {
                base64String = imageData.base64EncodedString()
            } else {
                base64String = nil
            }
        }
    }

    func editEvent() async -> Bool {
        guard let id = eventID else {
            errorMessage = "Missing event id."
            return false
        }

        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please fill out all fields."
            return false
        }

        isSaving = true
        errorMessage = nil
        defer { isSaving = false }

        do {
            try await EventService.shared.editEvent(
                id: id,
                title: title,
                description: description,
                timestamp: timestamp,
                location: location,
                uiImage: uiImage
            )
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
