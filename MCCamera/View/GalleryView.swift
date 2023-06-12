//
//  GalleryView.swift
//  MCCamera
//
//  Created by kyungbin on 2023/05/25.
//

//
//  GalleryView.swift
//  CustomCamera
//
//  Created by kyungbin on 2023/05/17.
//

import Foundation
import SwiftUI

struct GalleryView: View {
    @EnvironmentObject private var viewModel : CameraViewModel
    //@State private var scale: CGFloat = 1.0
    @State private var selectedIndex : Int? = nil
    @Binding var isPresentingGallery : Bool
    var userName : String
    
    var body: some View{
        
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
                Button(action : {isPresentingGallery.toggle()}){
                    
                    Image(systemName: "chevron.left")
                        .foregroundColor(.mainColor)
                }
                
                Spacer()
                Text(userName)
                Spacer()
//                Button("선택"){
//                    //사진 선택하는 action
//                    print(imgSize)
//                }
            }
            .foregroundColor(.mainColor)
            .font(.system(size: 18, weight: .semibold))
            .padding(.horizontal, 30)
            
            Divider()
                .background(Color.mainColor)
                
            //picture display
            
            ScrollView {
                     LazyVGrid(columns: columns, spacing: 2) {
                         if viewModel.photoDatas != nil {
                             ForEach(Array(viewModel.photoDatas!.enumerated()) , id: \.offset) { index, data in
                                 Image(uiImage: UIImage(data: data)!)
                                     .resizable()
                                     .scaledToFill()
                                     .frame(width: imgSize, height: imgSize)
                                     .clipped()
                                     .aspectRatio(1, contentMode: .fit)
                                     .onTapGesture {
                                        selectedIndex = index
                                     }


                             }
                             .fullScreenCover(item: $selectedIndex){ index in
                                 MyGalleryDetailView(imageIndex: index)
                                     .environmentObject(viewModel)
                                 
                             }
                         }

                         
                         //test
//                         ForEach(0..<100) { index in
//                                Rectangle()
//                                     .frame(width: imgSize, height: imgSize)
//                                     .foregroundColor(.red)
//
//                         }
                     }
                   
                 }
        }
        
        
  

    }
    
    
    
}
