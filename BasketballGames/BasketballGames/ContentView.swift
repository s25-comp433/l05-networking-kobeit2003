//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var results: [Game]
}

struct Game: Codable {
    var id: Int
    var team: String
    var opponent: String
    var date: String
    var score: Score
    var isHomeGame: Bool
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var results = [Game]()

    var body: some View {
        NavigationView {
            List(results, id: \.id) { game in
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(game.team) vs. \(game.opponent)")
                        Spacer()
                        Text("\(game.score.unc) - \(game.score.opponent)")
                    }
                    .font(.headline)
                    .fontWeight(.regular)
                    HStack {
                        Text(game.date)
                        Spacer()
                        Text(game.isHomeGame ? "Home" : "Away")
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
            }.navigationTitle("UNC Basketball")
        }
        .task {
            await loadData()
        }
    }

    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()

            if let decodedResponse = try? decoder.decode(Response.self, from: data) {
                results = decodedResponse.results
            } else if let decodedGames = try? decoder.decode([Game].self, from: data) {
                results = decodedGames
            }
        } catch {
            print("Invalid Data")
        }
    }
}

#Preview {
    ContentView()
}
