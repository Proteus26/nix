import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "config.js" as Config
import "components"

Scope {
	id: root
	property bool launcherOpen: false

	property var searchResults: []

	property int currentIndex: -1

	function fuzzyScore(query, target) {
		if (!query || !target) return -1
		const q = query.toLowerCase()
		const t = target.toLowerCase()

		const idx = t.indexOf(q)
		if (idx !== -1) return 100 - idx + q.length * 2

		let ti = 0
		let score = 0
		for (let qi = 0; qi < q.length; qi++) {
			const found = t.indexOf(q[qi], ti)
			if (found === -1) return -1
			score += (found === ti) ? 2 : 1
			ti = found + 1
		}
		return score
	}

	IpcHandler {
		target: "launcher"

		function toggle() : void {
			root.launcherOpen = !root.launcherOpen
		}

		function show() : void {
			root.launcherOpen = true
		}

		function hide() : void {
			root.launcherOpen = false
		}
	}

	function safeCalculate(expr) {
		if (!/^[0-9+\-*/().\s]+$/.test(expr)) return null
		try {
			const result = Function('"use strict"; return (' + expr + ')')()
			return (typeof result === "number" && isFinite(result)) ? result : null
		} catch (e) {
			return null
		}
	}

	function updateModel(query) {
		let newResults = []

		if (query.startsWith("=")) {
			const expr = query.slice(1).trim()
			if (expr.length > 0) {
				const result = root.safeCalculate(expr)
				newResults.push({
					appName: result !== null ? (expr + " = " + result) : "Invalid expression",
					appIcon: "",
					appId: "",
					appObj: null,
					isCalc: true,
					calcResult: result !== null ? String(result) : "",
					matchScore: 0
				})
			}

			root.searchResults = newResults
			root.currentIndex = newResults.length > 0 ? 0 : -1
			return
		}

		const allApps = DesktopEntries.applications.values
		const q = query.trim()

		for (let i = 0; i < allApps.length; i++) {
			const app = allApps[i]
			if (!app || app.noDisplay || !app.name) continue

			let currentScore = 0
			if (q !== "") {
				const nameScore = root.fuzzyScore(q, app.name)
				const genericScore = app.genericName ? root.fuzzyScore(q, app.genericName) : -1

				let keywordScore = -1

				if (app.keywords) {
					for (let k = 0; k < app.keywords.length; k++) {
						keywordScore = Math.max(keywordScore, root.fuzzyScore(q, app.keywords[k]))
					}
				}

				currentScore = Math.max(nameScore, genericScore * 0.6, keywordScore * 0.4)
				if (currentScore < 0) continue
			} else {
				currentScore = 1
			}

			newResults.push({
				appName: app.name || "",
				appIcon: app.icon || "",
				appId: app.id || "",
				appObj: app,
				isCalc: false,
				calcResult: "",
				matchScore: currentScore
			})
		}

		newResults.sort((a, b) => {
			if (b.matchScore !== a.matchScore) return b.matchScore - a.matchScore
			return a.appName.localeCompare(b.appName)
		})

		root.searchResults = newResults

		root.currentIndex = newResults.length > 0 ? 0 : -1
	}

	function activateCurrent() {
		if (root.currentIndex < 0 || root.currentIndex >= root.searchResults.length) return

		const entry = root.searchResults[root.currentIndex]

		if (entry.isCalc) {
			if (entry.calcResult !== "") {
				Quickshell.execDetached(["wl-copy", String(entry.calcResult)])
				Qt.callLater(() => { root.launcherOpen = false })
			} else {
				root.launcherOpen = false
			}
			return
		}

		const app = DesktopEntries.byId(entry.appId)
		if (app) {
			app.execute()
		}
		root.launcherOpen = false
	}

	Variants {
		model: Quickshell.screens

		PanelWindow {
			required property var modelData
			screen: modelData

			readonly property var monitor: Hyprland.monitorFor(modelData)
			readonly property bool isFocusedMonitor: monitor?.name === Hyprland.focusedMonitor?.name

			visible: root.launcherOpen && isFocusedMonitor
			implicitWidth: 460
			implicitHeight: 520
			color: "transparent"
			exclusionMode: ExclusionMode.Ignore

			WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

			onVisibleChanged: {
				if (visible) {
					searchField.text = ""
					root.updateModel("")
					searchField.input.forceActiveFocus()
				}
			}

			MCard {
				anchors.fill: parent
				radius: Config.mat.radius.xl
				color: Config.mat.surfaceContainerLowest
				elevation: Config.mat.elevation.high

				ColumnLayout {
					anchors.fill: parent
					anchors.margins: 16
					spacing: 14

					RowLayout {
						Layout.fillWidth: true

						Text {
							Layout.fillWidth: true
							text: "Applications"
							color: Config.mat.onSurface
							font.family: Config.bar.fontFamily
							font.pixelSize: Config.bar.fontSize + 2
							font.bold: true
						}

						Text {
							visible: root.searchResults.length > 0 && !searchField.text.startsWith("=")
							text: root.searchResults.length + " result" + (root.searchResults.length === 1 ? "" : "s")
							color: Config.mat.onSurfaceVariant
							font.family: Config.bar.fontFamily
							font.pixelSize: Config.bar.fontSize - 3
						}
					}

					MField {
						id: searchField
						Layout.fillWidth: true
						icon: searchField.text.startsWith("=") ? "\uf1ec" : "\uf002"
						iconColor: searchField.text.startsWith("=") ? Config.mat.primary : Config.mat.onSurfaceVariant
						placeholder: "Type to search, or start with = to calculate..."

						onSubmit: root.activateCurrent()
						onClose: root.launcherOpen = false
						onInputChanged: root.updateModel(searchField.text)

						onNavigateDown: {
							if (root.searchResults.length > 0)
								root.currentIndex = (root.currentIndex + 1) % root.searchResults.length
						}
						onNavigateUp: {
							if (root.searchResults.length > 0)
								root.currentIndex = (root.currentIndex - 1 + root.searchResults.length) % root.searchResults.length
						}
					}

					ListView {
						id: appList
						Layout.fillWidth: true
						Layout.fillHeight: true
						visible: root.searchResults.length > 0
						model: root.searchResults
						currentIndex: root.currentIndex
						clip: true
						spacing: 4
						boundsBehavior: Flickable.StopAtBounds
						highlightMoveDuration: 100

						onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Contain)

						delegate: MItem {
							id: delegateRoot
							width: ListView.view.width
							height: 52
							radius: Config.mat.radius.md
							selected: ListView.isCurrentItem

							required property var modelData
							required property int index

							RowLayout {
								anchors.fill: parent
								anchors.margins: 10
								spacing: 16

								Image {
									Layout.preferredWidth: 34
									Layout.preferredHeight: 34
									visible: !modelData.isCalc && source.toString() !== ""
									source: modelData.isCalc ? "" : (Quickshell.iconPath(modelData.appIcon, true) || "")
									fillMode: Image.PreserveAspectFit
								}

								Text {
									visible: modelData.isCalc
									Layout.preferredWidth: 34
									text: "="
									horizontalAlignment: Text.AlignHCenter
									color: Config.mat.primary
									font.bold: true
									font.family: Config.bar.fontFamily
									font.pixelSize: Config.bar.fontSize + 6
								}

								Text {
									Layout.fillWidth: true
									text: modelData.appName
									color: modelData.isCalc ? Config.mat.primary : Config.mat.onSurface
									font.family: Config.bar.fontFamily
									font.pixelSize: Config.bar.fontSize
									font.bold: true
									elide: Text.ElideRight
								}

								Text {
									visible: modelData.isCalc && modelData.calcResult !== ""
									text: "copy"
									color: Config.mat.onSurfaceVariant
									font.family: Config.bar.fontFamily
									font.pixelSize: Config.bar.fontSize - 3
								}
							}

							onClicked: {
								root.currentIndex = delegateRoot.index
								root.activateCurrent()
							}
							onHoveredChanged: {
								if (delegateRoot.hovered) root.currentIndex = delegateRoot.index
							}
						}
					}

					Item {
						Layout.fillWidth: true
						Layout.fillHeight: true
						visible: root.searchResults.length === 0

						Text {
							anchors.centerIn: parent
							text: searchField.text.startsWith("=") ? "Enter a valid expression" : "No matching applications"
							color: Config.mat.onSurfaceVariant
							font.family: Config.bar.fontFamily
							font.pixelSize: Config.bar.fontSize - 1
							horizontalAlignment: Text.AlignHCenter
						}
					}
				}
			}
		}
	}
}
