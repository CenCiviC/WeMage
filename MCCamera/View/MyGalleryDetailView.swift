//
//  MyGalleryDetailView.swift
//  MCCamera
//
//  Created by kyungbin on 2023/06/12.
//

import SwiftUI

struct MyGalleryDetailView: View {
    @EnvironmentObject private var viewModel : CameraViewModel
    @Environment(\.dismiss) var dismiss
    @State public var imageIndex : Int
    
    let imgSize = UIScreen.screenWidth
    
    var body: some View {
        VStack{
            HStack{
                Button(action : {dismiss()}){
                    
                    Image(systemName: "chevron.left")
                        .foregroundColor(.mainColor)
                }
                
                Spacer()
                Text("\(imageIndex+1)/\(viewModel.photoDatas!.count)")
                Spacer()
//                Button("삭제"){
//                    //사진 선택하는 action
//                    print("")
//                }
            }
            .foregroundColor(.mainColor)
            .font(.system(size: 18, weight: .semibold))
            .padding(.horizontal, 30)
            
            Divider()
                .background(Color.mainColor)
            
            
            TabView(selection: $imageIndex) {
                ForEach(Array(viewModel.photoDatas!.enumerated()), id: \.offset) { index, data in
                        Image(uiImage: UIImage(data: data)!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: imgSize, height: imgSize)
                            .clipped()
                            .aspectRatio(1, contentMode: .fit)
                            .tag(index)
                                        
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
        }
        
        
        
        
        
        
    }
}


