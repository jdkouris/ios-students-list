//
//  MainViewController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class StudentsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var sortSelector: UISegmentedControl!
    @IBOutlet weak var filterSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private let studentController = StudentController()
    
    private var students = [Student]() {
        didSet {
            updateDataSource()
        }
    }
    
    private var filteredAndSortedStudents = [Student]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentController.loadFromPersistentStore { (students, error) in
            if let error = error {
                print("Error loading students: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.students = students ?? []
            }
        }
        
    }
    
    // MARK: - Action Handlers
    
    @IBAction func sort(_ sender: UISegmentedControl) {
        updateDataSource()
    }
    
    @IBAction func filter(_ sender: UISegmentedControl) {
        updateDataSource()
    }
    
    // MARK: - Private
    
    private func updateDataSource() {
        var updatedStudents: [Student]
        
        switch filterSelector.selectedSegmentIndex {
        case 1: // filter for iOS
            updatedStudents = students.filter({ (student) -> Bool in
                return student.course == "iOS"
            })
        case 2: // filter for Web
            updatedStudents = students.filter { $0.course == "Web" }
        case 3: // filter for UX
            updatedStudents = students.filter { $0.course == "UX" }
        default: // filter for none (or if another segment is added, they'd fall in here too)
            updatedStudents = students
        }
        
        if sortSelector.selectedSegmentIndex == 0 { // first name sort
            updatedStudents = updatedStudents.sorted { $0.firstName < $1.firstName }
        } else if sortSelector.selectedSegmentIndex == 1 { // last name sort
            updatedStudents = updatedStudents.sorted { $0.lastName < $1.lastName }
        }
        
        filteredAndSortedStudents = updatedStudents
    }
    
}

extension StudentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAndSortedStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        
        let aStudent = filteredAndSortedStudents[indexPath.row]
        cell.textLabel?.text = aStudent.name
        cell.detailTextLabel?.text = aStudent.course
        
        return cell
    }
}
