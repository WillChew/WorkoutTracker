//
//  WorkoutViewController.swift
//  WorkoutTracker
//
//  Created by Will Chew on 2020-01-22.
//  Copyright © 2020 Will Chew. All rights reserved.
//

import UIKit
import CoreData


class WorkoutViewController: UIViewController {
    
    var workout: Workout!
    
    @IBOutlet weak var tableView: UITableView!
    var managedContext : NSManagedObjectContext!
    var exercisesArray = [Exercise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
            managedContext = appDelegate?.persistentContainer.viewContext
//        exercisesArray = workout.exercise?.allObjects as! [Exercise]
        exercisesArray = workout.exercise?.array as! [Exercise]
        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addExerciseButtonPressed(_ sender: UIBarButtonItem) {
        addExercise()
    }
    @IBAction func addSetButtonPressed(_ sender: Any) {
        
    }
    
}

extension WorkoutViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workout.exercise!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        
        return exercisesArray[section].name
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return exercisesArray[section].set!.count + 2
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitlesCell", for: indexPath)
            cell.textLabel?.text = "titles"
            return cell
        }
        
        if indexPath.row == exercisesArray[indexPath.section].set!.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath)
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
        cell.textLabel?.text = "TEST"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension WorkoutViewController {
    
    func addExercise() {
        do {
            let pullups = Exercise(context: managedContext)
            pullups.name = "Pullups"
            pullups.uuid = UUID()
            
            workout.addToExercise(pullups)
            try managedContext.save()
            
        } catch {
            print("error adding exercise : \(error)")
        }
        tableView.reloadData()
    }
}
