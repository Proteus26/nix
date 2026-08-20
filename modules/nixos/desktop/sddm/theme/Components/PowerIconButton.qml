import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
  id: btn
  property string glyph: ""
  property string label: ""

  signal clicked

  implicitWidth: 60
  implicitHeight: 90

  MouseArea {
    id: area
    anchors.fill: parent
    hoverEnabled: true
    onClicked: btn.clicked()
  }

  Text {
    id: icon
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    text: btn.glyph
    font.family: "Symbols Nerd Font"
    font.pixelSize: 50
    color: area.containsMouse ? Qt.rgba(0.80, 0.84, 0.96, 1.0) : Qt.rgba(0.65, 0.68, 0.78, 0.75)
  }
  Text {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: icon.bottom
    anchors.topMargin: 4
    text: btn.label
    font.family: "Rubik"
    font.pixelSize: 10
    font.bold: true
    color: Qt.rgba(0.65, 0.68, 0.78, 0.6)
  }
}
