# FreeFinder Milestone 4A

## (1) Brief Description about what you plan to do and not do in the second iteration. 
For our second iteration, we will be focusing on the following additional things. First note since we were unable to successfully connect our frontend to the backend during iteration one, we will focus on ensuring all UI interactions from the first iteration are functional. Now for the second iteration we will be adding a filtering option for both the map and list view. Users can filter items by each individual type (at the moment we will not allow filtering by multiple type options) or by a given distance radius. We will also now let users decrement the quantity field of items and have items automatically deleted once their quantity reaches zero. We hope to also be able to access and utilize each user's device location. Finally, we will be creating an app icon and stylize our interface. 

We have chosen to omit the following features:
- Notifications
- Photos 
- User's own postings page
- Editing of profile settings (note this is no longer neccessary due to the removal of notifications)
- Item reservation


## (2) A brief description of how the work will be divided among all pairs of people in your team. 
The work will be divided as follows: 
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

## (3) Unit Test Cases
Our unit testing can be found in the FreeFinder4BTests and FreeFinder4BUITests folders. See the following instructions to compile and run them. 

### How to compile
You will need XCode in order to compile our code. Once you've cloned the repo, open it up in XCode. If anything pod related shows up in the folder, delete it. 
If you experience troubles/errors with the packages, try quitting XCode and reopening it. You might also need to redownload the package dependencies for Realm. To do this go to File then Add packages... in the menu bar and copy and paste this (https://github.com/realm/realm-swift.git
) into the search bar. Press add packages and add both. 
### How to run the code
Press run in XCode (the play button on the top left). Alternatively, do command R or go to product then run in the menu bar. Make sure the scheme is set to FreeFinders3B. We tested outs on iPhone 14 Pro simulator running iOS 16.1. Have patience, depending on the device (and if you are running a simulator) there might be some lag. We've also run into issues with the M1 chip on mac and xcode. In this case, you cannot run a simulator and need to build on a physical device. To do this connect your phone (if it is an iphone) to your computer and build on it. 
### How to run the unit test cases
Run command U (alternatively go to Product in the menu bar and then press test). If you run into issues where you are gettng a No module found Realm error (or something of that nature), click the FreeFinders3B main project file (top left) then under targets click FreeFinder3BTests then click Build Phases. Go to link binary with libraries and click the + button and then add RealmSwift and Realm. If you don't have those packages to add, follow the add package dependencies step outline above. 

## (4) Code Directory Structure
TODO: STEVEN
