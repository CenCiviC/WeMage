//
//  FriendGalleryView.swift
//  MCCamera
//
//  Created by kyungbin on 2023/06/07.
//

import SwiftUI

struct FriendGalleryView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject public var friend : Friend
    @State private var selectedIndex : Int? = nil
    @State private var deleteAlertMsg : Bool = false
    @State private var doSelecting : Bool = false
    @State private var selectedcnt : Int = 0
    @State private var alertSave : Bool = false
    
    var body: some View {
        let columns = [
            GridItem(.flexible(), spacing: 1),
            GridItem(.flexible(), spacing: 1),
            GridItem(.flexible(), spacing: 1),
            GridItem(.flexible(), spacing: 1),
            GridItem(.flexible(), spacing: 1)
        ]
        
        let imgSize = (UIScreen.screenWidth/5)-1.2
        
        
        VStack{
            HStack{
                Button(action : {dismiss()}){
                    
                    Image(systemName: "chevron.left")
                        .foregroundColor(.mainColor)
                }
                
                Spacer()
                Text(friend.peerId.displayName)
                Spacer()
                
                Text("전체 삭제")
                    .foregroundColor(.red)
                    .padding(.trailing, 30)
                    .onTapGesture {
                        deleteAlertMsg = true
                    }.alert("앨범에 저장된 사진 이외의 사진을 지우시겠습니까?", isPresented: $deleteAlertMsg) {
                        Button("삭제") {
                            friend.deleteAllImg()
                        }.foregroundColor(.red)
                        Button("취소") {
                            print("cnlth")
                        }
                        
                        
                        
                       
                    }
                
                Button(doSelecting ? "취소" : "선택"){
                    if(doSelecting){
                        friend.cancellSelection()
                    }
                    
                    doSelecting.toggle()
                    
                }
            }
                    .foregroundColor(.mainColor)
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.horizontal, 30)
                
                Divider()
                    .background(Color.mainColor)
                
                //picture display
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        //                         if viewModel.photoDatas != nil {
                        //                             ForEach(viewModel.photoDatas!, id: \.self) { data in
                        //                                 Image(uiImage: UIImage(data: data)!)
                        //                                     .resizable()
                        //                                     .frame(width: imgSize, height: imgSize)
                        //                                     .scaledToFit()
                        //
                        //                             }
                        //                         }
                        
                        
                        ForEach(Array(friend.images.enumerated()), id: \.offset) { index, imgType in
                           
                            ZStack{
                                Image(uiImage: imgType.img)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: imgSize, height: imgSize)
                                        .clipped()
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay(
                                            Rectangle()
                                                .stroke(!imgType.isStored ?   Color.white:  Color.mainColor, lineWidth: 1)
                                        )
                                     
                                  
                            
                                imgType.isSelected && doSelecting ?
                                    ZStack{
                                        Rectangle()
                                            .frame(width: imgSize, height: imgSize)
                                            .foregroundColor(.black)
                                            .opacity(0.7)
                                
                                        Image(systemName: "checkmark.circle")
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.mainColor)
                                       
                                    }
                                : nil
                            }
                            .onTapGesture {
                                if(doSelecting){
                                    var newImgType = imgType
                                    newImgType.toggleSelect()
                                    friend.images[index] = newImgType
                                    selectedcnt = friend.selectedImgCount()
                                    print(selectedcnt)
                                }else{
                                    selectedIndex = index
                                }
                            }
                            
                            
                            
                        
                                    
                            
                            
                            
                            
                            
                        }
                        .fullScreenCover(item: $selectedIndex){ index in
                            ImageDetailView(imageIndex: index, friend: friend)
                            
                        }
                        
                        
                        
                        
                        
                    }
                    
                }
            if(doSelecting){
                HStack{
                    Spacer()
                    Button(action: {
                        friend.imgStore()
                        alertSave.toggle()
                    }){
                        Text("\(selectedcnt)장의 사진을 앨범에 저장")
                            .padding(.vertical, 30)
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                    }
              
                        
                    Spacer()
                }.edgesIgnoringSafeArea(.bottom)
                    .background(Color.mainColor)
                
                
                
               
                    
            }
            
        }.alert("저장되었습니다.", isPresented: $alertSave){
            Button("확인"){
                doSelecting.toggle()
                
            }
        }
            
        }
    }

//struct FriendGalleryView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendGalleryView()
//    }
//}
