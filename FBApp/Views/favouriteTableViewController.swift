
//
//  favouriteTableViewController.swift
//  
//
//  Created by Administrator on 5/29/18.
//

import UIKit
import Firebase
class favouriteTableViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    var pictureList = ["empty list"]
    var favouriteList: [String] = []
    var PassedfavouriteReceipe = ""
    var repeatedReceipe:Bool = false
    var favouriteButtonPress: Bool = false
    var favouriteAlertPress: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("the result of favourite Button is   " + String(favouriteButtonPress))
        tableView.delegate = self
        tableView.dataSource = self
        //writeFavouriteListToFirebaseForThisUser()
        loadFavouriteListFromFirebaseForThisUser()
        
    }
    @IBOutlet weak var tableView: UITableView!
    //set up table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictureList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell") as! favoriteTableViewCell
        
        cell.favLabel.text = pictureList[indexPath.row]
        
        cell.favLabel.numberOfLines = 4;
        
        cell.favImage.image = UIImage(named: pictureList[indexPath.row])
        return cell
    }
    
    
    func writeFavouriteListToFirebaseForThisUser(){
        let favouriteListDB = Database.database().reference().child("users").child("MH48tjT3KZgulzvrKgBpKj3Qwy22").child("favourites")
        favouriteListDB.setValue(pictureList)
        
        
    }
    func loadFavouriteListFromFirebaseForThisUser(){
        let shoppingListDB = Database.database().reference().child("users").child("MH48tjT3KZgulzvrKgBpKj3Qwy22").child("favourites")
        shoppingListDB.observeSingleEvent(of:.value){(snapshot) in
            let snapshotValue = snapshot.value as? Array<String> ?? self.favouriteList
            self.favouriteList = snapshotValue
            //print("load from firebase \(self.favouriteList) ")
            for singleItem in self.favouriteList{
                if(singleItem == self.PassedfavouriteReceipe){
                    self.repeatedReceipe = true
                }
            }
            print("repeatedReceipe  \(self.repeatedReceipe)  PassedfavouriteReceipe  \(self.PassedfavouriteReceipe) favouritebuttonpressed  \(self.favouriteButtonPress)  favourite alert result  \(self.favouriteAlertPress)")
//            if self.repeatedReceipe == false && self.PassedfavouriteReceipe != "" && self.favouriteButtonPress == false{
//                self.updateFireBaseAndLocalList()
//            }
            if self.favouriteAlertPress == true && self.repeatedReceipe == false{
                self.updateFireBaseAndLocalList()
            }
            
            self.pictureList = self.favouriteList
            self.tableView.reloadData()
            
            
        }
    }
    func updateFireBaseAndLocalList(){
        print("this is triggered")
        addFavouriteListToFireBaseFavouriteList()
        pictureList = self.favouriteList
        writeFavouriteListToFirebaseForThisUser()
    }
    
    
    func addFavouriteListToFireBaseFavouriteList(){
        
            favouriteList.append(PassedfavouriteReceipe)
        
        //print("after append what is in the firebase \(self.favouriteList) ")
        
    }
    
    // pass data at select index
    var selectedIndex: Int = 0
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetailsFav", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? tableDetailViewController{
            destination.receipeNamePassed = pictureList[selectedIndex]
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            pictureList.remove(at: indexPath.row)
            writeFavouriteListToFirebaseForThisUser()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    

}
