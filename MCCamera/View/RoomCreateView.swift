//
//  RoomCreateView.swift
//  MCCamera
//
//  Created by kyungbin on 2023/05/25.
//

//
//  RoomCreateView.swift
//  DesignTest
//
//  Created by kyungbin on 2023/05/18.
//

import SwiftUI

struct RoomCreateView: View {
    @State var doSearch : Bool = false
    
    var body: some View {
        VStack(alignment: .leading){
            Profile()
            Spacer()
            
            
            if doSearch{
                PendingList()
                Spacer()
                ConnectedList()
            }else{
                VStack{
                    Spacer()
                    SearchUser(doSearch: self.$doSearch)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                    Spacer()
                }
               
            }
            
       
            
        }
        .padding(EdgeInsets(top: 80, leading: 30, bottom: 80, trailing: 30))
        .navigationBarBackButtonHidden(true)
       
        
      
    }
}

struct RoomCreateView_Previews: PreviewProvider {
    static var previews: some View {
        RoomCreateView()
    }
}

//profile
struct Profile: View{
    var body: some View{
        HStack(alignment: .center){
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 70, height: 70)
                .padding([.trailing], 10)
            Text("임경빈")
                .font(.system(.title))
            Spacer()
        }
    }
}

//pending list
struct PendingList: View{
    let data = ["1", "2", "3", "4", "5", "6", "7"]
    let layout = [
        GridItem(.adaptive(minimum:60))
    ]
    
    var body: some View {
        Text("대기 중..")
            .font(.title2)
        
        LazyVGrid(columns: layout, spacing: 30){
            ForEach(data, id: \.self){ item in
                LazyVStack{
                    OtherProfile(name: "임경빈")
                }
            }
        }
    }
}

//connected list
struct ConnectedList: View{
    let data = ["1", "2", "3", "4", "5", "6", "7"]
    let layout = [
        GridItem(.adaptive(minimum:60))
    ]
    
    var body: some View {
        Text("연결됨")
            .font(.title2)
        
        LazyVGrid(columns: layout, spacing: 30){
            ForEach(data, id: \.self){ item in
                LazyVStack{
                    OtherProfile(name: "김수환")
                }
            }
        }
    }
}

//other profile
struct OtherProfile: View{
    var name: String
    
    var body: some View{
        VStack{
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
            
            Text(name)
        }
    }
}

//searching user

struct SearchUser: View{
    @Binding var doSearch : Bool
    
    var body: some View{
        Button(action: {
            doSearch.toggle()
        }) {
            HStack {
                Image(systemName: "magnifyingglass")
                Text("검색 시작")
            }.padding(10)
                
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                   .stroke(lineWidth: 2)
                   
            )
        }.disabled(doSearch)
    }
}
