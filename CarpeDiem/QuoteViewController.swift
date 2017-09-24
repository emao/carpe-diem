//
//  QuoteViewController.swift
//  CarpeDiem
//
//  Created by Eric Mao on 1/21/17.
//  Copyright © 2017 Eric Mao. All rights reserved.
//

import UIKit
import os.log

class QuoteViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    //MARK: Properties
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var quoteTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `QuoteTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new quote.
     */
    var quote: Quote?
    let quoteBodyPlaceholder = "The ones who are crazy enough to think that they can change the world, are the ones who do."
    
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddQuoteMode = presentingViewController is UINavigationController
        if isPresentingInAddQuoteMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The QuoteViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let author = authorTextField.text ?? ""
        let body = quoteTextView.text ?? ""
        
        // Set the quote to be passed to QuoteTableViewController after the unwind segue.
        quote = Quote(author: author, body: body)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        // Enable the save button only if there is text in the quote body
        updateSaveButtonState()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Remove the quote body placeholder text when user begins editing
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // Add placeholder text back if user leaves quote body empty
        if textView.text.isEmpty {
            textView.text = quoteBodyPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    //MARK: Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        authorTextField.delegate = self
        
        // Handle the text view's user input through delegate callbacks.
        quoteTextView.delegate = self
        
        // Set up views if editing an existing Quote.
        if let quote = quote {
            navigationItem.title = quote.author
            authorTextField.text = quote.author
            quoteTextView.text = quote.body
        }
        else {
            // Set the placeholder text for quote body
            quoteTextView.text = quoteBodyPlaceholder
            quoteTextView.textColor = UIColor.lightGray
        }
        
        // Enable the Save button only if the text view has a quote.
        updateSaveButtonState()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text view is empty.
        let text = quoteTextView.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }


}

