# Market
After launching app,User should be logged in by username and password then the app shows user a list of products and user can get more detail about each item by selecting item. 


# Demo Account
**User:**
 - Email: user@choco.com 
 - Password: chocorian


# Requirement
- XCode 12.5
- macOS Big Sur

# Installation
- To run the project :
- Git clone from *https://github.com/choco-hire/Mozhgan-iOS.git*
- Open `Choco.xcodeproj`
- Let SPM dependencies downloading has been finished
- Press Run Button

# Language used 
- Swift 5.4

# App Version
- 1.0.0 
# Design Pattern Used

## Clean Swift VIP
Clean Swift (a.k.a VIP) is Uncle Bob’s Clean Architecture applied to iOS and Mac projects. The Clean Swift Architecture is not a framework. It is a set of Xcode templates to generate the Clean Architecture components for you. That means you have the freedom to modify the templates to suit your needs.
- View Controller
  - The viewController has two main roles, one being as an entry point for any actions of the current scene, the other being to display the formatted information contained in the viewmodel back to the user
- Interactor
  - The role of the interactor is mainly the computation part of a scene. This is where you would fetch data (network or local), detect errors, make calculations, compute entries.
- Presenter
  - The presenter has a very precise role. Its main focus is to create a representation of parts of the data to be displayed on screen at a specific moment in time. This data representation is contained in an element called the viewmodel. Once it has formatted the raw data the presenter sends it back to the controller to be displayed.
- Worker
  - The worker is a secondary element in the clean swift schema. Its main role has to do with the heavy lifting and unburdening of the interactor from things like network api calls, database requests and so on.
- Models
  - This component encapsulates the request, response and viewmodel representation for each flow of action of the scene.
- Router
  - This element is linked to the controller. It takes care of the transition between scenes 

![Vip](https://www.netguru.com/hs-fs/hubfs/894db5a4-4fdf-4928-b887-07836f7ec843.jpeg?width=1604&name=894db5a4-4fdf-4928-b887-07836f7ec843.jpeg)

# Features

## Login View
- Shows a screen with Email and Password inputs
-  
## List View
- Shows a list of product with product's photo and item description.
- If Network is available it fetches products from API only,and if there is a problem on network or connection it shows products fetched from local repository  
  if available.

## Detail View
- Used new screen to show  product detail

## Data Caching
- Realm is used for data caching. Items fetched from server are displayed to UI and also saves/updates on database.
- Keychain is used for saving and retrieving Access Token

## Pull to Refresh
- If network available - fetches data from starting index from server, if data is available then it is displayed new data to UI and then save/update it into database.
- If network not available - Error alert shows "No internet connection".


# Assumptions        
 1. The app is designed for iPhones and iPad.        
 2. App currently supports English.
 3. Mobile and iPad platform supported: iOS (13.x,14.x, 15.x)        
 4. Device support : iPhone , iPad  
 5. Data caching is available.



# Frameworks/Libraries used
- Moya
- SnapKit
- Kingfisher
- RealmSwift


# Unit Test
- Login
- List
- Detail



