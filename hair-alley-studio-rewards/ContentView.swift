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
    @State private var newListPhone = ""
    @State private var newListNum = 0
    @State private var hover: Bool = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        //predicate: NSPredicate(format: "name == %@", "bryce"),
        animation: .default)
    private var items: FetchedResults<Item>
    
    enum SheetContent {
        case add, edit
    }

    var body: some View {
        NavigationView {
            List {
                Button {
                    isPresented = true
                    addItem()
                } label: {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Add")
                    }
                }.buttonStyle(.plain)
                TextField("Search", text: $query).textFieldStyle(.roundedBorder)
                ForEach(items) { item in
                    NavigationLink {
                        VStack {
                            HStack(alignment: .top){
                                VStack (alignment:.leading){
                                    Text(item.name ?? "")
                                        .font(.system(size: 30).bold())
                                    HStack{
                                        Text(item.phone ?? "")
                                        Text("Rewards: \(item.numOfCuts )")
                                            .onAppear{
                                                newListNum = Int(item.numOfCuts)
                                            }
                                    }
                                }.padding(.leading, 75)
                                Spacer()
                                Button("Delete Client"){
                                    viewContext.delete(item)
                                    do {
                                        try viewContext.save()
                                    } catch {
                                        // Replace this implementation with code to handle the error appropriately.
                                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                        let nsError = error as NSError
                                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                    }
                                }.onHover { isHovered in
                                    hover = isHovered
                                    DispatchQueue.main.async { //<-- Here
                                        if (hover) {
                                            NSCursor.pointingHand.push()
                                        } else {
                                            NSCursor.pop()
                                        }
                                    }
                                }.padding(.trailing, 75)
                            }.padding(.top,65)
                            
                            Spacer()
                            
                            HStack{
                                VStack(alignment: .leading) {
                                    Text("Edit Client").font(.system(size: 20))
                                    TextField("New Name", text: $newListName)
                                        .textFieldStyle(.roundedBorder)
                                    TextField("New Phone", text: $newListPhone)
                                        .textFieldStyle(.roundedBorder)
                                }.padding(.leading, 75)
                                    .padding(.trailing, 75)
                                Spacer()
                                if( item.numOfCuts == 7) {
                                    Text("Free Haircut").font(.system(size: 25).bold())
                                        .padding(.trailing, 75)
                                }
                            }
                            
                            Spacer()
                            
                            HStack {
                                if ( newListNum == 0 ) {
                                    Button("-"){
                                        newListNum = newListNum - 1
                                    }.disabled(newListNum == 0)
                                    
                                }
                                if ( newListNum != 0 ) {
                                    Button("-"){
                                        newListNum = newListNum - 1
                                    }.onHover { isHovered in
                                        hover = isHovered
                                        DispatchQueue.main.async { //<-- Here
                                            if (hover) {
                                                NSCursor.pointingHand.push()
                                            } else {
                                                NSCursor.pop()
                                            }
                                        }
                                    }
                                }
                                Text("Rewards: \(newListNum)")
                                if ( newListNum == 7 ) {
                                    Button("Free"){
                                        newListNum = 0
                                    }
                                    .onHover { isHovered in
                                        hover = isHovered
                                        DispatchQueue.main.async { //<-- Here
                                            if (hover) {
                                                NSCursor.pointingHand.push()
                                            } else {
                                                NSCursor.pop()
                                            }
                                        }
                                    }
                                } else {
                                    
                                    Button("+"){
                                        newListNum = newListNum + 1
                                    }.onHover { isHovered in
                                        hover = isHovered
                                        DispatchQueue.main.async { //<-- Here
                                            if (hover) {
                                                NSCursor.pointingHand.push()
                                            } else {
                                                NSCursor.pop()
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                            Button("Confirm Edit"){
                                //editItem()
                                if ( newListName == "" && newListPhone == "" ) {
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
                                if ( newListName != "" && newListPhone != "" ) {
                                    
                                    if ( item.numOfCuts == newListNum ) {
                                        item.name = newListName
                                        newListName = ""
                                        item.phone = newListPhone
                                        newListPhone = ""
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
                                        item.phone = newListPhone
                                        newListPhone = ""
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
                                if ( newListName != "" && newListPhone == "" ) {
                                    
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
                                if ( newListName == "" && newListPhone != "" ) {
                                    
                                    if ( item.numOfCuts == newListNum ) {
                                        item.phone = newListPhone
                                        newListPhone = ""
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
                                        item.phone = newListPhone
                                        newListPhone = ""
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
                            }.disabled(newListName.isEmpty && newListNum == item.numOfCuts && newListPhone.isEmpty )
                                .onHover { isHovered in
                                    hover = isHovered
                                    DispatchQueue.main.async { //<-- Here
                                        if (hover && newListNum != item.numOfCuts || hover && !newListName.isEmpty || hover && !newListPhone.isEmpty) {
                                            NSCursor.pointingHand.push()
                                        } else {
                                            NSCursor.pop()
                                        }
                                    }
                                }
                                .padding(.bottom, 75)
        
                        }
                        
                    } label: {
                        Text(item.name ?? "").padding(.leading, 10)
                    }
                    .onHover { isHovered in
                        hover = isHovered
                        DispatchQueue.main.async { //<-- Here
                            if (hover) {
                                NSCursor.pointingHand.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                    
                }
            }.sheet(isPresented: $showSheet, content: {
                switch sheetContent {
                case .add: AddNewListView { newListName, newListNum in }.frame(width: 350, height: 300)
                case .edit: EditListView { newListName, newListNum in }.frame(width: 350, height: 300)
                }
            })
            
            Text("Select a Client")
        }.searchable(text: $query)
            .onChange(of: query) { newValue in
                items.nsPredicate = searchPredicate(query: newValue)
            }.frame(width: 700, height: 350)
    }
    
    private func searchPredicate(query: String) -> NSPredicate? {
        if query.isEmpty {return nil}
        return NSPredicate(format: "%K BEGINSWITH[cd] %@ OR %K BEGINSWITH[cd] %@",
                        #keyPath(Item.name),query, #keyPath(Item.phone), query)
    }
    
    private func deleteItem() -> String {
        return "yes"
    }
    
    private func editItem() {
        withAnimation {
            //let newItem = Item(context: viewContext)
            //newItem.timestamp = Date()
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
