//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Zoltan Vegh on 06/04/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello world!")
        }
    }
    
    func executeDelete() {
        print("Now deleting...")
    }
}

#Preview {
    ContentView()
}
