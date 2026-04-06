//
//  ProfileView.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/16/26.
//

import SwiftUI
import PhotosUI
import SwiftData

struct ProfileView: View {
    @Bindable var vm: ProfileViewModel
    @Environment(\.modelContext) private var modelContext
    @Query var upcomingEvents: [RSVPedEvent]
    @Query var pastEvents: [RSVPedEvent]
    @Query var profiles: [UserProfile]

    var profile: UserProfile? { profiles.first }

    init(vm: ProfileViewModel) {
        _vm = Bindable(vm)
        let now = Date.now
        _upcomingEvents = Query(
            filter: #Predicate { event in
                event.timestamp >= now
            }
        )
        _pastEvents = Query(
            filter: #Predicate { event in
                event.timestamp < now
            }
        )
    }

    var body: some View {
        List {
            VStack(spacing: 24) {
                PhotosPicker(selection: $vm.selectedPhoto, matching: .images) {
                    Group {
                        if let image = vm.image {
                            image
                                .resizable()
                                .scaledToFill()
                        } else if let data = profile?.imageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray4))
                                Image(systemName: "plus")
                                    .font(.system(size: 36, weight: .light))
                                    .foregroundStyle(.primary)
                            }
                        }
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                }
                .task(id: vm.selectedPhoto) {
                    await vm.loadImage(profile: profile, modelContext: modelContext)
                }

                Text("John Smith")
                    .font(.title2)
                    .fontWeight(.semibold)

                HStack(spacing: 0) {
                    ForEach(vm.tabs, id: \.self) { tab in
                        Button {
                            vm.selectTab(tab: tab)
                        } label: {
                            VStack {
                                Text(tab)
                                    .foregroundStyle(.primary)
                                Rectangle()
                                    .fill(vm.selectedTab == tab ? Color.cyan : Color.clear)
                                    .frame(height: 2)
                                    .padding(.top, 4)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.top, 20)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            if vm.selectedTab == "RSVP'd" {
                ForEach(upcomingEvents) { event in
                    ProfileEventCardView(event: event)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(upcomingEvents[index])
                    }
                }
            } else {
                ForEach(pastEvents) { event in
                    ProfileEventCardView(event: event)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(pastEvents[index])
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    ProfileView(vm: ProfileViewModel())
}
