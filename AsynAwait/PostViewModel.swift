//
//  PostViewModel.swift
//  AsynAwait
//
//  Created by phong on 15/4/25.
//

import Foundation

@MainActor
class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    func fetchPosts() async throws  {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { throw AsyncError.invaildURL }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw AsyncError.invailResponse }
            
            let decodedPosts = try JSONDecoder().decode([Post].self, from: data)
            self.posts = decodedPosts
        } catch {
            
            print("Failed to fetch posts: \(error)")
            throw AsyncError.invalidData
        }
    }
}


struct Post: Identifiable, Codable {
    let id: Int
    let title: String
    let body: String
}

enum AsyncError : Error{
    case invaildURL
    case invailResponse
    case invalidData
}
