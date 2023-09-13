//
//  HomeViewController.swift
//  BreakTimeReminderApp
//
//  Created by hanif hussain on 22/08/2023.
//

import UIKit
import FSCalendar

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate {
    let cellReuseIdentifier = "cell"
    
    // save and load user data
    let defaults = UserDefaults.standard
    
    // Create Attachment
    let imageAttachment = NSTextAttachment(image: UIImage(systemName: "timer")!)
    
    // Set bound to reposition for imageAttachment
    let imageOffsetY: CGFloat = -5.0
    
    var timers: [savedTimers] = []
    
    var selectedRow = Int()
    
    var calendarHeightConstraint: NSLayoutConstraint!
    
    var showEmptyTimerView = false
    
    var emptyTimerView: UIView = {
        // create a view to let user's know they should add a timer
        let emptyTimerView = UIView()
        emptyTimerView.translatesAutoresizingMaskIntoConstraints = false
        return emptyTimerView
    }()
    
    fileprivate var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
        // customise look of calendar
        
        // calendar will show week instead of month view
        calendar.scope = .week
        
        // set sunday as first day of week for calendar
        calendar.firstWeekday = 1
        
        // set date format of header
        calendar.appearance.headerDateFormat = "MMM dd"
        
        // hide calendar bounds
        calendar.clipsToBounds = true
        
        // hide the red dot for the current day
        //calendar.today = nil;
        
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
        calendar.appearance.todayColor = .systemGray3
        calendar.appearance.todaySelectionColor = .magenta
        
        
        return calendar
    }()
    
    // create a table view
    let tableView: UITableView = {
        let tv = UITableView()
        //tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // create Calendar
//    var calendarView: UICalendarView = {
//        let calendarView = UICalendarView()
//        calendarView.backgroundColor = .secondarySystemBackground
//        calendarView.layer.cornerCurve = .continuous
//        calendarView.layer.cornerRadius = 10
//        calendarView.tintColor = .systemTeal
//        calendarView.availableDateRange = DateInterval(start: .now, end: .distantFuture)
//        calendarView.translatesAutoresizingMaskIntoConstraints = false
//        return calendarView
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        setupCalendar()
        setupTableView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTimer))
        calendar.backgroundColor = .systemGray4

    }
    
    func setupTableView() {
        // assign tableView as it's own delegate
        tableView.delegate = self
        
        // remove seperator line
        tableView.separatorStyle = .none
        
        // assign tableView to handle it's own data
        tableView.dataSource = self
        
        // register our custom cell as our tableview cell
        tableView.register(CustomHomeTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // set constraints for tableView
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // setup FSCalendar
    func setupCalendar() {
        calendar.dataSource = self
        calendar.delegate = self
        
        // set the frame height of our FSCalendar weekly view and activate the constraint
        calendarHeightConstraint = calendar.heightAnchor.constraint(equalToConstant: 250)
        calendarHeightConstraint?.isActive = true
        
        view.addSubview(calendar)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        
        ])
    }
    
    // load user data
    func loadData() {
        // Retrieve from UserDefaults
        if let decodedData = UserDefaults.standard.data(forKey: "SavedTimers") {
            // have to read back as [savedTimers] as we are saving an array of timers
            let decodedArray = try? JSONDecoder().decode([savedTimers].self, from: decodedData)
            timers = decodedArray ?? [savedTimers]()
        }
        
    }
    
    // save user data
    func saveDate() {
        // convert to json data to save
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(timers) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedTimers")
        }
        self.tableView.reloadData()
    }
    
    
    // set the height for each row in the tableview this will allow us to render our custom cell correctly
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if timers.isEmpty {
            return 1
        } else {
            return timers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CustomHomeTableViewCell
        
        // create tap gesture recogniser for our dotted manage timer image in the cell
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        
        // add a tag to track which image was selected
        cell.manageTimerImage.tag = indexPath.row
        
        // add the recogniser to our manage image timer
        cell.manageTimerImage.addGestureRecognizer(tapGesture)
        
        cell.layer.cornerRadius = 15

        if !timers.isEmpty {
            // remove empty timerview from view
            emptyTimerView.removeFromSuperview()

            cell.set(result: timers[indexPath.row])
            
            // set showEmptyTimerView to false so we don't show the empty view again until we need to
            showEmptyTimerView = false
            
        } else {
            
            // set the showEmptyTimerView to true so we can keep track of when this view is showing
            showEmptyTimerView = false
            
            // create a label to display informative text to users
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Get started by creating a new timer by clicking the + icon at the top"

            // customise label and emptyTimerView layout
            label.numberOfLines = 0
            label.textColor = .black
            label.font = UIFont(name: "ChalkDuster", size: 40)
            emptyTimerView.backgroundColor = .white

            // add label to empty timer view
            emptyTimerView.addSubview(label)
            // add empty timer view to main view
            view.addSubview(emptyTimerView)

            NSLayoutConstraint.activate([
                // add constraints for the view
                emptyTimerView.topAnchor.constraint(equalTo: calendar.bottomAnchor),
                emptyTimerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                emptyTimerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                emptyTimerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

                // add constraints for the label
                label.topAnchor.constraint(equalTo: emptyTimerView.topAnchor),
                label.leadingAnchor.constraint(equalTo: emptyTimerView.leadingAnchor, constant: 10),
                label.trailingAnchor.constraint(equalTo: emptyTimerView.trailingAnchor, constant: -10),
                label.bottomAnchor.constraint(equalTo: emptyTimerView.bottomAnchor)

            ])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CountDownViewController()
        // display the new timer view as a popup view
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            let updateTimerView = UpdateTimerViewController()
            updateTimerView.delegate = self
            selectedRow = sender.view!.tag
            updateTimerView.timerToUpdate = timers[selectedRow]
            updateTimerView.position = selectedRow
            
            updateTimerView.modalPresentationStyle = .overCurrentContext
            updateTimerView.modalTransitionStyle = .crossDissolve
            
            let updateTimerNavCon = UINavigationController(rootViewController: updateTimerView)
            
            present(updateTimerNavCon, animated: true)
        }
    }
    @objc func addTimer() {
        // create and initialise the new timer view
        let newTimerView = newTimerPopupView()
        
        // display the new timer view as a popup view
        newTimerView.modalPresentationStyle = .overCurrentContext
        newTimerView.modalTransitionStyle = .crossDissolve
        
        newTimerView.delegate = self
        
        // add a newTimerView to navigation controller so we can display the view inside a nav controller
        let newTimerNavCon = UINavigationController(rootViewController: newTimerView)
        
        // present newTimerNavCon view
        present(newTimerNavCon, animated: true)
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        calendar.setCurrentPage(date, animated: true)
        calendar.select(date)
        
        //format the selectedDate and set to the header
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = calendar.appearance.headerDateFormat
        
        for cell in calendar.calendarHeaderView.collectionView.visibleCells {
            (cell as! FSCalendarHeaderCell).titleLabel.text = dateFormatter.string(from: date)
        }
    }
    
    
//    func calendar(_ calendar: FSCalendar?, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        calendar?.frame = CGRect(origin: calendar?.frame.origin ?? CGPoint.zero, size: bounds.size)
//        // Do other updates here
//        self.calendarHeightConstraint.constant = CGRectGetHeight(bounds);
//        // Do other updates here
//        [self.view layoutIfNeeded];
//    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
        
       }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            calendar.calendarHeaderView.reloadData()
            calendar.reloadData()
    }
    
    func updateTimer(timer: savedTimers, position: Int) {
        // convert to json data to save
        timers[position] = timer
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(timers) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedTimers")
        }
        self.tableView.reloadData()
    }
    
}
