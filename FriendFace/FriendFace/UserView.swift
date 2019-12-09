//
//  UserView.swift
//  FriendFace
//
//  Created by Ma Xueyuan on 2019/12/09.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct UserView: View {
    var userList: [User]
    var userId: String
    var user: User
    
    var body: some View {
        Form {
            Section(header: Text("Info")) {
                Text("Status: \(user.isActive ? "🟢Active" : "🔴Inactive")")
                Text("Age: \(user.age)")
                Text("Company: \(user.company)")
                Text("Email: \(user.email)")
                Text("Address: \(user.address)")
                Text("Registered: \(user.displayRegistered)")
            }
            
            Section(header: Text("About")) {
                Text(user.about).font(.subheadline)
            }
            
            Section(header: Text("Tags")) {
                Text(user.displayTags)
                    .font(.subheadline)
                .bold()
            }
            
            Section(header: Text("Friends")) {
                ForEach(user.friends) { friend in
                    NavigationLink(destination: UserView(userList: self.userList, userId: friend.id)) {
                        Text(friend.name)
                    }
                }
            }
        }
        .navigationBarTitle(user.name)
    }
    
    init(userList: [User], userId: String) {
        guard let user = userList.first(where: { (u) -> Bool in
            u.id == userId
        }) else {
            fatalError("Invalid user.")
        }
        
        self.user = user
        self.userList = userList
        self.userId = userId
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(id: "123", isActive: true, name: "Cecil Ma", age: 30, company: "Mushoku", email: "cma@me.com", address: "No.8 Mejirodai, Tokyo", about: "An iOS developer.", registered: "2019-11-12T12:13:14-00:00", tags: ["swift", "iOS", "engineer"], friends: [Friend(id: "123", name: "Friend A"), Friend(id: "123", name: "Friend B")])
        let testUserList = [testUser]
        return UserView(userList: testUserList, userId: "123")
    }
}
