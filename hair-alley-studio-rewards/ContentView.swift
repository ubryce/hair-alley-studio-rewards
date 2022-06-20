//
//  ContentView.swift
//  hair-alley-studio-rewards
//
//  Created by Bryce Nguyen on 2022-06-17.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isPresented: Bool = false
    @State private var isEditPresented: Bool = false
    @State private var query = ""
    @State private var sheetContent: SheetContent = .add
    @State private var showSheet = false
    @State private var newListName = ""
    @State private var newListNum = 0

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        //predicate: NSPredicate(format: "name == %@", "bryce"),
        animation: .default)
    private var items: FetchedResults<Item>
    
    enum SheetContent {
        case add, edit
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Name: \(item.name ?? "")")
                        TextField("New Client Name", text: $newListName)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                        Text("Rewards: \(item.numOfCuts )")
                            .onAppear{
                                newListNum = Int(item.numOfCuts)
                            }
                        HStack {
                            if ( newListNum != 0 ) {
                                Button("-"){
                                    newListNum = newListNum - 1
                                }
                            }
                            Text("Rewards: \(newListNum)")
                            if ( newListNum == 7 ) {
                                Button("+"){
                                    newListNum = 0
                                }
                            } else {
                                Button("+"){
                                    newListNum = newListNum + 1
                                }
                            }
                        }
                        
                        Button("Confirm Edit"){
                            //editItem()
                            if ( newListName == "") {
                                if ( item.numOfCuts == newListNum ) {
                                    do {
                                        try viewContext.save()
                                    } catch {
                                        // Replace this implementation with code to handle the error appropriately.
                                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                        let nsError = error as NSError
                                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                    }
                                } else {
                                    item.numOfCuts = Int64(newListNum)
                                    do {
                                        try viewContext.save()
                                    } catch {
                                        // Replace this implementation with code to handle the error appropriately.
                                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                        let nsError = error as NSError
                                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                    }
                                }
                            }
                            else {
                                
                                if ( item.numOfCuts == newListNum ) {
                                    item.name = newListName
                                    newListName = ""
                                    do {
                                        try viewContext.save()
                                    } catch {
                                        // Replace this implementation with code to handle the error appropriately.
                                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                        let nsError = error as NSError
                                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                    }
                                } else {
                                    item.numOfCuts = Int64(newListNum)
                                    item.name = newListName
                                    newListName = ""
                                    do {
                                        try viewContext.save()
                                    } catch {
                                        // Replace this implementation with code to handle the error appropriately.
                                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                        let nsError = error as NSError
                                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                    }
                                }
                            }
                        }
                        Button("delete"){
                            //editItem()
                            viewContext.delete(item)
                            do {
                                try viewContext.save()
                            } catch {
                                // Replace this implementation with code to handle the error appropriately.
                                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        }
                    } label: {
                        Text(item.name ?? "")
                    }
                }
                .onDelete(perform: deleteItems)
            }.onDeleteCommand(perform: {print("delete")})
            .toolbar {
                ToolbarItemGroup {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                    
                }
            }.sheet(isPresented: $showSheet, content: {
                switch sheetContent {
                case .add: AddNewListView { newListName, newListNum in }.frame(width: 600, height: 400)
                case .edit: EditListView { newListName, newListNum in }.frame(width: 600, height: 400)
                }
            })
            
            Text("Select an item")
        }.searchable(text: $query)
            .onChange(of: query) { newValue in
                items.nsPredicate = searchPredicate(query: newValue)
            }
    }
    
    private func searchPredicate(query: String) -> NSPredicate? {
        if query.isEmpty {return nil}
        return NSPredicate(format: "%K BEGINSWITH[cd] %@",
                           #keyPath(Item.name),query)
    }
    
    private func itemChange() {
        print("ran")
    }
    
    private func editItem() {
        withAnimation {
            //let newItem = Item(context: viewContext)
            //newItem.timestamp = Date()
            isEditPresented = true
            sheetContent = .edit
            showSheet = true
        }
    }


    private func addItem() {
        withAnimation {
            //let newItem = Item(context: viewContext)
            //newItem.timestamp = Date()
            isPresented = true
            sheetContent = .add
            showSheet = true
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
