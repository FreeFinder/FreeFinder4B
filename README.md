# FreeFinder Milestone 3B

### (1) How to compile
You will need XCode in order to compile our code. Once you've cloned the repo, open it up in XCode. If anything pod related shows up in the folder, delete it. 
If you experience troubles/errors with the packages, try quitting XCode and reopening it. You might also need to redownload the package dependencies for Realm. To do this go to File then Add packages... in the menu bar and copy and paste this (https://github.com/realm/realm-swift.git
) into the search bar. Press add packages and add both. 
### (2) How to run the code
Press run in XCode (the play button on the top left). Alternatively, do command R or go to product then run in the menu bar. Make sure the scheme is set to FreeFinders3B. We tested outs on iPhone 14 Pro simulator running iOS 16.1. Have patience, depending on the device (and if you are running a simulator) there might be some lag. We've also run into issues with the M1 chip on mac and xcode. In this case, you cannot run a simulator and need to build on a physical device. To do this connect your phone (if it is an iphone) to your computer and build on it. 
### (3) How to run the unit test cases
Run command U (alternatively go to Product in the menu bar and then press test). If you run into issues where you are gettng a No module found Realm error (or something of that nature), click the FreeFinders3B main project file (top left) then under targets click FreeFinder3BTests then click Build Phases. Go to link binary with libraries and click the + button and then add RealmSwift and Realm. If you don't have those packages to add, follow the add package dependencies step outline above. 
### (4) Some acceptance tests to try 
We suggest playing around with the different views, as you have the option to find the same items through the map or the list. You can also add your own item and see it appear on the map! Once you add an item, you can comment any thoughts about it on that item's page. Once you add your comment, it will continue to appear any time the item is opened, until you delete it. Once an item is deleted, it is no longer accessible from either view. 

### (5) Text description of what is implemented. You can refer to the use cases and user stories in your design document.
We've implemented the following use cases:
* Create item
* Delete item
* Comment on post
* Refresh map
* Sign in (we've implemented the function for this but have not connected the UI yet, this will come in iteration 2)
* View map/list
* View posting

Along with this we've implemented our database using MongoDB. Many of these use cases interact with the database. At this point in time, nothing can be edited. Comments cannot be edited or deleted either. Note: we are allowing two items to have the same name. The indexing in the database is not based off of the name so this should not pose any issues for the code.  
### (6) Who did what: who paired with who, which part is implemented by which pair
Main pairs:
* Charlie and William - Sign In and MapKit
* Jordan and Sydney - add comment, create item and delete item and testing update
* Ellen and Ruxi - UI/UX (with help from Jordan) 
* Steven and Madhav - Backend/Database (this has a lot of overlap with the functionality implemented by the other teams as we isolated the database calls) 

However, towards the end it became more of a group effort in finishing up the app. 
### (7) Changes: design changes or unit test changes from earlier milestones
We are not implementing the ability to upload a photo in this iteration. For this iteration, we've made the counter fixed at one. Incrementing this and chainging it will come in the later iteration. For the classes, in general, for every function that requires database access we have a new function that is db_function that just handles the database side. In addition, we added comment and create_item to the user class. Comment and sign_out now return boolean and create_item (under user) returns the Item if it is successfully added. We were not able to get google sign in to work (we ran into a ton of errors related to this) so we've implemented a simpler sign in feature where the user just enters an email which must be a @uchicago.edu email. We also added a AppData class that contains the data for the app namely the list of items and the user. It also has functions to get all the items from the database, refresh the items list, and fetch user from the database. For the testing, most of the test cases are the same but since we changed databases, the implementation of the testing has changed. 

Iteration 2 will (hopefully) include the following features:
* Notifications (and preferences)
* Filtering
* UI/UX Improvements
* Sign out
* Sign in UI connection 
* Counter/quantity functionality
* Adding photos (?) -- we are unsure if we can get the capability to store images somewhere, so this feature might be dropped
### (8) Other information 
