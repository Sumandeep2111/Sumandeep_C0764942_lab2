//
//  InfoTaskTableViewController.swift
//  Sumandeep_C0764942_lab2
//
//  Created by MacStudent on 2020-01-21.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData

class InfoTaskTableViewController: UITableViewController {
    
    
    @IBOutlet weak var sortByTitle: UIBarButtonItem!
    
    @IBOutlet weak var sortByDate: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var Tasks:[Taskinfo]?
    var items:[NSManagedObject] = []
    var addDays = "0"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadCoreData()
    }
    
    
    //sorting
    
    @IBAction func sortTitle(_ sender: UIBarButtonItem) {
        let sortTask = self.Tasks!
        self.Tasks! = sortTask.sorted{$0.name < $1.name}
        self.tableView.reloadData()
    }
    
    
    @IBAction func sortDays(_ sender: UIBarButtonItem) {
        
        let sortDays = self.Tasks!
        self.Tasks! = sortDays.sorted{$0.days < $1.days}
        self.tableView.reloadData()
    }
    
    
    //core data file
    func loadCoreData() {
           Tasks = [Taskinfo]()
           // create an instance of app delegate
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           // second step is context
           let managedContext = appDelegate.persistentContainer.viewContext

           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EntityTask")

           do {
               let Taskres = try managedContext.fetch(fetchRequest)
               if Taskres is [NSManagedObject] {
                   for task in Taskres as! [NSManagedObject] {
                       let taskname = task.value(forKey: "name") as! String
                       let taskdays = task.value(forKey: "days") as! Int
                       Tasks?.append(Taskinfo(name: taskname, days: Int(taskdays) ))
                   }
               }

           } catch {
               print(error)
           }

       }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Tasks?.count ?? 0
    }

    
    func updateTask(taskArray: [Taskinfo]){
        Tasks = taskArray
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let task = Tasks![indexPath.row]
         let cell = tableView.dequeueReusableCell(withIdentifier: "cellTask")
            
        // Configure the cell...
                cell?.textLabel?.text = task.name
        cell?.detailTextLabel?.text = "\(task.days) days + \(task.counter) completed days"
        
        if Tasks?[indexPath.row].counter == self.Tasks?[indexPath.row].days{
            cell?.backgroundColor = UIColor.gray
            cell?.textLabel?.text = "Completed"
            cell?.detailTextLabel?.text = ""
            
        }

        // Configure the cell...

        return cell!
    }
    

    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let actionAdd = UITableViewRowAction(style: .normal, title: "Add Day") { (rowaction, indexPath) in
                        print("days added")
                        let alertcontroller = UIAlertController(title: "Add Day", message: "Enter a day for this task", preferredStyle: .alert)
                                       
                                       alertcontroller.addTextField { (textField ) in
                                                       textField.placeholder = "number of days"
                                        self.addDays = textField.text!
                                        print(self.addDays)
                                        
                                           textField.text = ""
                                        
                                       }
                                       let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                                       CancelAction.setValue(UIColor.brown, forKey: "titleTextColor")
                                       let AddItemAction = UIAlertAction(title: "Add Item", style: .default){
                                           (action) in
                                        let count = alertcontroller.textFields?.first?.text
                                        self.Tasks?[indexPath.row].counter += Int(count!) ?? 0
                                        
                                        if self.Tasks?[indexPath.row].counter == self.Tasks?[indexPath.row].days{
                                            
                                            print("equal")
                      
                                                    

                                            }
                                            
                                        
                                    
                                        self.tableView.reloadData()
                                        
                                
                            }
                                AddItemAction.setValue(UIColor.black, forKey: "titleTextColor")
                                                     alertcontroller.addAction(CancelAction)
                                                     alertcontroller.addAction(AddItemAction)
                                                     self.present(alertcontroller, animated: true, completion: nil)
                    }
                    actionAdd.backgroundColor = UIColor.orange
                    
            
                    let actionDelete = UITableViewRowAction(style: .normal, title: "Delete") { (rowaction, indexPath) in
                        
                        
                              // let taskItem = self.tasks![indexPath.row] as? NSManagedObject
                               let appDelegate = UIApplication.shared.delegate as! AppDelegate
                               let ManagedContext = appDelegate.persistentContainer.viewContext
                               let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EntityTask")
                        do{
                            let task = try ManagedContext.fetch(fetchRequest)
                            let item = task[indexPath.row] as!NSManagedObject
                            self.Tasks?.remove(at: indexPath.row)
                            ManagedContext.delete(item)
                            tableView.reloadData()
                            
                            do{
                                        try ManagedContext.save()
                                }
                        
                            catch{
                                               print(error)
                                           }
                        }
                        catch{
                            print(error)
                        }
                               
                            

                    }
                         actionDelete.backgroundColor = UIColor.blue
                           return [actionAdd,actionDelete]

       
      
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let detailView = segue.destination as? TaskViewController {
                   detailView.taskTable = self
                   detailView.Tasks = Tasks
               }
    }
    

}
