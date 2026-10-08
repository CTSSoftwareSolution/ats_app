# ATS App design system

These rules keep every screen consistent and readable during real-time vehicle inspection, which happens outdoors, in a hurry, often with one hand or gloves.

The visual language is **enterprise and flat**:
- One brand colour.
- Neutral surfaces separated by hairline borders.
- Small corner radii.
- No gradients and no decorative shadows.
- Motion only where it explains a change of state.

Everything here is implemented as code. Use the tokens and widgets; don't re-create them with raw numbers.

One import brings in every token and component:

```dart
import 'package:ats_app/design_system.dart';
```

(In tests, import `flutter_test` with `hide fail`, because `fail` is also a colour token.)

| What | Where |
|---|---|
| Colours | `lib/utilities/color_data.dart` |
| Typography | `lib/utilities/new_app_theme/app_text.dart` (`AppText`) |
| Spacing and sizes | `lib/utilities/new_app_theme/app_spacing.dart` (`AppSpacing`) |
| Radius | `lib/utilities/new_app_theme/app_radius.dart` (`AppRadius`) |
| Shadows | `lib/utilities/new_app_theme/app_shadow.dart` (`AppShadow`) |
| Motion | `lib/utilities/new_app_theme/app_motion.dart` (`AppMotion`) |
| Breakpoints and widths | `lib/utilities/new_app_theme/app_layout.dart` (`AppLayout`) |
| Icon sizes | `lib/utilities/new_app_theme/app_icon_size.dart` (`AppIconSize`) |
| Material theme | `lib/utilities/new_app_theme/app_theme.dart` (`AppTheme.light`) |
| Components | `lib/widgets/new_app_ui/` |

## Principles

1. **Deep Indigo, one accent.** `appColor` (#3F51B5) is used for app bars, primary buttons, FAB, selection and focus. `secondaryColor` (#5C6BC0) is the supporting indigo for secondary actions, progress and section accents; it is readable on white and under white text. `accent` (#7C4DFF) is a violet highlight used sparingly on light surfaces (theme `tertiary`); on indigo or dark surfaces (tab underlines, snackbar actions) use `accentOnDark` (#B388FF). Text is `textPrimary` (#263238), the page is `bg` (#FAFAFF) and neutral fills are `surface2` (#E8EAF6). Every other colour is either neutral or carries a status meaning.
2. **Flat.** Separate surfaces with hairline borders (`border`), not shadows. There are no gradients. `AppShadow.overlay` is the only shadow, and it is reserved for things floating over live content.
3. **Compact, not cramped.** Radii are small (6–16). Cards hug their content. Never set a fixed height on a card.
4. **Readable first.** Text is at least 11pt. Readable text uses `textPrimary`, `textSecondary` or `na`. `textMuted` is only for placeholders, disabled states and decorative icons.
5. **Big targets.** Anything tappable is at least 48 × 48dp. Primary actions are 52dp tall.
6. **Always say what's happening.** Every async screen has a loading state, an empty state and an error state with Retry. Finished tasks confirm success.
7. **Status is never colour alone.** It always pairs an icon with text.

## Colour

| Token | Use |
|---|---|
| `appColor` | Brand primary (#3F51B5): app bar, primary button, FAB, selected chip/tab, focus ring, links |
| `primaryDark` | Deepest indigo (#1A237E): dark panels, inverse surfaces, shadow tint |
| `secondaryColor` / `secondaryLight` | Secondary indigo (#5C6BC0, 4.9:1 on white): secondary actions, progress, section accents / tinted fill #E8EAF6 (theme `secondary` / `secondaryContainer`) |
| `secondaryDark` | Secondary text and icons on light surfaces (same value as `secondaryColor`) |
| `primaryLight` | Muted violet (#7E57C2): section icons and labels beside `appColor` |
| `accent` / `accentContainer` | Violet accent (#7C4DFF, 4.8:1 on white) for sparing highlights on light surfaces / its tinted fill #EDE7FF (theme `tertiary` / `tertiaryContainer`) |
| `accentOnDark` | Accent tint (#B388FF) for highlights on `appColor` or dark surfaces: tab indicator, snackbar action |
| `accentLight` | Selected-state tint on light surfaces (#E8EAF6): selected chips, segments, nav pill |
| `bg` | Page background |
| `surface` | Cards, sheets, dialogs, inputs, bottom bars |
| `surface2` | Neutral fills: static chips, progress tracks |
| `disabledBg` / `disabledFg` | **Disabled**: button fill / disabled text and icons |
| `shimmerBase` / `shimmerHighlight` | Loading skeletons |
| `border` / `borderDark` | Hairline dividers and card borders / outlined button and input outlines |
| `textPrimary` / `textSecondary` | Main text / supporting text |
| `na` | Captions, overlines, neutral icons (4.9:1 on white) |
| `textMuted` | Placeholders, disabled, decorative only (≈4.3:1, not for body text) |
| `textWhite` / `textWhiteSub` | Text on `appColor` or dark media |
| `pass` / `passLight` / `passBorder` | **Success**: pass, uploaded, saved |
| `fail` / `failLight` / `failBorder` | **Error**: fail, failed, destructive actions |
| `warn` / `warnLight` / `warnBorder` | **Pending / warning**: waiting, needs attention |
| `passOnDark` / `warnOnDark` | Status text and icons on dark indigo panels or photo overlays |
| `infoColor` / `infoLight` (secondary indigo, #5C6BC0) | **Info / in progress**: uploading, processing; tinted icon backgrounds |
| `scrim` | Overlay behind dialogs, sheets and the blocking loader (set in the theme) |
| `mediaBg` | Background of the camera and full-screen image / video viewers |
| `mediaScrim` | Backing behind controls and captions laid over a photo or video |

The legacy colours at the top of `color_data.dart` are only for old screens. Don't use them in new code.

## Typography

The font is Gilroy, bundled as one family per weight. Choose the weight with `fontFamily` (`"Medium"`, `"SemiBold"`, `"Bold"`), never with `fontWeight`.

| `AppText.` | Size | Weight | Use |
|---|---|---|---|
| `display` | 24 | Black | Brand heading on dark (splash, login) |
| `appBarTitle` | 18 | SemiBold | App bar title (set by the theme) |
| `pageTitle` (H1) | 20 | Bold | Heading inside page content |
| `dialogTitle` | 17 | Bold | Dialog titles |
| `sectionTitle` (H2) | 16 | Bold | Card, section, sheet and state titles |
| `title` (H3) | 15 | SemiBold | List item titles, question text |
| `button` | 15 | SemiBold | Button labels (applied by the theme) |
| `label` | 14 | SemiBold | Compact row titles, banner and snackbar titles |
| `buttonCompact` | 14 | SemiBold | Labels of 40dp inline buttons on cards ("Inspect", "Retry") |
| `input` / `hint` | 15 | SemiBold / Medium | Typed text / placeholder in fields |
| `body` | 14 | Medium | Body text |
| `bodySecondary` | 13 | Medium | Descriptions, state messages |
| `chip` / `fieldLabel` | 13 | SemiBold | Chips, tabs, meta rows / labels above fields |
| `tag` | 12 | SemiBold | Static metadata tags (`InfoChip`), slot captions |
| `caption` / `navLabel` | 12 | Medium / SemiBold | Helper text, counters / navigation labels (both states) |
| `appBarSubtitle` | 12 | Medium | Second line in the app bar (vehicle number) |
| `badge` / `badgeDense` | 12 / 11 | Bold | Status badges |
| `overline` | 11 | Bold | UPPERCASE group labels (use `SectionHeader`) |
| `plate` | 17 | Bold | Registration number (`RegistrationPlate`) |

- Use one H1 per page at most. Most pages rely on the app bar title and start with H2 section titles.
- The theme's `textTheme` maps to these styles, so a plain `Text` already gets `body`.
- Use tabular figures (`style.copyWith(fontFeatures: AppText.tabular)`) for counts and times that update in place.
- Don't write `copyWith(fontSize: …)` on a screen. If a size is missing from the scale, add a named style to `AppText`.

## Spacing and layout

The scale goes in steps of 4: `xxs 2 · xs 4 · sm 8 · md 12 · lg 16 · xl 24 · xxl 32`.

| Token | Value | Use |
|---|---|---|
| `AppSpacing.iconGap` | 6 | Between an icon and its label inside chips, pills and meta rows |
| `AppSpacing.page` | 16 | Left and right gutter of every screen (24 on tablets, `AppLayout.gutter`) |
| `AppSpacing.card` | 16 | Card padding |
| `AppSpacing.dialog` | 20 | Dialog and bottom sheet padding |
| `AppSpacing.listGap` | 12 | Between list cards and form rows |
| `AppSpacing.section` | 24 | Between unrelated sections |
| `AppSpacing.buttonHeight` | 52 | Primary and secondary buttons |
| `AppSpacing.compactHeight` | 40 | Inline buttons and filter chips (tap area padded to 48) |
| `AppSpacing.inputHeight` | 48 | Single-line inputs and search |
| `AppSpacing.inputPadding` | 14 | Inner padding of inputs (set in the theme) |
| `AppSpacing.minTouchTarget` | 48 | Smallest tappable area |

- Use `sm` between related items (label to field, chip to chip).
- The **primary action** goes in a `BottomActionBar` docked at the bottom of the screen. It doesn't float over content.

## Radius

| Token | Value | Use |
|---|---|---|
| `AppRadius.xs` | 4 | Progress bars, checkboxes, skeleton lines |
| `AppRadius.sm` | 6 | Static chips, tags, thumbnails, number plate |
| `AppRadius.md` | 8 | Buttons, inputs, filter chips, capture slots, icon tiles, banners, snackbars |
| `AppRadius.lg` | 12 | Cards and list groups |
| `AppRadius.xl` | 16 | Dialogs, top of bottom sheets |
| `AppRadius.full` | stadium | Status badges, pills, counts |

Don't nest rounded containers more than one level deep inside a card. An inner element uses a smaller radius than its parent.

## Shadows and elevation

| Token | Use |
|---|---|
| `AppShadow.none` | Everything: cards, sheets, dialogs, app bars, bottom bars, the blocking loader |
| `AppShadow.overlay` / `overlayElevation` | Only for elements over live content with no scrim: popup menus, camera controls over the preview |

Depth comes from the scrim behind dialogs and sheets, not from shadows.

## Motion

| Token | Value | Use |
|---|---|---|
| `AppMotion.fast` | 150ms | Selection feedback: chips, tabs, navigation pills, toggles |
| `AppMotion.standard` | 200ms | Expand and collapse, content swaps |
| `AppMotion.curve` | easeOutCubic | All of the above |

Nothing animates for decoration: no entrance animations, no bouncing and no looping effects. Spinners and skeleton shimmer are the only continuous motion.

## Icons

Use Material **rounded** icons for actions and selected states, and **outlined** icons for idle or empty variants (for example navigation: `home_outlined` → `home_rounded`). Don't add new PNG icons for UI controls. Bitmaps are for the logo and photos only.

| `AppIconSize.` | Size | Use |
|---|---|---|
| `xxs` | 12 | Inside dense status badges |
| `xs` | 14 | Inside status badges and `InfoChip` |
| `sm` | 16 | Next to captions and meta text, filter-chip check |
| `md` | 20 | Default: buttons, list tiles, field prefixes, banners, bottom bar |
| `lg` | 24 | App bar, navigation rail |
| `xl` | 32 | Empty, error and success state illustrations |

An icon used on its own needs a `tooltip` (on `IconButton`) or a `Semantics` label.

## Dividers

- Use the theme's `Divider()`: 1dp, `border` colour, no extra space.
- Inside a grouped list (for example Profile settings), indent dividers to the text start. Don't put a divider after the last row.
- Don't put a divider between cards. The list gap separates them.

## Responsive behaviour

| Width | Class | Navigation | Content |
|---|---|---|---|
| < 600 | compact (phone) | Docked bottom bar | Full width, 16 gutter, 1 column |
| 600–839 | medium (small tablet) | Brand navigation rail | Centred, max 840, 24 gutter, 2 columns |
| ≥ 840 | expanded (tablet) | Brand navigation rail | Centred, max 840, 24 gutter, 2–3 columns |

- Use `AppLayout` (`isTablet`, `gridColumns`, `gutter`) or the `BoxConstraints` extension `isTablet` in `responsive_ext.dart`. Decide layout from the available width (`LayoutBuilder`), not from the device type.
- App bars, tab strips and bottom bars stay full-bleed. Wrap the **scrolling body** in `ResponsiveContent` (max 840) or `ResponsiveContent.form` (max 480).
- Capture grids size tiles by width (`SliverGridDelegateWithMaxCrossAxisExtent`, about 240dp) rather than a fixed column count.
- Dialogs are at most 420 wide and bottom sheets at most 640 (set in the theme). On tablets, sheets sit centred.
- The camera and media viewers are always full screen.

## Components

### App bars: `AppTopBar`
- Every screen uses `AppTopBar(title: …)`. It is brand-coloured and flat, with an 18 SemiBold white title that is left-aligned.
- Pushed screens pass `onBack` and get the shared back button (`Icons.arrow_back_rounded`). Tab roots omit it, and their title lines up with the page gutter.
- Inspection-flow screens pass `subtitle: vehicleSubtitle(context)`, so the vehicle's registration number is always visible.
- A tab strip goes in `bottom:`, which continues the brand colour.
- Actions are icon buttons with a `tooltip`. Put at most two in the bar and move the rest to an overflow menu.

### Bottom navigation
- Both layouts use one indicator, `AppNavIndicator`: a 24dp icon on a 56 × 32dp stadium. Selected tabs show the filled icon on a tinted pill; unselected tabs show the outlined icon with no pill.
- Labels use `AppText.navLabel` (12 SemiBold) in both states. Only the colour changes, so labels never shift width when you switch tabs. Labels scale with system text up to 1.2×.
- **Phone (`CustomBottomNavigation`):** a docked white bar, 64dp tall, with a hairline top border and no shadow.
  - Selected: `accentLight` pill with an `appColor` icon and label.
  - Unselected: `textSecondary` icon and label.
  - The tap ripple follows the item's stadium shape.
- **Tablet (`TabletNavigationRail`):** a flush, full-height `appColor` rail with the logo at the top and Log out at the bottom. Selected tabs show a white icon on a 16% white pill; unselected tabs use `textWhiteSub`.
- Destinations are defined once in `appNavDestinations` (`new_app_ui/app_navigation.dart`), in the same order as `BottomNavigationProvider.pages`. Behaviour stays in the provider.

### Buttons
| Type | Widget | Use |
|---|---|---|
| Primary | `PrimaryButton` | One per screen or sheet. 52dp, full width, brand colour. Pass `loading: true` while it runs, and `color: fail` for destructive actions |
| Secondary | `SecondaryButton` | Outlined, 52dp. The second action of a pair (Cancel, Reset). Goes to the left of the primary, usually `flex: 1` against `flex: 2`. Pass `color: fail` for a destructive secondary action ("Remove photo") |
| Inline | Theme `FilledButton` / `OutlinedButton` / `TextButton` | Actions on a card ("Retest", "Retry"), 48dp minimum |
| Icon | `IconButton` with `tooltip` | Toolbar and row actions |

- All buttons use an 8dp radius (`AppRadius.md`) and no elevation. Full-height buttons use `AppText.button` labels; 40dp inline card buttons use `AppText.buttonCompact`.
- Labels are verbs ("Sign in", "Save address", "Log out"), not "Yes" or "OK".
- Disabled buttons use a `surface2` fill with `textMuted` text. Never hide a primary action just because it is disabled; show why it is disabled (for example "Next · 3 parts left").
- Floating action buttons are not used.

### Tabs and other controls
These come from the theme, so plain Material widgets already match:

| Control | Look |
|---|---|
| `TabBar` (in `AppTopBar.bottom`) | White `AppText.chip` labels on the brand colour, a 3dp white underline under the whole selected tab, and `textWhiteSub` for unselected tabs |
| `SegmentedButton` | 2–3 way choices (Pass / Fail). 48dp tall, 8 radius, `borderDark` outline, `accentLight` fill with an `appColor` label when selected |
| `ExpansionTile` | Flat collapsible group with card padding and no dividers. Its chevron is `appColor` when open and `textSecondary` when closed |
| `Switch`, `Checkbox`, `Radio` | `appColor` when on, `borderDark` when off |
| `Badge` | Count dot: `fail` fill with a white `badgeDense` label |
| `Scrollbar` | 4dp thumb, `textMuted` at 60% |

### Icon tiles: `AppIconTile`
An icon on a 10% tint of its own colour. It's the only decorative icon treatment in the app.
- `AppIconTile` is a 40dp rounded square, for dialogs and menu or list rows.
- `AppIconTile.large` is a 64dp circle, for full-area empty, error and success states.

### Cards: `AppCard`
- White, 12 radius, hairline border, no shadow, 16 padding. Pass `onTap` to make the whole card a tap target.
- Show state with `borderColor`: `pass` or `fail` at about 35–45% alpha. Don't fill the card with colour.
- Cards size to their content. Keep one card per item, and put at most one level of grouped content inside a card.

### Inputs: `CustomTextField` / theme `InputDecoration`
- Put a `FieldLabel` above the field. Placeholder text (`AppText.hint`) only gives an example.
- Fields are 48dp tall, white fill, 8 radius, `AppText.input` text.
- Borders: 1dp `border` normally, 1.5dp `appColor` when focused, `fail` for errors.
- The error text goes below the field (`AppText.caption`, `fail`). Don't show a toast for a field error.
- Always set `textInputAction`, and `autofillHints` where it applies.
- Search uses `CustomSearchTextField`, with a search prefix icon and a `SearchClearButton` suffix.

### Chips
| Type | Widget | Look |
|---|---|---|
| Metadata (static) | `InfoChip` | `surface2` fill, 6 radius, `AppText.tag`, optional 14dp (`AppIconSize.xs`) icon |
| Filter (single-select) | `AppFilterChip` (`VehicleFilterChip` wraps it) | 40dp, 8 radius. Selected: brand fill, white check and label. Idle: white with a hairline border. Optional `count` |
| Status | `StatusBadge` | See below. Never use a chip for status |

Filter chips sit in a horizontal scroller with `sm` gaps, aligned to the page gutter.

### Status: `StatusBadge`
Stadium shape, tinted background, 25%-alpha border, icon and `AppText.badge` label. Use the named constructors so a status always looks the same:

- `pass`, `fail`: inspection outcome
- `pending`: waiting for a result, or not started yet
- `inProgress`: work has started but isn't finished
- `completed`: every step finished and nothing failed
- `captured`: media saved on the device but not yet uploaded
- `uploading`, `processing`: work in progress
- `uploaded`: media successfully sent
- `error`: something went wrong
- `neutral`: informational

`StatusBadge.fromResult` converts API "Pass"/"Fail" strings. Use `dense: true` inside tight rows.

### List cards
- **Appointment card (Home, `VehicleClassScreenItem`).** It is compact and scans top to bottom:
  - `RegistrationPlate` with the overall status badge on the right: Pending, In progress, Completed or Failed.
  - The vehicle name and year (`title`), one meta line for class and fuel (`bodySecondary`), and the booking ID (`caption`). Each meta line has a 14dp `na` icon. `AppointmentTime` sits on the right: the time over a relative date ("Today", "Tomorrow", "6 Oct"), with today in `appColor`.
  - After a divider, the stage results ("Manual [Pass]", "AI [Pending]"), then a 4dp stage-progress bar with "1/2" and the action button.
  - The action is a verb for the state: Start, Continue or Open. All three open the same flow.
  - A failed stage tints the border `fail`. The pinned "Current inspection" card is outlined in `appColor`.
  - `AppointmentStatus` (`home_widgets/appointment_status.dart`) derives all of this from the list API's stage statuses. It is display logic only.
- Result cards use the same plate-first layout, with the result and the action in the footer.
- Inspection stages use `StageStatusTable` / `stageStatusBadge`: Pass, Fail, "Not started", or the API value shown as pending.
- Media capture uses `CaptureStatus`: **Required** (amber) → Captured → Uploading → Uploaded, or Upload failed → Retry. The vehicle parts header shows every required slot in one segmented bar (`MediaPipelineSummary`): uploaded, uploading, captured but not sent, failed, then required. Failures raise an `AppBanner.error` whose "Review failed" opens the uploads sheet on its Failed filter, and a finished set shows `AppBanner.success`. The first unfinished part on a step is outlined and badged "Up next".

### Inspection questions (`QuestionTile`)
- A 28dp marker shows the question number, then a green tick (Yes) or a red cross (No) once answered. A 3dp left rail in the same colour lets answered questions stand out while scrolling.
- Answers are two 52dp full-width buttons, "Yes · Pass" and "No · Fail", filled solid when selected.
- A "No" answer opens one **Defect details** panel (`fail` hairline). It holds the severity badge (derived on save, not chosen), the required evidence photo and the optional remark.
- Evidence uses `ImagePickerPrompt` (with an "Uploading photo…" state) and then `ImagePreview`, an 88dp thumbnail with Replace and Remove actions.
- Visual Inspection and Under-PIT Inspection are the same screen in two provider modes, so they share every component. Under-PIT has a single section and no tab strip, so `SectionSummaryCard` names the section with its icon (`AppIconTile`, a tick once complete), its progress and the Pass/Fail/Pending tally.

### AI result
- The screen leads with an **overall verdict** card: FAIL if any check failed, PASS only when every check passed, PENDING while the AI is still analysing, otherwise AI RESULT NOT AVAILABLE. A one-line reason sits under it ("1 of 4 checks failed"), with a segmented bar and legend.
- Each question card reads top to bottom: the question, the **AI result** badge (PASS, FAIL, PENDING or "AI result not available"), the remark, the collapsible result details, then **Change result**. A result changed on this screen is tagged "Changed by you".
- Result details never show technical metadata: timings, request/model IDs and versions, timestamps, paths or URLs.

### Section labels: `SectionHeader`
An UPPERCASE overline above a group ("Settings", "Category", "Remark"). Screen readers treat it as a header. Use `trailing` for a count or a small action.

### Dialogs: `AppDialog` (via `customShowDialog` / `customConfirmationDialogBox`)
- Layout: an `AppIconTile` (tinted 40dp square), then the title (`AppText.dialogTitle`), the message, and equal-width actions with the secondary action first.
- 16 radius, 20 padding, max 420 wide, scrim behind, no shadow.
- Use `iconColor: fail` with `destructive: true` for irreversible actions, `warn` for warnings, and `pass` for a blocking success confirmation.
- Dialogs are for confirmations and blocking alerts only. For anything with input, use a bottom sheet.

### Bottom sheets: `AppBottomSheet`
- Drag handle, optional title (`sectionTitle`) and subtitle. It scrolls, stays above the keyboard, and is limited to 90% of the screen height.
- 16 top radius, 20 padding. Max 640 wide, centred on tablets.
- Open it with `showAppBottomSheet(context: …, builder: …)`, which sets the standard options.
- Editing sheets pass `showClose: true` and `onClose` for a close button beside the title (pass `onClose: null` while saving). The primary action names what it will do ("Update to PASS", "Update remark"), and while nothing has changed it is disabled with a reason ("No changes to update").
- Actions go at the bottom: `SecondaryButton` + `PrimaryButton`.

### Loading
| Situation | Use |
|---|---|
| First load of a list | Skeleton cards shaped like the real ones (`AppSkeleton` + `SkeletonBox`, e.g. `AppointmentCardShimmer`) |
| First load of a screen or panel | `AppLoadingView(message: …)` / `CustomLoader.loader()` (an `AppSpinner.large` with a message) |
| Blocking action (save, upload, sign in) | `CustomLoader.showLoader` overlay, plus `PrimaryButton(loading: true)` |
| Work in progress inside a component | `StatusBadge.uploading` / `.processing` and an `AppProgressBar` (4dp; `value: null` while the amount is unknown) |
| Progress through a flow (photos captured, questions answered) | `AppProgressBar.thick` (6dp) or `CaptureProgressHeader`; turns green at 100% |
| Load more / end of list | `ListFooter`: a small spinner while paging, then "All N … shown" |
| Pull to refresh | `RefreshIndicator`; wrap empty and error states in `PullToRefreshFill` |

Use `AppSpinner` for every spinner: `.large` (32dp) for a whole area, the default (24dp) inline, `.small` (20dp) inside buttons. Pass `color: textWhite` on brand or media surfaces. Don't build spinners or progress bars from raw `CircularProgressIndicator` / `LinearProgressIndicator`.

### Empty, error and success states
| State | Full-area (`AppStateView`) | Inline (`AppBanner`) | Passing (toast/snackbar) |
|---|---|---|---|
| Empty | `.empty`: neutral. Say what's missing and how to get it ("No matching appointments – Try another lane, or pull down to refresh") | `AppBanner.info` | – |
| Error | `.error`: red. Say what failed in plain words and always give a Retry that repeats the same request | `AppBanner.error` with an action ("2 uploads failed · Retry all") | `CustomLoader.showCustomErrorSnackBar` for errors the user needs time to read |
| Warning | – | `AppBanner.warning` ("Location is off") | – |
| Success | `.success`: green, for the end of a flow ("Inspection submitted" plus "Back to home") | `AppBanner.success` ("All parts captured") | `CustomLoader.success` for quick confirmations ("Result updated") |
| Processing (AI / server) | `AppLoadingView` with what is happening ("Loading result…"), or the blocking `CustomLoader.showLoader` | `StatusBadge.processing` / `.pending` ("PENDING" for an AI result still being analysed) | – |
| Uploading | – | `StatusBadge.uploading` plus `AppProgressBar` (indeterminate when no byte progress is reported); summarise many uploads in one segmented bar (`MediaPipelineSummary`) | – |
| Failed (retryable) | – | `StatusBadge.error` ("Upload failed") on the item with a Retry action, plus `AppBanner.error` with "Review failed" when several items failed | `CustomLoader.errorMessage` for a single failure the inspector only needs to read |

**Toasts** (`showAppToast`, through `CustomLoader.message` / `.success` / `.errorMessage`) are in-app, not native. Each has an icon plus text: info on indigo, success on green, error on red. One shows at a time (a new toast replaces the old). They float above bottom action bars and wrap up to three lines. Errors stay four seconds and the others 2.5.

**Error copy** names the kind of failure in plain words ("You're offline…", "The server took too long…"). It never shows exception text, status codes or field names.

Every empty state offers the quickest way back to content: "Clear search" when a search matches nothing, "Show all categories" when a filter is empty, and "Retry" otherwise. Reuse the existing search, filter and refresh paths for these actions; don't add new requests.

Never show stack traces or developer text. Keep one toast at a time and short messages (under about 60 characters).

## Migrating legacy UI

Older screens still use the first-generation widgets. When you touch one, swap it for the design-system equivalent. Change only the presentation: providers, callbacks and navigation stay as they are.

| Legacy | Use instead |
|---|---|
| Raw `AppBar(...)`, dark custom app bars | `AppTopBar` |
| `CustomText(...)`, inline `TextStyle(fontSize: …)`, `GoogleFonts.inter` | `Text` with an `AppText` style |
| `CustomButton` | `PrimaryButton` / `SecondaryButton` / theme inline buttons |
| `EmptyStateWidget`, `ErrorScreen`-style one-offs | `AppStateView.empty` / `.error` / `.success` |
| `StatusChip`, coloured `Container` pills | `StatusBadge` named constructors |
| Raw `AlertDialog` | `AppDialog` (via `customShowDialog`) |
| `ChangeStatusSheet` layout, raw `showModalBottomSheet` | `showAppBottomSheet` + `AppBottomSheet` |
| `CircularProgressIndicator()` | `AppSpinner` |
| `ClipRRect` + `LinearProgressIndicator` | `AppProgressBar` |
| `CustomStepper` | `AppProgressBar.thick` with a "Step X of N" caption |
| Legacy shimmers (`home_shimmer`, `list_shimmer`, `select_vehicle_shimmer`) | `AppSkeleton` + `SkeletonBox` |
| `Colors.black` behind the camera or media | `mediaBg` / `mediaScrim` |
| Legacy colours (`greenColor`, `redColor`, `greyColor`, `cardBackgroundColor`, …) | `pass`, `fail`, `na`/`textSecondary`, `surface2`, … |
| Hex colours, gradients, `BoxShadow` | Tokens; flat surfaces with `border` |
| `fontFamily: "Bold"` strings on a screen | The matching `AppText` style |

## Accessibility checklist
- [ ] Touch targets are at least 48dp. Give small visual controls a padded tap area.
- [ ] Text contrast is at least 4.5:1 and icon contrast at least 3:1 (no `textMuted` for meaningful content).
- [ ] Every icon-only control has a tooltip or `Semantics` label.
- [ ] Status is shown with an icon and text, never colour alone.
- [ ] Long values ellipsize (`maxLines` + `TextOverflow.ellipsis`) instead of overflowing. Registration numbers scale down and are never cut off.
- [ ] Layouts hold at 320dp width and 1.3× text size (covered by `test/*_layout_test.dart`).
