//
//  ViewController.swift
//  Anomaly_Dection_iOS
//
//  Created by CSE498 on 9/26/18.
//  Copyright © 2018 CSE498. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let list = ["Type...................Credit Card",
                "Transaction Amount.....-$31.42",
                "Posted Date............Oct 2, 2018",
                "Transaction Date.......Oct 1, 2018",
                "Card Number............x1234",
                "New Balance............$271.83",
                "Description............DARTH PLAGUEIS W., SAN FRANCISCO, CA",
                "Warnings...............POTENTIAL FRAUDULENT TRANSACTION"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(list.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = list[indexPath.row]
        return(cell)
    }
    
    //MARK: Properties
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet var White: [UIImageView]!
    @IBOutlet var MSUFCU: [UILabel]!
    @IBOutlet weak var ProfileButton: UIButton!
    @IBOutlet weak var TransactionsLabel: UILabel!
    @IBOutlet weak var WhiteBar2: UIImageView!
    @IBOutlet weak var AccountsImg: UIImageView!
    @IBOutlet weak var MoveMoneyImg: UIImageView!
    @IBOutlet weak var eDepositImg: UIImageView!
    @IBOutlet weak var MyOffersImg: UIImageView!
    @IBOutlet weak var AccountsLabel: UILabel!
    @IBOutlet weak var MoveMoneyLabel: UILabel!
    @IBOutlet weak var eDepositLabel: UILabel!
    @IBOutlet weak var MyOffersLabel: UILabel!
    @IBOutlet weak var EmbeddedTable: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

