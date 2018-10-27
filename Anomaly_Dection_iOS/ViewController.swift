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
                "Description        WALMART 3452 CUSCO",
                "Warnings       POTENTIAL FRAUD"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(list.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        //let cell = UITableViewCell(style: <#T##UITableViewCellStyle#>, reuseIdentifier: "Cell")
        cell.textLabel?.text = list[indexPath.row]
        return(cell)
    }
    
    
    
    
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
        
        struct Account: Decodable {
            let transactions: [Transaction]
            
            enum CodingKeys : String, CodingKey {
                case transactions
            }
        }
        
        struct Transaction: Decodable {
            let id: String
            let processor_account: String
            let post_amount: String
            let card_acceptor_name: String
            let card_acceptor_city: String
            let card_acceptor_country: String
            let fraud_flag: Bool
        }
        
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 6
        
    }
    
    
    func getData() -> Array<Any> {
        
        let urlString = URL(string: "http://django-env.zqqwi3vey2.us-east-1.elasticbeanstalk.com/api/transactions/?account=3243617280")
        
        //var list_of_lists = Array<Any>()
        
        var temp_list = Array<Any>()
    
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let usableData = data {
                        //print(usableData) //JSONSerialization
                        if let json = try? JSONSerialization.jsonObject(with: usableData, options: []) as? [[String: Any]] {
                            
                            for transaction in json!{
                                //print(transaction)
                                //print(transaction["id"]!)
                                //let trans_id = transaction["id"] as? String
                                let type = transaction["tran_sub_type"] as? Int
                                let amount = transaction["post_amount"] as? Float
                                let date = transaction["our_transmission_date"] as? String
                                let card_number = transaction["processor_account"] as? String
                                let description = transaction["card_acceptor_name"] as? String
                                let fraud_flag = transaction["fraud_flag"] as? Int
                                
                                temp_list = [type, amount, date, card_number, description, fraud_flag] //as [Any]
                                
                                func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                                    
                                    return(temp_list.count)
                                }
                                
                                func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
                                    UITableViewCell {
                                        
                                        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
                                        //let cell = UITableViewCell(style: <#T##UITableViewCellStyle#>, reuseIdentifier: "Cell")
                                        cell.textLabel?.text = temp_list[indexPath.row] as? String
                                        return(cell)
                                }
                                
                                //list_of_lists += list
                                
                                /*for item in temp_list{
                                    print(item)
                                }*/
                                
                                
                                //print(transaction["fraud_flag"]!)
                                /*let fraud_flag = "1"
                                 if (fraud_flag as Any? === transaction["fraud_flag"]){
                                 print("POTENTIAL FRAUD")
                                 }*/
                            }
                            //return temp_list
                        }
                        /*for item in temp_list{
                            print(item)
                        }*/
                        print("able to access data")
                    }
                }
                for item in temp_list{
                    print(item)
                }
                
            }
            task.resume()
        }
        //print("test")
        
        return temp_list
        
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

