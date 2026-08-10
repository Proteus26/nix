// Catppuccin Mocha, keeping the existing structure: near-flat dark
// surfaces, a single accent used sparingly, small radii, floating
// segments - just recolored to the Mocha palette.
const colors = {
	// Base surfaces - Mocha base/crust hierarchy
	bg: "#11111b",          // crust (darkest)
	base: "#1e1e2e",        // base (bar/panel surface)
	surface: "#313244",     // surface0
	surfaceAlt: "#45475a",  // surface1
	overlay: "#585b70",     // surface2

	border: "#45475a",      // surface1
	borderMuted: "#313244", // surface0

	// Text
	text: "#cdd6f4",        // text
	textMuted: "#a6adc8",   // subtext0
	textDim: "#6c7086",     // overlay0

	// One accent, used for active/selected/emphasis states only
	accent: "#89b4fa",      // blue
	onAccent: "#1e1e2e",    // base
	accentDim: "#45475a",   // surface1 (subtle emphasis border)

	// Secondary accent, reserved for media / a second point of interest
	accent2: "#cba6f7",     // mauve

	// Status colors - Mocha red/yellow/green
	good: "#a6e3a1",        // green
	warn: "#f9e2af",        // yellow
	bad: "#f38ba8",         // red

	// Hover / interactive accents
	hover: "#45475a",       // surface1
	hoverBorder: "#585b70", // surface2
}

const radius = {
	small: 8,
	medium: 12,
	large: 18,
	full: 999,
}

const bar = {
	fontFamily: "Rubik",
	// Font for icon glyphs (battery, wifi, media, etc.) that Rubik
	// can't render - kept on a Nerd Font so the glyphs don't fall back.
	iconFontFamily: "Roboto Mono Nerd Font",
	fontSize: 15,
	height: 40,
	gap: 8,        // gap between floating segments
	margin: 10,    // gap between the bar and the screen edge
	segmentSpacing: 12, // spacing inside a segment between items
}

const notifications = {
	timeout: 5000,
}

// Shared popup styling (launcher, clipboard, notification center)
const panel = {
	padding: 16,
	gap: 12,
	listItemHeight: 52,
	thumbHeight: 180,
}
