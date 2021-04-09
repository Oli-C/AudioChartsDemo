//
//  AudioManager.swift
//  AudioChartsDemo
//
//  Created by Oli Clarke on 18/03/2021.
//

import Foundation
import AudioKit

class AudioManager{
    
    // Initialise Audio Engine
    let engine = AudioEngine()
    
    var nodeMixer: Mixer // Mixer for all synth squares
    var master: Mixer    // Mixer for adding effects
    
    // Effects
    var reverb: Reverb
    var delay: Delay
    var lowPassFilter: LowPassFilter
    
    var limiter: PeakLimiter
    
    init() {
        
        // Each node is mixed together in an AK's Mixer object
        nodeMixer = Mixer()
        
        // Delay
        delay = Delay(nodeMixer)
        delay.feedback = 0.3
        delay.time = 0.5
        delay.dryWetMix = 0.5
        
        // Reverb
        reverb = Reverb(nodeMixer)
        reverb.dryWetMix = 0.1
        reverb.loadFactoryPreset(.plate)
        
        // Effects are mixed together
        master = Mixer(reverb)
        
        // LPF to remove high end
        lowPassFilter = LowPassFilter(master)
        lowPassFilter.cutoffFrequency = 15000
        lowPassFilter.resonance = 0.2
        
        // Limiter to catch any distortion
        limiter = PeakLimiter(lowPassFilter, attackTime: 0.0, decayTime: 0.1, preGain: 0.0)
        
        // Set the audio output and start AudioKit for output
        engine.output = master
        
        do {
            try   engine.start()
        } catch {
            print("could not start sound engine")
            engine.stop()
            return
        }
    }
    
    // Method called when any audio effect UI setting is changed
    func changeAudioSetting(audioSetting : String, value : Double) {
        
        // Change reverb dry/wet
        if audioSetting == "Reverb Mix" {
            reverb.dryWetMix = AUValue(value)
        }
        
        // Change Reverb type
        else if audioSetting == "Reverb Type" {
            
            if value == 0.0{
                reverb.loadFactoryPreset(.mediumRoom)
            }
            
            if value == 1.0{
                reverb.loadFactoryPreset(.largeHall)
            }
            
            if value == 2.0{
                reverb.loadFactoryPreset(.plate)
            }
            
            if value == 3.0{
                reverb.loadFactoryPreset(.cathedral)
            }
            
        }
        else if audioSetting == "Delay Mix" {
            delay.dryWetMix = AUValue(value)
        }
        else if audioSetting == "Delay Time" {
            delay.time = AUValue(value)
        }
        else if audioSetting == "Delay Feedback" {
            delay.feedback = AUValue(value)
        }
        else if audioSetting == "Low Pass" {
            lowPassFilter.cutoffFrequency = AUValue(value)
        }
    }
}
