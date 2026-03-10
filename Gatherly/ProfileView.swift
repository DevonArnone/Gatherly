//
//  ProfileView.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/16/26.
//

import SwiftUI

struct ProfileView: View {
    @Bindable var vm: ProfileViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.gray)

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

                    Spacer(minLength: 40)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView(vm: ProfileViewModel())
}
