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
    
    var transactions:[(cardAcceptor:String, postAmount:NSNumber, date:String,
    cardNum:String, fraudFlag:NSNumber, cardAcceptorCity:String, cardAcceptorState:String, cardAcceptorCountry:String)]?
    
    private var cardAcceptorValue:[String] = []
    private var postAmountValue:[NSNumber] = []
    private var dateValue:[String] = []
    private var cardNumValue:[String] = []
    private var fraudFlagValue:[NSNumber] = []
    private var cardAcceptorCityValue:[String] = []
    private var cardAcceptorStateValue:[String] = []
    private var cardAcceptorCountryValue:[String] = []
    
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
        let request = URLRequest(url: URL(string:"http://django-env.zqqwi3vey2.us-east-1.elasticbeanstalk.com/api/transactions/?account=1387654812")!)
        httpGet(request: request){
            (data, error) -> Void in
            if error != nil {
                print("http error")
                print(error)
            }else {
                //print(data) // Print all data to console
                
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String: Any]] {
                    
                    //print(json?.count)
                    
                    var x = 0
                    
                    for transaction in json!{
                        //print(transaction["post_amount"]!)
                        self.postAmountValue.append(transaction["post_amount"]! as! NSNumber)
                        //self.postAmountValue.append(String(format: "%.2f",transaction["post_amount"] as! float_t))
                        //print(self.postAmountValue[0])
                        self.cardAcceptorValue.append(transaction["card_acceptor_name"]! as! String)
                        self.dateValue.append(transaction["our_transmission_date"]! as! String)
                        self.cardNumValue.append(transaction["processor_account"]! as! String)
                        self.fraudFlagValue.append(transaction["fraud_flag"]! as! NSNumber)
                        self.cardAcceptorCityValue.append(transaction["card_acceptor_city"]! as! String)
                        self.cardAcceptorStateValue.append(transaction["card_acceptor_state"]! as! String)
                        self.cardAcceptorCountryValue.append(transaction["card_acceptor_country"]! as! String)
                        
                        let trans = (self.cardAcceptorValue[x], self.postAmountValue[x], self.dateValue[x], self.cardNumValue[x], self.fraudFlagValue[x], self.cardAcceptorCityValue[x], self.cardAcceptorStateValue[x], self.cardAcceptorCountryValue[x])
                        self.transactions?.append(trans)
                        
                        x += 1
                    }
                }
                
            }
            
            /*var indx = 0
            for transaction in self.transactions!{
                if transaction.fraudFlag != 0{
                    self.transactions?.remove(at: indx)
                    self.transactions?.insert(transaction, at: 0)
                }
                indx += 1
            }*/
            
            /*self.postAmountValue.append("40.00")
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
            self.fraudFlagValue.append("2")*/
            
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
        
        cell?.textLabel?.text = self.cardAcceptorValue[indexPath.row]
        //print(self.cardAcceptorValue[0] as? String)
        cell?.detailTextLabel?.text = String(format:"$%.2f", self.postAmountValue[indexPath.row].doubleValue)
        cell?.detailTextLabel?.textColor = UIColor.black
        //print(self.postAmountValue[0] as? String)
    
        //cell.textLabel?.text = "Walmart";
        //cell.detailTextLabel?.text = "-$35.33";
        
        if self.fraudFlagValue[indexPath.row] == 3{
            cell?.backgroundColor = UIColor.red
        }else if self.fraudFlagValue[indexPath.row] == 2{
            cell?.backgroundColor = UIColor.yellow
        }else if self.fraudFlagValue[indexPath.row] == 1{
            cell?.backgroundColor = UIColor.orange
        }else{
            cell?.backgroundColor = UIColor.clear
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cardAcceptor = self.cardAcceptorValue[indexPath.row]
        let postAmount = self.postAmountValue[indexPath.row]
        let date = self.dateValue[indexPath.row]
        let cardNum = self.cardNumValue[indexPath.row]
        let fraudFlag = self.fraudFlagValue[indexPath.row]
        var _ff = ""
        let city = self.cardAcceptorCityValue[indexPath.row]
        let state = self.cardAcceptorStateValue[indexPath.row]
        let country = self.cardAcceptorCountryValue[indexPath.row]
        let location = city + ", " + state + ", " + country
        
        if fraudFlag == 0{
            _ff = "None"
        }else if fraudFlag == 1{
            _ff = "THIS RECURRING PAYMENT HAS INCREASED"
        }else if fraudFlag == 2{
            _ff = "THIS PAYMENT IS POTENTIALLY FRAUDULENT"
        }else if fraudFlag == 3{
            _ff = "THIS PAYMENT IS LIKELY FRAUDULENT"
        }
        
        var msg = "Description: " + cardAcceptor + " " + location +  " \n " + "Amount: "
        msg += String(format:"$%.2f", postAmount.doubleValue)
        msg += " \n " + "Date: " + date + " \n " + "Card Number: "
        msg += cardNum
        msg += " \n " + "Warnings: "
        msg += _ff + " \n "
        msg += "Fraud Flag: "
        msg += String(format:"%i", fraudFlag.intValue)
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

