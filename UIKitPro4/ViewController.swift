//
//  ViewController.swift
//  UIKitPro4
//
//  Created by Sothesom on 27/04/1403.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var useWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let startWordsURL = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        } else {
            allWords = ["Sothesom"]
        }
            startGame()
    }
    
    func startGame() {
        // ساختن کلمه
        title = allWords.randomElement()
        // ذخیره کلمه
        useWords.removeAll(keepingCapacity: true)
        // لود کردن کلمات
        tableView.reloadData()
    }
        

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return useWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "word", for: indexPath)
        cell.textLabel?.text = useWords[indexPath.row]
        return cell
        
    }

}

