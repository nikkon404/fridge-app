//
//  HomeViewController.swift
//  FridgeApp
//
//  Created by Devansh Vipulkumar Shah on 8/9/22.
//

import UIKit
import Charts

//class responsible for showing bar and pie charts
//REFERENCE CODE
//https://github.com/danielgindi/Charts/tree/master/ChartsDemo-iOS/Swift/Demos
class SummaryViewController: UIViewController, ChartViewDelegate {
    
    //making it singleton
    static var instance: SummaryViewController?
    
    @IBOutlet weak var upperChart: UIView!
    
    @IBOutlet weak var pieView: UIView!
    
    
    var barChart = BarChartView()
    var pieChart = PieChartView()
    
    var items = [GroceryItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.delegate = self
        pieChart.delegate = self
        
        setupData()
        
        //initalizeing instance of singleton
        SummaryViewController.instance = self
        
    }
    
    
    //fetches grocery data and plots it into charts
    public func setupData()
    {
        items = DatabaseService.getAllGroceryItems(searchText:"", orderBy: SortBy.addedFirst, category: "")
        
        
        if(items.count == 0)
        {
            let lbl =  UILabel(frame: view.frame)
            
            lbl.text = "No grocery Items to show"
            lbl.textAlignment = .center
            view.addSubview(lbl)
            
        }
        else {
            barChart.removeFromSuperview()
            pieChart.removeFromSuperview()
            
           setupUpperChart()
            setupPieChart()
        }
                
    }
    
    
    //method to create barchart
    func setupUpperChart(){
        let size = upperChart.frame.size
        barChart.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        barChart.center = upperChart.center
        var entries  = [BarChartDataEntry]()
        
        
        let total = items.count
        
        entries.append(BarChartDataEntry( x: Double(0), y: Double(total), data: "Total"))
        
        let expired = items.filter{Converter.daysBetweenDates(endDate: $0.expiryDate!) < 0}.count
        entries.append(BarChartDataEntry( x: Double(1), y: Double(expired), data: "Expired"))
        
        
        let expSoon = items.filter{Converter.daysBetweenDates(endDate: $0.expiryDate!) >= 0
            && Converter.daysBetweenDates(endDate: $0.expiryDate!) <= 2
        }.count
        entries.append(BarChartDataEntry( x: Double(2), y: Double(expSoon), data: "Exp Soon"))
        
        
        let healthy = total - expired - expSoon
        entries.append(BarChartDataEntry( x: Double(3), y: Double(healthy), data: "Healthy"))
        
        
        
        let set = BarChartDataSet(entries)
        set.colors = [.blue,.red,.yellow,.green]
        
        let data = BarChartData(dataSet:set)
        barChart.data = data
        let formatter: CustomIntFormatter = CustomIntFormatter()
        barChart.data?.setValueFormatter(formatter)
        //data.setDrawValues(true)
        
        
        
        let l = barChart.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .top
        l.orientation = .vertical
        
        l.form = .circle
        l.formSize = 15
        l.yEntrySpace = 15
        
        
        let allLabel = LegendEntry(label: "ALL")
        allLabel.formColor = .blue
        
        let expLbl = LegendEntry(label: "Expired")
        expLbl.formColor = .red
        
        
        let expSponlbl = LegendEntry(label: "Expiring Soon")
        expSponlbl.formColor = .yellow
        
        let healthyLbl = LegendEntry(label: "Healthy")
        healthyLbl.formColor = .green
       
        
        l.setCustom(entries: [allLabel, expLbl,expSponlbl, healthyLbl])
        
        let xAxis = barChart.xAxis
        
        
        xAxis.valueFormatter = CustomAxisFormatter()
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.drawGridLinesBehindDataEnabled = false
        xAxis.drawLimitLinesBehindDataEnabled = false
        xAxis.axisLineColor = .white
        xAxis.labelPosition = .bottom
        
        xAxis.enabled = false
        
        
        let  yAxis = barChart.leftAxis
        yAxis.drawLabelsEnabled = false
        yAxis.drawAxisLineEnabled = false
        yAxis.drawGridLinesEnabled = false
        yAxis.drawGridLinesBehindDataEnabled = false
        yAxis.drawLimitLinesBehindDataEnabled = false
        xAxis.axisLineColor = .white
        
        barChart.legend.enabled = true
        
        
        barChart.gridBackgroundColor = .clear
        
        barChart.rightAxis.enabled = false
        barChart.leftAxis.enabled = false
        
        yAxis.labelTextColor = .lightGray
        xAxis.labelTextColor = .lightGray
        
        upperChart.addSubview(barChart)
        barChart.animate(xAxisDuration: 1.0)
        barChart.animate(yAxisDuration: 1.0)
        
        
    }
    
    
    
    //method to create bar graph
    func setupPieChart ()
    {
         pieChart = PieChartView(frame: CGRect(x: 0, y: 0, width: pieView.frame.size.width - 10, height: pieView.frame.size.height - 10))
        
        
        let dictionary = Dictionary(grouping: items, by: { (element: GroceryItem) in
            return element.category
        })
        
        
        var entries = [PieChartDataEntry]()
        for (index, value) in dictionary {
            
            
            let entry = PieChartDataEntry()
            entry.y = Double(value.count)
            entry.label = index
            entries.append( entry)
        }
        
        let set = PieChartDataSet( entries: entries, label: "")
        
        
        set.colors = ChartColorTemplates.material()
        let data = PieChartData(dataSet: set)
        data.setValueFormatter(CustomIntFormatter())
        pieChart.data = data
        pieChart.noDataText = "Categories"
        // user interaction
        pieChart.isUserInteractionEnabled = true
        
        pieChart.largeContentTitle = "Categories"
        
        let d = Description()
        d.text = "Categories"
        pieChart.chartDescription = d
        pieChart.centerText = "Categories"
        pieChart.holeRadiusPercent = 0.5
        pieChart.transparentCircleColor = UIColor.clear
        
        
        pieView.addSubview( pieChart)
        
        pieChart.animate(xAxisDuration: 1.0)
        pieChart.animate(yAxisDuration: 1.0)
    }
    
    
}

class CustomIntFormatter: NSObject, ValueFormatter{
    public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        let correctValue = Int(value)
        print("correctValue: \(correctValue)")
        return String(correctValue)
    }
}

class CustomAxisFormatter: NSObject, AxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let correctValue = Int(value)
        print("correctValue: \(correctValue)")
        return String(correctValue)
    }
}
