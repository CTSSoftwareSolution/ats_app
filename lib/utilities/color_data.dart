import 'dart:ui';

// ATS colour tokens. See docs/design_system.md for when to use each one.
//
// Brand: [appColor] is the single primary colour, used only for important
// actions and selected states (app bars, primary buttons, selected tabs /
// chips / nav items, focus rings, links, progress). Surfaces are white /
// neutral; status colours are deliberately different hues from the brand.
//
// The block directly below (up to `background`) is the legacy palette, still
// referenced by older/unused screens. New UI uses the tokens further down.

//const appColor = Color(0xff345afa);
//const appColor = Color(0xff1c3e70);
const appColor = Color(0xFF1565C0);
const appGradientColor = Color(0xff19162e);
const stepperInactiveColor = Color(0x4a345afa);
const bottomIconColor = Color(0xffa29c9c);
const scanTextColor = Color(0xff4f4f4f);
const cardBackgroundColor = Color(0x14345afa);
const greenColor = Color(0xff1fb055);
const redColor = Color(0xffff5c5c);
const whiteColor = Color(0xffffffff);
const indicatorContainerColor = Color(0x4dffffff);
const indicatorColor = Color(0x8affffff);
const blackColor = Color(0xf3000000);
const greyLightColor = Color(0xf3d9d9d9);
const greyColor = Color(0xf38b8b8b);
const mediaPickerColor = Color(0x45d9d9d9);
const cameraBackConColor = Color(0x4fd9d9d9);
const textFieldColor = Color(0xf3e8e8e8);
const background = Color(0xFFF7F9FC);

// ── Brand ───────────────────────────────────────────────────────────────────
/// Darker primary: pressed states, the theme's secondary colour.
const appColorDark = Color(0xFF0D47A1);

/// Light primary tint: selected chip / nav pill / icon-tile backgrounds.
const primaryLight = Color(0xFFE3F2FD);

// ── Backgrounds ─────────────────────────────────────────────────────────────
const bg = Color(0xFFF7F9FC);
const surface = Color(0xFFFFFFFF);
const surface2 = Color(0xFFF2F4F7);
const surfaceDark = Color(0xFF172033);

// Navy names kept for the new-manual-flow screens; they now follow the
// primary family so those screens match the rest of the app.
const navy = appColorDark;
const navyMid = appColorDark;
const navyLight = appColor;
const navyAccent = appColor;

// ── Borders ─────────────────────────────────────────────────────────────────
const border = Color(0xFFE4E7EC);
const borderDark = Color(0xFFD0D5DD);

// ── Status (distinct hues from the brand blue) ──────────────────────────────
const pass = Color(0xFF1A7F4B);
const passLight = Color(0xFFE8F5EE);
const fail = Color(0xFFC0392B);
const failLight = Color(0xFFFDECEA);
const warn = Color(0xFFB45309);
const warnLight = Color(0xFFFEF3E2);

/// In progress: uploading / processing.
const processing = Color(0xFF6941C6);
const processingLight = Color(0xFFF4F3FF);

/// Media captured on the device, not yet sent.
const captured = Color(0xFF0E7490);
const capturedLight = Color(0xFFECFEFF);

/// Neutral / not started / not applicable. Also the caption colour
/// (≈4.8:1 on white).
const na = Color(0xFF667085);
const naLight = Color(0xFFF2F4F7);

// ── Text ────────────────────────────────────────────────────────────────────
const textPrimary = Color(0xFF172033);
const textSecondary = Color(0xFF667085);

/// Placeholders, disabled and decorative only (not for readable text).
const textMuted = Color(0xFF98A2B3);
const textWhite = Color(0xFFFFFFFF);

/// Secondary text on the primary colour (app bar subtitles, inactive tabs).
const textWhiteSub = Color(0xFFD6E6FA);

// ── Legacy aliases ──────────────────────────────────────────────────────────
/// In-progress status colour (was a bright blue; now [processing] so it is
/// distinct from the brand).
const accent = processing;

/// Primary tint (alias of [primaryLight]).
const accentLight = primaryLight;

// Overlay behind dialogs and bottom sheets ([textPrimary] at 45%).
const scrim = Color(0x73172033);
