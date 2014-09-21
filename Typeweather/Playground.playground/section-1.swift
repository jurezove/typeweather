// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var tutorialTeam = 56.0

println(++tutorialTeam)

class TipCalculator {
    let total: Double
    let taxPct: Double
    let subtotal: Double
    
    init(total:Double, taxPct:Double) {
        self.total = total
        self.taxPct = taxPct
        subtotal = total / (taxPct + 1)
    }
    
    func calcTipWithTipPct(tipPct:Int) -> Double {
        return subtotal * Double(tipPct)/100
    }
    
    func returnPossibleTips() -> [Int:AnyObject] {
        
        let possibleTipsInferred = [15, 18, 20]
        
        // 2
        var retval = Dictionary<Int, Double>()
        for possibleTip in possibleTipsInferred {
            let intPct = possibleTip
            // 3
            retval[intPct] = calcTipWithTipPct(possibleTip)
        }
        return retval
        
    }
    
}

let tipCalc = TipCalculator(total: 33.25, taxPct: 0.06)

tipCalc.returnPossibleTips()

var v:Dictionary<String, String> = ["test":"burek"]
v["test"]
v["salat"] = "watafak"
println(v)
