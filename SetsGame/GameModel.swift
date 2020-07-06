//
//  GameModel.swift
//  SetsGame
//
//  Created by Hadi Laasi on 14/06/2020.
//  Copyright © 2020 Hadi Laasi. All rights reserved.
//

import Foundation
import SwiftUI




struct SetGame<CardContent: Equatable> {
    
    var cardDeck = Array<Card>()
    var faceupCards = Array<Card>()
    let starterCards = 12

    init(allVariations: Array<Variation>, cardContentFactory: ([String : Any]) -> CardContent) {
        
        var cardVariations = Array<Dictionary<String, Any>>()
        
        for variation in allVariations{
            if cardVariations.isEmpty {
                for attribute in variation.allAttributes {
                    cardVariations.append([variation.name: attribute])
                }
            }
            else {
                var newCardVariations = Array<Dictionary<String, Any>>()
                for attribute in variation.allAttributes {
                    for cardVariation in cardVariations {
                        var updatedCardVariation = cardVariation
                        updatedCardVariation[variation.name] = attribute
                        newCardVariations.append(updatedCardVariation)
                    }
                }
                cardVariations = newCardVariations
            }
        }
        
        
        for (index, variation) in cardVariations.enumerated(){
            cardDeck.append(Card(id: index, content: cardContentFactory(variation)))
        }
        cardDeck.shuffle()
        
    }
    
    mutating func flipCards(number: Int){
        let countOfCardsToFlip = cardDeck.count < number ? cardDeck.count : number
        
        for index in 0..<countOfCardsToFlip{
            faceupCards.append(cardDeck[index])
        }
        
        //faceupCards.append(contentsOf: cardDeck[0..<countOfCardsToFlip])
        cardDeck.removeSubrange(0..<countOfCardsToFlip)
    }
    
    mutating func startGame(){
        self.flipCards(number: self.starterCards)
    }
        
    mutating func chooseCard(card: Card, cardsMatch: (Array<Card>) -> Bool){
        
        if let selectedCardIndex = faceupCards.firstIndex(matching: card){
            //Toggle the card
            faceupCards[selectedCardIndex].isChosen.toggle()
            
            let selectedCards = faceupCards.filter{ $0.isChosen == true }
            
            //When 3 cards are already selected, and we are now selecting the 4th one, unselected the previous three cards.
            if selectedCards.count == 4 {
                faceupCards.map{
                    if $0.id != card.id { //TODO: Why did I have to add ID to this?
                        faceupCards[faceupCards.firstIndex(matching: $0)!].isChosen = false
                    }
                    
                }
            }
            
            // Now, if the third card is selected, see if there is a match
            if selectedCards.count == 3 {
                if cardsMatch(selectedCards){
                    selectedCards.map{
                        if let cardIndex = faceupCards.firstIndex(matching: $0){
                            faceupCards[cardIndex].isMatched = true //TODO: Why does this leave blank gaps?
                        }
                    }
                    flipCards(number:3)
                }
                else {
                    selectedCards.map{
                        if let cardIndex = faceupCards.firstIndex(matching: $0){
                            faceupCards[cardIndex].isChosen = false
                        }
                    }
                }
            }
        }
        
    }
    
    struct Variation{
        var name: String
        var allAttributes: Array<Any>
    }
    
    struct Card: Identifiable, CustomStringConvertible, Equatable {

        
        var id: Int
        var content: CardContent
        var isChosen: Bool = false
        var description: String {
            "\(content)"
        }
        var isMatched: Bool = false
        //TODO: Why did this cause the cards from being selected?
//        static func == (lhs: SetGame<CardContent>.Card, rhs: SetGame<CardContent>.Card) -> Bool {
//            return lhs.id == rhs.id
//        }

        
    }
    
}


