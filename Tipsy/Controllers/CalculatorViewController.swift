//
//  ViewController.swift
//  Tipsy
//


import UIKit


class CalculatorViewController: UIViewController, UITextFieldDelegate {
    
    //variables
    
    var tip = 0.10
    var numberOfPeople = 2
    var billTotal = 0.0
    
    //pass the value from this view controller to the result view controller
    //variable linked to the result viewcontroller
    var finalResult = "0.0"
    
    
    
    //IBOutlet
    
    @IBOutlet weak var billTextField: UITextField!
    
    @IBOutlet weak var zeroPctButton: UIButton!
    
    @IBOutlet weak var tenPctButton: UIButton!
    
    @IBOutlet weak var twentyPctButton: UIButton!
    
    @IBOutlet weak var splitNumberLabel: UILabel!
    
    
    //IBAction
    
    @IBAction func tipChanged(_ sender: UIButton) {
        
        //Dismiss the keyboard when the user chooses one of the tip values.
        billTextField.endEditing(true)
        //Deselect all tip buttons via IBOutlets
        clearSelectedState()
        
        
        //Make the button that triggered the IBAction selected.
        sender.isSelected = true
        
        //Get the current title of the button that was pressed.
        let buttonTitle = sender.currentTitle!
        
        //Remove the last character (%) from the title then turn it back into a String.
        let buttonTitleMinusPercentSign =  String(buttonTitle.dropLast())
        
        //Turn the String into a Double.
        let buttonTitleAsANumber = Double(buttonTitleMinusPercentSign)!
        
        //Divide the percent expressed out of 100 into a decimal e.g. 10 becomes 0.1
        tip = buttonTitleAsANumber / 100
    }
    
    //Clear all the selected buttons
    
    func clearSelectedState(){
        zeroPctButton.isSelected = false
        tenPctButton.isSelected = false
        twentyPctButton.isSelected = false
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == billTextField {
            billTextField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        
        //Get the stepper value using sender.value, round it down to a whole number then set it as the text in
        //the splitNumberLabel
        //splitNumberLabel.text = Int(sender.value).description
        splitNumberLabel.text = String(format: "%.0f", sender.value)//%.0f means whole number
        
        
        //Set the numberOfPeople property as the value of the stepper as a whole number.
        numberOfPeople = Int(sender.value)
    }
    
    //Calculate button
    @IBAction func calculatePressed(_ sender: UIButton) {
        
        
        //Get the text the user typed in the billTextField
        let bill = billTextField.text!
        
        //If the text is not an empty String ""
        if bill != "" {
            
            //Turn the bill from a String e.g. "123.50" to an actual String with decimal places.
            //e.g. 125.50
            billTotal = Double(bill)!
            
            //Multiply the bill by the tip percentage and divide by the number of people to split the bill.
            let result = billTotal * (1 + tip) / Double(numberOfPeople)
            //Round the result to 2 decimal places and turn it into a String.
            //%.2f means 2 decimal places
            //variable linked to the result viewcontroller
            finalResult = String(format: "%.2f", result)
            
        }
        //In Main.storyboard there is a segue between CalculatorVC and ResultsVC with the identifier "goToResults".
        //This line triggers the segue to happen.
        //Segue
        //enter the identifier inside ""
        //go to the results viewContoller
        self.performSegue(withIdentifier: "goToResult", sender: self)
        
        //clear the textfield after returning back to the calculator viewcontroller
        billTextField.text = ""
        clearSelectedState()
        splitNumberLabel.text = "2"
    }
    
    //passing the values between story boards
    //This method gets triggered just before the segue starts.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //If the currently triggered segue is the "goToResults" segue.
        if segue.identifier == "goToResult" {
            
            //Get hold of the instance of the destination VC and type cast it to a ResultViewController.
            let destinationVC = segue.destination as! ResultsViewController
            
            //Set the destination ResultsViewController's properties.
            destinationVC.result = finalResult
            destinationVC.tip = Int(tip * 100)
            destinationVC.split = numberOfPeople
        }
        
    }
    
    
    
}
