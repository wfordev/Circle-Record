//
//  EventLogView.swift
//  Circle Record
//
//  Created by watabe on 2020/04/19.
//  Copyright © 2020 watabe. All rights reserved.
//

import SwiftUI

struct BookInfo: Codable, Identifiable {
    var id:Int
    var title:String
    var date:String
    var circ:String//部数
    var cost:String//原価
    var totalCost:String//印刷費
    var price:String
}

struct EventLogView: View, MyProtocol {
    @State var books: [BookInfo] = []
    @State var dateStr:String = ""
    
    func loadInfo() {
        let decoder = JSONDecoder()
        let userDefaults: UserDefaults = UserDefaults.standard
        guard let data = userDefaults.data(forKey: "BOOKS_INFO") else {
            print("contentsArray cannot be found in UserDefaults")
            return
        }
        do {
            books = try decoder.decode([BookInfo].self, from: data)
        } catch {
            print(error)
        }
    }
    func saveInfo(){
        let userDefaults: UserDefaults = UserDefaults.standard
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(books)
            userDefaults.set(data, forKey: "BOOKS_INFO")
        }catch{
            print(error)
            return
        }
    }
    

    @State private var isPresented = false
    
    var body: some View {
        VStack {
            Button(action: {
                self.isPresented.toggle()
            }) {
                Text("add")
            }.sheet(isPresented: self.$isPresented) {
                RegisterView(isPresent: self.$isPresented, delegate: self)
            }
            
            List(books) { book in
                HStack{
                    Text(book.title)
                    Text(book.cost)
                    Text(book.circ)
                    Text(book.price)
                    Text(book.date)
                }
            }.onAppear{
                self.loadInfo()
            }
                
                
            }
        }
    
}

protocol MyProtocol {
    func loadInfo()
}

struct RegisterView: View {
    @State var title = ""
    @State var totalCost = ""//insatuhi
    @State var date = Date()
    @State var circ = ""//busuu
    @State var price = ""//urine
    
    @Binding var isPresent: Bool// SecondViewの表示/非表示
    
    var delegate: MyProtocol
    
    func registerInfo(){
        let cost:Double = ceil(atof(totalCost)/atof(circ))
        let _cost =  String("\(cost)")
        var _date = ""
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        _date = formatter.string(from: date)
    
       
        let newBook:BookInfo = BookInfo.init(id: 0, title: title, date: _date, circ: circ, cost: _cost, totalCost: totalCost, price: price)
        
        var books:[BookInfo] = []
        let decoder = JSONDecoder()
        let userDefaults: UserDefaults = UserDefaults.standard
        //guard let data = userDefaults.data(forKey: "BOOKS_INFO") else {
          //  print("contentsArray cannot be found in UserDefaults")
            //return
        //}
        if let data = userDefaults.data(forKey: "BOOKS_INFO"){
            do {
                books = try decoder.decode([BookInfo].self, from: data)
            } catch {
                print(error)
            }
        }
        books.append(newBook)
        
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(books)
            userDefaults.set(data, forKey: "BOOKS_INFO")
        }catch{
            print(error)
            return
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("登録内容")) {
                    TextField("タイトル", text: $title)
                    TextField("印刷費", text: $totalCost).keyboardType(.numberPad)
                    TextField("部数", text: $circ).keyboardType(.numberPad)
                    TextField("設定価格", text: $price).keyboardType(.numberPad)
                    DatePicker("支払い日", selection: $date, displayedComponents: .date)
                }
                Section(header: Text("")) {
                    Button("登録", action: {
                        self.registerInfo()
                        self.isPresent = false
                        self.delegate.loadInfo()
                    })
                }
            }
            .navigationBarTitle("商品を登録", displayMode: .inline)
            // FirstViewへ戻る
            .navigationBarItems(trailing:
                Button(action: {
                    self.isPresent = false
                }) {
                    Text("Done")
                }
            )
        }
    }
}


struct EventLogView_Previews: PreviewProvider {
    static var previews: some View {
        EventLogView()
    }
}








