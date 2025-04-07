//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Zoltan Vegh on 06/04/2025.
//

import SwiftUI

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State var correctAnswer  = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score: Int = 0
    @State private var questionsAsked: Int = 0
    private var questionLimit: Int = 8
    @State private var showingFinalScore: Bool = false
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)],
                           center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        // Current Score Alert
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        // Game Over Alert
        .alert("Game Over", isPresented: $showingFinalScore) {
            Button("Restart game", action: restartGame)
        } message: {
            Text("Your final score is \(score) out of \(questionLimit)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Wrong! Thats the flag of \(countries[number])"
        }
        
        questionsAsked += 1
        
        if questionsAsked == 8 {
            showingFinalScore = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        if showingFinalScore {
            return
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func executeDelete() {
        print("Now deleting...")
    }
    
    func restartGame() {
        score = 0
        questionsAsked = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}
    
#Preview {
    ContentView()
}
