# FreeFinder Milestone 4B

## (1) What we did in this iteration
The work was be divided as follows: 
1. Connect UI to existing backend successfully - Ellen/Ruxi
- Sign in
- Sign out
- Delete Item
2. Filtering by category  
- API -> Sydney/Jordan
- UI -> Ellen/Ruxi
3. Filtering by distance 
- API -> William/Charlie
- UI -> Ellen/Ruxi
4. Decrementing of quantity
- API -> Sydney/Jordan
- Database -> Steven/Madhav
- UI -> Ellen/Ruxi
5. Styling of UI/UX elements -> Ellen/Ruxi
6. Accessing/Utilizing User Location -> William/Charlie
7. App Icon
- Design + implementation -> Ellen

We completed most of what was initially proposed with the exception of the following features:
1. Notifications
2. Photos
3. User's own postings page
4. Editing of profile settings (note this is no longer neccessary due to the removal of notifications)
5. Item reservation

## (2) Compiling and Running Unit Tests
Our unit testing can be found in the FreeFinder4BTests and FreeFinder4BUITests folders. See the following instructions to compile and run them. 

### How to compile
You will need XCode in order to compile our code. Once you've cloned the repo, open it up in XCode. If anything pod related shows up in the folder, delete it. 
If you experience troubles/errors with the packages, try quitting XCode and reopening it. You might also need to redownload the package dependencies for Realm. To do this go to File then Add packages... in the menu bar and copy and paste this (https://github.com/realm/realm-swift.git
) into the search bar. Press add packages and add both. If you are still having issues, under file go to packages and click reset package caches.

### How to run the code
Press run in XCode (the play button on the top left). Alternatively, do command R or go to product then run in the menu bar. Make sure the scheme is set to FreeFinders3B. We tested outs on iPhone 14 Pro simulator running iOS 16.1. Have patience, depending on the device (and if you are running a simulator) there might be some lag. We've also run into issues with the M1 chip on mac and xcode. In this case, you cannot run a simulator and need to build on a physical device. To do this connect your phone (if it is an iphone) to your computer and build on it. 
### How to run the unit test cases
Run command U (alternatively go to Product in the menu bar and then press test). If you run into issues where you are gettng a No module found Realm error (or something of that nature), click the FreeFinders3B main project file (top left) then under targets click FreeFinder3BTests then click Build Phases. Go to link binary with libraries and click the + button and then add RealmSwift and Realm. If you don't have those packages to add, follow the add package dependencies step outline above. 

### UI Unit Testing
FreeFinder4BUITests contains our UI unit tests
In addition to the coded tests, here are some more UI tests to be tested manualy when the device is built.
- Pressing create item button should take user to create item page. 
- Pressing delete item should cause a pop up to appear checking if the user is sure they want to delete the item, pressing confirm will delete the item and the user will be returned to their previous screen while pressing cancel will return the user back to the view item screen. 
- On the map, the user should be aple to click on an item and press the info button to be taken to the view item screen. 
- User should be able to move the map around (as one would on google maps or apple maps)
- Clicking the fliter button on the top left should allow the user to chose how to filter the items which will be reflected in the users view. 
- If the user is already signed in, upon opening the app they should have a screen saying welcome back. Upon pressing start they should be taken to the map view. 
- One the bottom of the screen, the user should be able to toggle between different views: map, list and profile. 

## (3) Code Directory Structure
Within the FreeFinder4B directory, you will find a FreeFinder4B that contains all of our code building the app, with subfolders as follows.
- App contains all the project entry points and main files. 
- Classes contains the app schema and all of our class definitions
- Context contains general global data (ie constants) and things relevant to the state of the app. 
- Controllers contains all view controllers.
- Storyboards contains all storyboards for the UI. 
- Utilities contains any miscellaneous function definitions that do not belong in the classes. 

For the unit tests, we have two main folders: FreeFinder4BTests and FreeFinder4BUITests. 

FreeFinder4BTests contains the following files:
- AppDataTests.swift: tests filtering by type
- FreeFinders4B.swift: tests user and item related functions as well as filtering by distance from user
- LocalDeviceTests.swift: tests local user related functions
- MongoDBTests.swift: tests database functions

## (4) Acceptance Tests
Try signing in (assuming you are not already signed in). Try creating an item. Try deleting an item (you have to be physically close to the item to delete it). Try decrementing the quantity of an item (you have to be physically close to the item to decrement the quantity). If there is an item whose location is far from you, try deleting the item and an error message should pop up. If the quantity of an item is one and you decrement it, the item will be deleted (as the quantity will be zero). If items have been created, try filtering by type and by distance. Try commenting on an item. Try signing out. Try creating items with invalid fields (for example no title). This should cause a pop up with an error message. Try clicking on an item on the map, this should lead you to the item page. 
