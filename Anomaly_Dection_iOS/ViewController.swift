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
    
    var transactions = [(cardAcceptor:String, postAmount:NSNumber, date:String, cardNum:String, fraudFlag:NSNumber, cardAcceptorCity:String, cardAcceptorState:String, cardAcceptorCountry:String)]()
    
    var card1 = [(cardAcceptor:String, postAmount:NSNumber, date:String, cardNum:String, fraudFlag:NSNumber, cardAcceptorCity:String, cardAcceptorState:String, cardAcceptorCountry:String)]()
    
    var card2 = [(cardAcceptor:String, postAmount:NSNumber, date:String, cardNum:String, fraudFlag:NSNumber, cardAcceptorCity:String, cardAcceptorState:String, cardAcceptorCountry:String)]()
    
    var CARD_TO_USE = "CARD1"
    
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
 
        
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 6
    
        debitCardButtonVar.setTitleColor(UIColor.darkGray, for: [])
        creditCardButtonVar.setTitleColor(UIColor.blue, for: [])
        
        activityIndicator()
        
        callDtaFromWeb()
        
        self.transactionTable.addSubview(self.refreshControl)
        
        self.transactionTable.tableFooterView = UIView(frame:CGRect.zero)
    }
    
    func callDtaFromWeb(){
        let request = URLRequest(url: URL(string:"http://django-env.zqqwi3vey2.us-east-1.elasticbeanstalk.com/api/transactions/?account=1387654812")!)
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.black
        httpGet(request: request){
            (data, error) -> Void in
            if error != nil {
                print("http error")
                print(error!)
            }else {
                //print(data) // Print all data to console
                
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String: Any]] {
                    
                    //print(json?.count)
                    
                    var x = 0
                    
                    self.postAmountValue.removeAll()
                    self.cardAcceptorValue.removeAll()
                    self.dateValue.removeAll()
                    self.fraudFlagValue.removeAll()
                    self.cardAcceptorCityValue.removeAll()
                    self.cardAcceptorStateValue.removeAll()
                    self.cardAcceptorCountryValue.removeAll()
                    self.transactions.removeAll()
                    
                    
                    for transaction in json!{
                        //print(transaction["post_amount"]!)
                        self.postAmountValue.append(transaction["post_amount"]! as! NSNumber)
                        //self.postAmountValue.append(String(format: "%.2f",transaction["post_amount"] as! float_t))
                        //print(self.postAmountValue[0])
                        self.cardAcceptorValue.append(transaction["card_acceptor_name"]! as! String)
                        self.dateValue.append(transaction["our_transmission_date"]! as! String)
                        self.cardNumValue.append(transaction["processor_account"]! as! String)
                        //print(self.cardNumValue[x])
                        self.fraudFlagValue.append(transaction["fraud_flag"]! as! NSNumber)
                        self.cardAcceptorCityValue.append(transaction["card_acceptor_city"]! as! String)
                        self.cardAcceptorStateValue.append(transaction["card_acceptor_state"]! as! String)
                        self.cardAcceptorCountryValue.append(transaction["card_acceptor_country"]! as! String)
                        
                        let trans = (self.cardAcceptorValue[x], self.postAmountValue[x], self.dateValue[x], self.cardNumValue[x], self.fraudFlagValue[x], self.cardAcceptorCityValue[x], self.cardAcceptorStateValue[x], self.cardAcceptorCountryValue[x])
                        //print(trans)
                        //self.transactions.append(trans)
                        
                        //print(trans.3)
                        
                        if trans.3 == "4888887992597070"{
                            self.card1.append(trans)
                            if self.CARD_TO_USE == "CARD1"{
                                //self.debitCardButtonVar.setTitleColor(UIColor.darkGray, for: [])
                                self.transactions.append(trans)
                            }
                        }else if trans.3 == "4888889523448350"{
                            self.card2.append(trans)
                            if self.CARD_TO_USE == "CARD2"{
                                //self.creditCardButtonVar.setTitleColor(UIColor.darkGray, for: [])
                                self.transactions.append(trans)
                            }
                        }
                        
                        x += 1
                    }
                }
                
            }
            
            /*var indx = 0
            for transaction in self.transactions{
                if transaction.fraudFlag != 0{
                    self.transactions.remove(at: indx)
                    self.transactions.insert(transaction, at: 0)
                }
                indx += 1
            }
            indx = 0
            for transaction in self.card1{
                if transaction.fraudFlag != 0{
                    self.card1.remove(at: indx)
                    self.card1.insert(transaction, at: 0)
                }
                indx += 1
            }
            indx = 0
            for transaction in self.card2{
                if transaction.fraudFlag != 0{
                    self.card2.remove(at: indx)
                    self.card2.insert(transaction, at: 0)
                }
                indx += 1
            }*/
            
            DispatchQueue.main.async {
                self.transactionTable.reloadData()
            }
            
            //self.transactionTable.reloadData()
        }
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
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
        
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as UITableViewCell
        
        let cellIdentifier = "cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        }
        
        
        cell?.textLabel?.text = self.transactions[indexPath.row].cardAcceptor
        //print(self.cardAcceptorValue[0] as? String)
        cell?.detailTextLabel?.text = String(format:"$%.2f", self.transactions[indexPath.row].postAmount.doubleValue)
        cell?.detailTextLabel?.textColor = UIColor.black
        //print(self.postAmountValue[0] as? String)
        
        if self.transactions[indexPath.row].fraudFlag == 3 as NSNumber{
            cell?.backgroundColor = UIColor(red:0.87,green:0.55,blue:0.54,alpha:1.0)
        }else if self.transactions[indexPath.row].fraudFlag == 2 as NSNumber{
            cell?.backgroundColor = UIColor.clear
        }else if self.transactions[indexPath.row].fraudFlag == 1 as NSNumber{
            cell?.backgroundColor = UIColor(red:1.00,green:0.89,blue:0.77,alpha:1.0)
        }else if self.transactions[indexPath.row].fraudFlag == 0 as NSNumber{
            cell?.backgroundColor = UIColor.clear
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*let cardAcceptor = self.cardAcceptorValue[indexPath.row]
        let postAmount = self.postAmountValue[indexPath.row]
        let date = self.dateValue[indexPath.row]
        let cardNum = self.cardNumValue[indexPath.row]
        let fraudFlag = self.fraudFlagValue[indexPath.row]
        var _ff = ""
        let city = self.cardAcceptorCityValue[indexPath.row]
        let state = self.cardAcceptorStateValue[indexPath.row]
        let country = self.cardAcceptorCountryValue[indexPath.row]*/
        
        let cardAcceptor = self.transactions[indexPath.row].cardAcceptor
        let postAmount = self.transactions[indexPath.row].postAmount
        let date = self.transactions[indexPath.row].date
        let cardNum = self.transactions[indexPath.row].cardNum
        let fraudFlag = self.transactions[indexPath.row].fraudFlag
        var _ff = ""
        let city = self.transactions[indexPath.row].cardAcceptorCity
        let state = self.transactions[indexPath.row].cardAcceptorState
        let country = self.transactions[indexPath.row].cardAcceptorCountry
        
        let location = city + ", " + state + ", " + country
        
        if fraudFlag == 0 as NSNumber{
            _ff = "None"
        }else if fraudFlag == 1 as NSNumber{
            _ff = "THIS RECURRING PAYMENT HAS INCREASED"
        }else if fraudFlag == 2 as NSNumber{
            _ff = "THIS PAYMENT IS POTENTIALLY FRAUDULENT"
        }else if fraudFlag == 3 as NSNumber{
            _ff = "THIS PAYMENT IS LIKELY FRAUDULENT"
        }
        
        var msg = "Description: " + cardAcceptor + " " + location +  " \n " + "Amount: "
        msg += String(format:"$%.2f", postAmount.doubleValue)
        msg += " \n " + "Date: " + date + " \n " + "Card Number: "
        msg += cardNum
        msg += " \n " + "Warnings: "
        msg += _ff + " \n "
        //msg += "Fraud Flag: "
        //msg += String(format:"%i", fraudFlag.intValue)
        let alert = UIAlertController(title: "Transaction Details", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
        
        
    }
    
    @IBAction func openMenu2(_ sender: Any) {
        if (menuShowing) {
            leadingContraint.constant = -150
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.view.layoutIfNeeded()
            })
        }else{
            leadingContraint.constant = 0
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.view.layoutIfNeeded()
            })
        }
        
        menuShowing = !menuShowing
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
    
    var indicator = UIActivityIndicatorView()
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        callDtaFromWeb()
        self.transactionTable.reloadData()
        refreshControl.endRefreshing()
    }

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    @IBOutlet weak var debitCardButtonVar: UIButton!
    
    @IBOutlet weak var creditCardButtonVar: UIButton!
    
    @IBAction func debitCardButton(_ sender: Any) {
        creditCardButtonVar.setTitleColor(UIColor.blue, for: [])
        
        self.transactions.removeAll()
        
        for trans in card1{
            self.transactions.append(trans)
        }
        
        CARD_TO_USE = "CARD2"
        
        self.transactionTable.reloadData()
        
        openMenu2(menuButton)
        
        debitCardButtonVar.setTitleColor(UIColor.darkGray, for: [])
    }
    
    @IBAction func creditCardButton(_ sender: Any) {
        debitCardButtonVar.setTitleColor(UIColor.blue, for: [])
        
        self.transactions.removeAll()
        
        for trans in card2{
            self.transactions.append(trans)
        }
        
        CARD_TO_USE = "CARD1"
        
        self.transactionTable.reloadData()
        
        openMenu2(menuButton)
        
        creditCardButtonVar.setTitleColor(UIColor.darkGray, for: [])
    }
}

