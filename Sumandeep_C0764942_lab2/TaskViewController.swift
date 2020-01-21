//
//  TaskViewController.swift
//  Sumandeep_C0764942_lab2
//
//  Created by MacStudent on 2020-01-21.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {
    
    var Tasks: [Taskinfo]?
    var taskTable: InfoTaskTableViewController?
    
    
    @IBOutlet weak var nameTextfld: UITextField!
    
    @IBOutlet weak var daystextfld: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveCoreData()
         NotificationCenter.default.addObserver(self, selector: #selector(saveCoreData), name: UIApplication.willResignActiveNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func addTask(_ sender: UIButton) {
               let name = nameTextfld.text ?? ""
               let days = daystextfld.text ?? ""
               let task = Taskinfo(name: name, days: Int(days) ?? 0)
               Tasks?.append(task)
               nameTextfld.text = ""
               daystextfld.text = ""
               nameTextfld.resignFirstResponder()
        
    }
    
    @objc func saveCoreData() {
             // call clear core data
           
            clearCoreData()

             // create an instance of app delegate
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             // second step is context
             let managedContext = appDelegate.persistentContainer.viewContext

             for task in Tasks! {
                 let taskEntity = NSEntityDescription.insertNewObject(forEntityName: "EntityTask", into: managedContext)
                 taskEntity.setValue(task.name, forKey: "name")
               taskEntity.setValue(task.days, forKey: "days")

                print("\(task.days)")
                 // save context
                 do {
                     try managedContext.save()
                 } catch {
                     print(error)
                 }
                print("days:\(task.days)")
             }
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
        print(Tasks!.count)
    }
    override func viewWillDisappear(_ animated: Bool) {
        taskTable?.updateTask(taskArray: Tasks!)
    }
    
    func clearCoreData() {
              // create an instance of app delegate
              let appDelegate = UIApplication.shared.delegate as! AppDelegate
              // second step is context
              let managedContext = appDelegate.persistentContainer.viewContext
              // create a fetch request
              let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EntityTask")

              fetchRequest.returnsObjectsAsFaults = false

              do {
                  let results = try managedContext.fetch(fetchRequest)
                  for managedObjects in results {
                      if let managedObjectData = managedObjects as? NSManagedObject {
                          managedContext.delete(managedObjectData)
                      }
                  }
              } catch {
                  print(error)
              }

          }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//
//        taskTable?.updateTask(taskArray: Tasks!)
//    }
    

}
