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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
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
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){
            // به ما اجازه میدهد مقادیر استفاده شده در داخل بسته چگونه باید ثبت شوند
            // نها یک اشاره‌گر ضعیف به متغیرها دارد و در صورتی که هیچ ارجاع قوی‌ای به آن متغیر وجود نداشته باشد، آن متغیر آزاد می‌شود.
            // رجاع‌های ضعیف به صورت اختیاری (Optional) هستند و در صورتی که متغیر آزاد شود، مقدار آن به
            // nil تغییر پیدا میکند
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        // برای نمایش
        present(ac, animated: true)
    }
    
    // بررسی اینکه این یک کلمه انگلیسی معتبر هست یا نه
    
    func submit(_ answer: String ) {
        let lowerAmswer = answer.lowercased()
        
        let errorTitle: String
        let errorMassage : String
        
        if isPossible(word: lowerAmswer){
            if isOrgiall(word: lowerAmswer){
                if isReal(word: lowerAmswer){
                    // اضافه کردن به جدول
                    useWords.insert(answer, at: 0)
                    
                    // موقعیتش در جدول: اون بالا قرار بگیره
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    errorTitle = "کلمه شناسایی نشد"
                    errorMassage = "یک بار دیگه تلاش کن"
                }
            } else {
                errorTitle = "کلمه قبلا استفاده شده"
                errorMassage = "یک کلمه جدید بگو"
            }
        } else {
            errorTitle = "کلمه وارد شده از حروف کلمه اصلی نیست"
            errorMassage = "سعی کن با حروف کلمه اصلی یه کلمه جدید بسازی، کلمه اصلی: \(title!.lowercased())"
        }
        let ac = UIAlertController(title: errorTitle, message: errorMassage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "باشه", style: .default))
        present(ac, animated: true )
    }
    
    // بررسی یانکه ایا حروف کلمه وارد شده در حروف کلمه اصلی هست یا نه
    func isPossible (word:String) -> Bool {
        // آیا یک رشته داخل یک رشته دیگری وجود دارد یا نه
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
                
            } else {
                return false
            }
        }
        return true
    }
    
    // غیر تکراری
    func isOrgiall (word: String) -> Bool {
        // خلاف آن چیزی که قبلا استفاده شده
        // کد استفاده شد: useWords.contains(word)
        return !useWords.contains(word)
    }
    
    // آیا آن کلمه واقعا انگلیسی است؟
    func isReal (word: String) -> Bool {
        let cheker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        // چک کردن غلط املایی
        let misspelledRange = cheker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }

}

