//
//  SetsViewModel.swift
//  SetsGame
//
//  Created by Hadi Laasi on 15/06/2020.
//  Copyright © 2020 Hadi Laasi. All rights reserved.
//

import Foundation
import SwiftUI

class SetsGameViewModel: ObservableObject {
    
    @Published private var game: SetGame<CardContents> = SetsGameViewModel.createSetGame()
    
    struct CardContents: Equatable{
        
        //Variations
        var color: Color
        var numberOfSymbols: Int
        var symbol: Symbol
        var shading: Shading
        
        enum Shading{
            case opaque
            case transparent
            case semitransparent
            
            var transparency: Double {
                switch self {
                case .opaque: return 1.0
                case .transparent: return 0.2
                case .semitransparent: return 0.5
                }
            }
        }
        
        enum Symbol{
            case diamond
            case oval
            case squiggle
            
            var shape: AnyView {
                switch self {
                case .diamond: return AnyView(Diamond())
                case .oval: return AnyView(Oval())
                case .squiggle: return AnyView(Squiggle())
                }
            }

        }
    }
    

    static func createSetGame() -> SetGame<CardContents>{
        
        let colors = SetGame<CardContents>.Variation(name: "colors", allAttributes: [Color.red, Color.purple, Color.green])
        let symbols = SetGame<CardContents>.Variation(name: "symbols", allAttributes: [CardContents.Symbol.squiggle, .diamond, .oval])
        
        let numbersOfSymbols = SetGame<CardContents>.Variation(name: "numberOfSymbols", allAttributes: [1,2,3])
        let shading = SetGame<CardContents>.Variation(name: "shading", allAttributes: [CardContents.Shading.opaque, .transparent, .semitransparent])
            
        let allVariations: Array<SetGame<CardContents>.Variation> = [colors, symbols, shading, numbersOfSymbols]
        
        return createDeck(allVariations: allVariations)
    }

    static func createDeck(allVariations: Array<SetGame<CardContents>.Variation>) -> SetGame<CardContents> {
        
        return SetGame<CardContents>(allVariations: allVariations) { (variation) -> CardContents in
            
            return CardContents(color: variation["colors"] as! Color, numberOfSymbols: variation["numberOfSymbols"] as! Int, symbol: variation["symbols"] as! SetsGameViewModel.CardContents.Symbol, shading: variation["shading"] as! SetsGameViewModel.CardContents.Shading)
            
        }
    }
    
    
    // MARK - Access to the Model
    var deck: Array<SetGame<CardContents>.Card> {
        return game.cardDeck
    }
    
    var flippedCards: Array<SetGame<CardContents>.Card>{
        return game.faceupCards
    }
    
    func flipCards(number:Int){
        game.flipCards(number: number)
    }
    
    func startGame(){
        game.startGame()
    }
    
    func newGame(){
        game = SetsGameViewModel.createSetGame()
        game.startGame()
    }
    
    func chooseCard(card: SetGame<CardContents>.Card) {
        //Note: To make the game easier, you can comment out some of the rules below!
        
        game.chooseCard(card: card) { (matchedCards) -> Bool in
            if let firstElem = matchedCards.first {
                for card in matchedCards {
                    if card != firstElem && card.content.color == firstElem.content.color {
                        return false
                    }
                    if card != firstElem && card.content.symbol == firstElem.content.symbol {
                        return false
                    }
                    if card != firstElem && card.content.shading == firstElem.content.shading {
                        return false
                    }
                    if card != firstElem && card.content.numberOfSymbols == firstElem.content.numberOfSymbols {
                        return false
                    }
                }
            }
            return true
        }
    }
    

    
        
}

