//
//  containerViewController.swift
//  To Do (Minimalistic Design)
//
//  Created by Roy Akash on 03/03/19.
//  Copyright © 2019 The Roy Akash Software, Company. All rights reserved.
//

import UIKit

class containerViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    var todoTableViewController: ToDoTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentDate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TodoVC" {
            todoTableViewController = ((segue.destination as! UINavigationController).children.first as! ToDoTableViewController)            
        }
    }
    
    @IBOutlet weak var dateViewLabel: UILabel!
    func getCurrentDate(){
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let getStringFromFormatter = formatter.string(from: Date())
        dateViewLabel.text = getStringFromFormatter
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
