//
//  ProfileViewModel.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/16/26.
//

import Foundation
import PhotosUI
import SwiftUI
import UIKit

@Observable
final class ProfileViewModel {
    let tabs = ["RSVP'd", "Past Events"]
    var selectedTab: String = "RSVP'd"
    var selectedPhoto: PhotosPickerItem?
    var uiImage: UIImage?
    var image: Image? {
        if let uiImage = uiImage {
            return Image(uiImage: uiImage)
        }
        return nil
    }

    func selectTab(tab: String) {
        selectedTab = tab
        filterEvents()
    }

    func filterEvents() {
        // No-op for now
    }

    func loadImage() async {
        if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
            uiImage = UIImage(data: data)
        }
    }
}
