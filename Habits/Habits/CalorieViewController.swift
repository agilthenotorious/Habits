//
//  CalorieViewController.swift
//  Habits
//
//  Created by Agil Madinali on 9/28/20.
//

import UIKit

class CalorieViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }
    
    weak var delegate: CalorieDelegate?
    let rangeList: [String] = ["0-50 calories", "50-100 calories", "100-150 calories", "150-200 calories", "200-250 calories", "250-300 calories", "300-350 calories", "350-400 calories"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pick a Range"
        self.setupUI()
    }
    
    func setupUI() {
        self.tableView.backgroundColor = .systemTeal
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView()
    }
}

extension CalorieViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        self.delegate?.returnCalorieRange(with: self.rangeList[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}

extension CalorieViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.rangeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalorieTableViewCell.identifier) as? CalorieTableViewCell else { fatalError("Cell cannot be dequeued!") }
        
        cell.calorieRangeLabel.text = self.rangeList[indexPath.row]
        return cell
    }
}

protocol CalorieDelegate: class {
    
    func returnCalorieRange(with range: String)
}
