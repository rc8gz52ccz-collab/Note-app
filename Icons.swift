import SwiftUI

struct house: View {
    @Binding var activeTab: Int
    
    let neonBlue = Color(red: 0.2, green: 0.7, blue: 1.0)
    let neonPink = Color(red: 0.8, green: 0.3, blue: 0.7)
    
    var body: some View {
        Button(action: {
            withAnimation {
                activeTab = 1
            }
        }) {
            HStack {
                VStack(spacing: 0) {
                    Image(systemName: activeTab == 1 ? "square.fill" : "square" )
                        .font(.system(size: 29, weight: .thin))
                        .rotationEffect(.degrees(-45))
                        .offset(y: 17)
                        .frame(width: 29, height: 26)
                        .clipped()
                        .foregroundStyle(
                            LinearGradient(
                                colors: [neonPink, neonBlue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Image(systemName: activeTab == 1 ? "square.fill" : "square" )
                        .font(.system(size: 29, weight: .thin))
                        .offset(y: -13.8)
                        .frame(width: 29, height: 29)
                        .clipped()
                        .foregroundStyle(
                            LinearGradient(
                                colors: [neonPink, neonBlue],
                                startPoint: .topLeading,
                                endPoint: .trailing
                            )
                        )
                    
                }
            }
            .frame(width: 25, height: 28)
            .clipped()
        }
        .buttonStyle(.plain)
    }
}

struct dotMenu: View {
    
    let neonBlue = Color(red: 0.2, green: 0.7, blue: 1.0)
    let neonPink = Color(red: 0.8, green: 0.3, blue: 0.7)
    
    var body: some View {
        Button(action: {
            // Action for options menu
        }) {
            
            ZStack {
                //Image(systemName: "app.background.dotted")
                  //  .font(.system(size: 24, weight: .thin))
                   // .frame(width: 23, height: 23)
                    //.offset(x: 1.8, y: 1.8)
                    //.clipShape(
                      //  RoundedRectangle(cornerRadius: 2))
                    //.foregroundStyle(
                      //  LinearGradient(
                        //    colors: [neonBlue, neonPink.opacity(0.6)],
                          //  startPoint: .topLeading,
                            //endPoint: .bottomTrailing
                        //)
                    //)
                
                Image(systemName: "square.dotted")
                    .font(.system(size: 29, weight: .thin))
                    .rotationEffect(.degrees(-90))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [neonPink.opacity(0.0), neonBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Image(systemName: "ellipsis")
                    .font(.system(size: 10.6, weight: .thin))
                    .foregroundStyle(neonBlue)
            }
        }
        .buttonStyle(.plain)
        .padding(.trailing, 10)
    }
}
