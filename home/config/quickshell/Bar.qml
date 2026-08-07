import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Networking
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

import "config.js" as Config
import "components"

Scope {
	id: root

	// system stats
	property int cpuUsage: 0
	property int memUsage: 0
	property int diskUsage: 0
	property int volumeLevel: 0
	property int batteryLevel: -1
	property int batteryStatus: -1
	property string wifiSSID: ""
	property int wifiSignal: 0
	property string networkType: "offline"
	property var lastCpuIdle: 0
	property var lastCpuTotal: 0

	// media (Mpris service)
	property var mediaPlayer: null

	// ---- services ----

	readonly property var audioSink: Pipewire.defaultAudioSink
	readonly property var batteryDevice: UPower.displayDevice

	property string activeWindowTitle: Hyprland.activeToplevel?.title ?? ""

	function batteryIcon() {
		if (batteryStatus === UPowerDeviceState.Charging) return "\uf0e7"
		if (batteryLevel >= 90) return "\uf240"
		if (batteryLevel >= 60) return "\uf241"
		if (batteryLevel >= 40) return "\uf242"
		if (batteryLevel >= 10) return "\uf243"
		return "\uf244"
	}

	function wifiIcon() {
		if (networkType === "ethernet") return "\udb80\ude00"
		if (networkType !== "wifi" || wifiSSID === "") return "\udb82\udd2d"
		if (wifiSignal >= 80) return "\udb82\udd28"
		if (wifiSignal >= 55) return "\udb82\udd25"
		if (wifiSignal >= 30) return "\udb82\udd22"
		return "\udb82\udd1f"
	}

	// ---- cpu (reads /proc/stat through FileView, no subprocess) ----
	FileView {
		id: cpuFile
		path: "/proc/stat"
		blockAllReads: true
	}

	function updateCpu() {
		cpuFile.reload()
		const data = cpuFile.text()
		if (!data) return
		const parts = data.trim().split(/\s+/)
		const user = parseInt(parts[1]) || 0
		const nice = parseInt(parts[2]) || 0
		const system = parseInt(parts[3]) || 0
		const idle = parseInt(parts[4]) || 0
		const iowait = parseInt(parts[5]) || 0
		const irq = parseInt(parts[6]) || 0
		const softirq = parseInt(parts[7]) || 0
		const total = user + nice + system + idle + iowait + irq + softirq
		const idleTime = idle + iowait

		if (root.lastCpuTotal > 0) {
			const totalDiff = total - root.lastCpuTotal
			const idleDiff = idleTime - root.lastCpuIdle
			if (totalDiff > 0) {
				root.cpuUsage = Math.round(100 * (totalDiff - idleDiff) / totalDiff)
			}
		}
		root.lastCpuTotal = total
		root.lastCpuIdle = idleTime
	}

	// ---- memory (reads /proc/meminfo through FileView) ----
	FileView {
		id: memFile
		path: "/proc/meminfo"
		blockAllReads: true
	}

	function updateMem() {
		memFile.reload()
		const data = memFile.text()
		if (!data) return
		let total = 0
		let available = 0
		const lines = data.split("\n")
		for (const line of lines) {
			if (line.startsWith("MemTotal:")) total = parseInt(line.split(/\s+/)[1]) || 0
			else if (line.startsWith("MemAvailable:")) available = parseInt(line.split(/\s+/)[1]) || 0
		}
		if (total > 0) {
			root.memUsage = Math.max(0, Math.min(100, Math.round(100 * (total - available) / total)))
		}
	}

	// ---- disk (df) ----
	Process {
		id: diskProc
		command: ["sh", "-c", "df / | tail -1"]
		stdout: SplitParser {
			onRead: data => {
				if (!data) return
				const parts = data.trim().split(/\s+/)
				const percentStr = parts[4] || "0%"
				root.diskUsage = parseInt(percentStr.replace('%', '')) || 0
			}
		}
	}

	// ---- volume (Pipewire service) ----
	function refreshVolume() {
		root.volumeLevel = root.audioSink ? Math.round(root.audioSink.volume * 100) : 0
	}
	Connections {
		target: root.audioSink
		function onVolumesChanged() { root.refreshVolume() }
		function onMutedChanged() { root.refreshVolume() }
	}
	onAudioSinkChanged: root.refreshVolume()

	// ---- battery (UPower service) ----
	function refreshBattery() {
		const dev = root.batteryDevice
		if (dev && dev.isPresent) {
			root.batteryLevel = Math.round(dev.percentage)
			root.batteryStatus = dev.state
		} else {
			root.batteryLevel = -1
			root.batteryStatus = -1
		}
	}
	Connections {
		target: root.batteryDevice
		function onPercentageChanged() { root.refreshBattery() }
		function onStateChanged() { root.refreshBattery() }
	}
	onBatteryDeviceChanged: root.refreshBattery()

	// ---- network (NetworkManager service) ----
	function refreshNetwork() {
		root.networkType = "offline"
		root.wifiSSID = ""
		root.wifiSignal = 0
		const devices = Networking.devices.values
		for (let i = 0; i < devices.length; i++) {
			if (devices[i].type === DeviceType.Wired && devices[i].connected) {
				root.networkType = "ethernet"
				root.wifiSSID = "Wired"
				root.wifiSignal = 100
				return
			}
		}
		for (let i = 0; i < devices.length; i++) {
			const dev = devices[i]
			if (dev.type !== DeviceType.Wifi) continue
			const networks = dev.networks.values
			for (let j = 0; j < networks.length; j++) {
				if (networks[j].connected) {
					root.networkType = "wifi"
					root.wifiSSID = networks[j].name || ""
					root.wifiSignal = Math.min(100, Math.round(networks[j].signalStrength))
					return
				}
			}
		}
	}

	// ---- media (Mpris service) ----
	function refreshMediaPlayer() {
		const players = Mpris.players.values
		for (let i = 0; i < players.length; i++) {
			if (players[i].isPlaying) {
				root.mediaPlayer = players[i]
				return
			}
		}
		root.mediaPlayer = players.length > 0 ? players[0] : null
	}

	function playerLabel() {
		const p = root.mediaPlayer
		if (!p) return "No media"
		if (p.trackArtist && p.trackTitle) return p.trackArtist + " - " + p.trackTitle
		return p.trackTitle || p.identity || "No media"
	}

	function playerIcon() {
		return root.mediaPlayer && root.mediaPlayer.isPlaying ? "\uf04c" : "\uf04b"
	}

	// ---- polling timers (data sources only, no subprocess spawning) ----
	Timer {
		interval: 1000
		running: true
		repeat: true
		onTriggered: root.updateCpu()
	}

	Timer {
		interval: 5000
		running: true
		repeat: true
		onTriggered: {
			root.updateMem()
			diskProc.running = true
		}
	}

	Timer {
		interval: 3000
		running: true
		repeat: true
		onTriggered: root.refreshNetwork()
	}

	Timer {
		interval: 1000
		running: true
		repeat: true
		onTriggered: root.refreshMediaPlayer()
	}

	Component.onCompleted: {
		root.updateCpu()
		root.updateMem()
		root.refreshVolume()
		root.refreshBattery()
		root.refreshNetwork()
		root.refreshMediaPlayer()
		diskProc.running = true
	}

	// ---- layout ----
	Variants {
		model: Quickshell.screens

		PanelWindow {
			property var modelData
			screen: modelData

			anchors {
				top: true
				left: true
				right: true
			}

			implicitHeight: Config.bar.height
			color: "transparent"

			margins {
				top: 6
				bottom: 0
				left: 8
				right: 8
			}

			MCard {
				anchors.fill: parent
				color: Config.mat.surfaceContainer
				radius: Config.bar.radius
				elevation: Config.mat.elevation.low

				RowLayout {
					anchors.fill: parent
					anchors.leftMargin: 8
					anchors.rightMargin: 12
					spacing: 2

					// workspaces
					Repeater {
						model: 10

						Item {
							id: wsItem
							Layout.preferredWidth: 28
							Layout.preferredHeight: Config.bar.chipHeight
							Layout.topMargin: (Config.bar.height - Config.bar.chipHeight) / 2
							Layout.bottomMargin: (Config.bar.height - Config.bar.chipHeight) / 2

							property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
							property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
							property bool hasWindows: workspace !== null

							Rectangle {
								id: wsBg
								anchors.fill: parent
								radius: 8
								color: parent.isActive ? Config.mat.primaryContainer : "transparent"
								Behavior on color { ColorAnimation { duration: 120 } }
							}

							Text {
								text: index === 9 ? "0" : index + 1
								color: parent.isActive ? Config.mat.onPrimaryContainer
									: (parent.hasWindows ? Config.mat.primary : Config.mat.onSurfaceVariant)
								font.pixelSize: Config.bar.fontSize
								font.family: Config.bar.fontFamily
								font.bold: true
								anchors.centerIn: parent
							}

							Rectangle {
								anchors.fill: parent
								radius: 8
								color: wsMouse.pressed ? Config.mat.statePressed
									: (wsMouse.containsMouse ? Config.mat.stateHover : "transparent")
								Behavior on color { ColorAnimation { duration: 120 } }
							}

							MouseArea {
								id: wsMouse
								anchors.fill: parent
								hoverEnabled: true
								onClicked: Hyprland.dispatch("workspace " + (index + 1))
							}
						}
					}

					Rectangle {
						Layout.preferredWidth: 1
						Layout.preferredHeight: 16
						Layout.alignment: Qt.AlignVCenter
						Layout.leftMargin: 8
						Layout.rightMargin: 8
						color: Config.mat.outlineVariant
					}

					Text {
						text: root.activeWindowTitle
						color: Config.mat.onSurfaceVariant
						font.pixelSize: Config.bar.fontSize
						font.family: Config.bar.fontFamily
						Layout.alignment: Qt.AlignVCenter
						Layout.maximumWidth: 300
						Layout.leftMargin: 4
						elide: Text.ElideRight
						maximumLineCount: 1
					}

					// Expanding spacer to push right-side modules
					Item { Layout.fillWidth: true }

					MStat {
						icon: "\uf4bc"
						label: cpuUsage + "%"
						iconColor: Config.colors.yellow
					}

					MStat {
						icon: "\uefc5"
						label: memUsage + "%"
						iconColor: Config.colors.peach
					}

					MStat {
						icon: "\uf0a0"
						label: diskUsage + "%"
						iconColor: Config.colors.blue
					}

					MStat {
						icon: "\uf027"
						label: volumeLevel + "%"
						iconColor: Config.colors.mauve
					}

					MStat {
						visible: root.batteryLevel >= 0
						icon: root.batteryIcon()
						label: batteryLevel + "%"
						iconColor: Config.colors.green
					}

					MStat {
						icon: root.wifiIcon()
						label: wifiSSID
						iconColor: Config.colors.teal
						Layout.maximumWidth: 170
					}

					Rectangle {
						Layout.preferredWidth: 1
						Layout.preferredHeight: 16
						Layout.alignment: Qt.AlignVCenter
						Layout.leftMargin: 8
						Layout.rightMargin: 6
						color: Config.mat.outlineVariant
					}

					Text {
						id: clockText
						text: Qt.formatDateTime(new Date(), "HH:mm")
						color: Config.mat.onSurface
						font.pixelSize: Config.bar.fontSize
						font.family: Config.bar.fontFamily
						font.bold: true
						Layout.alignment: Qt.AlignVCenter
						Layout.leftMargin: 4
						Layout.rightMargin: 6

						Timer {
							interval: 1000
							running: true
							repeat: true
							onTriggered: clockText.text = Qt.formatDateTime(new Date(), "HH:mm")
						}
					}
				}
			}

			// center media chip
			MCard {
				id: mediaPill
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter
				height: Config.bar.chipHeight + 4
				width: Math.min(mediaRow.implicitWidth, 400)
				radius: Config.mat.radius.lg
				color: Config.mat.surfaceContainerHigh
				elevation: Config.mat.elevation.medium
				visible: root.mediaPlayer !== null

				MouseArea {
					anchors.fill: parent
					acceptedButtons: Qt.LeftButton
					onClicked: {
						if (root.mediaPlayer) root.mediaPlayer.togglePlaying()
					}
					onWheel: (wheel) => {
						if (wheel.angleDelta.y > 0) {
							if (root.mediaPlayer) root.mediaPlayer.next()
						} else {
							if (root.mediaPlayer) root.mediaPlayer.previous()
						}
						wheel.accepted = true
					}
				}

				RowLayout {
					id: mediaRow
					anchors.fill: parent
					anchors.leftMargin: 4
					anchors.rightMargin: 12
					spacing: 4

					MButton {
						id: playBtn
						icon: root.playerIcon()
						fgColor: Config.mat.onSurface
						size: 28
						radius: 14
						onClicked: {
							if (root.mediaPlayer) root.mediaPlayer.togglePlaying()
						}
					}

					Text {
						text: root.playerLabel()
						color: Config.mat.onSurfaceVariant
						font.pixelSize: Config.bar.fontSize
						font.family: Config.bar.fontFamily
						elide: Text.ElideRight
						Layout.alignment: Qt.AlignVCenter
						Layout.maximumWidth: 340
						Layout.fillWidth: true
					}
				}
			}
		}
	}
}
