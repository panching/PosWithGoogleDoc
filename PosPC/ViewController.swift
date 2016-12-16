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
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    var googleDocProduct = [Product]()
    var chooseArray = [Product]()
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // set Defult Products
        self.setDefultItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getDefultItem(_ sender: Any) {
        self.setDefultItem()
    }
    
    @IBAction func getGoogleDocItem(_ sender: Any) {
        self.loadingIndicatorView.startAnimating()
        self.postRequest()
    }
    
    @IBAction func doClear(_ sender: Any) {
        chooseArray = [Product]()
        totalLabel.text = "$ 0 元"
        self.itemTableView.reloadData()
    }
    
    func setDefultItem() -> Void {
        googleDocProduct = [Product]()
        products = [Product]()
        //create defult products
        for i in 0...10 {
            let item = Product(name:"飲料 \(i+1) 號", money: (i+1)*10)
            products.append(item)
        }
        self.itemCollectionView.reloadData()
    }
    
    //postRequest get googleDoc Excel
    func postRequest() -> Void {
        
        guard googleDocProduct.count == 0 else {
            googleDocProduct = [Product]()
            self.loadingIndicatorView.stopAnimating()
            return
        }
        //Use AFNetworking post googleURL get jsonData
        let manager = AFHTTPSessionManager()
        do {
            var counter = 0
            //googleDoc value array
            var itemNameArray = [String]()
            var itemMoneyArray = [String]()
            
            manager.get(googleDoc, parameters: nil, success: { (oper, data) -> Void in
                let jsonDict = data as? Dictionary<String, Any>
                let feedDict = jsonDict?["feed"] as? Dictionary<String, Any>
                guard let entryArray = feedDict?["entry"] as? Array<Any> else{
                    return
                }
                // json parser google cell
                //ex. 
                //"content":{"type":"text","$t":"drink"} << cellInfo
                //"content":{"type":"text","$t":"$20"} << cellInfo
                for temp in entryArray {
                    guard let tempDict = temp as? Dictionary <String, Any> else{
                        return
                    }
                    let content = tempDict["content"] as? Dictionary <String, Any>
                    guard let cellInfo = content?["$t"] as? String else{
                        return
                    }
                    
                    if (counter % 2) == 0{
                        itemNameArray.append(cellInfo)
                    }else{
                        itemMoneyArray.append(cellInfo)
                    }
                    counter += 1
                }
             
                //create googleDoc Products
                for i in 0..<itemNameArray.count{
                    let item = Product()
                    item.itemName = itemNameArray[i]
                    item.itemMoney = Int(itemMoneyArray[i])!
                    self.googleDocProduct.append(item)
                }
                
                self.itemCollectionView.reloadData()
                self.loadingIndicatorView.stopAnimating()
            }) { (opeation, error) -> Void in
                self.loadingIndicatorView.stopAnimating()
                print(error)
            }
        } catch {
            self.loadingIndicatorView.stopAnimating()
            print("Error ! \(error)")
        }

    }
    
    //MARK: - collectionView Method
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if(googleDocProduct.count>0){
            return googleDocProduct.count
        }else{
            return products.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemCollectionViewCell
        let tempArray:Array<Any>
        if(googleDocProduct.count>0){
            tempArray = googleDocProduct
        }else{
            tempArray = products
        }
        let item = tempArray[indexPath.row] as! Product
        cell.itemImage.image = item.itemImage
        cell.itemName.text = item.itemName
        cell.itemMoney.text = "$\(item.itemMoney)"
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let tempArray:Array<Any>
        if(googleDocProduct.count>0){
            tempArray = googleDocProduct
        }else{
            tempArray = products
        }
        chooseArray.append(tempArray[indexPath.row] as! Product)
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
        cell.itemAmount.text = "$ \(String(item.itemMoney))"
        return cell
    }

}

