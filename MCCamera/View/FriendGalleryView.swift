//
//  FriendGalleryView.swift
//  MCCamera
//
//  Created by kyungbin on 2023/06/07.
//

import SwiftUI

struct FriendGalleryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject public var friend : Friend
    @State private var selectedIndex : Int? = nil
    @State private var deleteAlertMsg : Bool = false
    @State private var doSelecting : Bool = false
    
    
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
                        }
                        Button("취소") {
                            print("cnlth")
                        }
                        
                        
                        
                       
                    }
                
                Button(doSelecting ? "취소" : "선택"){
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
                                  
                            
                                imgType.isSelected && doSelecting ?
                                    ZStack{
                                        Rectangle()
                                            .frame(width: imgSize, height: imgSize)
                                            .foregroundColor(.black)
                                            .opacity(0.7)
                                
                                        Circle()
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(.blue)
                                    }
                                : nil
                            }
                            .onTapGesture {
                                if(doSelecting){
                                    imgType.toggleSelect()
                                    print("\(imgType.isSelected)")
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
            }
            
        }
    }

//struct FriendGalleryView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendGalleryView()
//    }
//}
