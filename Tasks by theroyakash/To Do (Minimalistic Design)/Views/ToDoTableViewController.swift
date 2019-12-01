//
//  ToDoTableViewController.swift
//  To Do (Minimalistic Design)
//
//  Created by Roy Akash on 10/12/18.
//  Copyright © 2018 The Roy Akash Software, Company. All rights reserved.
//

import UIKit
import StoreKit

//var hasAskedForReview = false

class ToDoTableViewController: UITableViewController {
    
    var addButtonReference: UIButton!    
    var todoItems:[toDoItem]!{
        didSet{
            progressBar.setProgress(progress, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        whatsNewIfNeeded()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        if !hasAskedForReview && todoItems.count >= 4 {
//            hasAskedForReview = true
//            SKStoreReviewController.requestReview()
//        }
//
//    }
    
    func whatsNewIfNeeded(){
        let items = [WhatsNew.Item(
                        title: "HapticTouch Support",
                        subtitle: "Haptic touch support for all iPhones",
                        image: UIImage(named: "3d")
                    ),
                     WhatsNew.Item(
                                title: "Beautiful DarkMode",
                                subtitle: "System-wide darkMode support for iOS 13 or Later, hand-crafted",
                                image: UIImage(named: "darkMode")
                    ),
                     WhatsNew.Item(title: "Localized Data",
                      subtitle: "Your data don't leave your iPhone. What you write on your iPhone stays on your iPhone",
                      image: UIImage(named: "lock")
                    ),
                     WhatsNew.Item(title: "No ads",
                      subtitle: "Full Ad free experience & will remain ad free forever",
                      image: UIImage(named: "adFree")
                    ),
                      WhatsNew.Item(title: "No Subscription Fee",
                      subtitle: "No Recurring Subscription Fee at all",
                      image: UIImage(named: "subs")
                        ),
                      WhatsNew.Item(
                    title: "State of the Art Machine Learning",
                    subtitle: "This app will use Machine learning to predict what you write, Still in beta",
                    image: UIImage(named: "artificial-intelligence")
                )
        ]
        
        let theme = WhatsNewViewController.Theme {configuration in
            configuration.apply(animation: .slideUp)
            configuration.apply(theme: .default)
        }
        
        let config = WhatsNewViewController.Configuration(theme: theme)
        let keyValueVersionStore = KeyValueWhatsNewVersionStore(keyValueable: UserDefaults.standard)
        let whatsnew = WhatsNew(title: "What's new in Tasks by theroyakash", items: items)
        let whatsNewVC = WhatsNewViewController(whatsNew: whatsnew, configuration: config, versionStore: keyValueVersionStore)
        
        if let VC = whatsNewVC{
            self.present(VC, animated: true)
        }
    }
    
    func loadData(){
        todoItems = [toDoItem]()
        todoItems = DataManager.loadAll(toDoItem.self).sorted(by:{
            $0.createdAt < $1.createdAt
        })
        tableView.reloadData()
        progressBar.setProgress(progress, animated: true)
    }
    
    @IBOutlet weak var progressBar: UIProgressView!
    var progress: Float{
        if todoItems.count > 0 {
            return Float(todoItems.filter({$0.completed}).count) / Float(todoItems.count)
        } else {
            return 0
        }
    }
    
    @IBAction func addNewTodo(_ sender: Any) {
        let addAlert = UIAlertController(title: "Add New Task", message: "Added task can be deleted by swiping left and can be marked completed by tapping over it.", preferredStyle: .alert)
        addAlert.addTextField { (textfield:UITextField) in
            textfield.placeholder = "Write your task here?"
            
        }
        addAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action:UIAlertAction) in
            guard let title = addAlert.textFields?.first?.text else {return}
            let newTodo = toDoItem(title: title, completed: false, createdAt: Date(), itemIdentifier: UUID())
            newTodo.saveItem()
            
            self.todoItems.append(newTodo)
            let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }))
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(addAlert, animated: true, completion: nil)
        
    }
    
    func completeToDoItem(_ indexPath: IndexPath) {
        var todoItem = todoItems[indexPath.row]
        todoItem.markAsCompleted()
        todoItems[indexPath.row] = todoItem
        
        if let cell = tableView.cellForRow(at: indexPath) as? ToDoTableViewCell{
            cell.todoLabel.attributedText = strikeThroughText(todoItem.title)
            
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = cell.transform.scaledBy(x: 1.1, y: 1.1)
            }) { (success) in
                UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform.identity
                }, completion: nil)
            }
        }
    }
    
    func strikeThroughText (_ text: String) -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSMutableAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (acti0on:UITableViewRowAction, indexPath:IndexPath) in
            self.todoItems[indexPath.row].deleteItem()
            self.todoItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        deleteAction.backgroundColor = UIColor.red
        return [deleteAction]
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completeToDoItem(indexPath)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ToDoTableViewCell
        let todoItem = todoItems[indexPath.row]
        
        cell.todoLabel.text = todoItem.title

        if todoItem.completed{
            cell.todoLabel.attributedText = strikeThroughText(todoItem.title)
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
