//
//  TimerViewController.swift
//  testForModel
//
//  Created by 박형석 on 2021/03/07.
//

import UIKit

class TimerViewController: UIViewController {
    
    //MARK: - Property
    
    @IBOutlet weak var playAndpauseButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var minute15buttone: UIButton!
    @IBOutlet weak var minute30buttone: UIButton!
    @IBOutlet weak var minute45buttone: UIButton!
    @IBOutlet weak var minute60buttone: UIButton!
    @IBOutlet var minuteButtons: [UIButton]!
    
    @IBOutlet weak var contentView: UIView!
    
    let timeLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textAlignment = .center
        label.text = "00:00"
        return label
    }()
    
    let backgroundLayer: CAShapeLayer = {
       let layer = CAShapeLayer()
        layer.lineWidth = 3
        layer.strokeColor = UIColor.opaqueSeparator.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    let foregroundLayer: CAShapeLayer = {
       let layer = CAShapeLayer()
        layer.lineWidth = 20
        layer.lineCap = .round
        layer.strokeColor = UIColor.systemIndigo.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    let timeManager = TimeManager.shared
    
    var timer = Timer()
    var leftTime = 3
    var onTimer: Bool = false
    var completionTime: FOCUSTIMER?
    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        foregroundLayerUpdateUI(endAngle: 0.degreeToRadius)
        
        minuteButtons.forEach { $0.addTarget(self, action: #selector(minuteButtonsTapped), for: .touchUpInside) }
        
        let time = timeManager.secondToMinuteSecond(wholeSecond: leftTime)
        let timeString = timeManager.makeTimeString(minute: time.0, second: time.1)
        timeLabel.text = timeString
        
        self.timeManager.readTimes()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateButtonUI()
        backgroundLayerUpdateUI()
        
        contentView.layer.addSublayer(foregroundLayer)
        timeLabelUpdateUI()
    }
    
    //MARK: - IBAction
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        onTimer = false
        playAndpauseButton.setTitle("시작", for: .normal)
        playAndpauseButton.backgroundColor = .systemGreen
        leftTime = 0
        foregroundLayerUpdateUI(endAngle: -90.degreeToRadius)
        timeLabel.text = "00:00"
    }
    
    @IBAction func startAndPauseButtonTapped(_ sender: UIButton) {
        
        guard leftTime > 0 else { return  }
        
        animationLayer()
        
        if onTimer {
            timer.invalidate()
            playAndpauseButton.setTitle("시작", for: .normal)
            playAndpauseButton.backgroundColor = .systemGreen
            onTimer = false
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCounting), userInfo: nil, repeats: true)
            playAndpauseButton.setTitle("일시정지", for: .normal)
            playAndpauseButton.backgroundColor = .systemRed
            foregroundLayer.removeAllAnimations()
            onTimer = true
        }
    }
    
  
    //MARK: - Function
    
    private func animationLayer() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 1
        animation.toValue = 0
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        switch completionTime {
        case .timer15:
            animation.duration = Double(FOCUSTIMER.timer15.timerToSecond)
        case .timer30:
            animation.duration = Double(FOCUSTIMER.timer30.timerToSecond)
        case .timer45:
            animation.duration = Double(FOCUSTIMER.timer45.timerToSecond)
        case .timer60:
            animation.duration = Double(FOCUSTIMER.timer60.timerToSecond)
        default:
            animation.duration = Double(FOCUSTIMER.timer15.timerToSecond)
        }
        foregroundLayer.add(animation, forKey: "first animation")
    }
    
    @objc private func timerCounting(){
        
        leftTime -= 1
        let time = timeManager.secondToMinuteSecond(wholeSecond: leftTime)
        let timeString = timeManager.makeTimeString(minute: time.0, second: time.1)
        timeLabel.text = timeString
        
        if leftTime == 0 {
            timer.invalidate()
            playAndpauseButton.setTitle("시작", for: .normal)
            playAndpauseButton.backgroundColor = .systemGreen
            onTimer = false
            timeManager.createTime(completionTime: completionTime?.timerToSecond ?? FOCUSTIMER.timer15.timerToSecond)
        }
    }
    
    @objc func minuteButtonsTapped(_ sender: UIButton) {
        
        switch sender {
        case minute15buttone :
            leftTime = 15*60
            completionTime = .timer15
            DispatchQueue.main.async {
                self.foregroundLayerUpdateUI(endAngle: 0.degreeToRadius)
            }
        case minute30buttone:
            leftTime = 30*60
            completionTime = .timer30
            DispatchQueue.main.async {
                self.foregroundLayerUpdateUI(endAngle: 90.degreeToRadius)
            }
        case minute45buttone:
            leftTime = 45*60
            completionTime = .timer45
            DispatchQueue.main.async {
                self.foregroundLayerUpdateUI(endAngle: 180.degreeToRadius)
            }
        case minute60buttone:
            leftTime = 60*60
            completionTime = .timer60
            DispatchQueue.main.async {
                self.foregroundLayerUpdateUI(endAngle: 270.degreeToRadius)
            }
        default:
            break
        }
        
        let time = timeManager.secondToMinuteSecond(wholeSecond: leftTime)
        let timeString = timeManager.makeTimeString(minute: time.0, second: time.1)
        playAndpauseButton.setTitle("시작", for: .normal)
        playAndpauseButton.backgroundColor = .systemGreen
        onTimer = false
        timeLabel.text = timeString
    }
    
        

    
    
    private func updateButtonUI(){
        
        for button in minuteButtons {
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 25
        }
      
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 25
        cancelButton.setTitle("RESET", for: .normal)
       
        playAndpauseButton.layer.masksToBounds = true
        playAndpauseButton.layer.cornerRadius = 25
    }
    
    private func timeLabelUpdateUI() {
        contentView.addSubview(timeLabel)
        timeLabel.frame.size = CGSize(width: 100, height: 60)
        timeLabel.center = CGPoint(x: contentView.bounds.midX, y:contentView.bounds.midY)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
      
    }
   
    private func backgroundLayerUpdateUI() {
        
        let centerPoint = CGPoint(x: contentView.frame.width/2, y:contentView.frame.height/2)
       
        backgroundLayer.path = UIBezierPath(arcCenter:centerPoint, radius: contentView.bounds.height / 2, startAngle: -90.degreeToRadius, endAngle: 270.degreeToRadius, clockwise: true).cgPath
      
        contentView.layer.addSublayer(backgroundLayer)
    }
    
    private func foregroundLayerUpdateUI(endAngle: CGFloat) {
        let centerPoint = CGPoint(x: contentView.layer.bounds.midX, y: contentView.layer.bounds.midY)
        foregroundLayer.path = UIBezierPath(arcCenter: centerPoint, radius: contentView.bounds.height / 2, startAngle: -90.degreeToRadius, endAngle: endAngle, clockwise: true).cgPath
        print(endAngle)
    }
}

extension Int {
    var degreeToRadius : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
