//
//  ContentView.swift
//  BinaryGame
//
//  Created by Timur Ramazanov on 05.09.2024.
//

import SwiftUI

struct ContentView: View {
    @State var bitsNR = 5
    @State var score = 0
    @State var toGuess = 0
    @State var binString = ""
    @State var input = ""
    @State var isError = false
    @Environment(\.colorScheme) var colorScheme
    
    /// Pow function
    func pow (_ base:Int, _ power:Int) -> Int {
        var answer : Int = 1
        for _ in 0..<power { answer *= base }
        return answer
    }
    
    /// Selects number to guess
    func nextGuess() {
        let max = pow(2, bitsNR - 1) - 1
        withAnimation {
            toGuess = Int.random(in: 3...max)
        }
    }
    
    /// Converts decimal int to binary string and ensures that it has minimum nr bits
    func decToBin(_ number: Int?) -> String {
        /// Ensure the input number is non-nil
        guard let num = number else {
            return "Invalid input"
        }
        
        /// Convert the number to binary string
        let binaryString = String(num, radix: 2)
        
        /// Ensure the binary string has at least bitsNR digits by padding with leading zeros
        let paddedBinaryString = String(repeating: "0", count: max(0, bitsNR - binaryString.count)) + binaryString
        
        return paddedBinaryString
    }
    
    /// Checks if number in input is correct
    func checkAnswer() -> Bool {
        guard let input = Int(input) else {
            print("not int in input")
            return false
        }
        let correct = input == toGuess
        withAnimation {
            isError = !correct
        }
        return correct
        
    }
    
    var body: some View {
        VStack(spacing: 25) {
            VStack(spacing: 32) {
                HStack {
                    Text("Binary Quiz")
                        .bold()
                        .fontDesign(.rounded)
                        .font(.title)
                    Spacer()
                    Picker("NR of binary bit", selection: $bitsNR) {
                        ForEach(4..<11, id:\.self) {
                            Text("\($0) bits")
                                .tag($0)
                        }
                    }
                }
                VStack {
                    Text("Score: \(score)")
                    Text(decToBin(toGuess))
                        .font(.title)
                        .bold()
                }
                VStack {
                    TextField("Decimal number", text: $input)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        .keyboardType(.numberPad)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.red, lineWidth: isError ? 2 : 0)
                            
                        )
                    Button("Check") {
                        if checkAnswer() {
                            score += 1
                            input = ""
                            nextGuess()
                        }
                    }
                    .padding(.horizontal, 48)
                    .padding(.vertical, 16)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .padding(.top, 10)
                    .bold()
                }
            }
            .padding()
            .onAppear {
                isError = false
                nextGuess()
            }
            .background(colorScheme == .light ? .white : .white.opacity(0.2))
            .cornerRadius(20)
            .shadow(radius: 25)
            .padding(30)
            authorLink
        }
    }
    
    var authorLink: some View {
        Link(destination: URL(string: "https://github.com/ramz1t/tictactoe")!, label: {
            HStack(spacing: 5) {
                Text("Made by Ramz1 🇸🇪")
                Image(systemName: "arrow.up.forward.app")
            }
            .bold()
            .foregroundStyle(.secondary)
            .fontDesign(.rounded)
        })
        .bold()
        .foregroundStyle(.secondary)
        .fontDesign(.rounded)
    }
}

#Preview {
    ContentView()
}
