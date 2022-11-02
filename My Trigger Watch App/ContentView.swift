//
//  ContentView.swift
//  My Trigger Watch App
//
//  Created by Koray KIRCAOGLU on 11/1/22.
//

import SwiftUI

var gotResult = false;

func setTrigger(command:String) async{
    let url = URL(string: "http://192.168.4.67:1337/")!
    var request = URLRequest(url: url);
    let body: [String: String] = ["command": command, "device": "watch"]
 
    do{
        let finalBody = try JSONSerialization.data(withJSONObject: body)
        
        request.httpMethod = "POST";
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept");
        
        let (data, _) = try await URLSession.shared.data(for: request)
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            // try to read out a string array
            if let result = json["result"] as? [String] {
                print(result)
            }
        }
        gotResult = true
        await fetchData()
    }catch{
        print(error)
    }

}

func fetchData() async {
        
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Select Trigger")
            Button("Sleep"){
                Task {
                    await setTrigger(command: "sleep")
                }
            }
            .foregroundColor(Color.black)
            .background(Color.init(UIColor(red:235/255, green:180/255, blue:52/255, alpha: 1)))
            .cornerRadius(25)
            
            
            HStack{
                Button(action:{
                    Task {
                        await setTrigger(command: "fav")
                    }
                },label: {
                    Text("FAV")
                })
                .background(Color.blue)
                .contentShape(Circle())
                .cornerRadius(30)
                
                Button(action:{
                    Task {
                        await setTrigger(command: "turnoff")
                    }
                },label: {
                    Text("Off")
                })
                .background(Color.red)
                .contentShape(Circle())
                .cornerRadius(30)
                .frame(width: 60)
            }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
