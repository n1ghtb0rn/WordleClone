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
    
    var inputs = [[UITextField]]()
    
    var currentRowIndex = 0
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    let words = ["REACT", "SWIFT", "HELLO", "WORLD"]
    
    var targetWord: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        targetWord = words.randomElement()!
        
        print(targetWord)
        
        self.initInputArray()
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
        
        var answer = [String]()
        
        let currentRow = inputs[currentRowIndex]
        
        for input in currentRow {
            answer.append(input.text!)
        }
        
        if answer.count != 5 {
            return
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
        
    }
    
}

