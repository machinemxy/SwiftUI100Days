//
//  TestView.swift
//  Edutainment
//
//  Created by Ma Xueyuan on 2019/11/24.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct TestView: View {
    let maxNumber: Int
    let questionAmount: Int
    let questions: [Question]
    
    @State private var questionId = 0
    @State private var answer = ""
    @State private var star = 0
    @State private var showAlert = false
    @State private var gameOver = false
    @State private var title = ""
    @State private var message = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
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
        .alert(isPresented: $gameOver) {
            Alert(title: Text("Your test is over"), message: Text("You got \(star) ⭐️"), dismissButton: .default(Text("Back to setting"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
    
    init(maxNumber: Int, questionAmount: Int) {
        self.maxNumber = maxNumber
        self.questionAmount = questionAmount
        
        var tempQuestions = [Question]()
        for i in 1...maxNumber {
            for j in 1...maxNumber {
                let question = Question(description: "\(i) * \(j) = ", answer: "\(i * j)")
                tempQuestions.append(question)
            }
        }
        tempQuestions.shuffle()
        let sa = tempQuestions.count - questionAmount
        if sa > 0 {
            tempQuestions.removeLast(sa)
        }
        self.questions = tempQuestions
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

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(maxNumber: 2, questionAmount: 5)
    }
}
