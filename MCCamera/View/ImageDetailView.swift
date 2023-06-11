//
//  ImageDetailView.swift
//  MCCamera
//
//  Created by kyungbin on 2023/06/09.
//

import SwiftUI

struct ImageDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State public var imageIndex : Int
    
    public var friend : Friend
    let imgSize = UIScreen.screenWidth
    
    var body: some View {
        VStack{
            HStack{
                Button(action : {dismiss()}){
                    
                    Image(systemName: "chevron.left")
                        .foregroundColor(.mainColor)
                }
                
                Spacer()
                Text("\(imageIndex+1)/\(friend.images.count)")
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
                ForEach(Array(friend.images.enumerated()), id: \.offset) { index, imgType in
                        Image(uiImage: imgType.img)
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

//struct ImageDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageDetailView()
//    }
//}
