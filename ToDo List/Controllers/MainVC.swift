//
//  MainVC.swift
//  ToDo List
//
//  Created by nassermac on 6/23/23.
//  Copyright © 2023 Nasser Co. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase



class MainVC: UIViewController {
// MARK: - Proprites.
 var ref = Database.database(url: URLs.fireBase).reference()
 var arrOfNotes = [Notes]()
// MARK: - Outlets.
@IBOutlet weak var listTableView: UITableView!
// MARK: - LifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        removeLineFromTableView()
        setUpTableView()
        setNavigationbar()
        setRoot()
        fetchAllNotes()
    }

    override func viewWillAppear(_ animated: Bool) {
      self.navigationController?.navigationBar.isHidden = false

    }

// MARK: - private methods.
    
    private func removeLineFromTableView(){
        listTableView.tableFooterView = UIView()
        listTableView.separatorStyle = .none
    }
    private func setUpTableView(){
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UINib(nibName: "MediaCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

}
// MARK: - UITableViewDelegate,UITableViewDataSource.
extension MainVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfNotes.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MediaCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MediaCell else{
            return UITableViewCell()
        }
        cell.noteNameLabel.text = arrOfNotes[indexPath.row].content
        cell.noteDatelabel.text = arrOfNotes[indexPath.row].date
        cell.backgroundColor = UIColor.clear
        cell.onDelete = { [weak self] in
            guard let note = self?.arrOfNotes[indexPath.row] else {
                return
            }
            let alert = UIAlertController(title: "Sorry", message: "Are You Sure You Want To Delete This TODO ?", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Yes", style: .destructive) { (action) in
                    self?.deleteNoteFromFirebase(note: note) { success in
                    if success {
                        if let index = self?.arrOfNotes.firstIndex(of: note) {
                            self?.arrOfNotes.remove(at: index)
                            self?.listTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                        }
                    } else {
                        self?.showAlert(msg: "Error deleting note!")
                    }
                }
            }
            let action2 = UIAlertAction(title: "No", style: .default, handler: nil)
            alert.addAction(action2)
            alert.addAction(action1)
            self?.present(alert, animated: true, completion: nil)
        }
        return cell
    }

 private func setNavigationTitle() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("Users").child(userID!).child("username").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            if let username = snapshot.value as? String {
                  self.navigationItem.title = username
                print("user name is \(username)")
            } else {
                print("username not found in snapshot")
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    

    private func fetchAllNotes() {
        let activity = activtyIndicator.showActivtyIndicator(view: self.view)
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        let notesRef = ref.child(Node.users).child(userID).child(Node.notes)
        notesRef.observe(.value) { [weak self] snapshot in
            guard let self = self else { return } // Check if self is not nil
            self.arrOfNotes.removeAll() // Clear previous data
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let noteData = childSnapshot.value as? [String: Any],
                    let date = noteData["date"] as? String,
                    let content = noteData["content"] as? String {
                    let note = Notes(noteId: snapshot.key, date: date, content: content)
                    print(note)
                    self.arrOfNotes.append(note)
                }
            }
            self.listTableView.reloadData()
            activtyIndicator.stopActivtyIndicator(activty: activity)
        }
    }
 // Just Fot Test
/*    func deleteNoteFromFirebase(note: Notes, completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        let notesRef = ref.child(Node.users).child(userID).child(Node.notes)
        notesRef.removeValue { error, _ in
            if let error = error {
                print("Error deleting note: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
                print(note.date)
            }
        }
  } */
    func deleteNoteFromFirebase(note: Notes, completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        let notesRef = ref.child(Node.users).child(userID).child(Node.notes)
        notesRef.queryOrdered(byChild: "content").queryEqual(toValue: note.content).observeSingleEvent(of: .value) { snapshot in
            guard let noteToDelete = snapshot.children.allObjects.first as? DataSnapshot else {
                print("Note not found")
                completion(false)
                return
            }
            
            noteToDelete.ref.removeValue { error, _ in
                if let error = error {
                    print("Error deleting note: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                    print(note.date)
                }
            }
        }
    }
    
    private func setNavigationbar(){
        setNavigationTitle()
        navigationController?.navigationBar.barTintColor = UIColor.purple
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white]
        setBarButtons()

    }
    private func setBarButtons(){
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(named: "backArrow"),style:.plain, target: self, action: #selector(backBtn))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtn))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white

    }
    private func setRoot(){
        let def = UserDefaults.standard
        def.setValue(true, forKey: UserDefaultsKeys.token)
    }
    
    @objc func backBtn(){
        let mainStory = UIStoryboard(name: StoryBoards.main, bundle: nil)
        let signIn: SignInVC = mainStory.instantiateViewController(withIdentifier: Views.signIn) as! SignInVC
        self.navigationController?.pushViewController(signIn, animated: true)
    }
    @objc func addBtn(){
   let mainStory = UIStoryboard(name: StoryBoards.main, bundle: nil)
   let popupContentVC = mainStory.instantiateViewController(withIdentifier: Views.popup) as! PopUpVC
       popupContentVC.view.backgroundColor = .clear
       popupContentVC.dateAndTimeTextField.placeholder = "DateAndTime"
        popupContentVC.providesPresentationContextTransitionStyle = true
        popupContentVC.definesPresentationContext = true
        popupContentVC.modalPresentationStyle = .overCurrentContext
        popupContentVC.modalTransitionStyle = .crossDissolve
        self.present(popupContentVC, animated: true, completion: nil)
        
    }
    
    
}
