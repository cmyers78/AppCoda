//
//  KivaLoanTableViewController.swift
//  KivaLoan
//
//  Created by Simon Ng on 4/10/2016.
//  Updated by Simon Ng on 6/12/2017.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class KivaLoanTableViewController: UITableViewController {
    private let kivaLoanUrl = "https://api.kivaws.org/v1/loans/newest.json"
    private var loans = [Loan]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 92.0
        tableView.rowHeight = UITableViewAutomaticDimension
        getLatestLoans()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Custom functions
    
    func getLatestLoans() {
        guard let loanUrl = URL(string: kivaLoanUrl) else { return }
        
        let request = URLRequest(url: loanUrl)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                self.loans = self.parseJsonData(data : data)
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    func parseJsonData(data : Data) -> [Loan] {
        var loans = [Loan]()
        
        let decoder = JSONDecoder()
        
        do {
            let loanDataStore = try decoder.decode(LoansDataStore.self, from: data)
            loans = loanDataStore.loans
        } catch {
            print(error)
        }
        
        return loans
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return loans.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! KivaLoanTableViewCell
        
        cell.nameLabel.text = loans[indexPath.row].name
        cell.countryLabel.text = loans[indexPath.row].country
        cell.useLabel.text = loans[indexPath.row].use
        cell.amountLabel.text = ("$\(loans[indexPath.row].amount)")
        // Configure the cell...

        return cell
    }
    


}
