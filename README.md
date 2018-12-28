# Dracker
[![Swift Version][swift-image]][swift-url]
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](https://www.apple.com/ios/ios-11/)
[![Build Status](https://travis-ci.org/dwyl/esta.svg?branch=master)](https://travis-ci.org/dwyl/esta)

An iOS and React app to send/receive money and manage debt. This app allows users to create transactions, add descriptions, tag images, tag notes, and manage them. It features a rich and immersive user experience with 3D touch, quick actions, Actionable User Notifications, and Touch ID/Passcode capability for secure authentication.

![](img/logo.png)

## UI

### iOS

#### Login/Register
<kbd><img src="img/ios/login.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/register.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/register2.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/register3.png" width="180" height="310"></kbd>


#### Dashboard
<kbd><img src="img/ios/home.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/wallet.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/profile.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/settings.png" width="180" height="310"></kbd>

#### Existing Transactions
<kbd><img src="img/ios/details.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/add_note.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/transaction_details_peek.png" width="180" height="310"></kbd>

#### New Transactions
<kbd><img src="img/ios/add_transaction.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/qr_code.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/tag_image.png" width="180" height="310"></kbd>

#### Summary
<kbd><img src="img/ios/friends.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/friends_detail.png" width="180" height="310"></kbd>

#### Profile
<kbd><img src="img/ios/change_password.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/change_email.png" width="180" height="310"></kbd>

#### Settings
<kbd><img src="img/ios/change_passcode.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/set_passcode.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/set_frequency.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/bank_account.png" width="180" height="310" style="border: 1px solid black;"></kbd>

#### Security
<kbd><img src="img/ios/authentication.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/passcode.png" width="180" height="310"></kbd>

#### Miscellaneous
<kbd><img src="img/ios/quick_actions.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/notifications.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/no_internet.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/onboarding.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/bank.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/plaid.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/notifications.jpeg" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/ios/save_image.jpeg" width="180" height="310"></kbd>


### React

#### Login
<kbd><img src="img/react/login.png" width="420" height="228"></kbd>

#### Password Reset
<kbd><img src="img/react/forgot-password.png" width="420" height="228"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/react/forgot-password2.png" width="420" height="228"></kbd>

#### Register
<kbd><img src="img/react/register1.png" width="420" height="228"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/react/register2.png" width="420" height="228"></kbd><kbd>

<img src="img/react/register3.png" width="420" height="228"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/react/register4.png" width="420" height="228"></kbd>




### Text Messages
<kbd><img src="img/text/text-messages.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/text/settle-text.png" width="180" height="310"></kbd>

### Emails 
<kbd><img src="img/emails/welcome_email.jpg" width="200" height="310"></kbd>&nbsp;&nbsp;&nbsp;<kbd><img src="img/emails/transaction_email.jpg" width="200" height="310"></kbd>&nbsp;&nbsp;&nbsp;<kbd><img src="img/emails/passwordReset_email.jpg" width="200" height="310"></kbd>&nbsp;&nbsp;&nbsp;<kbd><img src="img/emails/emailChange_email.jpg" width="210" height="310"></kbd>


## Features

### Current
#### iOS
- [x] Adding transactions with other people via phone number.
- [x] Registeration of new users/ Login functionality.
- [x] Authentication via Firebase
- [x] Unique QR Code and adding transaction using QR Code.
- [x] Access to data anywhere via AWS.
- [x] Text messages when payments are completed.
- [x] Ability to connect bank account (plaid integration).
- [x] Sending/Recieving money through ACH.  
- [x] Taggable transactions. An image (such as a bill) can be tagged with the transaction.
- [x] Saving tagged images to camera roll.
- [x] Enabling/disabling user notifications.
- [x] Actionable notifications (ability to silence a particular payment reminder).
- [x] User ratings based on transaction history.
- [x] Enabling/disabling touch ID.
- [x] 3D touch compatibility for Quick Actions.
- [x] 3D touch for Dashbard table cells.

#### React.js App
- [x] Retriving Transactions list.
- [x] Registeration of new users/ Login functionality.
- [x] Authentication via Firebase
- [x] Access to data anywhere via AWS.
- [x] Access to your Dracker dashboard, wallet, summary and profile.
- [x] Updating email and password.
- [x] Setting default funding source.

## Requirements

- iOS 10.0+
- Xcode 9.3
- Swift 4.1
- React.js 16.6
- npm 2.1

## Architecture

#### Rest API
![](img/architecture/API_Architecture.png)
- API Gateway and AWS Lambda are used to deploy the REST API
- DynamoDB is used to store all the data for user transactions and other details
- S3 is used to store profile images and tagged images with transactions
- Twilio is used to send messages
- Firebase is used for Authentication
- SendGrid for Emails
- Plaid for Bank Account Integration
- Dwolla for triggering ACH Transactions

#### iOS Application
![](img/architecture/iosApp_Architecture.png)
- Dracker API for all operations (REST API calls)
- Firebase is used for Login (Username/Password Validations)
- Plaid for Bank Integrations (Getting an authentication token to exchange at backend)


## Modules/Integrations Used
- Dwolla (ACH Transactions API and identity validation with verified customer)
- Plaid (Connecting user's bank account to dwolla)
- AWS (Backend)
- Twilio (payment completion notification)
- Firebase (Authentication)
- DZNEmptyDataSet (For nice empty cell look)
- Alamofire (API calls)
- SendGrid (for emailing Welcome, Verification, Note and Email change messages)

## Scripts

#### Cleanup
A configrable automation script that cleans up the AWS and Dwolla environment from test data. To be run pre-deployment in production. Script allows accounts to be preserved by adding the 'Email' in 'preserve_users.txt' file.

#### Webhook
A webhook created for dwolla, that handels clearing of ACH transactions. In case of successful ACH clearing, it sends out a text to the customer with transaction details. In case of unsuccessful ACH clearing, it sends out a text to the customer with transaction details and Dracker entry so the customer can track back and re-attempt to settle the payment.


## Meta

Raghav Bhasin – [@bhasin97](https://github.com/raghavbhasin97) – raghavbhasin97@gmail.com


[swift-image]:https://img.shields.io/badge/swift-4.0-orange.svg
[swift-url]: https://swift.org/


