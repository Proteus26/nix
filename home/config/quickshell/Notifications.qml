import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Notifications
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "config.js" as Config
import "components"

Scope {
	id: root
	property bool centerOpen: false
	ListModel {
		id: history
	}

	NotificationServer {
		id: server
		actionsSupported: true
		bodySupported: true
		imageSupported: true

		onNotification: n => {
			history.insert(0, {
				summary: n.summary,
				body: n.body,
				appName: n.appName,
				urgency: n.urgency,
				time: Qt.formatDateTime(new Date(), "HH:mm")
			})
			n.tracked = true
		}
	}

	IpcHandler {
		target: "notifications"
		function toggle() : void { root.centerOpen = !root.centerOpen }
		function show() : void { root.centerOpen = true }
		function hide() : void { root.centerOpen = false }
	}

	// notification toasts
	Variants {
		model: Quickshell.screens

		PanelWindow {
			required property var modelData
			screen: modelData

			readonly property var monitor: Hyprland.monitorFor(modelData)
			readonly property bool isFocusedMonitor: monitor?.name === Hyprland.focusedMonitor?.name

			visible: isFocusedMonitor

			anchors { top: true; right: true }
			margins { top: 12; right: 12 }

			implicitWidth: 380
			implicitHeight: Math.max(1, column.implicitHeight)
			color: "transparent"

			exclusionMode: ExclusionMode.Normal

			ColumnLayout {
				id: column
				width: parent.width
				spacing: 10

				Repeater {
					model: server.trackedNotifications
					delegate: MCard {
						id: card
						required property var modelData

						Timer {
							running: card.modelData.urgency != NotificationUrgency.Critical
							interval: Config.notifications.timeout
							onTriggered: card.modelData.dismiss()
						}

						Layout.fillWidth: true
						Layout.preferredHeight: layout.implicitHeight
						radius: Config.mat.radius.lg
						elevation: Config.mat.elevation.medium
						color: card.modelData.urgency === NotificationUrgency.Critical
							? Config.mat.errorContainer
							: Config.mat.surfaceContainer

						Rectangle {
							anchors { top: parent.top; bottom: parent.bottom; left: parent.left }
							anchors.topMargin: 10
							anchors.bottomMargin: 10
							width: 3
							radius: 1.5
							color: card.modelData.urgency === NotificationUrgency.Critical
								? Config.mat.error
								: Config.mat.primary
						}

						RowLayout {
							id: layout
							anchors.fill: parent
							anchors.margins: 12
							spacing: 12

							Image {
								Layout.preferredHeight: 36
								Layout.preferredWidth: 36
								Layout.alignment: Qt.AlignTop
								fillMode: Image.PreserveAspectFit
								visible: source.toString() !== ""
								source: card.modelData.image || card.modelData.appIcon || ""
							}

							ColumnLayout {
								Layout.fillWidth: true
								spacing: 2

								Text {
									Layout.fillWidth: true
									text: card.modelData.summary
									color: card.modelData.urgency === NotificationUrgency.Critical
										? Config.mat.onErrorContainer
										: Config.mat.onSurface
									font.family: Config.bar.fontFamily
									font.pixelSize: Config.bar.fontSize
									font.bold: true
									elide: Text.ElideRight
								}

								Text {
									Layout.fillWidth: true
									visible: text !== ""
									text: card.modelData.body
									color: card.modelData.urgency === NotificationUrgency.Critical
										? Config.mat.onErrorContainer
										: Config.mat.onSurfaceVariant
									font.family: Config.bar.fontFamily
									font.pixelSize: Config.bar.fontSize - 1
									wrapMode: Text.WordWrap
								}
							}
						}

						MouseArea {
							anchors.fill: parent
							onClicked: card.modelData.dismiss()
						}
					}
				}
			}
		}
	}

	// notification center
	Variants {
		model: Quickshell.screens

		PanelWindow {
			required property var modelData
			screen: modelData

			readonly property var monitor: Hyprland.monitorFor(modelData)
			readonly property bool isFocusedMonitor: monitor?.name === Hyprland.focusedMonitor?.name

			visible: root.centerOpen && isFocusedMonitor

			anchors { top: true; right: true }
			margins { top: 12; right: 12 }

			implicitWidth: 380
			implicitHeight: centerCol.implicitHeight
			color: "transparent"

			exclusionMode: ExclusionMode.Normal

			MCard {
				anchors.fill: parent
				radius: Config.mat.radius.xl
				color: Config.mat.surfaceContainerLowest
				elevation: Config.mat.elevation.high

				ColumnLayout {
					id: centerCol
					anchors.fill: parent
					anchors.margins: 16
					spacing: 10

					RowLayout {
						Layout.fillWidth: true

						Text {
							Layout.fillWidth: true
							text: "Notifications"
							color: Config.mat.onSurface
							font.family: Config.bar.fontFamily
							font.pixelSize: Config.bar.fontSize + 2
							font.bold: true
						}

						MButton {
							visible: history.count > 0
							text: "Clear all"
							textPixelSize: Config.bar.fontSize
							fgColor: Config.mat.error
							onClicked: history.clear()
						}
					}

					Repeater {
						model: history
						delegate: MItem {
							Layout.fillWidth: true
							Layout.preferredHeight: histLayout.implicitHeight
							radius: Config.mat.radius.md
							normalColor: "transparent"
							selected: false

							RowLayout {
								id: histLayout
								anchors.fill: parent
								anchors.margins: 12
								spacing: 12

								ColumnLayout {
									Layout.fillWidth: true
									spacing: 2

									RowLayout {
										Layout.fillWidth: true
										spacing: 6

										Text {
											Layout.fillWidth: true
											text: summary
											color: urgency === NotificationUrgency.Critical
												? Config.mat.error
												: Config.mat.onSurface
											font.family: Config.bar.fontFamily
											font.pixelSize: Config.bar.fontSize
											font.bold: true
											elide: Text.ElideRight
										}

										Text {
											text: model.time
											color: Config.mat.onSurfaceVariant
											font.family: Config.bar.fontFamily
											font.pixelSize: Config.bar.fontSize - 3
										}
									}

									Text {
										Layout.fillWidth: true
										visible: body !== ""
										text: body
										color: Config.mat.onSurfaceVariant
										font.family: Config.bar.fontFamily
										font.pixelSize: Config.bar.fontSize - 1
										wrapMode: Text.WordWrap
									}

									Text {
										visible: model.appName !== ""
										text: model.appName
										color: Config.mat.outline
										font.family: Config.bar.fontFamily
										font.pixelSize: Config.bar.fontSize - 3
									}
								}

								MButton {
									icon: "\uf00d"
									size: 26
									radius: 13
									iconPixelSize: Config.bar.fontSize - 1
									fgColor: Config.mat.onSurfaceVariant
									onClicked: history.remove(index)
								}
							}
						}
					}
				}
			}
		}
	}
}
