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
    
    var transactions:[(cardAcceptor:Any, postAmount:Any, date:Any,
        cardNum:Any, fraudFlag:Any)]?
    
    private var cardAcceptorValue:[Any] = []
    private var postAmountValue:[Any] = []
    private var dateValue:[Any] = []
    private var cardNumValue:[Any] = []
    private var fraudFlagValue:[Any] = []
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingContraint: NSLayoutConstraint!
    
    @IBOutlet weak var transactionTable: UITableView!
    
    var menuShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //transactionTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
 
        
        //menuView.layer.shadowOpacity = 1
        //menuView.layer.shadowRadius = 6
        
        callDtaFromWeb()
    }
    
    func callDtaFromWeb(){
        let request = URLRequest(url: URL(string:"http://django-env.zqqwi3vey2.us-east-1.elasticbeanstalk.com/api/transactions/?account=3438561154")!)
        httpGet(request: request){
            (data, error) -> Void in
            if error != nil {
                print("http error")
                print(error)
            }else {
                //print(data) // Print all data to console
                
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String: Any]] {
                    
                    print(json?.count)
                    
                    var x = 0
                    
                    for transaction in json!{
                        print(transaction["post_amount"]!)
                        self.postAmountValue.append(String(format: "%.2f",transaction["post_amount"] as! float_t))
                        print(self.postAmountValue[0])
                        self.cardAcceptorValue.append(transaction["card_acceptor_name"]!)
                        self.dateValue.append(transaction["our_transmission_date"]!)
                        self.cardNumValue.append(transaction["processor_account"]!)
                        self.fraudFlagValue.append(transaction["fraud_flag"]!)
                        
                        let trans = (self.postAmountValue[x], self.cardAcceptorValue[x], self.dateValue[x], self.cardNumValue[x], self.fraudFlagValue[x])
                        self.transactions?.append(trans)
                        
                        x += 1
                    }
                }
                
            }
            
            self.postAmountValue.append("40.00")
            self.cardAcceptorValue.append("MSUFCU")
            self.dateValue.append("November 2, 2018")
            self.cardNumValue.append("1234567")
            self.fraudFlagValue.append("0")
            
            self.postAmountValue.append("167.19")
            self.cardAcceptorValue.append("WALMART")
            self.dateValue.append("November 1, 2018")
            self.cardNumValue.append("1234567")
            self.fraudFlagValue.append("3")
            
            self.postAmountValue.append("19.95")
            self.cardAcceptorValue.append("PLANET FITNESS")
            self.dateValue.append("November 3, 2018")
            self.cardNumValue.append("1234567")
            self.fraudFlagValue.append("1")
            
            self.postAmountValue.append("567.32")
            self.cardAcceptorValue.append("MEIJER")
            self.dateValue.append("November 2, 2018")
            self.cardNumValue.append("1234567")
            self.fraudFlagValue.append("2")
            
            DispatchQueue.main.async {
                self.transactionTable.reloadData()
            }
            //self.transactionTable.reloadData()
        }
    }
    
    func httpGet(request: URLRequest!, callback: @escaping (Data?, String?) -> Void) {
        print("inside httpget")
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (data,response,error) -> Void in
            if error != nil {
                callback(nil,error!.localizedDescription)
            }else {
                //let result = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.ascii.rawValue))!
                //print(result as String)
                callback(data, nil)
            }
        }
        task.resume()
    }
    
    func numberOfSecionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        // Return the number of rows in the section.
        
        return cardAcceptorValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as UITableViewCell
        
        let cellIdentifier = "cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        }
        
        /*dispatch_async(dispatch_get_main_queue(), { () -> Void in
                print("stuff")
            
            cell.textLabel?.text = self.cardAcceptorValue[indexPath.row];
            cell.detailTextLabel?.text = self.postAmountValue[indexPath.row];
        })*/
        
        /*for transaction in transactions!{
            print(transaction.postAmount)
        }*/
        
        cell?.textLabel?.text = self.cardAcceptorValue[indexPath.row] as? String;
        print(self.cardAcceptorValue[0] as? String)
        cell?.detailTextLabel?.text = self.postAmountValue[indexPath.row] as? String;
        print(self.postAmountValue[0] as? String)
    
        //cell.textLabel?.text = "Walmart";
        //cell.detailTextLabel?.text = "-$35.33";
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cardAcceptor = self.cardAcceptorValue[indexPath.row] as! String
        let postAmount = self.cardAcceptorValue[indexPath.row] as! String
        let date = self.dateValue[indexPath.row] as! String
        let cardNum = self.cardNumValue[indexPath.row] as! String
        var fraudFlag = self.fraudFlagValue[indexPath.row] as! String
        
        if fraudFlag == "0"{
            fraudFlag = "None"
        }else if fraudFlag == "1"{
            fraudFlag = "THIS RECURRING PAYMENT HAS INCREASED"
        }else if fraudFlag == "2"{
            fraudFlag = "THIS PAYMENT IS POTENTIALLY FRAUDULENT"
        }else if fraudFlag == "3"{
            fraudFlag = "THIS PAYMENT IS LIKELY FRAUDULENT"
        }
        
        let msg = "Description: " + cardAcceptor + " \n " + "Amount: " + postAmount + " \n " + "Date: " + date + " \n " + "Card Number: " + cardNum + " \n " + "Warnings: " + fraudFlag
        let alert = UIAlertController(title: "Transaction Details", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    
    /*@IBAction func openMenu(_ sender: Any) {
        
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
    }*/


}

