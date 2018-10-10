//
//  ViewController.swift
//  Anomaly_Dection_iOS
//
//  Created by CSE498 on 9/26/18.
//  Copyright © 2018 CSE498. All rights reserved.
//

import UIKit
//import SwiftyJSON
//import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let list = ["Type       Credit Card",
                "Transaction Amount     -$31.42",
                "Posted Date        Oct 2, 2018",
                "Transaction Date       Oct 1, 2018",
                "Card Number        x1234",
                "New Balance        $271.83",
                "Description        WALMART 3452 CUSCO",
                "Warnings       POTENTIAL FRAUD"]
    let lists = [["Data":"Type","Details":"Credit Card"],
                 ["Data":"Transaction Amount","Details":"Posted Date"],
                 ["Data":"Card Number","Details":"x1234"],
                 ["Data":"New Balance","Details":"$271.83"],
                 ["Data":"Description","Details":"WALMART 3452 CUSCO"],
                 ["Data":"Warnings","Details":"POTENTIAL FRAUD"]]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(list.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        //let cell = UITableViewCell(style: <#T##UITableViewCellStyle#>, reuseIdentifier: "Cell")
        cell.textLabel?.text = list[indexPath.row]
        return(cell)
    }
    
    
    //Alamofire.request(.GET, url, params)
    
    /*let params = ["Date": dateStr,"Acceptor": acceptorStr, "State": stateStr, "Posted Amount": postedAmountStr]
        Alamofire.request(.GET, API_BASE_URL, parameters: params)
            .responseJSON { response in
                if let transactions = response.result.value {
                    print("JSON: \(transactions)")
                    if let error = transactions["error"] {
                        print("No transaction found | error :\(error)")
                        self.restaurantName.text = "Nothing found! Try again"
                        self.stopSpinner(nil)
                        return
                    }
                    let transCount = transactions.count
                    print(" count : \(transactions.count)")
                    if (transCount == 0) {
                        print("No transaction found")
                        self.restaurantName.text = "Nothing found! Try again"
                        self.stopSpinner(nil)
                        return
                    }
                    let transLimit = min(transCount, 50)
                    let randomTransactionIndex = Int(arc4random_uniform(UInt32(venueLimit)))
                    print(randomTransactionIndex)
                    guard let results = transactions as? NSArray
                        else {
                            print ("cannot find key location in \(transactions)")
                            return
                    }
                    for r in results{
                        let photoURL = NSURL(string:r["photo_url"] as! String)
                        if let imageData = NSData(contentsOfURL: photoURL!) {
                                let image  = UIImage(data: imageData)
    
                            let date = r["date"] as! String
                            let acceptor = r["acceptor"] as! String
                            let state = r["state"] as! String
                            let posted_amount = r["posted amount"] as! String
                            let transaction = Transaction(date: date, acceptor: acceptor, state: state, posted_amount: posted_amount)!
                            self.transactions.append(transaction)
    
                            print("\(date) \(acceptor) \(state) \(posted_amount)")
                        }
    
                    }
                    let randomTransaction = self.transaction[randomTransactionIndex]
                    self.setRandomTransaction(randomTransaction)
    
                    self.saveTransaction()
                    self.stopSpinner(nil)
                }
            }*/
    
    //MARK: Properties
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet var White: [UIImageView]!
    @IBOutlet var MSUFCU: [UILabel]!
    @IBOutlet weak var TransactionsLabel: UILabel!
    @IBOutlet weak var AccountsLabel: UILabel!
    @IBOutlet weak var MoveMoneyLabel: UILabel!
    @IBOutlet weak var eDepositLabel: UILabel!
    @IBOutlet weak var MyOffersLabel: UILabel!
    @IBOutlet weak var EmbeddedTable: UIView!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingContraint: NSLayoutConstraint!
    
    var menuShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 6
        
        print("test")
        
        let urlString = URL(string: "http://127.0.0.1:8000/api/transactions/?account=3243617280")
        
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let usableData = data {
                        print(usableData) //JSONSerialization
                    }
                }
            }
            task.resume()
        }
        
        
    }
    
    @IBAction func openMenu(_ sender: Any) {
        
        if (menuShowing) {
            leadingContraint.constant = -150
        }else{
            leadingContraint.constant = 0
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.view.layoutIfNeeded()
            })
        }
        
        menuShowing = !menuShowing
    }


}

