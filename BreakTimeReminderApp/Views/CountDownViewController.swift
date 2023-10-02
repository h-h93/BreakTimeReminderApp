//
//  CountDownViewController.swift
//  BreakTimeReminderApp
//
//  Created by hanif hussain on 11/09/2023.
//

import UIKit

class CountDownViewController: UIViewController {
    var savedtimer: savedTimers!
    
    var timeLabel =  UILabel()
    
    var countDownTimer = Timer()
    
    let shapeLayer = CAShapeLayer()
    
    var timeLeft: TimeInterval = 1500
    
    // here you create your basic animation object to animate the strokeEnd
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    
    var updateLabelTimer = Timer()

    var isTimerRunning = true {
        didSet {
            if isTimerRunning == true {
                pauseButton.setTitle("Pause", for: .normal)
            } else {
                pauseButton.setTitle("Reset", for: .normal)
            }
        }
    }
    
    let pauseButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 560, width: 100, height: 50))
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
        let button = UIButton(frame: CGRect(x: 250, y: 560, width: 100, height: 50))
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
        
        view.backgroundColor = .systemBackground

        // implement observer notifications to check when app enters background
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        // implement observer notifications to check when app enters foreground
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        drawButtons()
        
        // convert savedtimer.timeDuration to seconds and assign to timeLeft var
        timeLeft = savedtimer.timeDuration * 60
        
        // hide tab bar so user can't switch between tabs as they should focus on the timer
        self.tabBarController?.tabBar.isHidden = true
        
        // stop screen from going to sleep
        UIApplication.shared.isIdleTimerDisabled = true
        
        // let's start by drawing a circle somehow
        let center = view.center
        
        // create my track layer
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: .pi * 3 / 2, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 15
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        view.layer.addSublayer(trackLayer)
        
//        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        timeLabel = UILabel(frame: CGRect(x: view.frame.midX-50 ,y: view.frame.midY-25, width: 100, height: 50))
        timeLabel.textAlignment = .center
        timeLabel.text = timeLeft.time
        view.addSubview(timeLabel)
        
        updateLabelTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        updateLabelTimer.tolerance = 0.01
        
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startAnimation), userInfo: nil, repeats: false)
        
        pauseTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // show tab bar again so user can navigate between views
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func startAnimation() {
        
        //let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        
        basicAnimation.duration = timeLeft
        
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "myAnimation")
    }
    
    @objc func updateTimer() {
        if timeLeft > 0 {
            timeLeft -= 1.0
        } else {
            updateLabelTimer.invalidate()
            countDownTimer.invalidate()
            pauseButton.isEnabled = false
            resumeButton.isEnabled = false
            let ac = UIAlertController(title: "Timer Complete", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            present(ac, animated: true)
        }
        timeLabel.text = timeLeft.time
    }
    
    func drawButtons() {
        view.addSubview(pauseButton)
        view.addSubview(resumeButton)
        pauseButton.addTarget(self, action: #selector(pauseTimer), for: .touchUpInside)
        resumeButton.addTarget(self, action: #selector(resumeTimer), for: .touchUpInside)
    }
    
    @objc func restartTimer() {
        timeLeft = savedtimer.timeDuration * 60
        countDownTimer.invalidate()
        updateLabelTimer.invalidate()
        timeLabel.text = timeLeft.time
        
        updateLabelTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        updateLabelTimer.tolerance = 0.01
        
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startAnimation), userInfo: nil, repeats: false)
        
        pauseTimer()
    }
    
    @objc func pauseTimer() {
        if isTimerRunning == true {
            updateLabelTimer.invalidate()
            let pausedTime : CFTimeInterval = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
            shapeLayer.speed = 0
            shapeLayer.timeOffset = pausedTime
            isTimerRunning = false
        } else {
            // restart timer if user hits the pause button after tapping it once already
            isTimerRunning = true
            updateLabelTimer.invalidate()
            countDownTimer.invalidate()
            restartTimer()
        }
    }
    
    @objc func resumeTimer() {
        if isTimerRunning == false {
            updateLabelTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            updateLabelTimer.tolerance = 0.01
            let pausedTime = shapeLayer.timeOffset
            shapeLayer.speed = 1.0
            shapeLayer.timeOffset = 0.0
            shapeLayer.beginTime = 0.0
            let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            shapeLayer.beginTime = timeSincePause
            isTimerRunning = true
        }
    }

 
    
    @objc func appWillResignActive() {
       pauseTimer()
    }

    @objc func appDidBecomeActive() {
       
    }
    
}

extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
}
