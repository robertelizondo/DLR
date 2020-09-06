//
//  ViewController.swift
//  DLR
//
//  Created by Robert Elizondo on 9/5/20.
//  Copyright © 2020 Robert Elizondo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var _user: UITextField!
    
    @IBOutlet var _pass: UITextField!
    
    @IBOutlet var _text: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.shadowImage = UIImage()
        _user.delegate = self
        _pass.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        let uString: String = _user.text!
        
        let jsonUrlString = "http://192.168.1.16:3000/api/v1/users/checkforemail/"+uString
        
        
        guard let url = URL(string: jsonUrlString)else
        {return}
        
        URLSession.shared.dataTask(with: url) { (data, respnse, err) in
            
            guard let data = data else{return}
                    
            let foundData = String(data: data, encoding: .utf8)
                    
            print(foundData)
                    
            
            if(foundData == "{\"found\":true}"){
                print("trueeeeeeee")
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toStats", sender: nil)
                    }
                }
            }
            
        }.resume()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let statsVC: StatsViewController = segue.destination as! StatsViewController
        
        let passedPhrase = _user.text!
        
        statsVC.recEmail = passedPhrase
    }

}


extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ _text: UITextField) -> Bool {
        _text.resignFirstResponder()
        return true
    }
    
}
