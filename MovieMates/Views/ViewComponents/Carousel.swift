/**
 
 - Description:
    The struct that makes the carousel on the "discover" tab on HomeView.
    This view get an array, then calculate size of elements to display(images) then recreate horizontal carousel of element with specific distance between element and the return element as closure. Great thanks to manuelduarte077 github user
 (https://github.com/manuelduarte077/CustomCarouselList) for original idea of carousel
 
 - Authors:
    Karol Ö
    Oscar K
    Sarah L
    Joakim A
    Denis R
    Gustav S
 
 */

import SwiftUI

struct Carousel<Content: View, T: Identifiable>: View {
    
    var content: (T) -> Content
    var list: [T]
    
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    @Binding var index: Int
    
    
    //init list and spacing between list elements in carousel
    init(spacing: CGFloat = 15, trailingSpace: CGFloat = 100, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T)->Content){
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self.content = content
        self._index = index
    }
    
    
    var body: some View {
        
        //Getting size of element to calculate offsets and place for all elements
        GeometryReader{proxy in
            let width = proxy.size.width - ( trailingSpace - spacing )
            let adjustMentWidth = (trailingSpace / 2) - spacing
            
            HStack (spacing: spacing) {
                ForEach(list) { item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
                
            }
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(currentIndex) * -width) + ( currentIndex != 0 ? adjustMentWidth : 0 ) + offset)
            .gesture(
                //working with a Drag gesture and updating current index of shown element accordingly
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        //updating translation of element and position in carousel
                        
                        let offsetX = value.translation.width
                        
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        currentIndex = index
                    })
                //changing a current index of element which is displayed
                    .onChanged({ value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        
                    })
            )
            
        }
        .animation(.easeInOut, value: offset == 0)
        
    }
}
