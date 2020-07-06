//
//  ContentView.swift
//  SetsGame
//
//  Created by Hadi Laasi on 14/06/2020.
//  Copyright © 2020 Hadi Laasi. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var game: SetsGameViewModel

    var body: some View {
        VStack{
            HStack{
                Button("New Game") {
                    withAnimation(.linear){
                        game.newGame()
                    }
                }
                Spacer()
                Text("Sets").fontWeight(.bold)
                Spacer()
                Button("Deal 3 More") {
                    withAnimation(.linear){
                        game.flipCards(number: 3)
                    }
                }
            }.padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
            
            ZStack {
                Grid(game.flippedCards) { card in
                    CardView(card: card).onTapGesture{
                        withAnimation(.linear){
                            game.chooseCard(card:card)
                        }
                    }
                }.onAppear {
                    withAnimation(.linear(duration: 1)){
                        game.startGame()
                    }
                }
            }
        }
    }
}

struct CardView: View {
    
    var card : SetGame<SetsGameViewModel.CardContents>.Card

    @ViewBuilder
    var body: some View {

        if !card.isMatched {
            GeometryReader { geometry in
                ZStack {
                    RoundedRectangle(cornerRadius: geometry.size.width * self.cornerRadiusMultiplier)
                        .fill(Color.black)
                        .padding(self.card.isChosen ? 4:0)
                        .overlay(
                            RoundedRectangle(cornerRadius: geometry.size.width * self.cornerRadiusMultiplier)
                                .stroke(Color.red, lineWidth: self.card.isChosen ? 4:0)
                                .padding(self.card.isChosen ? 4:0)
                                
                        )
                    
                    
                    VStack {
                        ForEach (0 ..< (card.content.numberOfSymbols), id: \.self){ index in
                            self.card.content.symbol.shape
                                //.stroke(Color.red, lineWidth: 2) TODO: How do I cast AnyView into a shape?{
                                .opacity(self.card.content.shading.transparency)
                                .padding(geometry.size.width * 0.01)
                        }
                    }
                    .foregroundColor(card.content.color)
                    .padding(geometry.size.width * 0.03)
                }
                .padding(geometry.size.width * 0.02)
                .aspectRatio(3/4, contentMode: .fit)
                .transition(.move(edge: .leading))
                
                
                //var cornerRadius : CGFloat = (geometry.size.width * 0.12) #TODO: Understand why this didn't work.
                
            }.transition(.offset(CGSize(width: Int.random(in: 500..<1000), height: Int.random(in: 200..<1000))))
        }
        else{
            
        }
    }
        
    var cornerRadiusMultiplier : CGFloat = 0.12
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetsGameViewModel()
        return ContentView(game: game)
    }
}
