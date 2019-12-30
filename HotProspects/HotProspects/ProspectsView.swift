//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Ma Xueyuan on 2019/12/30.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    enum SortBy {
        case alphabet, mostRecent
    }
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    @EnvironmentObject var prospects: Prospects
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.sortedPeople
        case .contacted:
            return prospects.sortedPeople.filter { $0.isContacted }
        case .uncontacted:
            return prospects.sortedPeople.filter { !$0.isContacted }
        }
    }
    
    @State private var isShowingScanner = false
    @State private var isShowingSortSheet = false
    @State private var sortBy = SortBy.alphabet
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        if self.filter == .none {
                            if prospect.isContacted {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "questionmark.diamond")
                                    .foregroundColor(.yellow)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .contextMenu {
                        Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted" ) {
                            self.prospects.toggle(prospect)
                        }
                        if !prospect.isContacted {
                            Button("Remind Me") {
                                self.addNotification(for: prospect)
                            }
                        }
                    }
                }.onDelete(perform: delete)
            }
            .navigationBarTitle(title)
            .navigationBarItems(leading: Button(action: {
                self.isShowingSortSheet = true
            }, label: {
                Text("Sort")
            })
            ,trailing: Button(action: {
                self.isShowingScanner = true
            }) {
                Image(systemName: "qrcode.viewfinder")
                Text("Scan")
            })
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: self.handleScan)
            }
            .actionSheet(isPresented: $isShowingSortSheet) {
                ActionSheet(title: Text("Sort by"), message: nil, buttons: [
                    .default(Text("Alphabet"), action: {
                        self.prospects.sortBy = .alphabet
                    }),
                    .default(Text("Most recent"), action: {
                        self.prospects.sortBy = .mostRecent
                    })
                ])
            }
        }
    }
    
    func delete(atOffsets indexSet: IndexSet) {
        prospects.delete(atOffsets: indexSet)
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }

            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]

            self.prospects.add(person)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()

        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default

            //var dateComponents = DateComponents()
            //dateComponents.hour = 9
            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }

        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}

struct ProspectView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
