//
//  DataSynth.swift
//  AudioChartsDemo
//
//  Created by Oli Clarke on 18/03/2021.
//

import Foundation
import AudioKit

struct sequencerData {
    var isPlaying = false
    var tempo: BPM = 120
    var timeSignatureTop: Int = 16
    var downbeatNoteNumber = MIDINoteNumber(40)
    var beatNoteNumber = MIDINoteNumber(60)
    // var beatNoteVelocity = 100.0
    var currentBeat = 0
}

class DataSynth{
    
    let synth = RhodesPianoKey()
    
    private var dataArray : [Double]!
    
    public var sequencer = Sequencer()
    
    private var callbackInst = CallbackInstrument()
    
    // Struct for sequencer data
    @Published var seqData = sequencerData() {
        didSet {
            seqData.isPlaying ? sequencer.play() : sequencer.stop()
            sequencer.tempo = seqData.tempo
        }
    }
    
    // Init audio manager for all audiokit output, mixing etc.
    public var audioManager: AudioManager?
    
    init(){
        
        // Fader gain, could remove
        let fader = Fader(synth)
        fader.gain = 20.0
        
        // Set-up Audiomanager
        audioManager = AudioManager()
        
        sequencer = Sequencer(targetNode: synth)
        
        let _ = sequencer.addTrack(for: synth)
        
        callbackInst = CallbackInstrument(midiCallback: { (_, beat, _) in
            self.seqData.currentBeat = Int(beat)
            print(beat)
        })
        
        let _ = sequencer.addTrack(for: callbackInst)
        
        // Init audio mannager connections
        audioManager?.nodeMixer.addInput(synth)
        audioManager?.nodeMixer.addInput(callbackInst)
    }
    
    // Import Data
    public func importData(data: [Double]) -> Double{
        let returner = 0.0
        var next = 0.0
        
        var track = sequencer.tracks.first!
        
        seqData.timeSignatureTop = data.count
        
        track.length = Double(seqData.timeSignatureTop)
        
        track.clear()
        
        for i in data {
            
            track.sequence.add(noteNumber: MIDINoteNumber(Int(i)), velocity: MIDIVelocity(AUValue(20)), channel: 0, position: next, duration: 0.1)
            
            next += 1
            
        }
        
        return returner
    }
    
    // Stop sequencer
    public func stopPlay(){
        seqData.isPlaying = false
        sequencer.stop()
        sequencer.clear()
    }
    
    // Play sequencer
    public func playSeq(){
        seqData.isPlaying = true
        sequencer.playFromStart()
    }
    
    // Update BPM of sequencer and seqData
    public func changeBPM(BPM: Double ){
        sequencer.tempo = BPM
        seqData.tempo = BPM
    }
}
