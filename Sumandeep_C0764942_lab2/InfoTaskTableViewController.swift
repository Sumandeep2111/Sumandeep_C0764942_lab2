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
    
    var Tasks:[Taskinfo]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadCoreData()
    }
    
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
                cell?.detailTextLabel?.text = "\(task.days) days"

        // Configure the cell...

        return cell!
    }
    

    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

       
       let deleteaction = UITableViewRowAction(style: .normal, title: "Delete") { (rowaction, indexPath) in
           
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                  let ManagedContext = appDelegate.persistentContainer.viewContext
                  let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EntityTask")
           do{
               let data = try ManagedContext.fetch(fetchRequest)
               let item = data[indexPath.row] as? NSManagedObject
               self.Tasks?.remove(at: indexPath.row)
            ManagedContext.delete(item!)
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
              deleteaction.backgroundColor = UIColor.red
              return [deleteaction]
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
