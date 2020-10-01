//
//  HabitsViewController.swift
//  Habits
//
//  Created by Agil Madinali on 9/28/20.
//

import UIKit

class HabitsViewController: UIViewController {

    @IBOutlet weak var habitScrollView: UIScrollView!
    @IBOutlet weak var habitTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var placeSegmented: UISegmentedControl!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var calorieButton: UIButton!
    @IBOutlet weak var companyStepper: UIStepper!
    @IBOutlet weak var companyCountLabel: UILabel!
    @IBOutlet weak var excitedSlider: UISlider!
    @IBOutlet weak var excitedLabel: UILabel!
    @IBOutlet weak var reminderSwitch: UISwitch!

    var currentTextView: UITextView?
    let datePicker = UIDatePicker()
    let timePicker = UIPickerView()
    let timeValues = [ ["Hour", "0", "1", "2", "3", "4"],
                      ["Minute", "0", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"] ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Habit Planning"
        self.setupDate()
        self.setupTime()
        self.setupStepper()
        self.setupSlider()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        self.habitScrollView.contentInset = .zero
        self.habitScrollView.scrollIndicatorInsets = .zero
        self.view.endEditing(true)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size,
           let textView = self.currentTextView,
           let horizontalStackView = textView.superview {
            
            let contentInsets = UIEdgeInsets(top: self.habitScrollView.contentInset.top, left: 0, bottom: keyboardSize.height, right: 0)
            self.habitScrollView.contentInset = contentInsets
            self.habitScrollView.scrollIndicatorInsets = contentInsets
            
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            
            if !aRect.contains(horizontalStackView.frame.origin) {
                self.habitScrollView.scrollRectToVisible(horizontalStackView.frame, animated: true)
            }
        }
    }
    
    @objc func changeDate() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year] , from: self.datePicker.date)
        
        if let month = components.month,
           let day = components.day,
           let year = components.year {
            self.dateTextField.text = "\(month)/\(day)/\(year)"
        }
    }
    
    @objc func updateCompanyValue() {
        self.companyCountLabel.text = "\(Int(self.companyStepper.value)) fellas"
    }
    
    @objc func updateExcitedValue() {
        self.excitedLabel.text = "\(Int(self.excitedSlider.value))"
    }
    
    func setupStepper() {
        self.companyStepper.addTarget(self, action: #selector(updateCompanyValue), for: .valueChanged)
    }
    
    func setupSlider() {
        self.excitedSlider.value = 6
        self.excitedSlider.maximumValue = 10
        self.excitedSlider.minimumValue = 0
        self.excitedSlider.addTarget(self, action: #selector(updateExcitedValue), for: .valueChanged)
    }
    
    func setupDate() {
        self.dateTextField.inputView = datePicker
        self.datePicker.datePickerMode = .date
        self.datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
    }
    
    func setupTime() {
        self.timeTextField.inputView = timePicker
        self.timePicker.dataSource = self
        self.timePicker.delegate = self
    }
    
    func setupSwitch() {
        if self.reminderSwitch.isOn == true {
            remindHabit()
        }
    }
    
    func remindHabit() {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let calorieVC = segue.destination as? CalorieViewController else { return }
        calorieVC.delegate = self
    }
}

extension HabitsViewController: CalorieDelegate {
    func returnCalorieRange(with range: String) {
        self.calorieButton.setTitleColor(.label, for: .normal)
        self.calorieButton.setTitle(range, for: .normal)
    }
}

extension HabitsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.timeValues[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let hour = self.timeValues[0][pickerView.selectedRow(inComponent: 0)]
        let minute = self.timeValues[1][pickerView.selectedRow(inComponent: 1)]
        
        if hour == "Hour" || minute == "Minute" || (hour == "0" && minute == "0") {
            self.timeTextField.text = ""
        } else {
        self.timeTextField.text = "\(hour) hr  \(minute) min"
        }
    }
}

extension HabitsViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return timeValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.timeValues[component].count
    }
}

extension HabitsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.currentTextView = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.currentTextView = nil
    }
}
