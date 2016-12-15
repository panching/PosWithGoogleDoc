//
//  ViewController.swift
//  PosPC
//
//  Created by ChingPan on 2016/12/15.
//  Copyright © 2016年 pan. All rights reserved.
//

import UIKit
import AFNetworking
private let googleDoc = "https://spreadsheets.google.com/feeds/cells/1Su_W_SQU1UBZ2g0PY59-WLL6kQqVQTfIOwb_HB4vYJw/1/public/values?alt=json"

private let reuseIdentifier = "Cell"
class ViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var itemCollectionView: UICollectionView!

    var chooseArray = [Product]()
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //create products
        for i in 0...10 {
            let item = Product(name:"飲料 \(i) 號", money: i)
            products.append(item)
        }
        
        self.postRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //postRequest get googleDoc Excel
    func postRequest() -> Void {
        
        //Use AFNetworking post googleURL get jsonData
        let afn = AFHTTPSessionManager()
        afn.get(googleDoc, parameters: nil, success: { (oper, data) -> Void in
            print(data)
        }) { (opeation, error) -> Void in
            print(error)
        }
    }
    
    //MARK: - collectionView Method
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return products.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemCollectionViewCell
        
        let item = products[indexPath.row]
        cell.itemImage.image = item.itemImage
        cell.itemName.text = item.itemName
        cell.itemMoney.text = "$\(item.itemMoney)"
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        chooseArray.append(products[indexPath.row])
        var total = 0
        for item in chooseArray {
            total += item.itemMoney
        }
        totalLabel.text = "$\(total) 元"
        itemTableView.reloadData()
    }
    
    //MARK: - tableView Method
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return chooseArray.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ItemTableViewCell
        let item = chooseArray[indexPath.row]
        cell.itemImage.image = item.itemImage
        cell.itemName.text = item.itemName
        cell.itemType.text = ""
        cell.itemAmount.text = "1"
        return cell
    }

}

