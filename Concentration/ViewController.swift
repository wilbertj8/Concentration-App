//
//  ViewController.swift
//  Concentration
//
//  Created by Wilbert Joseph on 3/10/20.
//  Copyright © 2020 Wilbert Joseph. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private lazy var game: Concentration = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1)/2
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
        
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        flipCountLabel.text = "Flips: \(game.flipCount)"
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }
        }
    }
    
    private var themes = [["🎃","👻","😈","💀","🙀","🦉","🌘","🌧"],
                          ["🍔","🌭","🍟","🍕","🌮","🍗","🧀","🥐"],
                          ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼"],
                          ["⚽️","🏀","🏈","⚾️","🥎","🏐","🏉","🥏"],
                          ["😀","😭","😂","🥰","🤩","😜","🥶","😡"],
                          ["🇧🇪","🇦🇽","🇧🇧","🇧🇴","🇧🇬","🇧🇲","🇨🇨","🇨🇴"]]
    
    private lazy var emojiChoices = themes.randomElement()

    private var emoji = [Int:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices!.count > 0 {
            emoji[card.identifier] = emojiChoices!.remove(at: emojiChoices!.count.arc4random)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    
    @IBAction private func resetGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1)/2)
        emojiChoices = themes.randomElement()
        updateViewFromModel()
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
