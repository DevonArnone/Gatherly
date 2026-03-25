//
//  EventMapView.swift
//  Gatherly
//
//  Created by Devon Arnone on 3/17/26.
//

import MapKit
import SwiftUI

struct EventMapView: View {
    @State private var vm = EventsMapViewModel()
    @State private var position = MapCameraPosition.automatic
    @State private var selectedEvent: Event?

    var body: some View {
        MapReader { _ in
            Map(position: $position) {
                ForEach(vm.annotations) { annotation in
                    Annotation(annotation.event.title, coordinate: annotation.coordinate) {
                        Button {
                            selectedEvent = annotation.event
                        } label: {
                            Image(systemName: "mappin")
                                .font(.largeTitle)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .overlay {
                if case .loading = vm.loadingState {
                    ProgressView("Loading map...")
                }
            }
            .task {
                do {
                    try await vm.load()
                } catch let error as ErrorType {
                    vm.isError = true
                    vm.errorString = error.localizedDescription
                } catch {
                    vm.isError = true
                    vm.errorString = ErrorType.geocodingError.localizedDescription
                }
            }
            .sheet(item: $selectedEvent) { event in
                MapDetailView(event: event)
            }
            .alert("There was an error", isPresented: $vm.isError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(vm.errorString)
            }
        }
    }
}

#Preview {
    EventMapView()
}
