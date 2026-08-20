import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "Components"


Item {
  id: root
  width: Screen.width
  height: Screen.height

  readonly property string cText:     "#CDD6F4"
  readonly property string cTextDim:  "#A6ADC8"
  readonly property string cSurface:  "#313244"
  readonly property string cBorder:   "#45475A"
  readonly property string cAccent:   "#89B4FA"
  readonly property string cBase:     "#1E1E2E"
  readonly property string cBad:      "#F38BA8"
  readonly property string bodyFont:  config.Font

  Image {
    id: wallpaper
    anchors.fill: parent
    source: config.Background
    fillMode: Image.PreserveAspectCrop
    asynchronous: false
    cache: true
    mipmap: true
    clip: true
  }
  Rectangle {
    anchors.fill: parent
    color: "#000000"
    opacity: 0.76
  }

  Text {
    id: dateLabel
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    anchors.verticalCenterOffset: -210
    color: Qt.rgba(0.65, 0.68, 0.78, 0.85)
    font.family: "Rubik"
    font.bold: true
    font.pixelSize: 40

    Timer {
      interval: 10000
      running: true
      repeat: true
      onTriggered: parent.updateText()
    }
    function updateText() {
      var d = new Date()
      var days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
      var months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
      dateLabel.text = days[d.getDay()] + ", " + months[d.getMonth()] + " " + d.getDate()
    }
    Component.onCompleted: updateText()
  }

  Text {
    id: clockLabel
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    anchors.verticalCenterOffset: -300
    color: Qt.rgba(0.80, 0.84, 0.96, 0.95)
    font.family: "Rubik"
    font.bold: true
    font.pixelSize: 160
    horizontalAlignment: Text.AlignHCenter

    Timer {
      interval: 10000
      running: true
      repeat: true
      onTriggered: parent.updateText()
    }
    function updateText() {
      var d = new Date()
      var h = d.getHours() % 12; if (h === 0) h = 12
      var m = d.getMinutes(); if (m < 10) m = "0" + m
      clockLabel.text = h + ":" + m
    }
    Component.onCompleted: updateText()
  }

  Rectangle {
    id: userBox
    width: 300
    height: 60
    color: Qt.rgba(0.19, 0.20, 0.27, 0.55)
    border.width: 1
    border.color: Qt.rgba(0.27, 0.28, 0.35, 0.7)
    radius: height / 2
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    anchors.verticalCenterOffset: -40
  }
  Row {
    id: userLabel
    anchors.horizontalCenter: userBox.horizontalCenter
    anchors.verticalCenter: userBox.verticalCenter
    spacing: 10
    Text {
      text: "\uf2be"
      font.family: "Symbols Nerd Font"
      font.pixelSize: 18
      color: Qt.rgba(0.65, 0.68, 0.78, 0.9)
    }
    Text {
      text: currentUser().toUpperCase()
      font.family: "Rubik"
      font.bold: true
      font.pixelSize: 18
      color: Qt.rgba(0.65, 0.68, 0.78, 0.9)
    }
  }
  function currentUser() {
    if (userModel.lastUser && userModel.lastUser !== "") return userModel.lastUser
    for (var i = 0; i < userModel.count; i++) {
      var u = userModel.data(userModel.index(i, 0), Qt.UserRole)
      if (u) return u
    }
    return ""
  }

  Rectangle {
    id: passwordBox
    width: 300
    height: 60
    radius: height / 2
    color: Qt.rgba(0.12, 0.12, 0.18, 0.6)
    border.width: 2
    border.color: passwordText.activeFocus ? cAccent : Qt.rgba(0.27, 0.28, 0.35, 0.7)
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    anchors.verticalCenterOffset: 60

    Text {
      id: passPlaceholder
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      color: cTextDim
      font.family: bodyFont
      font.italic: true
      font.pixelSize: 18
      text: "Password"
      visible: passwordText.text === ""
    }

    TextInput {
      id: passwordText
      anchors.fill: parent
      anchors.leftMargin: 16
      anchors.rightMargin: 16
      focus: true
      echoMode: TextInput.Password
      passwordCharacter: "\u2022"
      renderType: Text.NativeRendering
      color: cText
      font.family: bodyFont
      font.bold: true
      font.pixelSize: 20
      horizontalAlignment: TextInput.AlignHCenter
      verticalAlignment: TextInput.AlignVCenter
      inputMethodHints: Qt.ImhHiddenText
      clip: true

      onAccepted: tryLogin()
      Keys.onReturnPressed: tryLogin()
    }
  }

  function currentSession() {
    for (var s = 0; s < sessionModel.count; s++) {
      var name = sessionModel.data(sessionModel.index(s, 0), Qt.DisplayRole)
      if (name === "hyprland-uwsm") return name
    }
    return sessionModel.lastSession
  }

  function tryLogin() {
    sddm.login(currentUser(), passwordText.text, currentSession())
    passwordText.text = ""
  }

  Item {
    id: powerRow
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 100

    PowerIconButton {
      glyph: "\udb81\udf09"; label: "Reboot";    onClicked: sddm.reboot()
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
    }
    PowerIconButton {
      glyph: "\udb81\udc25"; label: "Shutdown";  onClicked: sddm.powerOff()
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.horizontalCenterOffset: -140
      anchors.verticalCenter: parent.verticalCenter
    }
    PowerIconButton {
      glyph: "\udb82\udd04"; label: "Suspend";   onClicked: sddm.suspend()
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.horizontalCenterOffset: 140
      anchors.verticalCenter: parent.verticalCenter
    }
  }

  Connections {
    target: sddm
    function onLoginFailed() {
      passwordText.text = ""
      passwordText.focus = true
    }
  }
}
