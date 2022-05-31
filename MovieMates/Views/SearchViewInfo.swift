/**
 
 - Description:
    The text displayed if there's no input / search results
 
 - Authors:
   Karol Ö
   Oscar K
   Sarah L
   Joakim A
   Denis R
   Gustav S

*/

import SwiftUI

struct SearchViewInfo: View {
    
    @Binding var infoText: String
    
    var body: some View {
        Text(infoText)
    }
}
