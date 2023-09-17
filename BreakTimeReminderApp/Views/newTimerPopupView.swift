//
//  newTimerPopupView.swift
//  BreakTimeReminderApp
//
//  Created by hanif hussain on 28/08/2023.
//

import UIKit
import FSCalendar
import UserNotifications

class newTimerPopupView: UIViewController, UIScrollViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    weak var delegate: HomeViewController!
    
    var durationPicker: UIPickerView = {
        let picker = UIPickerView()
        //picker.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
        picker.backgroundColor = .white
        picker.layer.cornerRadius = 8
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let durationDataSource = ["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60"]
    
    let durationLabel: UILabel = {
        let durationLabel = UILabel()
        durationLabel.text = "Duration:"
        durationLabel.textColor = .white
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        return durationLabel
    }()
    
    var frequencyPicker: UIPickerView = {
        let picker = UIPickerView()
        //picker.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
        picker.backgroundColor = .white
        picker.layer.cornerRadius = 8
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let frequencyLabel: UILabel = {
        let frequencyLabel = UILabel()
        frequencyLabel.text = "Frequency:"
        frequencyLabel.textColor = .white
        frequencyLabel.translatesAutoresizingMaskIntoConstraints = false
        return frequencyLabel
    }()
    
    let frequencyDataSource = ["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60"]
    
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
    
    var nameTxtField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Task Name"
        textfield.backgroundColor = .systemFill
        textfield.textColor = .white
        textfield.borderStyle = .roundedRect
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    // view to hold the calendar and show it when needed
    let calendarView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .systemFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    // view to show the days of the week buttons for repeating tasks
    var weekdayView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        calendar.appearance.titleDefaultColor = .white
        
        return calendar
    }()
    
    // timer object
    var timer = savedTimers()
    
    // hold our date and pass to timer if user selects a specific date
    var selectedDate: Date!
    
    // Mutable string to pass to our timer object
    var name = NSMutableAttributedString(string: "")
    
    // create selectable buttons for user to select which day/days of the week they want to schedule a reminder for
    var dayOfWeekButtons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        durationPicker.dataSource = self
        durationPicker.delegate = self
        frequencyPicker.dataSource = self
        frequencyPicker.delegate = self
        
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
        
        timer.notificationIdentifier = [String]()
        
    }
    
    // number of columns in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // number of rows in picker columns
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == durationPicker {
            return durationDataSource.count
        } else {
            return frequencyDataSource.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == durationPicker {
            return durationDataSource[row]
        } else {
            return frequencyDataSource[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == durationPicker {
            timer.timeDuration = Double(durationDataSource[row])
        } else if pickerView == frequencyPicker {
            timer.frequency = Double(frequencyDataSource[row])
        }

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
        scrollView.addSubview(nameTxtField)
        scrollView.addSubview(weekdayView)
        scrollView.addSubview(repeatLabel)
        scrollView.addSubview(repeatToggle)
        
        for i in dayOfWeekButtons {
            weekdayView.addSubview(i)
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
            
            // set constraints for weekdayView selection
            weekdayView.topAnchor.constraint(equalTo: nameTxtField.bottomAnchor, constant: 40),
            weekdayView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            weekdayView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
            weekdayView.heightAnchor.constraint(equalToConstant: 450),
            
            // set constraints for repeat label
            repeatLabel.topAnchor.constraint(equalTo: weekdayView.topAnchor, constant: 10),
            repeatLabel.leadingAnchor.constraint(equalTo: weekdayView.leadingAnchor, constant: 10),

            
            // set constraints for repeat toggle
            repeatToggle.topAnchor.constraint(equalTo: repeatLabel.topAnchor, constant: -5),
            repeatToggle.leadingAnchor.constraint(equalTo: repeatLabel.trailingAnchor, constant: 10),
            repeatToggle.trailingAnchor.constraint(equalTo: weekdayView.trailingAnchor, constant: -5),
            
            // set constraints for days of the week
            dayOfWeekButtons[0].topAnchor.constraint(equalTo: repeatLabel.bottomAnchor, constant: 25),
            dayOfWeekButtons[0].leadingAnchor.constraint(equalTo: weekdayView.leadingAnchor, constant: 20),
            dayOfWeekButtons[0].widthAnchor.constraint(equalToConstant: 30),
            dayOfWeekButtons[0].heightAnchor.constraint(equalToConstant: 30),
            
            dayOfWeekButtons[1].topAnchor.constraint(equalTo: dayOfWeekButtons[0].topAnchor),
            dayOfWeekButtons[1].leadingAnchor.constraint(equalTo: dayOfWeekButtons[0].trailingAnchor, constant: 10),
            dayOfWeekButtons[1].widthAnchor.constraint(equalToConstant: 30),
            dayOfWeekButtons[1].heightAnchor.constraint(equalToConstant: 30),

            dayOfWeekButtons[2].topAnchor.constraint(equalTo: dayOfWeekButtons[0].topAnchor),
            dayOfWeekButtons[2].leadingAnchor.constraint(equalTo: dayOfWeekButtons[1].trailingAnchor, constant: 10),
            dayOfWeekButtons[2].widthAnchor.constraint(equalToConstant: 30),
            dayOfWeekButtons[2].heightAnchor.constraint(equalToConstant: 30),
            
            dayOfWeekButtons[3].topAnchor.constraint(equalTo: dayOfWeekButtons[0].topAnchor),
            dayOfWeekButtons[3].leadingAnchor.constraint(equalTo: dayOfWeekButtons[2].trailingAnchor, constant: 10),
            dayOfWeekButtons[3].widthAnchor.constraint(equalToConstant: 30),
            dayOfWeekButtons[3].heightAnchor.constraint(equalToConstant: 30),
            
            dayOfWeekButtons[4].topAnchor.constraint(equalTo: dayOfWeekButtons[0].topAnchor),
            dayOfWeekButtons[4].leadingAnchor.constraint(equalTo: dayOfWeekButtons[3].trailingAnchor, constant: 10),
            dayOfWeekButtons[4].widthAnchor.constraint(equalToConstant: 30),
            dayOfWeekButtons[4].heightAnchor.constraint(equalToConstant: 30),
            
            dayOfWeekButtons[5].topAnchor.constraint(equalTo: dayOfWeekButtons[0].topAnchor),
            dayOfWeekButtons[5].leadingAnchor.constraint(equalTo: dayOfWeekButtons[4].trailingAnchor, constant: 10),
            dayOfWeekButtons[5].widthAnchor.constraint(equalToConstant: 30),
            dayOfWeekButtons[5].heightAnchor.constraint(equalToConstant: 30),
            
            dayOfWeekButtons[6].topAnchor.constraint(equalTo: dayOfWeekButtons[0].topAnchor),
            dayOfWeekButtons[6].leadingAnchor.constraint(equalTo: dayOfWeekButtons[5].trailingAnchor, constant: 10),
            dayOfWeekButtons[6].widthAnchor.constraint(equalToConstant: 30),
            dayOfWeekButtons[6].heightAnchor.constraint(equalToConstant: 30),
        ])
        
        // setup calendar view and hide it initially and set weekdayview to visible
        setupCalendar()
        setupWeeklyViewPicker()
        calendarView.isHidden = true
        weekdayView.isHidden = false
        
    }
    
    // setup FSCalendar
    func setupCalendar() {
        calendar.dataSource = self
        calendar.delegate = self
        
        scrollView.addSubview(calendarView)
        weekdayView.isHidden = true
        // set the frame height of our FSCalendar weekly view and activate the constraint
        calendarHeightConstraint = calendar.heightAnchor.constraint(equalToConstant: 300)
        calendarHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            // set constraints for weekdayView selection
            calendarView.topAnchor.constraint(equalTo: nameTxtField.bottomAnchor, constant: 80),
            calendarView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            calendarView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
            calendarView.heightAnchor.constraint(equalToConstant: 450),
 
        ])
        
        addCalendar()
    }
    
    func addCalendar() {
        calendarView.addSubview(calendar)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: calendarView.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor, constant: 10),
            calendar.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant:  -10),
            // we have to enable a bottom anchor constraint otherwise scrolling will not work as the scrollview is unable to correctly work out scrolling
            //calendar.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50)
        
        ])
    }
    
    func setupWeeklyViewPicker() {
        durationLabel.removeFromSuperview()
        durationPicker.removeFromSuperview()
        frequencyLabel.removeFromSuperview()
        frequencyPicker.removeFromSuperview()
        weekdayView.addSubview(durationLabel)
        weekdayView.addSubview(durationPicker)
        weekdayView.addSubview(frequencyLabel)
        weekdayView.addSubview(frequencyPicker)
        
        NSLayoutConstraint.activate([
            // add constraints for timer picker and label
            durationLabel.topAnchor.constraint(equalTo: repeatLabel.bottomAnchor, constant: 100),
            durationLabel.leadingAnchor.constraint(equalTo: weekdayView.leadingAnchor, constant: 10),
            
            durationPicker.topAnchor.constraint(equalTo: durationLabel.topAnchor, constant: 25),
            durationPicker.leadingAnchor.constraint(equalTo: weekdayView.leadingAnchor, constant: 10),
            durationPicker.trailingAnchor.constraint(equalTo: weekdayView.trailingAnchor, constant: -10),
            durationPicker.heightAnchor.constraint(equalToConstant: 100),
            
            // add constraints for frequency picker and label
            frequencyLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 150),
            frequencyLabel.leadingAnchor.constraint(equalTo: weekdayView.leadingAnchor, constant: 10),
            
            frequencyPicker.topAnchor.constraint(equalTo: frequencyLabel.topAnchor, constant: 25),
            frequencyPicker.leadingAnchor.constraint(equalTo: weekdayView.leadingAnchor, constant: 10),
            frequencyPicker.trailingAnchor.constraint(equalTo: weekdayView.trailingAnchor, constant: -10),
            frequencyPicker.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func setupDurationPickerForCalendarView() {
        durationLabel.removeFromSuperview()
        durationPicker.removeFromSuperview()
        frequencyLabel.removeFromSuperview()
        frequencyPicker.removeFromSuperview()
        
        calendarView.addSubview(durationLabel)
        calendarView.addSubview(durationPicker)
        
        NSLayoutConstraint.activate([
        // add constraints for timer picker and label
        durationLabel.topAnchor.constraint(equalTo: repeatLabel.bottomAnchor, constant: 320),
        durationLabel.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor, constant: 10),
        
        durationPicker.topAnchor.constraint(equalTo: durationLabel.topAnchor, constant: 25),
        durationPicker.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor, constant: 10),
        durationPicker.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant: -10),
        durationPicker.heightAnchor.constraint(equalToConstant: 100),
        
        ])
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

    
    @objc func doneButtonTapped() {
        guard let nameText = nameTxtField.text, !nameText.isEmpty else { return }
        
        if timer.frequency == nil {
            timer.frequency = 5
        }
        
        if timer.timeDuration == nil {
            timer.timeDuration = 5
        }

        timer.title = nameText
        
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
            timer.repeatDay = days
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy/MM/dd HH:mm"
//            let someDateTime = formatter.date(from: "1980/02/09 22:31")
//            timer.date = someDateTime
            delegate.timers.append(timer)
            
        } else {
          // timer will be for scheduled day only and will not repeat
            timer.date = calendar.selectedDate
            
            // schedule the push notification for the mentioned day
            scheduleLocalDate(date: timer.date)
            
            // append new timer to homeViewcontroller timers array
            delegate.timers.append(timer)
        }
        
        dismiss(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate.saveDate()
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
            weekdayView.isHidden = false
            calendarView.isHidden = true
            setupWeeklyViewPicker()
        } else {
            // show weekday view
            calendarView.isHidden = false
            weekdayView.isHidden = true
            setupDurationPickerForCalendarView()
        }
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
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
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "\(timer.title!)"
        content.body = "Focus time"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default
        
        // create a UUID so we can store it and modify it when needed
        let notificationIdentifier = UUID().uuidString
        
        // initialise date components and set it to weekday so we can trigger notifications on specific days
        var dateComponents = DateComponents()
        dateComponents.weekday = weekday
        dateComponents.minute = Int(timer.frequency)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // trigger to test below by running notification 5 seconds after triggering it
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        
        // add notification request to notification center otherwise you won't trigger notification
        center.add(request)
        timer.notificationIdentifier.append(notificationIdentifier)

        
    }

    // schedule a notification based on user selecting a future date
    @objc func scheduleLocalDate(date: Date) {
//        var dateComp = DateComponents()
//        dateComp.year = 2023
//        dateComp.month = 9
//        dateComp.day = 9
//        let calendar = Calendar(identifier: .gregorian)
//        let date = calendar.date(from: dateComp)
//        print("\(Calendar.current.dateComponents([.day, .month, .year], from: date!))")
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "\(timer.title!)"
        content.body = "Focus time"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default
        
        // create a UUID so we can store it and modify it when needed
        let notificationIdentifier = UUID().uuidString
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        
        center.add(request)
        timer.notificationIdentifier.append(notificationIdentifier)
       //
    }

}
