//
//  ViewController.swift
//  Petometer
//
//  Created by Sebastian Cueva-Caro on 2/4/16.
//  Copyright © 2016 hack4health. All rights reserved.
//

import UIKit
import CoreMotion
class ViewController: UIViewController {
    
    @IBOutlet weak var activityState: UILabel!
    @IBOutlet weak var steps: UILabel!
    
    var days:[String] = []
    var stepsTaken:[Int] = []
    
    
    @IBOutlet weak var stateImageView: UIImageView!
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let calFlags: NSCalendarUnit = [.Year, .Month, .Day, .Hour, .Minute, .Second]
        let cal = NSCalendar.currentCalendar()
        let comps = cal.components(calFlags, fromDate: NSDate())
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let timeZone = NSTimeZone.systemTimeZone()
        cal.timeZone = timeZone
        
        let midnightOfToday = cal.dateFromComponents(comps)!
        
        self.activityState.text = "Stationary"
        self.stateImageView.image = UIImage(named: "Running")
        
        if(CMMotionActivityManager.isActivityAvailable()){
            self.activityManager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (data: CMMotionActivity?) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(data!.stationary == true){
                        self.activityState.text = "Stationary"
                        self.stateImageView.image = UIImage(named: "Sitting")
                    } else if (data!.walking == true){
                        self.activityState.text = "Walking"
                        self.stateImageView.image = UIImage(named: "Walking")
                    } else if (data!.running == true){
                        self.activityState.text = "Running"
                        self.stateImageView.image = UIImage(named: "Running")
                    } else if (data!.automotive == true){
                        self.activityState.text = "Automotive"
                    }
                })
                
            })
        }
        if(CMPedometer.isStepCountingAvailable()){
            let fromDate = NSDate(timeIntervalSinceNow: -86400 * 7)
            self.pedoMeter.queryPedometerDataFromDate(fromDate, toDate: NSDate()) { (data : CMPedometerData?, error) -> Void in
                print(data)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(error == nil){
                        self.steps.text = "\(data!.numberOfSteps)"
                    }
                })
                
            }
            
            self.pedoMeter.startPedometerUpdatesFromDate(midnightOfToday) { (data: CMPedometerData?, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(error == nil){
                        self.steps.text = "\(data!.numberOfSteps)"
                    }
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}