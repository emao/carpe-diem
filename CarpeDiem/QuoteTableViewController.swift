//
//  QuoteTableViewController.swift
//  CarpeDiem
//
//  Created by Eric Mao on 2/12/17.
//  Copyright © 2017 Eric Mao. All rights reserved.
//

import UIKit
import os.log

class QuoteTableViewController: UITableViewController {
    
    //MARK: Properties
    var quotes = [Quote]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data.
        if let savedQuotes = loadQuotes() {
            quotes += savedQuotes
        }
        else {
            //Load the sample data
            loadSampleQuotes()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "QuoteTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? QuoteTableViewCell else {
            fatalError("The dequeued cell is not an instance of QuoteTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let quote = quotes[indexPath.row]
        
        cell.authorLabel.text = quote.author
        cell.bodyLabel.text = quote.body
        
        return cell
    }
 

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            quotes.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let quoteDetailViewController = segue.destination as? QuoteViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedQuoteCell = sender as? QuoteTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedQuoteCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedQuote = quotes[indexPath.row]
            quoteDetailViewController.quote = selectedQuote
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
            
        }
    }
    
    //MARK: Actions
    @IBAction func unwindToQuoteList(sender: UIStoryboardSegue) {
        print("Unwinding to quote list")
        if let sourceViewController = sender.source as? QuoteViewController, let quote = sourceViewController.quote {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing quote.
                quotes[selectedIndexPath.row] = quote
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new quote.
                let newIndexPath = IndexPath(row: quotes.count, section: 0)
                
                quotes.append(quote)
                print("Added quote - author: \(quote.author)  body: \(quote.body)")
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the meals.
            saveMeals()
        }
    }
    
    //MARK: Private Methods
    
    private func loadSampleQuotes() {
        
        guard let quote1 = Quote(author: "Gandhi", body: "Be the change you wish to see in the world.") else {
            fatalError("Unable to instantiate quote1")
        }
        
        guard let quote2 = Quote(author: "", body: "A year from now, you'll wish you had started today.") else {
            fatalError("Unable to instantiate quote2")
        }
        
        guard let quote3 = Quote(author: "Jim Rohn", body: "If you are not willing to risk the usual, you will have to settle for the ordinary.") else {
            fatalError("Unable to instantiate quote3")
        }
        
        quotes += [quote1, quote2, quote3]
        
    }
    
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(quotes, toFile: Quote.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Quotes successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save quotes...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadQuotes() -> [Quote]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Quote.ArchiveURL.path) as? [Quote]
    }

}
