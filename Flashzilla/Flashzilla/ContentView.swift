//
//  ContentView.swift
//  Flashzilla
//
//  Created by Ma Xueyuan on 2019/12/31.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    static let maxTime = 100
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    
    @State private var cards = [Card]()
    @State private var timeRemaining = Self.maxTime
    @State private var isActive = true
    @State private var showingEditScreen = false
    @State private var showingTimeUpAlert = false
    @State private var showingSettingSheet = false
    @State private var engine: CHHapticEngine?
    @State private var putCardBackWhenWrong = false
    @State private var antiSwipeTooFastProperty = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Time: \(timeRemaining)")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(Color.black)
                        .opacity(0.75)
                )
                
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: self.cards[index], wrongAction: {
                            withAnimation {
                                if self.putCardBackWhenWrong {
                                    self.addCardToLast(at: index)
                                } else {
                                    self.removeCard(at: index)
                                }
                            }
                        }, correctAction: {
                            withAnimation {
                                self.removeCard(at: index)
                            }
                        })
                        .stacked(at: index, in: self.cards.count)
                        .allowsHitTesting(index == self.cards.count - 1)
                        .accessibility(hidden: index < self.cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0 && !antiSwipeTooFastProperty)
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Button(action: {
                        self.showingSettingSheet = true
                    }) {
                        Image(systemName: "gear")
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                    }
                    
                    Spacer()

                    Button(action: {
                        self.showingEditScreen = true
                    }) {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }

                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || accessibilityEnabled {
                VStack {
                    Spacer()

                    HStack {
                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answer as being incorrect."))
                        Spacer()

                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text("Mark your answer as being correct."))
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard self.isActive else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                
                if self.timeRemaining == 1 {
                    self.prepareHaptics()
                }
            } else {
                // time up
                self.isActive = false
                self.showingTimeUpAlert = true
                
                // make a custom viberation!
                self.performTimeUpHatic()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            self.isActive = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if self.cards.isEmpty == false {
                self.isActive = true
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
            EditCards()
        }
        .onAppear(perform: resetCards)
        .alert(isPresented: $showingTimeUpAlert) {
            Alert(title: Text("Time Up"), message: nil, dismissButton: .default(Text("Reset"), action: {
                self.resetCards()
            }))
        }
        .actionSheet(isPresented: $showingSettingSheet) {
            ActionSheet(title: Text("Setting"), message: Text("What should the app do when you are wrong?"), buttons: [
                .default(Text("Remove the card"), action: {
                    self.putCardBackWhenWrong = false
                    print(self.cards)
                }),
                .default(Text("Put the card to the last"), action: {
                    self.putCardBackWhenWrong = true
                    print(self.cards)
                })
            ])
        }
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        
        cards.remove(at: index)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func addCardToLast(at index: Int) {
        guard index >= 0 else { return }
        
        let newCard = cards[index]
        cards.remove(at: index)
        antiSwipeTooFastProperty = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.cards.insert(newCard, at: 0)
            self.antiSwipeTooFastProperty = false
        }
    }
    
    func resetCards() {
        timeRemaining = Self.maxTime
        isActive = true
        loadData()  
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func performTimeUpHatic() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create intense, sharp tap
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * 10))
    }
}
