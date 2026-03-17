//
//  ProfileView.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/16/26.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Bindable var vm: ProfileViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                PhotosPicker(selection: $vm.selectedPhoto, matching: .images) {
                    Group {
                        if let image = vm.image {
                            image
                                .resizable()
                                .scaledToFill()
                        } else {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 80))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                }
                .task(id: vm.selectedPhoto) {
                    await vm.loadImage()
                }

                Text("First Last")
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
                                    .fill(vm.selectedTab == tab ? Color.cyan : Color.primary)
                                    .frame(height: 2)
                                    .padding(.top, 4)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .padding(.top, 20)
        }
    }
}

#Preview {
    ProfileView(vm: ProfileViewModel())
}
