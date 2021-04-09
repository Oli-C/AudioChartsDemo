//
//  ContentView.swift
//  AudioChartsDemo
//
//  Created by Oli Clarke on 18/03/2021.
//

import SwiftUI
import SwiftUICharts


struct ContentView: View {
    
    @State private var dataLength: Double = 16 // Length of data array
    @State private var upperBoundry: Double = 100
    @State private var lowerBoundry: Double = 30
    
    @State var data1: [Double] = (0..<16).map { _ in .random(in: 30.0...100.0) }
    
    @State private var BPM: Double = 120
    
    @State private var chartType: Bool = true
    
    let blackStyle = ChartStyle(backgroundColor: .white,
                                foregroundColor: [ColorGradient(.red, .orange)])
    
    let dataSynth = DataSynth()
    
    var body: some View {
        
        VStack {
            
            
            if chartType == true{
            // Visual Represetation
            CardView(showShadow: true) {
                ChartLabel("Dataset", type: .subTitle)
                
                LineChart()
            }
            .data(data1)
            .chartStyle(blackStyle)
            .padding()
        }
            else if chartType == false{
                // Visual Represetation
                CardView(showShadow: true) {
                    ChartLabel("Dataset", type: .subTitle)
                    
                    BarChart()
                }
                .data(data1)
                .chartStyle(blackStyle)
                .padding()
                
                
            }
            
        }
        
        
        
        // BPM Slider
        VStack {
            Slider(value: $BPM, in: 20...4000, onEditingChanged: {changing in self.update(changing: changing) })
                
                .padding()
            
            Text("BPM: \(BPM, specifier: "%.f")")
        }
        
        .padding()
        
        // Data length slider
        VStack {
            Slider(value: $dataLength, in: 2...128)
                
                .padding()
            
            Text("Length of Dataset: \(dataLength, specifier: "%.f") ")
        }
        
        // MIDI Limits
        VStack {
            Slider(value: $upperBoundry, in: 64...128)
                
                .padding()
            
            Text("Upper MIDI Limit: \(upperBoundry, specifier: "%.f") ")
        }
        
        VStack {
            Slider(value: $lowerBoundry, in: 1...63)
                
                .padding()
            
            Text("Lower MIDI Limit: \(lowerBoundry, specifier: "%.f") ")
        }
        
        // Sonification Button
        HStack {
            Button(action: {
                dataSynth.importData(data: data1)
                dataSynth.playSeq()
            }) {
                Text("Sonify")
            }
            
            Spacer()
            
            // Stop Button
            Button(action: {
                dataSynth.stopPlay()
                self.data1 = (0..<Int(dataLength)).map { _ in .random(in: lowerBoundry...upperBoundry) } as [Double]
            }) {
                Text("Shuffle")
            }
        }
        
        .padding()
        
        
        // Change chart type
        VStack {
            Button(action: {
                chartType.toggle()
            }) {
                Text("Change Chart Type")
            }
        }
        
        .padding()
    }
    
    
    
    
    
    
    
    func update(changing: Bool) -> Void {
        dataSynth.changeBPM(BPM: BPM)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
