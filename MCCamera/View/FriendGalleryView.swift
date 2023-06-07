//
//  FriendGalleryView.swift
//  MCCamera
//
//  Created by kyungbin on 2023/06/07.
//

import SwiftUI

struct FriendGalleryView: View {
    @Environment(\.dismiss) var dismiss
    public var friend : Friend
    
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
                Button("선택"){
                    //사진 선택하는 action
                    print(imgSize)
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
                         
                         
                             ForEach(friend.images, id: \.self) { imgType in
                                 Image(uiImage: imgType.img)
                                     .resizable()
                                     .frame(width: imgSize, height: imgSize)
                                     .scaledToFit()

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
