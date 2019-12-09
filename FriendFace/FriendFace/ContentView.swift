//
//  ContentView.swift
//  FriendFace
//
//  Created by Ma Xueyuan on 2019/12/08.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var users = Users()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users.userList) { user in
                    NavigationLink(destination: UserView(userList: self.users.userList, userId: user.id)) {
                        HStack {
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(self.activeColor(user.isActive))
                            VStack(alignment: .leading) {
                                Text(user.name).font(.headline)
                                Text(user.company).font(.subheadline)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .onAppear(perform: loadData)
            .navigationBarTitle("FriendFace")
        }
    }
    
    func loadData() {
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                fatalError("No data in response.")
            }
                
            if let decoded = try? JSONDecoder().decode([User].self, from: data) {
                DispatchQueue.main.async {
                    self.users.userList = decoded
                }
            } else {
                fatalError("Invalid response from server.")
            }
        }.resume()
    }
    
    func activeColor(_ isActive: Bool) -> Color {
        isActive ? .green : .red
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
