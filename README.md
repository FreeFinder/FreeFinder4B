# FreeFinder Milestone 5

## Installation
First clone and download our repository to your local machine. You will need Xcode in order to run our program. If you don't have Xcode downloaded on your computer, you can use the CSIL computers. 

Once you've cloned the repo, open it up in Xcode. If anything pod related shows up in the folder, delete it. 
If when trying to build, you experience troubles/errors with the packages, try quitting XCode and reopening it. You might also need to redownload the package dependencies for Realm. To do this go to File then Add packages... in the menu bar and copy and paste this (https://github.com/realm/realm-swift.git
) into the search bar. Press add packages and add both. If you are still having issues, under file go to packages and click reset package caches (wait until Xcode finishes restting the package caches) and try building again. If you are still getting error, under file fo back to packages and then press resolve package versions. 

To run the code, press run in Xcode (the play button on the top left). Alternatively, do command R or go to product then run in the menu bar. Make sure the scheme is set to FreeFinders3B. We tested ours on iPhone 14 Pro simulator running iOS 16.1. Have patience, depending on the device (and if you are running a simulator) there might be some lag. We've also run into issues with the M1 chip on mac and xcode. In this case, you cannot run a simulator and need to build on a physical device. To do this connect your phone (if it is an iphone) to your computer and build on it. You might need to allow developer settings in the settings on your phone (https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device). 

## Functionality
Our app aims to address the issue of waste, by allowing users to post and find free things. Users can create an account and sign into our app. Then they are able to view listings of free items across the following categories: food, clothing, furniture and misc. They can view items both on a map view as well as a list view and are able to toggle between the two views. After clicking on an item, they are brought to the item listing page where they are able to see the information on the item. They can comment on the item from this page as well as decrement the quantity of an item if they have gone to take one. They can also delete an item. If there is only one item left and the decrement the quantity, the item will be deleted (as there are no more left). Both decrementing and deleting an item require the user to be somewhat close to the location of the item (which is defined to be within 0.01 degrees in longitude and latitude). Users can also create items, indicating the title, quantity, type and description of an item. The location for the new item is set to be the users current location. Finally, users can also sign out of the app which brings them back to the initial sign in screen. 

## How to Use
### Create Account
Upon opening the app, you will be brought to the sign in screen. If you do not already have an account, you can click on sign up to create an account. 

<img width="150" alt="Screen Shot 2022-12-02 at 6 19 52 PM" src="https://user-images.githubusercontent.com/68660398/205412584-e571f36f-8722-4bd3-a1db-a6dcdb70adaa.png">

You will be brought to the create account page where you need to input a uchicago email and click sign up.

<img width="150" alt="Screen Shot 2022-12-02 at 6 23 39 PM" src="https://user-images.githubusercontent.com/68660398/205412627-71962745-ef81-43ce-9dcd-b4a3987a1048.png">

### Sign In
If you already have an account, to sign in from the sign in page, simply enter your email and press sign in. 

### Create Item
To create an item, from either the map or list view, press the blue plus sign in the top right corner. 

<img width="150" alt="Screen Shot 2022-12-02 at 6 28 35 PM" src="https://user-images.githubusercontent.com/68660398/205412848-b42e9071-0479-49c7-b1da-feec078e5024.png">
<img width="150" alt="Screen Shot 2022-12-02 at 6 27 15 PM" src="https://user-images.githubusercontent.com/68660398/205412850-7f656cf0-f978-4045-b1aa-95b1db77c24a.png">

This will bring you to the create item page, where you need to input a title, description, type and quantity for the item you want to post. The location for the item will be your current location. 

<img width="150" alt="Screen Shot 2022-12-02 at 6 30 51 PM" src="https://user-images.githubusercontent.com/68660398/205412980-af2f48a6-1803-495f-964b-a6bf079eebd2.png">

### Toggle Between Views
To toggle between views, select the view you want on the bottom row. 

<img width="150" alt="Screen Shot 2022-12-02 at 6 31 58 PM" src="https://user-images.githubusercontent.com/68660398/205413071-90e6bf2b-9530-4a43-b969-d74dfef0e2ed.png">

### View Item on Map 
To view an item in map view, make sure the leftmost view is selected on the bottom row (see above). You will be able to see a map, which you can navigate as you would apple or google maps (this might be harder if you are building on a simulator). If you are in the vicinity of active listings, these will apear on the map. You can click on one and if you press info, this will take you to the item's page. 

<img width="150" alt="Screen Shot 2022-12-02 at 6 39 22 PM" src="https://user-images.githubusercontent.com/68660398/205413536-9562aed4-47ba-4a80-baf3-4ae113637bfb.png">

### View Item on List
To view an item in list view, make sure the middle view is selected on the bottom row (see above). You will see a list of all the items, which you can scroll through. If you click on one of the items, this will take you to the item's page. 

### Comment on Item
If you are on an item's page, you will be able to comment on the item. Press the comment button and you will be prompted to enter your comment. 

<img width="150" alt="Screen Shot 2022-12-02 at 6 41 19 PM" src="https://user-images.githubusercontent.com/68660398/205413635-30806d55-85f5-436c-a618-9fa0d34df1a7.png">

### Decrement Quantity of an Item
To decrement the quantity of item, you must be semi-near the item you want to decrement. This is defined to be within .01 degrees longitude/latitude. If you are within this distance, from the item's page, press the "Take One" button. If you take the last one (so the quantity is set to 1) the item will be deleted. 

<img width="150" alt="Screen Shot 2022-12-02 at 6 42 44 PM" src="https://user-images.githubusercontent.com/68660398/205413698-ef3b2995-69bc-448a-b55b-45422beb3507.png">

### Delete Item 
To delete an item, you must be semi-near the item you want to decrement. This is defined to be within .01 degrees longitude/latitude. If you are within this distance, from the item's page, press the delete post button. There will be a pop up confirming that you want to delete the item. 

<img width="150" alt="Screen Shot 2022-12-02 at 6 46 48 PM" src="https://user-images.githubusercontent.com/68660398/205413954-01c3ca40-b1bc-46e0-be6b-f9a52d527488.png">

### Filtering
To filter by type, on either the map or list views, press the filter button on the top left.

<img width="150" alt="Screen Shot 2022-12-02 at 6 50 25 PM" src="https://user-images.githubusercontent.com/68660398/205414145-74b688c6-ab53-4479-a7fc-917ea8856269.png">
<img width="150" alt="Screen Shot 2022-12-02 at 6 49 46 PM" src="https://user-images.githubusercontent.com/68660398/205414149-3cb95ed7-e3de-4b3b-aaa6-5e00749e619d.png">

This will trigger a drop down menu with the various filter options. Select what you want to filter by. Note that only one filter can be applied at a time.

<img width="150" alt="Screen Shot 2022-12-02 at 6 52 15 PM" src="https://user-images.githubusercontent.com/68660398/205414245-f2fb26ee-bf51-49d8-8426-4887001d37a5.png">

### Sign Out
To sign out, make sure you are in the right most view. Then click sign out.

<img width="150" alt="Screen Shot 2022-12-02 at 6 53 59 PM" src="https://user-images.githubusercontent.com/68660398/205414324-fb6997e0-e7f6-49a1-909c-3befb6b9b133.png">

This will bring you back to the start screen.

### Inputs that are not allowed for the various use cases (error messages should pop up if these are inputted):
- Empty strings for create item and comment fields
- comments that are longer than 200 characters
- quantity <= 0 
- description length >= 280 characters
- name length >= 100 characters
- deleting or decrementing an item from a location greater than 0.01 degrees (in longitude and latitude) away from an item
- emails that are not @uchicago.edu emails

## Code Directory Structure
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
