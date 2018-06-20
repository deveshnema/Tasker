# Tasker
An iOS (Swift 4) Task-list App

(Purpose of this App is to explore Cloud FireStore Realtime Database and learn different iOS features/cocoapods)

## Detail
- A Task-list App with Cloud FireStore Realtime Database as its backend
- Two different views for Tasks-List (UITableView) and Task-Category (UICollectionView)
- Adding new Tasks or Category implemented via UIAlertController
- The Task-Category UICollectionView has a Pinterest style custom Two-Column Layout with varying cells sizes 
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
Pinterest style two column layout with varying cell sizes 
![categories_iphonexspacegrey_portrait](https://user-images.githubusercontent.com/38988531/41646172-f5714924-7427-11e8-8eb6-fa9f9a0a147b.png)
Add category
![add_category_iphonexspacegrey_portrait](https://user-images.githubusercontent.com/38988531/41646169-f52adef8-7427-11e8-9a26-ab3c281be1c8.png)
Custom pull-to-refresh
![custom_refresh_iphonexspacegrey_portrait](https://user-images.githubusercontent.com/38988531/41646174-f5944da2-7427-11e8-82fc-557e6eed6d93.png)
Tasks-list
![tasks_iphonexspacegrey_portrait](https://user-images.githubusercontent.com/38988531/41646176-f5d21894-7427-11e8-84a7-84bf4fdafa5d.png)
Add task
![add_task_iphonexspacegrey_portrait](https://user-images.githubusercontent.com/38988531/41646171-f54e1fbc-7427-11e8-9355-5f7f731254fb.png)
Swipe to delete
![swipe_iphonexspacegrey_portrait](https://user-images.githubusercontent.com/38988531/41646175-f5b2cd68-7427-11e8-892a-02609939209a.png)
