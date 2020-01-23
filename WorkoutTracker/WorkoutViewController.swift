//
//  WorkoutViewController.swift
//  WorkoutTracker
//
//  Created by Will Chew on 2020-01-22.
//  Copyright © 2020 Will Chew. All rights reserved.
//

import UIKit
import CoreData


class WorkoutViewController: UIViewController, UITextFieldDelegate {
    
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
        
        let dismissKB = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        dismissKB.cancelsTouchesInView = false
        tableView.addGestureRecognizer(dismissKB)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        fetchExercises()
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
        
        let exercise = exercisesArray[section]
        
        addSet(to: exercise)
        
        
    }
    
    @IBAction func noteButtonPressed(_ sender: Any) {
        print("HI")
    }
    
    
}

extension WorkoutViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return workout.exercise!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        return exercisesArray[section].name
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //
    //        let myLabel = UILabel()
    //        myLabel.frame = CGRect(x: 10, y: 8, width: 320, height: 25)
    //        myLabel.font = UIFont.systemFont(ofSize: 25)
    //
    //        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
    //
    //        let headerView = UIView()
    //        headerView.addSubview(myLabel)
    //
    //        return headerView
    //    }
    
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
        
        let adjustedIndexPathShortcut = exercisesArray[indexPath.section].set?[indexPath.row - 1] as! Sett
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! SetsTableViewCell
        //        adjustedIndexPathShortcut?.reps
        cell.repsTextField.delegate = self
        cell.weightTextField.delegate = self
        
        cell.weightTextField.text = "\(adjustedIndexPathShortcut.weight)"
        
        cell.repsTextField.text = "\(adjustedIndexPathShortcut.reps)"
        
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cell: UITableViewCell = textField.superview?.superview as! SetsTableViewCell
        let table: UITableView = cell.superview as! UITableView
        let textFieldIndexPath = table.indexPath(for: cell)
        
        
        guard let indexPathArray = textFieldIndexPath else { return }
        let selectedSet = (exercisesArray[indexPathArray[0]].set![indexPathArray[1] - 1] as! Sett)
        
        if textField.text == nil {
            textField.text = "0"
        }
        
        if textField.tag == 1 {
            
            
            
            
            let numberAsDouble = textField.text.map { Double($0) }
            
            guard let n = numberAsDouble, let weight = n else { return }
            selectedSet.weight = weight
            changeWeights(for: selectedSet, value: weight)
            
        }
        if textField.tag == 2{
        guard let strAsInt = Int(textField.text!) else { return }
        let reps = Int32(strAsInt)
        
        
        
        selectedSet.reps = reps
        changeReps(for: selectedSet, value: reps)
        }
        
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension WorkoutViewController {
    
    //    func fetchExercises() {
    //        let fetch : NSFetchRequest<Exercise> = Exercise.fetchRequest()
    ////        fetch.predicate = NSPredicate(format: "%K == %@", "uuid", workout.uuid! as CVarArg)
    //        do {
    ////            exercisesArray = try managedContext.fetch(fetch)
    //            let results = try managedContext.fetch(fetch)
    //
    ////            exercisesArray = workout.exercise?.array as! [Exercise]
    //
    //
    //            //            let results = try managedContext.fetch(fetch)
    //            //            for result in results {
    //            //                managedContext.delete(result)
    //            //            }
    //                        try managedContext.save()
    //        } catch {
    //            print("Error fetching info")
    //        }
    //    }
    
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
    
    func changeReps(for set: Sett, value: Int32) {
        let fetch : NSFetchRequest<Sett> = Sett.fetchRequest()
        fetch.predicate = NSPredicate(format: "%K == %@", "uuid", workout.uuid! as CVarArg)
        
        do {
            let result = try managedContext.fetch(fetch)
            
            result.first?.setValue(value, forKey: "reps")
            try managedContext.save()
        } catch {
            print("Error ading reps to set")
        }
    }
    
    func changeWeights(for set: Sett, value: Double) {
        let fetch : NSFetchRequest<Sett> = Sett.fetchRequest()
        fetch.predicate = NSPredicate(format: "%K == %@", "uuid", workout.uuid! as CVarArg)
        
        do {
            let result = try managedContext.fetch(fetch)
            
            result.first?.setValue(value, forKey: "weight")
            try managedContext.save()
        } catch {
            print("Error ading reps to set")
        }
    }
    
}
