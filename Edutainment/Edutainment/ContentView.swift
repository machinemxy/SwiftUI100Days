//
//  ContentView.swift
//  Edutainment
//
//  Created by Ma Xueyuan on 2019/11/15.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct Question {
    var description = ""
    var answer = ""
}

struct ContentView: View {
    @State private var isSetting = true
    @State private var maxNumber = 9
    @State private var questionAmountId = 0
    @State private var questionId = 0
    @State private var questions = [Question(description: "1 * 1 = ", answer: "1")]
    @State private var answer = ""
    @State private var star = 0
    @State private var showAlert = false
    @State private var gameOver = false
    @State private var title = ""
    @State private var message = ""
    
    var questionAmountList = [5, 10, 20, 144]
    var describeList = ["5", "10", "20", "All"]
    
    var body: some View {
        Form {
            if isSetting {
                Section(header: Text("Max number")) {
                    Stepper(value: $maxNumber, in: 1...12) {
                        Text("\(maxNumber)")
                    }
                }
                
                Section(header: Text("Question Amount")) {
                    Picker("", selection: $questionAmountId) {
                        ForEach(0 ..< describeList.count) {
                            Text(self.describeList[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Are you ready?")) {
                    Button("Start", action: generateQuestions)
                }
            } else {
                Section(header: Text("Question \(questionId + 1) / \(questions.count)"),
                        footer: Text("⭐️: \(star)")) {
                    HStack {
                        Text(questions[questionId].description)
                        TextField("", text: $answer).keyboardType(.numberPad).textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Button("Submit", action: checkAnswer)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("Next"), action: next))
                }
            }
        }
        .alert(isPresented: $gameOver) {
            Alert(title: Text("Your test is over"), message: Text("You got \(star) ⭐️"), dismissButton: .default(Text("Back to setting"), action: {
                withAnimation {
                    self.isSetting.toggle()
                }
            }))
        }
    }
    
    func generateQuestions() {
        questions.removeAll()
        star = 0
        questionId = 0
        answer = ""
        
        for i in 1...maxNumber {
            for j in 1...maxNumber {
                let question = Question(description: "\(i) * \(j) = ", answer: "\(i * j)")
                questions.append(question)
            }
        }
        questions.shuffle()
        let sa = questions.count - questionAmountList[questionAmountId]
        if sa > 0 {
            questions.removeLast(sa)
        }
        withAnimation {
            isSetting.toggle()
        }
        
    }
    
    func checkAnswer() {
        if answer == questions[questionId].answer {
            title = "🐰Correct!"
            message = "You got a ⭐️!"
            star += 1
        } else {
            title = "🐷Wrong!"
            message = "You are as foolish as a pig."
        }
        showAlert.toggle()
    }
    
    func next() {
        if questionId == questions.count - 1 {
            gameOver.toggle()
        } else {
            questionId += 1
            answer = ""
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
