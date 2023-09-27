//
//  UpdateTimerViewController.swift
//  BreakTimeReminderApp
//
//  Created by hanif hussain on 07/09/2023.
//

import UIKit
import FSCalendar

class UpdateTimerViewController: UIViewController, UIScrollViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    weak var delegate: HomeViewController!
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .black
        scrollView.alpha = 0.7
        return scrollView
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    var calendarHeightConstraint: NSLayoutConstraint!
    var calendarWidthConstraint: NSLayoutConstraint!
    
    var nameTxtField: UITextField = {
        let textfield = UITextField()
        textfield.attributedPlaceholder = NSAttributedString(string: "Enter Task Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])

        textfield.backgroundColor = .white
        textfield.textColor = .black
        textfield.borderStyle = .roundedRect
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    // create a calendar view for when a user wishes to create a timer for specific date
    fileprivate var calendar: FSCalendar = {
        let calendar = FSCalendar()
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
        // customise look of calendar
        
        // set sunday as first day of week for calendar
        calendar.firstWeekday = 1
        
        // set date format of header
        calendar.appearance.headerDateFormat = "MMM dd"
        
        // hide calendar bounds
        calendar.clipsToBounds = true
        
        // hide the red dot for the current day
        calendar.today = nil;
        
        // hide the next and previous month start of week in header
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
        
        // set font for calendar
        //calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 14)
        
        // round corners for calendar frame
        calendar.layer.cornerRadius = 4
        
        calendar.allowsMultipleSelection = false
        
        calendar.appearance.weekdayTextColor = .magenta
        calendar.appearance.headerTitleColor = .magenta
        calendar.appearance.selectionColor = .blue
        calendar.appearance.todaySelectionColor = .magenta
        calendar.backgroundColor = .clear
        // change the colour of the days in the calendar
        calendar.appearance.titleDefaultColor = .black
        
        return calendar
    }()
    
    // timer object
    var timerToUpdate: savedTimers!
    
    var position = Int()
    
    // hold our date and pass to timer if user selects a specific date
    var selectedDate: Date!
    
    // create selectable buttons for user to select which day/days of the week they want to schedule a reminder for
    var dayOfWeekButtons = [UIButton]()
    
    let center = UNUserNotificationCenter.current()
    
    var durationPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.backgroundColor = .white
        picker.layer.cornerRadius = 8
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let durationDataSource = ["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60"]
    
    let durationLabel: UILabel = {
        let durationLabel = UILabel()
        durationLabel.text = "Duration:"
        durationLabel.textColor = .black
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        return durationLabel
    }()
    
    let repeatLabel: UILabel = {
        let repeatLabel = UILabel()
        repeatLabel.text = "Repeat:"
        repeatLabel.textColor = .white
        repeatLabel.translatesAutoresizingMaskIntoConstraints = false
        return repeatLabel
    }()
    
    var repeatToggle: UISwitch = {
        let repeatToggle = UISwitch()
        repeatToggle.preferredStyle = .sliding
        repeatToggle.translatesAutoresizingMaskIntoConstraints = false
        repeatToggle.isOn = true
        return repeatToggle
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = button.frame.height / 2
        button.backgroundColor = .white
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    let startTimerminutehour: UIDatePicker = {
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        datePicker.overrideUserInterfaceStyle = .light
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .compact
        datePicker.backgroundColor = .white
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
        return datePicker
    }()
    
    let frequencyLabel: UILabel = {
        let frequencyLabel = UILabel()
        frequencyLabel.text = "Time:"
        frequencyLabel.textColor = .black
        frequencyLabel.translatesAutoresizingMaskIntoConstraints = false
        return frequencyLabel
    }()
    
    var textView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var durationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var weekDayView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var monthSelectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var DurationViewConstraint = [NSLayoutConstraint]()
    var weekdayViewConstraints = [NSLayoutConstraint]()
    var monthselectionViewConstraints = [NSLayoutConstraint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide keyboard using our custom extension created at bottom of this class
        self.hideKeyboardWhenTappedAround()
        nameTxtField.delegate = self
        nameTxtField.text = timerToUpdate.title
        
        durationPicker.dataSource = self
        durationPicker.delegate = self
        
        calendar.dataSource = self
        calendar.delegate = self
        
        // Semi-transparent background
        view.backgroundColor = UIColor.darkGray
        
        // if we want to modify the colour of the navgation item title we'll need to create the attributes first
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
            
        ]
        
        // This will change the navigation bar background color
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black.withAlphaComponent(0.8)
        
        // apply attributes to title text so we can change colour
        appearance.titleTextAttributes = attributes
        
        // change navigation bar button colour
        navigationController?.navigationBar.tintColor = .red
        
        // apple the appearance to our nav controller
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
        // set nav title
        navigationItem.title = "Create"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        
        
        // round the corners of our ui view
        view.layer.cornerRadius = 10
        
        
        repeatToggle.addTarget(self, action: #selector(repeatToggleTapped), for: .touchUpInside)
        
        setupDayOfWeekButtons()
        setupView()
        
        // register for local notifications
        registerLocal()
        
        // assign tap register for delete button
        deleteButton.addTarget(self, action: #selector(deleteTapped(sender: )), for: .touchUpInside)
        
        timerToUpdate.notificationIdentifier = [String]()
        
    }
    
    // number of columns in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // number of rows in picker columns
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durationDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return durationDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timerToUpdate.timeDuration = Double(durationDataSource[row])
    }
    
    // set picker text colour
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: durationDataSource[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    func setupDayOfWeekButtons() {
        // create ui buttons and append them to aray
        for i in 1...7 {
            var button: UIButton = {
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                button.layer.cornerRadius = 15
                button.clipsToBounds = true
                switch i {
                case 1:
                    button.setTitle("M", for: .normal)
                case 2:
                    button.setTitle("T", for: .normal)
                case 3:
                    button.setTitle("W", for: .normal)
                case 4:
                    button.setTitle("T", for: .normal)
                case 5:
                    button.setTitle("F", for: .normal)
                case 6:
                    button.setTitle("S", for: .normal)
                case 7:
                    button.setTitle("S", for: .normal)
                default:
                    break
                }
                button.titleLabel?.textAlignment = .center
                button.backgroundColor = .red
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            button.addTarget(self, action: #selector(weekDayTapped), for: .touchUpInside)
            dayOfWeekButtons.append(button)
        }
    }
    
    func setupView() {
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 800)
        scrollView.delegate = self
        
        view.addSubview(lineView)
        view.addSubview(scrollView)
        
        scrollView.addSubview(monthSelectionView)
        monthSelectionView.addSubview(calendar)
        
        // add components to durationview
        durationView.addSubview(durationPicker)
        durationView.addSubview(durationLabel)
        durationView.addSubview(startTimerminutehour)
        durationView.addSubview(frequencyLabel)
        
        scrollView.addSubview(nameTxtField)
        scrollView.addSubview(repeatLabel)
        scrollView.addSubview(repeatToggle)
        scrollView.addSubview(weekDayView)
        scrollView.addSubview(durationView)
        scrollView.addSubview(deleteButton)
        
        for i in dayOfWeekButtons {
            weekDayView.addSubview(i)
        }
        
        NSLayoutConstraint.activate([
            
            // set constraints for the scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // set constraints for the seperator line shown below the navigation bar
            lineView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lineView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            // set constraints for name textfield
            nameTxtField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50),
            nameTxtField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            nameTxtField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant:  -40),
            nameTxtField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8),
            nameTxtField.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            
            // set constraints for repeat label
            repeatLabel.topAnchor.constraint(equalTo: nameTxtField.bottomAnchor, constant: 40),
            repeatLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            
            // set constraints for repeat toggle
            repeatToggle.topAnchor.constraint(equalTo: repeatLabel.topAnchor, constant: -5),
            repeatToggle.leadingAnchor.constraint(equalTo: repeatLabel.trailingAnchor, constant: 10),
            repeatToggle.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
        ])
        
        weekDayViewConstraints()
        setDurationViewConstraints(view: weekDayView)
        monthSelectionViewConstraints()
        
        for (index, item) in dayOfWeekButtons.enumerated() {
            
            if item == dayOfWeekButtons[0] {
                NSLayoutConstraint.activate([
                    dayOfWeekButtons[0].topAnchor.constraint(equalTo: weekDayView.topAnchor, constant: 20),
                    dayOfWeekButtons[0].leadingAnchor.constraint(equalTo: weekDayView.leadingAnchor, constant: 20),
                    dayOfWeekButtons[0].widthAnchor.constraint(equalToConstant: 30),
                    dayOfWeekButtons[0].heightAnchor.constraint(equalToConstant: 30),
                ])
            } else {
                NSLayoutConstraint.activate([
                item.topAnchor.constraint(equalTo: dayOfWeekButtons[index-1].topAnchor),
                item.leadingAnchor.constraint(equalTo: dayOfWeekButtons[index-1].trailingAnchor, constant: 10),
                item.widthAnchor.constraint(equalToConstant: 30),
                item.heightAnchor.constraint(equalToConstant: 30),
                ])
            }
            
        }
        // setup calendar view and hide it initially and set weekdayview to visible
        monthSelectionView.isHidden = true
        weekDayView.isHidden = false
    }
    
    func weekDayViewConstraints() {
        weekdayViewConstraints = [
            // set constraints for weekdayView selection
            weekDayView.topAnchor.constraint(equalTo: repeatLabel.bottomAnchor, constant: 20),
            weekDayView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            weekDayView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
            weekDayView.heightAnchor.constraint(equalToConstant: 65),
        ]
        
        for i in weekdayViewConstraints {
            i.isActive = true
        }
    }
    
    func setDurationViewConstraints(view: UIView) {
        
        // disable constraints for duration view so we can reapply them when switching between repeat view and monthly calendar view
        for i in DurationViewConstraint {
            i.isActive = false
        }
        DurationViewConstraint = [
            // add constraints for duration view
            durationView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
            durationView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            durationView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
            durationView.heightAnchor.constraint(equalToConstant: 200),
            durationView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -300),
            
             //add constraints for timer picker and label
            durationLabel.topAnchor.constraint(equalTo: durationView.topAnchor, constant: 20),
            durationLabel.leadingAnchor.constraint(equalTo: durationView.leadingAnchor, constant:10),
            
            durationPicker.topAnchor.constraint(equalTo: durationLabel.topAnchor, constant: 25),
            durationPicker.leadingAnchor.constraint(equalTo: durationView.leadingAnchor, constant: 10),
            durationPicker.trailingAnchor.constraint(equalTo: durationView.trailingAnchor, constant: -10),
            durationPicker.heightAnchor.constraint(equalToConstant: 100),
            
            // add constraints for frequency picker and label
            frequencyLabel.topAnchor.constraint(equalTo: durationPicker.bottomAnchor, constant: 10),
            frequencyLabel.leadingAnchor.constraint(equalTo: durationView.leadingAnchor, constant: 10),
            
            startTimerminutehour.topAnchor.constraint(equalTo: frequencyLabel.topAnchor, constant: 0),
            startTimerminutehour.leadingAnchor.constraint(equalTo: durationView.leadingAnchor, constant: 215),
            startTimerminutehour.trailingAnchor.constraint(equalTo: durationView.trailingAnchor, constant: -10),
            
            deleteButton.topAnchor.constraint(equalTo: frequencyLabel.topAnchor, constant: 80),
            deleteButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 100),
            deleteButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -100),
            deleteButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -220)
        ]
        
        for i in DurationViewConstraint {
            i.isActive = true
        }
    }
    
    func monthSelectionViewConstraints() {
        // set the frame height of our FSCalendar weekly view and activate the constraint
        calendarHeightConstraint = calendar.heightAnchor.constraint(equalToConstant: 300)
        calendarHeightConstraint?.isActive = true
        
        calendarWidthConstraint = calendar.widthAnchor.constraint(equalToConstant: 305)
        calendarWidthConstraint.isActive = true
        
        monthselectionViewConstraints = [
            // set constraints for calendar selection
            monthSelectionView.topAnchor.constraint(equalTo: repeatLabel.bottomAnchor, constant: 20),
            monthSelectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            monthSelectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
            monthSelectionView.heightAnchor.constraint(equalToConstant: 300),
            
            calendar.topAnchor.constraint(equalTo: monthSelectionView.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: monthSelectionView.leadingAnchor, constant: 5),
        ]
        
        for i in monthselectionViewConstraints {
            i.isActive = true
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // print(date)
        selectedDate = date
        calendar.setCurrentPage(date, animated: true)
        calendar.select(date)
        
        //format the selectedDate and set to the header
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = calendar.appearance.headerDateFormat
        
        for cell in calendar.calendarHeaderView.collectionView.visibleCells {
            (cell as! FSCalendarHeaderCell).titleLabel.text = dateFormatter.string(from: date)
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        calendarWidthConstraint.constant = bounds.width
        view.layoutIfNeeded()
        
    }
    
    // restrict date selection by dissalowing past dates from current date
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        let curDate = Date().addingTimeInterval(-24*60*60)
        
        if date < curDate {
            return false
        } else {
            return true
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendar.calendarHeaderView.reloadData()
        calendar.reloadData()
    }
    
    // disable scrolling horizontally
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    @objc func deleteTapped(sender: UIButton) {
        // remove the pending notification for the timer
        center.removePendingNotificationRequests(withIdentifiers: timerToUpdate.notificationIdentifier)
        delegate.deleteTimer(timer: timerToUpdate, position: position)
        dismiss(animated: true)
    }
    
    @objc func doneButtonTapped() {
        guard let nameText = nameTxtField.text, !nameText.isEmpty else { return }
        
        let today = Date.now
        
        // remove the pending notification for the updated timer before setting a new reminder
        center.removePendingNotificationRequests(withIdentifiers: timerToUpdate.notificationIdentifier)
        
        if timerToUpdate.timeDuration == nil {
            timerToUpdate.timeDuration = 5
        }
        
        timerToUpdate.title = nameText
        
        if repeatToggle.isOn {
            var dayCount = [Int]()
            var days = [String]()
            for (pos, day) in dayOfWeekButtons.enumerated() {
                
                if day.isSelected {
                    
                    // check which button was selected and convert it to day of week e.g. monday = 2 so we can schedule a notification
                    switch pos {
                        
                    case 0:
                        // append monday
                        dayCount.append(2)
                        days.append("M")
                        scheduleLocal(weekday: 2)
                    case 1:
                        // append tuesday
                        dayCount.append(3)
                        days.append("T")
                        scheduleLocal(weekday: 3)
                    case 2:
                        // append wednesday
                        dayCount.append(4)
                        days.append("W")
                        scheduleLocal(weekday: 4)
                    case 3:
                        // append thursday
                        dayCount.append(5)
                        days.append("T")
                        scheduleLocal(weekday: 5)
                    case 4:
                        // append friday
                        dayCount.append(6)
                        days.append("F")
                        scheduleLocal(weekday: 6)
                    case 5:
                        // append saturday
                        dayCount.append(7)
                        days.append("S")
                        scheduleLocal(weekday: 7)
                    case 6:
                        // append sunday
                        dayCount.append(1)
                        days.append("S")
                        scheduleLocal(weekday: 1)
                    default:
                        break
                    }
                }
            }
            // append the dayCount to timer array
            timerToUpdate.repeatDay = days
            timerToUpdate.timeOfDay = startTimerminutehour.date
            delegate.updateTimer(timer: timerToUpdate, position: position, updateCalendarTimer: false)
        } else {
            // timer will be for scheduled day only and will not repeat
            timerToUpdate.date = calendar.selectedDate
            
            // append time of notification
            timerToUpdate.timeOfDay = startTimerminutehour.date
            
            // schedule the push notification for the mentioned day
            scheduleLocalDate(date: timerToUpdate.date)
            
            // append new timer to homeViewcontroller timers array
            delegate.updateTimer(timer: timerToUpdate, position: position, updateCalendarTimer: true)
        }
        
        dismiss(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate.saveData()
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func weekDayTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.backgroundColor = .green
            
        } else {
            sender.backgroundColor = .red
        }
    }
    
    @objc func repeatToggleTapped(_ sender: UISwitch) {
        if sender.isOn {
            // remove calendarview view and calendar
            weekDayView.isHidden = false
            monthSelectionView.isHidden = true
            setDurationViewConstraints(view: weekDayView)
        } else {
            // show weekday view
            monthSelectionView.isHidden = false
            weekDayView.isHidden = true
            setDurationViewConstraints(view: monthSelectionView)
        }
    }
    
    @objc func registerLocal() {
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Granted")
                //self.scheduleLocal()
            } else {
                print("not granted")
            }
        }
    }
    
    // regular repeat schedule notification
    @objc func scheduleLocal(weekday: Int) {
        
        let content = UNMutableNotificationContent()
        content.title = "\(timerToUpdate.title!)"
        content.body = "Focus time"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default
        
        // Create a date component
        let date = startTimerminutehour.date
        var dateComponents = DateComponents()
        
        // Create a trigger for every Monday at the specified time
        let weeklyTrigger = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        // Update the hour and minute components as needed for your notification time
        //dateComponents.hour = weeklyTrigger.hour
        dateComponents.weekday = weekday
        dateComponents.hour = weeklyTrigger.hour
        dateComponents.minute = weeklyTrigger.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create a unique identifier for the notification
        let notificationIdentifier = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        timerToUpdate.notificationIdentifier.append(notificationIdentifier)
        center.add(request)
    }
    
    // schedule a notification based on user selecting a future date
    @objc func scheduleLocalDate(date: Date) {
        
        let content = UNMutableNotificationContent()
        content.title = "\(timerToUpdate.title!)"
        content.body = "Focus time"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default
        
        // get the date from FScalendar that we implemented
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        // get the hour and minute the user selected
        let date2 = startTimerminutehour.date
        var dateComponents2 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date2)

        // add the year month and day to our date component
        dateComponents2.year = dateComponents.year
        dateComponents2.month = dateComponents.month
        dateComponents2.day = dateComponents.day
        
        // create a UUID so we can store it and modify it when needed
        let notificationIdentifier = UUID().uuidString
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents2, repeats: false)
        
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        
        center.add(request)
        timerToUpdate.notificationIdentifier.append(notificationIdentifier)
    }
    
}

