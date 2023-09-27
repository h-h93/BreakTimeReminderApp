//
//  ViewController.swift
//  BreakTimeReminderApp
//
//  Created by HH on 21/08/2023.
//

import UIKit

class ViewController: UITabBarController {
    
    // create instances of view controllers
    let homeView = HomeViewController()
    let focusView = FocusViewViewController()
    //let scheduleView = ScheduleViewController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the background view to white
        view.backgroundColor = .systemBackground
        
        // customise tabBarView and Tab bar button colours
        self.tabBar.isTranslucent = false
        tabBar.backgroundColor = .systemBackground
        //tabBar.barTintColor = UIColor.red
        tabBar.tintColor = .magenta
        title = "Break Time!!!"
        
        // set views title
//        homeView.title = "Home"
//        focusView.title = "Focus"
//        scheduleView.title = "Schedule"
        
        // assign view controllers to tab bar
        //self.setViewControllers([homeView, focusView], animated: true)
        homeView.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        // set homeView in a navigation controller so we can then add it to tab bar and use navigation item buttons
        let homeNavCon = UINavigationController(rootViewController: homeView)
        
        focusView.tabBarItem = UITabBarItem(title: "Focus", image: UIImage(systemName: "timelapse"), tag: 1)
        
        let focusNavCon = UINavigationController(rootViewController: focusView)
        
        // add navigation controllers containing views to tab bar viewControllers
        viewControllers = [homeNavCon, focusNavCon]
        
//        // assign images to tab bar items
//        guard let items = self.tabBar.items else { return }
//
//        let images = ["house", "timelapse", "bell"]
//
//        for (index, item) in items.enumerated() {
//            item.image = UIImage(systemName: images[index])
//        }
        
    }
    


}

