//
//  ViewController.swift
//  StopWatch
//
//  Created by SatnamSingh on 11/05/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var LapsTableView: UITableView!
    @IBOutlet weak var LapButton: UIButton!
    
    //following are valiables
    var isStarted = false
    var isPaused = false
    var timer = Timer()
    var counter = 0
    var lapNumber = 0
    var laps :[String] = []
    var timeString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        StartButton.layer.cornerRadius = StartButton.frame.size.height/2
        LapButton.layer.cornerRadius = LapButton.frame.size.height/2
        // Do any additional setup after loading the view.
    }

    @IBAction func startFunction(_ sender: Any) {
        if !isStarted {
            isStarted = true
            StartButton.setTitle("PAUSE", for: .normal)
            StartButton.backgroundColor = UIColor.systemGreen
            startTimer()
        }else{
            
            if !isPaused{
                isPaused = true
                timer.invalidate()
                StartButton.setTitle("RESUME", for: .normal)
                StartButton.backgroundColor = UIColor.systemPurple
                LapButton.setTitle("RESET", for: .normal)
                LapButton.backgroundColor = UIColor.systemRed
                
            }else{
                isPaused = false
                StartButton.setTitle("PAUSE", for: .normal)
                StartButton.backgroundColor = UIColor.systemGreen
                LapButton.setTitle("LAP", for: .normal)
                LapButton.backgroundColor = UIColor.systemPurple
                startTimer()
            }
        }
        
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    @objc func timerCounter(){
        counter = counter + 1
        let (hour,minute,second) = timerConverter(second: counter)
        timeString = timeToString(hour: hour, minute: minute, second: second)
        counterLabel.text = timeString
        
    }
    func timerConverter(second:Int)->(Int,Int,Int){
        return((second/3600),((second%3600)/60),((second%3600)%60))
    }
    func timeToString(hour:Int,minute:Int,second:Int)->String{
        var temp = ""
        temp = temp + String(format: "0%2d", hour)
        temp = temp + " : "
        temp = temp + String(format: "%02d", minute)
        temp = temp + " : "
        temp = temp + String(format: "%02d", second)
        return temp
    }
    
    @IBAction func LapButton(_ sender: Any) {
        if isPaused {
            resetTimer()
        }else{
            laps.insert(timeString, at: 0)
            LapsTableView.reloadData()
        }
        
    }
    
    
    func resetTimer()  {
        self.counter = 0
        laps.removeAll(keepingCapacity: false)
        LapsTableView.reloadData()
        timer.invalidate()
        counterLabel.text = timeToString(hour: 0, minute: 0, second: 0)
        StartButton.setTitle("START", for: .normal)
        StartButton.backgroundColor = UIColor.systemPurple
        LapButton.setTitle("LAP", for: .normal)
        LapButton.backgroundColor = UIColor.systemPurple
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Lap \(laps.count - indexPath.row)"
        cell.detailTextLabel?.text = laps[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
}

