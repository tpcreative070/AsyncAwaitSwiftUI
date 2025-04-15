//
//  ContentView.swift
//  AsynAwait
//
//  Created by phong on 15/4/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var viewModel = PostViewModel()
      
      var body: some View {
          NavigationView {
              List(viewModel.posts) { post in
                  VStack(alignment: .leading) {
                      Text(post.title)
                          .font(.headline)
                      Text(post.body)
                          .font(.subheadline)
                          .foregroundColor(.gray)
                  }
                  .padding(.vertical, 4)
              }
              .navigationTitle("Posts")
          }
          .task {
              do {
                  try await viewModel.fetchPosts()
              }
              catch AsyncError.invaildURL {
                  print("Invaild URL")
              }
              catch AsyncError.invailResponse {
                  print("Invalid response")
              }
              catch AsyncError.invalidData {
                  print("Invalid data")
              }
              catch {
                  print("Unexpected error")
              }
            
          }
      }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
