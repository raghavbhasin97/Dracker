# Dracker
[![Swift Version][swift-image]][swift-url]
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](https://www.apple.com/ios/ios-11/)
[![Build Status](https://travis-ci.org/dwyl/esta.svg?branch=master)](https://travis-ci.org/dwyl/esta)

An iOS app to track/manage debt. This app allows users to create transactions, add descriptions, tag images, tag notes, and manage them. It features a rich and immersive user experience with 3D touch, quick actions, Actionable User Notifications, and Touch ID/Passcode capability for secure authentication.

![](img/logo.png)

## UI

#### Login/Register
<kbd><img src="img/login.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/register.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/register2.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/register3.png" width="180" height="310"></kbd>


#### Dashboard
<kbd><img src="img/home.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/wallet.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/profile.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/settings.png" width="180" height="310"></kbd>

#### Existing Transactions
<kbd><img src="img/details.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/add_note.png" width="180" height="310"></kbd>

#### New Transactions
<kbd><img src="img/add_transaction.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/qr_code.png" width="180" height="310"></kbd>

#### Summary
<kbd><img src="img/friends.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/friends_detail.png" width="180" height="310"></kbd>

#### Profile
<kbd><img src="img/change_password.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/change_email.png" width="180" height="310"></kbd>

#### Settings
<kbd><img src="img/change_passcode.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/set_passcode.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/set_frequency.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/bank_account.png" width="180" height="310" style="border: 1px solid black;"></kbd>

#### Security
<kbd><img src="img/authentication.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/passcode.png" width="180" height="310"></kbd>

#### Miscellaneous
<kbd><img src="img/quick_actions.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/notifications.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/no_internet.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/onboarding.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/bank.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/plaid.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/notifications.jpeg" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/save_image.jpeg" width="180" height="310"></kbd>

#### SMS
<kbd><img src="img/text-messages.png" width="180" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/settle-text.png" width="180" height="310"></kbd>

#### Email Templates
<kbd><img src="img/welcome_email.jpg" width="200" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/passwordReset_email.jpg" width="200" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/emailChange_email.jpg" width="210" height="310"></kbd>&nbsp;&nbsp;&nbsp;&nbsp;<kbd><img src="img/transaction_email.jpg" width="210" height="310"></kbd>

## Features

### Current
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

## Requirements

- iOS 10.0+
- Xcode 9.3
- Swift 4.1

## Architecture
![](img/architecture.png)

- DynamoDB is used to store all the data for user transactions and other details
- S3 is used to store profile images and tagged images with transactions.
- Twilio is used to send messages for payment completion.
- Firebase is used for Authentication.
- SendGrid for emails.
- AWS Lambda fir backend
- API Gateway for API calls to backend
- Plaid for bank account integration
- Dwolla for making ACH Transactions

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

#### ACH Processor
A simple script that is scheduled to run once every day to check on status of pending transactions and notify users when the transactions are processed.


## Meta

Raghav Bhasin – [@bhasin97](https://github.com/raghavbhasin97) – raghavbhasin97@gmail.com


[swift-image]:https://img.shields.io/badge/swift-4.0-orange.svg
[swift-url]: https://swift.org/


