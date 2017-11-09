# MLDPtest-ios
App for communication between RN4020 and iOS device by MLDP.

## 実行環境
- iOS10 or Higher
- Xcode 9.1
- Swift 4

### Peripheralの設定
- MLDPサービスを持っているRN4020と自動で接続します

### アプリの操作
- アプリを起動後、[START SCAN] ボタンをタップしてください。上記設定が正しく行われていれば、デバイスに接続が完了し、"DoFMode:on" が送信されます

- ColorModeの際は0-255の値で"H S V"を入力し、 [SEND] ボタンをタップして送信してください
