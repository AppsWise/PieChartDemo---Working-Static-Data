//
//  ViewController.swift
//  PieChartDemo
//

//

import UIKit
struct DateRange : SequenceType {
    
    var calendar: NSCalendar
    var startDate: NSDate
    var endDate: NSDate
    var stepUnits: NSCalendarUnit
    var stepValue: Int
    
    func generate() -> Generator {
        return Generator(range: self)
    }
    
    struct Generator: GeneratorType {
        
        var range: DateRange
        
        mutating func next() -> NSDate? {
            let nextDate = range.calendar.dateByAddingUnit(range.stepUnits,
                value: range.stepValue,
                toDate: range.startDate,
                options: NSCalendarOptions())
            
            if range.endDate.compare(nextDate!) == NSComparisonResult.OrderedAscending {
                return nil
            }
            else {
                range.startDate = nextDate!
                return nextDate
            }
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    var dateDict:[String:Double] = [String:Double]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        let monthFormatter = NSDateFormatter()
        monthFormatter.dateFormat = "MMM"

        
        let sDate = NSDate()
        let eDate = NSCalendar.currentCalendar().dateByAddingUnit(
            .Day,
            value: 100,
            toDate: sDate,
            options: NSCalendarOptions(rawValue: 0))
        

            let dateRange = DateRange(calendar: NSCalendar.currentCalendar(),startDate: sDate,endDate: eDate!,stepUnits: NSCalendarUnit.Day,stepValue: 1)
        
        for date in dateRange {
            
            let month = monthFormatter.stringFromDate(date)
            if self.dateDict.indexForKey(month) != nil {
                self.dateDict[month]! += 1.0
            }else{
                self.dateDict.updateValue(1.0, forKey: month)
            }

        }
        let dataPointArray = Array(dateDict.keys)
        let valuesArray = Array(dateDict.values)
        setChart(dataPointArray, values: valuesArray)
//        print(dateDict)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func offDaysDidLoad() {
//
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "MMM"
//        dateDict = [:]
//        for od in chartArray {
//            let date = od["Date"] as! NSDate
//            let month = formatter.stringFromDate(date)
//            if self.dateDict.indexForKey(month) != nil {
//                self.dateDict[month]! += 1.0
//            }else{
//                self.dateDict.updateValue(1.0, forKey: month)
//            }
//        }
//        let dataPointArray = Array(dateDict.keys)
//        let valuesArray = Array(dateDict.values)
//        pieChartView.data = nil
//        pieChartView.legend
//        pieChartView.backgroundColor = UIColor.grayColor()
//        setChart(dataPointArray, values: valuesArray)
//
//    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        let label = ""
        for i in 0..<dataPoints.count {
            
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
            //            label += "\(dataPoints[i]) "
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: label)
        
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartData.setDrawValues(false)
        pieChartView.legend.labels = [label]
        pieChartView.data = pieChartData
        pieChartView.animate(xAxisDuration: NSTimeInterval(5))
        //            = ChartLegendPosition.BelowChartLeft
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        pieChartDataSet.colors = colors
        
    }
}

