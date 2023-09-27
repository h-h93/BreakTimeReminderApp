//
//  CountDownViewController.swift
//  BreakTimeReminderApp
//
//  Created by hanif hussain on 11/09/2023.
//

import UIKit

class CountDownViewController: UIViewController {
    var savedtimer: savedTimers!
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    var timeLeft: TimeInterval = 1500
    var endTime: Date?
    var timeLabel =  UILabel()
    var timer = Timer()
    // here you create your basic animation object to animate the strokeEnd
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    var isTimerRunning = true
    
    let pauseButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 550, width: 100, height: 50))
        button.setTitle("Pause", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = button.frame.height / 2
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 1
        return button
    }()
    
    let resumeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 250, y: 550, width: 100, height: 50))
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = button.frame.height / 2
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 1
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // implement observer notifications to check when app enters background
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        // implement observer notifications to check when app enters foreground
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        drawButtons()
        
        // hide tab bar so user can't switch between tabs as they should focus on the timer
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupAnimations(timeRemaining: savedtimer.timeDuration * 60)
    }
    
    func setupAnimations(timeRemaining: TimeInterval) {
        // convert minutes to seconds
        timeLeft = timeRemaining
        
        view.backgroundColor = .systemBackground //UIColor(white: 0.94, alpha: 1.0)
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
        
        // pause timer at the start to pause the animation until user clicks start
        pauseTimer()
        
        drawButtons()
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
        bgShapeLayer.strokeColor = UIColor.secondarySystemBackground.cgColor
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
        if isTimerRunning == true {
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
    }
    
   @objc func pauseTimer() {
       timer.invalidate()
       isTimerRunning = false
       
       // pause the timer animation
       let pausedTime = timeLeftShapeLayer.convertTime(CACurrentMediaTime(), from: nil)
       timeLeftShapeLayer.speed = 0
       timeLeftShapeLayer.timeOffset = pausedTime
       

    }
    
    @objc func resumeTimer() {
        if isTimerRunning == false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            isTimerRunning = true
            // disable animation for countdown till user selects start
            strokeIt.speed = 1
            
            // resume timer animation
            let pausedTime = timeLeftShapeLayer.timeOffset
            timeLeftShapeLayer.speed = 1.0
            timeLeftShapeLayer.timeOffset = 0.0
            timeLeftShapeLayer.beginTime = 0.0
            let timeSincePause = timeLeftShapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            timeLeftShapeLayer.beginTime = timeSincePause

        }
    }
    
    // stop and remove animation and label to reset animation
    @objc func disableAnimations() {
        pauseTimer()
        timeLeftShapeLayer.removeAllAnimations()
        bgShapeLayer.removeAllAnimations()
        
        timeLabel.removeFromSuperview()
    }
    
    @objc func enableAnimations() {
        setupAnimations(timeRemaining: timeLeft)
        resumeTimer()
    }
    
    @objc func appWillResignActive() {
        disableAnimations()
    }

    @objc func appDidBecomeActive() {
        enableAnimations()
    }
    
}

extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
}
