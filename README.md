# Tasker
An iOS (Swift 4) Task-list App

(Purpose of this App is to explore Cloud FireStore Realtime Database and learn different iOS features/cocoapods)

## Detail
- A Task-list App with Cloud FireStore Realtime Database as its backend
- Two different views for Tasks-List (UITableView) and Task-Category (UICollectionView)
- Adding new Tasks or Category implemented via UIAlertController
- The Task-Category UICollectionView has a Pinterest style custom Two-Column Layout with different cells sizes 
- The Task-Category UICollectionView also has a custom UIRefreshControl, whose view is implemented in a xib/nib
- The Tasks-List UITableView has an animation on the table cells - which spring up the cells anytime the tableview appears
- Tasks-List tableview cells are also swipeable (to delete tasks) - implemented via SwipeCellKit
- Tasks-list View Controller contains a searchbar 
- Chameleon Framework is used to assign different colors to UICollectionView cells and UITableView cells
- Tasks-List cells derive their color from their parent Category cell's color
- As more tasks are added to a category, the cells are assigned a gradient of their parent Category cell's color
- Also explored using CoreData Framework while developing this app



## Technology
- Swift 4
- Cloud Firestore (Realtime Database)

## Frameworks / Cocoapods
- SwipeCellKit
- ChameleonFramework
- Firebase/Core
- Firebase/Firestore
- CoreData

## Screenshots
