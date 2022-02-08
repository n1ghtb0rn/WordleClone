//
//  ViewController.swift
//  WordleClone
//
//  Created by Daniel Falkedal on 2022-02-07.
//

import UIKit

class ViewController: UIViewController {
    
    /* confirm + cancel buttons */
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    /* text fields */
    @IBOutlet weak var input00: UITextField!
    @IBOutlet weak var input01: UITextField!
    @IBOutlet weak var input02: UITextField!
    @IBOutlet weak var input03: UITextField!
    @IBOutlet weak var input04: UITextField!
    
    @IBOutlet weak var input10: UITextField!
    @IBOutlet weak var input11: UITextField!
    @IBOutlet weak var input12: UITextField!
    @IBOutlet weak var input13: UITextField!
    @IBOutlet weak var input14: UITextField!
    
    @IBOutlet weak var input20: UITextField!
    @IBOutlet weak var input21: UITextField!
    @IBOutlet weak var input22: UITextField!
    @IBOutlet weak var input23: UITextField!
    @IBOutlet weak var input24: UITextField!
    
    
    @IBOutlet weak var input30: UITextField!
    @IBOutlet weak var input31: UITextField!
    @IBOutlet weak var input32: UITextField!
    @IBOutlet weak var input33: UITextField!
    @IBOutlet weak var input34: UITextField!
    
    @IBOutlet weak var input40: UITextField!
    @IBOutlet weak var input41: UITextField!
    @IBOutlet weak var input42: UITextField!
    @IBOutlet weak var input43: UITextField!
    @IBOutlet weak var input44: UITextField!
    
    @IBOutlet weak var input50: UITextField!
    @IBOutlet weak var input51: UITextField!
    @IBOutlet weak var input52: UITextField!
    @IBOutlet weak var input53: UITextField!
    @IBOutlet weak var input54: UITextField!
    
    var inputs = [[UITextField]]()
    
    let yellowColor: UIColor = #colorLiteral(red: 0.7079477906, green: 0.6244826913, blue: 0.2295816839, alpha: 1)
    let greenColor: UIColor = #colorLiteral(red: 0.3271112442, green: 0.5547715425, blue: 0.3070441782, alpha: 1)
    let grayColor: UIColor = .darkGray
    
    var currentRowIndex = 0
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    var words = [String]()
    
    var targetWord: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.loadWordlist()
        
        targetWord = words.randomElement()!
        
        print(targetWord)
        
        self.initInputArray()
        
        input00.becomeFirstResponder() //TODO: Fix this!
    }

    
    @IBAction func inputUpdate(_ currentInput: UITextField) {
        
        let text: NSString = currentInput.text! as NSString
        
        if text.length <= 0 {
            return
        }
        
        let lastIndex: Int = text.length-1
        
        let lastChar = text.character(at: lastIndex)
        
        let newString: String = String(UnicodeScalar(lastChar)!)
        
        currentInput.text = newString
        
        activateNextInput(currentInput)
        
    }
    
    private func activateNextInput(_ currentInput: UITextField) {
        
        var currentPosition: CGPoint = CGPoint(x: -1, y: -1)
        
        var maxIndex: Int = -1
        
        for y in 0...inputs.count-1 {
            let row = inputs[y]
            maxIndex = row.count-1
            for x in 0...row.count-1 {
                if row[x] == currentInput {
                    currentPosition.y = CGFloat(y)
                    currentPosition.x = CGFloat(x)
                }
            }
        }
        
        if currentPosition.y < 0 || currentPosition.x < 0 || maxIndex < 0 {
            return
        }
        
        let nextPosition: CGPoint = CGPoint(x: currentPosition.x+1, y: currentPosition.y)
        
        if Int(nextPosition.x) > maxIndex {
            currentInput.isEnabled = false
            currentInput.isEnabled = true
            return
        }
        
        let nextInput = inputs[Int(nextPosition.y)][Int(nextPosition.x)]
        
        nextInput.becomeFirstResponder()
        
    }
    
    
    @IBAction func confirmClicked(_ sender: UIButton) {
        
        var answerString: String = ""
        
        let currentRow = inputs[currentRowIndex]
        
        for input in currentRow {
            answerString.append(input.text!.lowercased())
        }
        
        let answer = Array(answerString)
        
        if answer.count != 5 {
            return
        }
        
        let target = Array(targetWord)
        
        var isValid = false
        for current in words {
            if current == answerString {
                isValid = true
            }
        }
        if !isValid {
            return
        }
        
        print("WORD EXISTS!")
        
        var correctLetters: Int = 0
        
        var colors = [UIColor]()
        for _ in 0...answer.count-1 {
            colors.append(grayColor)
        }
        
        for i in 0...answer.count-1 {
            //currentRow[i].backgroundColor = grayColor
            for j in 0...target.count-1 {
                if answer[i] == target[j] {
                    
                    if i != j {
                        if colors[i] != greenColor {
                            colors[i] = yellowColor
                        }
                    }
                    else {
                        colors[i] = greenColor
                        correctLetters += 1
                    }
                }
            }
        }
        
        var delay: Double = 0.0
        let delayIncrease: Double = 0.2
        
        for colorIndex in 0...currentRow.count-1 {
            delay += delayIncrease
            
            DispatchQueue.main.asyncAfter (deadline: .now() + delay) {
                
                currentRow[colorIndex].backgroundColor = colors[colorIndex]
                
            }
        }
        
        DispatchQueue.main.asyncAfter (deadline: .now() + (delayIncrease * 6) ) {
            
            for input in currentRow {
                input.isEnabled = false
            }
            
            if correctLetters == 5 {
                print("Correct letters: \(correctLetters)")
                return
            }
            
            self.currentRowIndex += 1
            
            if self.currentRowIndex >= self.inputs.count {
                print("Current row index: \(self.currentRowIndex)")
                return
            }
            
            let nextRow = self.inputs[self.currentRowIndex]
            for input in nextRow {
                input.isEnabled = true
                input.alpha = 1.0
            }
            
            nextRow[0].becomeFirstResponder()
            
        }
        
        
        
    }
    
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        
        let currentRow = inputs[currentRowIndex]
        
        for currentInput in currentRow {
            currentInput.text = ""
        }
        
        currentRow[0].becomeFirstResponder()
        
    }
    
    private func initInputArray() {
        
        let row0 = [input00!, input01!, input02!, input03!, input04!]
        self.inputs.append(row0)
        
        let row1 = [input10!, input11!, input12!, input13!, input14!]
        self.inputs.append(row1)
        
        let row2 = [input20!, input21!, input22!, input23!, input24!]
        self.inputs.append(row2)
        
        let row3 = [input30!, input31!, input32!, input33!, input34!]
        self.inputs.append(row3)
        
        let row4 = [input40!, input41!, input42!, input43!, input44!]
        self.inputs.append(row4)
        
        let row5 = [input50!, input51!, input52!, input53!, input54!]
        self.inputs.append(row5)
        
        for i in 1...inputs.count-1 {
            let row = inputs[i]
            for current in row {
                current.isEnabled = false
                current.alpha = 0.5
            }
        }
        
    }
    
    private func loadWordlist() {
    
        do {
            // This solution assumes  you've got the file in your bundle
            if let path = Bundle.main.path(forResource: "wordlist", ofType: "txt"){
                let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                words = data.components(separatedBy: "\n")
            }
        } catch let err as NSError {
            // do something with Error
            print(err)
        }
        
        print("List loaded!")
    }
    
}

