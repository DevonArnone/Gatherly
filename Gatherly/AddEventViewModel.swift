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
    var isSaving: Bool = false
    var errorMessage: String?

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

    func createEvent() async -> Bool {
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
            let createdEvent = try await EventService.shared.createEvent(
                title: title,
                description: description,
                timestamp: timestamp,
                location: location,
                uiImage: uiImage
            )

            guard createdEvent != nil else {
                errorMessage = "Failed to create event."
                return false
            }
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
