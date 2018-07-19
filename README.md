# Dracker
[![Swift Version][swift-image]][swift-url]
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](https://www.apple.com/ios/ios-11/)

An iOS app to track/manage debt. This app allows users to create transactions, add descriptions, tag images, tag notes, and manage them. It features a rich and immersive user experience with 3D touch, quick actions, Actionable User Notifications, and Touch ID/Passcode capability for secure authentication.

![](logo.png)

## UI

#### Login/Register
<img src="img/login.png" width="180" height="310">&nbsp;&nbsp;&nbsp;&nbsp;<img src="img/register.png" width="180" height="310">


#### Dashboard
<img src="img/home.png" width="180" height="310">&nbsp;&nbsp;&nbsp;&nbsp;<img src="img/wallet.png" width="180" height="310">&nbsp;&nbsp;&nbsp;&nbsp;<img src="img/profile.png" width="180" height="310">&nbsp;&nbsp;&nbsp;&nbsp;<img src="img/settings.png" width="180" height="310">

#### Existing Transactions
<img src="img/details.png" width="180" height="310">&nbsp;&nbsp;&nbsp;&nbsp;<img src="img/add_note.png" width="180" height="310">

#### New Transactions
<img src="img/add_transaction.png" width="180" height="310">&nbsp;&nbsp;&nbsp;&nbsp;<img src="img/qr_code.png" width="180" height="310">

#### Summary
<img src="img/friends.png" width="180" height="310">&nbsp;&nbsp;&nbsp;&nbsp;<img src="img/friends_detail.png" width="180" height="310">

#### Profile
<img src="img/change_password.png" width="180" height="310">&nbsp;&nbsp;&nbsp;&nbsp;<img src="img/change_email.png" width="180" height="310">

#### Settings
<img src="img/change_passcode.png" width="180" height="310">&nbsp;&nbsp;&nbsp;&nbsp;<img src="img/set_passcode.png" width="180" height="310">&nbsp;&nbsp;&nbsp;&nbsp;<img src="img/set_frequency.png" width="180" height="310">

#### Security
<img src="img/authentication.png" width="180" height="310">&nbsp;&nbsp;&nbsp;&nbsp;<img src="img/passcode.png" width="180" height="310">

#### Miscellaneous
<img src="img/quick_actions.png" width="180" height="310">&nbsp;&nbsp;&nbsp;&nbsp;<img src="img/notifications.png" width="180" height="310">&nbsp;&nbsp;&nbsp;&nbsp;<img src="img/no_internet.png" width="180" height="310">



## Features

### Current
- [x] Adding transactions with other people via phone number.
- [x] Registeration of new users/ Login functionality.
- [x] Authentication via Firebase
- [x] Unique QR Code and adding transaction using QR Code.
- [x] Access to data anywhere via AWS.
- [x] Text messages when payments are completed.
- [x] Taggable transactions. An image (such as a bill) can be tagged with the transaction.
- [x] Saving tagged images to camera roll.
- [x] Enabling/disabling user notifications.
- [x] Actionable notifications (ability to silence a particular payment reminder).
- [x] User ratings based on transaction history.
- [x] Enabling/disabling touch ID.
- [x] 3D touch compatibility for Quick Actions.
- [x] 3D touch for Dashbard table cells.

### Upcoming
- \[ ] Support for actually moving around money.

## Requirements

- iOS 10.0+
- Xcode 9.3
- Swift 4.1

## Architecture
![](architecture.png)

- DynamoDB is used to store all the data for user transactions and other details
- S3 is used to store profile images and tagged images with transactions.
- Twillo is used to send messages for payment completion.
- Firebase is used for Authentication.
- SendGrid for emails.

## Libraries/Modules Used
- AWS (data storage)
- Twillo (payment completion notification)
- Firebase (Login/Authentication)
- DZNEmptyDataSet (For nice empty table look)
- Alamofire (API calls (to Twillo))
- SendGrid (for emailing note attached to a transaction)


## Meta

Raghav Bhasin – [@bhasin97](https://github.com/raghavbhasin97) – raghavbhasin97@gmail.com


[swift-image]:https://img.shields.io/badge/swift-4.0-orange.svg
[swift-url]: https://swift.org/


