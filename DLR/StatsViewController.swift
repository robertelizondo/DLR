//
//  StatsViewController.swift
//  DLR
//
//  Created by Robert Elizondo on 9/6/20.
//  Copyright © 2020 Robert Elizondo. All rights reserved.
//

import UIKit

struct pool: Decodable{
    let name: String
    let balance: Int
    let winner: String
    let hasBusted: Bool
}

struct poolList: Decodable{
    let pools: [pool]
}

var curr = 0

var siz : Int = Int()

var poolsJson = [pool]()

class StatsViewController: UIViewController {

    
    @IBOutlet var nameLab: UILabel! //name label
    
    
    @IBOutlet var balanceLab: UILabel! //balance label
    
    
    @IBOutlet var bustedLab: UILabel! //busted label
    
    
    @IBOutlet var actIndB: UIActivityIndicatorView! //activity indicator bust
    
    @IBOutlet var winnerLab: UILabel! //winner label
    
    @IBOutlet var actIndW: UIActivityIndicatorView! //activity indicator winner
    
    
    
    var timerB: Timer!
    var timerW: Timer!
    
    
    var recEmail = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        actIndB.hidesWhenStopped = true
        actIndW.hidesWhenStopped = true

        
    
        let jsonUrlString = "http://192.168.1.16:3000/api/v1/pools/getbyuser/"+recEmail
        
        
        guard let url = URL(string: jsonUrlString)else
        {return}
        
        URLSession.shared.dataTask(with: url) { (data, respnse, err) in
            
            guard let data = data else{return}
                    
            
            do{
                poolsJson = try JSONDecoder().decode([pool].self, from: data)
                
                siz = (poolsJson.count)
                
                DispatchQueue.global(qos: .background).async {
                     DispatchQueue.main.async {
                        self.nameLab.text = poolsJson[curr].name
                        self.balanceLab.text = "$"+String(poolsJson[curr].balance)
                        
                        self.timerB = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.actAnimateB), userInfo: nil, repeats: false)
                        
                        if(poolsJson[curr].winner != "N/A"){
                            self.timerW = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(self.actAnimateW), userInfo: nil, repeats: false)
                        }
                        
                        

                     }
                 }

            }catch let jsonErr{
                print("Error parsing json: ", jsonErr)
            }
            
            
            
        }.resume()
        
    }
    
    //down button func
        
    @IBAction func downButton(_ sender: Any) {
        
        self.bustedLab.text = ""
        self.winnerLab.text = ""
                
        if(curr+1 != siz){
            
            curr += 1
            
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    self.nameLab.text = poolsJson[curr].name
                    self.balanceLab.text = "$"+String(poolsJson[curr].balance)
                    
                    
                    self.timerB = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.actAnimateB), userInfo: nil, repeats: false)
                    
                    if(poolsJson[curr].winner != "N/A"){
                        self.timerW = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(self.actAnimateW), userInfo: nil, repeats: false)
                    }
                }
            }

        }
    }
    
    
    // up arrow func
    

    @IBAction func upButton(_ sender: Any) {
        
        self.bustedLab.text = ""
        self.winnerLab.text = ""
        
        if(curr != 0){
            
            curr -= 1

            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    self.nameLab.text = poolsJson[curr].name
                    self.balanceLab.text = "$"+String(poolsJson[curr].balance)
                    
                    self.timerB = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.actAnimateB), userInfo: nil, repeats: false)
                                        
                    if(poolsJson[curr].winner != "N/A"){
                        self.timerW = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.actAnimateW), userInfo: nil, repeats: false)
                    }

                }
            }

        }
        
        
    }
    

    
    @objc func actAnimateB(){ //animates the activity indicator for busted lable
        actIndB.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.actIndB.stopAnimating()
            
            if(poolsJson[curr].hasBusted == true){
                self.bustedLab.textColor = UIColor.systemGreen
                self.bustedLab.text = "YES"
            }
            else{
                self.bustedLab.textColor = UIColor.systemRed
                self.bustedLab.text = "NO"
            }
            
            self.timerB.invalidate()
        }
    }
 
    
    @objc func actAnimateW(){ //animates the activity indicator for busted lable
        
        actIndW.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.actIndW.stopAnimating()
            
            if(poolsJson[curr].winner == self.recEmail){
                self.winnerLab.text = "YOU ARE THE WINNER"
            }
            else{
                self.winnerLab.text = "Winner is: " + poolsJson[curr].winner
            }
    
            self.timerW.invalidate()
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
