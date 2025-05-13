//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Zoltan Vegh on 06/04/2025.
//

import SwiftUI

// Create a custom ViewModifier (and accompanying View extension) that makes a view have a large, blue font suitable for prominent titles in a view.
struct LargeBlue: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.blue)
    }
}

extension View {
    func largeBlueStyle() -> some View {
        modifier(LargeBlue())
    }
}

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State var correctAnswer  = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score: Int = 0
    @State private var questionsAsked: Int = 0
    
    private var questionLimit: Int = 8
    @State private var showingFinalScore: Bool = false
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
    
    @State private var rotationAmounts = [0.0, 0.0, 0.0]
    @State private var selectedFlag: Int? = nil
    
    // Go back to project 2 and replace Image view used for flags with the new FlagImage() view that renders one flag
    // image using the specific set of modifiers we had.
    struct FlagImage: View {
        var country: String

        var body: some View {
            Image(country)
                .clipShape(.capsule)
                .shadow(radius: 5)
        }
    }
    
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
                            .largeBlueStyle()
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            // anim for the tapped flag
                            withAnimation(.easeInOut(duration: 1)) {
                                rotationAmounts[number] += 360
                                selectedFlag = number
                            }
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                        }
                        .accessibilityLabel(labels[countries[number]], default: "Unknown Flag")
                        .rotation3DEffect(
                            .degrees(rotationAmounts[number]),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        // animations for the other 2 flags
                        .opacity(selectedFlag == nil || selectedFlag == number ? 1: 0.25)
                        .scaleEffect(selectedFlag == nil || selectedFlag == number ? 1: 0.75)
                        .animation(.easeInOut(duration: 0.5), value: selectedFlag)
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
        rotationAmounts = [0.0, 0.0, 0.0]
        selectedFlag = nil
    }
    
    func executeDelete() {
        print("Now deleting...")
    }
    
    func restartGame() {
        score = 0
        questionsAsked = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        rotationAmounts = [0.0, 0.0, 0.0]
        selectedFlag = nil
        
    }
}
    
#Preview {
    ContentView()
}
