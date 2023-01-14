//
//  APTranscriptionViewController.swift
//  eZen Dev
//
//  Created by Wykee on 13/01/2023.
//  Copyright © 2023 Music of Wisdom. All rights reserved.
//

import UIKit

class APTranscriptionViewController: UIViewController {
    
    @IBOutlet weak var transcriptionText: UITextView!
    
    var words = [Utterance]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.transcriptionText.text = ""
    }
    
    final class func create() -> APTranscriptionViewController {
        let view = APTranscriptionViewController(nibName: "APTranscriptionViewController", bundle: nil)
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for word in words {
            let sentence = word.transcript
            self.transcriptionText.text += "\n\n\(sentence)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    @IBAction func onDismissPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func navigateToVideo(_ sender: Any) {
        self.saveTranscription()
    }
    
    func saveTranscription(){
        print("Text....\(self.transcriptionText.text!)")
        
        let text = self.transcriptionText.text ?? ""
        let characters = CharacterSet(charactersIn: "\n\n")
        let new_ArrayOfwords = text.components(separatedBy: characters)
        
        var finalArray = [String]()
        var newWords = [Utterance]()
        
        let group = DispatchGroup()
        
        for modified_word in new_ArrayOfwords {
            if modified_word != "" {
                finalArray.append(modified_word)
                for oldWords in words{
                    let newObj = Utterance.init(start: oldWords.start, end: oldWords.end, confidence: oldWords.confidence, channel: oldWords.channel, transcript: modified_word, words: oldWords.words, speaker: oldWords.speaker, id: oldWords.id)
                    newWords.append(newObj)
                }
            }
            
        }
        
        print("New Array is....\(new_ArrayOfwords)")
        print("Final Array is....\(finalArray)")
        
        print("...\(newWords.count)")
        
        let visualizeVC = Accessors.AppDelegate.delegate.appDiContainer.makeVisualizeDIContainer().makeVisualViewController()
        visualizeVC.words = newWords
        visualizeVC.modalPresentationStyle = .fullScreen
        visualizeVC.modalTransitionStyle = .coverVertical
        self.customPresent(vc: visualizeVC, duration: 0.2, type: .fromRight)
    }
    
}
