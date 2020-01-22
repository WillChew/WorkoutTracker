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
        
        //                exercisesArray = workout.exercise?.allObjects as! [Exercise]
        exercisesArray = workout.exercise?.array as! [Exercise]
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchExercises()
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
        var nameTextField : UITextField?
        let alert = UIAlertController(title: "Add exercise", message: "", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            nameTextField = textfield
            nameTextField?.placeholder = "Exercise name"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            self.addExercise(nameTextField!.text ?? "unnamed exercise")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    @IBAction func addSetButtonPressed(_ sender: Any) {
        let button = sender as! UIButton
        guard let section = button.superview?.tag else { return }
//        print(exercisesArray[section])
        let exercise = exercisesArray[section]
        print(section)
        addSet(to: exercise)
        
        
        
    }
    
}

extension WorkoutViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(workout.exercise!.count)
        return workout.exercise!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
            
            return exercisesArray[section].name
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if exercisesArray.count == 0 {
            return 2
        } else {
            return (exercisesArray[section].set?.array.count)! + 2
           
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitlesCell", for: indexPath)
            cell.textLabel?.text = "titles"
            return cell
        }
        
//        if indexPath.row == 1  {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonTableViewCell
//            cell.addSetButton.superview?.tag = indexPath.section
//            return cell
//        }
        
        if indexPath.row > (exercisesArray[indexPath.section].set?.array.count)!  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonTableViewCell
            cell.addSetButton.superview?.tag = indexPath.section
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
    
    func fetchExercises() {
        let fetch : NSFetchRequest<Exercise> = Exercise.fetchRequest()
//        fetch.predicate = NSPredicate(format: "%K == %@", "uuid", workout.uuid! as CVarArg)
        do {
//            exercisesArray = try managedContext.fetch(fetch)
            let results = try managedContext.fetch(fetch)

//            exercisesArray = workout.exercise?.array as! [Exercise]
            
            
            //            let results = try managedContext.fetch(fetch)
            //            for result in results {
            //                managedContext.delete(result)
            //            }
                        try managedContext.save()
        } catch {
            print("Error fetching info")
        }
    }
    
    func addExercise(_ name: String) {
        do {
            let exercise = Exercise(context: managedContext)
            exercise.name = name
            exercise.uuid = UUID()
            
            workout.addToExercise(exercise)
            exercisesArray = workout.exercise?.array as! [Exercise]
            try managedContext.save()
            
        } catch {
            print("error adding exercise : \(error)")
        }
        tableView.reloadData()
    }
    
    
    func addSet(to exercise: Exercise) {
        
        do {
            let set = Sett(context: managedContext)
            set.uuid = UUID()
            set.reps = 5
            set.weight = 100.0
            exercise.addToSet(set)
            try managedContext.save()
        } catch {
            print("error adding set")
        }
        tableView.reloadData()
    }
}
