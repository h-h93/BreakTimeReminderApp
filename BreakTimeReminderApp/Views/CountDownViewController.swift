//
//  CountDownViewController.swift
//  BreakTimeReminderApp
//
//  Created by hanif hussain on 11/09/2023.
//

import UIKit

class CountDownViewController: UIViewController {
    var duration = 25
    //var timer: Timer!
    
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    var timeLeft: TimeInterval = 1499
    var endTime: Date?
    var timeLabel =  UILabel()
    var timer = Timer()
    // here you create your basic animation object to animate the strokeEnd
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    var isTimerRunning = false
    
    let pauseButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 550, width: 100, height: 50))
        button.setTitle("Pause", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = button.frame.height / 2
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    let resumeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 250, y: 550, width: 100, height: 50))
        button.setTitle("Start", for: .normal)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        drawBgShape()
        drawTimeLeftShape()
        addTimeLabel()
        // here you define the fromValue, toValue and duration of your animation
        strokeIt.fromValue = 0
        strokeIt.toValue = 1
        strokeIt.duration = timeLeft
        // add the animation to your timeLeftShapeLayer
        timeLeftShapeLayer.add(strokeIt, forKey: nil)
        // define the future end time by adding the timeLeft to now Date()
        endTime = Date().addingTimeInterval(timeLeft)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        drawButtons()
        
        // hide tab bar so user can't switch between tabs as they should focus on the timer
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // show the tab bar again as user has exited the focus mode
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func drawButtons() {
        view.addSubview(pauseButton)
        view.addSubview(resumeButton)
        pauseButton.addTarget(self, action: #selector(pauseTimer), for: .touchUpInside)
        resumeButton.addTarget(self, action: #selector(resumeTimer), for: .touchUpInside)
    }
    
    func drawBgShape() {
        bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius: 100, startAngle: deg2rad(-90), endAngle: deg2rad(270), clockwise: true).cgPath
        bgShapeLayer.strokeColor = UIColor.white.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 15
        view.layer.addSublayer(bgShapeLayer)
    }
    func drawTimeLeftShape() {
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius: 100, startAngle: deg2rad(-90), endAngle: deg2rad(270), clockwise: true).cgPath
        timeLeftShapeLayer.strokeColor = UIColor.red.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = 15
        view.layer.addSublayer(timeLeftShapeLayer)
    }
    
    func addTimeLabel() {
        timeLabel = UILabel(frame: CGRect(x: view.frame.midX-50 ,y: view.frame.midY-25, width: 100, height: 50))
        timeLabel.textAlignment = .center
        timeLabel.text = timeLeft.time
        view.addSubview(timeLabel)
    }
    
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    @objc func updateTime() {
        isTimerRunning = true
        if timeLeft > 0 {
            // minus 1 second each time
            timeLeft -= 1
            //timeLeft = endTime?.timeIntervalSinceNow ?? 0
            timeLabel.text = timeLeft.time
        } else {
            timeLabel.text = "00:00"
            timer.invalidate()
        }
    }
    
   @objc func pauseTimer() {
        timer.invalidate()
       isTimerRunning = false
    }
    
    @objc func resumeTimer() {
        if isTimerRunning == false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            isTimerRunning = true
        }
    }
    
    
}

extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
}
