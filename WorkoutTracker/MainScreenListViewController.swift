//
//  MainScreenListViewController.swift
//  WorkoutTracker
//
//  Created by Will Chew on 2020-01-22.
//  Copyright © 2020 Will Chew. All rights reserved.
//

import UIKit
import CoreData

class MainScreenListViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    var managedContext: NSManagedObjectContext!
    var workouts = [Workout]()
    var selectedWorkout: Workout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
//        deleteAll()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchWorkouts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WorkoutSegue" {
            let vc = segue.destination as! WorkoutViewController
            vc.workout = selectedWorkout
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
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var nameTF : UITextField?
        
        let alert = UIAlertController(title: "Add a workout", message: "", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            nameTF = textfield
            nameTF?.placeholder = "Add a name"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            self.addWorkout(workout: nameTF?.text ?? "No name")
            self.fetchWorkouts()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
  
}

extension MainScreenListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !workouts.isEmpty {
            return workouts.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if !workouts.isEmpty {
            cell.textLabel?.text = workouts[indexPath.row].name
        } else {
            cell.textLabel?.text = "HI"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !workouts.isEmpty {
        selectedWorkout = workouts[indexPath.row]
            performSegue(withIdentifier: "WorkoutSegue", sender: self)
        }
    }
}

extension MainScreenListViewController {
    
    func fetchWorkouts() {
        let fetch : NSFetchRequest<Workout> = Workout.fetchRequest()
        
        do {
            workouts = try managedContext.fetch(fetch)
            
        } catch let error as NSError {
            print("Error fetching workout : \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func addWorkout(workout name: String) {
        
        let workout = Workout(context: managedContext)
        workout.name = name
        workout.uuid = UUID()
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error saving workout: \(error), \(error.userInfo)")
        }
    }
    
    func deleteAll() {
        let fetch : NSFetchRequest<Workout> = Workout.fetchRequest()
        
        do {
            let results = try managedContext.fetch(fetch)
            
            for result in results {
                managedContext.delete(result)
            }
        } catch {
            print("Error deleting")
        }
    }
}


