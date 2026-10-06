# ATS App design system

The rules below keep every screen consistent and readable during real-time vehicle inspection: outdoors, in a hurry, often with one hand.

Everything here is implemented as code. Use the tokens and widgets; don't re-create them with raw numbers.

| What | Where |
|---|---|
| Colours | `lib/utilities/color_data.dart` |
| Typography | `lib/utilities/new_app_theme/app_text.dart` (`AppText`) |
| Spacing / sizes | `lib/utilities/new_app_theme/app_spacing.dart` (`AppSpacing`) |
| Radius | `lib/utilities/new_app_theme/app_radius.dart` (`AppRadius`) |
| Icon sizes | `lib/utilities/new_app_theme/app_icon_size.dart` (`AppIconSize`) |
| Material theme | `lib/utilities/new_app_theme/app_theme.dart` (`AppTheme.light`) |
| Components | `lib/widgets/new_app_ui/` |

## Principles

1. **One brand colour.** `appColor` (#1C3E70) is used for app bars, primary buttons, selection and focus. Every other colour is either neutral or carries a status meaning.
2. **Flat.** Separate surfaces with hairline borders (`border`), not shadows. No gradients. The only shadow left is on popup menus.
3. **Readable first.** Text is at least 11pt. Readable text uses `textPrimary`, `textSecondary` or `na`. `textMuted` is only for placeholders, disabled states and decorative icons.
4. **Big targets.** Anything tappable is at least 48 × 48dp. Primary actions are 52dp tall.
5. **Always say what's happening.** Every async screen has a loading state, an empty state and an error state with Retry.

## Colour

| Token | Use |
|---|---|
| `appColor` | Brand: app bar, primary button, selected chip/tab, focus ring, links |
| `bg` | Page background |
| `surface` | Cards, sheets, dialogs, inputs, bottom bars |
| `surface2` | Neutral fills: disabled buttons, chip backgrounds, progress tracks |
| `border` / `borderDark` | Hairline dividers and card borders / outlined button and input outlines |
| `textPrimary` / `textSecondary` | Main text / supporting text |
| `na` | Captions, overlines, neutral icons (4.7:1 on white) |
| `textMuted` | Placeholders, disabled, decorative only (fails AA for body text) |
| `textWhite` / `textWhiteSub` | Text on `appColor` or dark media |
| `pass` / `passLight` | Pass, success, uploaded |
| `fail` / `failLight` | Fail, error, destructive actions |
| `warn` / `warnLight` | Pending, needs attention |
| `accent` / `accentLight` | In-progress states (uploading, processing); tinted icon backgrounds |
| `scrim` | Overlay behind dialogs, sheets and the blocking loader (set in the theme) |

The legacy colours at the top of `color_data.dart` are only for old screens. Don't use them in new code.

## Typography

The font is Gilroy, bundled as one family per weight. Choose the weight with `fontFamily` (`"Medium"`, `"SemiBold"`, `"Bold"`), never with `fontWeight`.

| `AppText.` | Size | Weight | Use |
|---|---|---|---|
| `display` | 24 | Black | Brand heading on dark (splash, login) |
| `pageTitle` | 20 | Bold | Heading inside page content |
| `sectionTitle` | 16 | Bold | Card, section, sheet and state titles |
| `title` | 15 | SemiBold | List item titles, question text |
| `button` | 15 | SemiBold | Button labels (applied by the theme) |
| `body` | 14 | Medium | Body and input text |
| `bodySecondary` | 13 | Medium | Descriptions, state messages |
| `chip` / `fieldLabel` | 13 | SemiBold | Chips, tabs, meta rows / labels above fields |
| `caption` / `navLabel` | 12 | Medium / SemiBold | Helper text, counters / bottom navigation |
| `overline` | 11 | Bold | UPPERCASE group labels (use `SectionHeader`) |

App bar titles are 18 SemiBold white, set by the theme. The theme's `textTheme` maps to these styles, so a plain `Text` already gets `body`.

## Spacing and layout

The scale is in steps of 4: `xs 4 · sm 8 · md 12 · lg 16 · xl 24 · xxl 32`.

- **Page gutter:** `AppSpacing.page` (16) on the left and right of every screen.
- **Card padding:** `AppSpacing.card` (16).
- **Gaps:** `sm` between related items (label to field, chip to chip), `md` between list cards and form rows, `xl` between sections.
- **Primary action:** goes in a `BottomActionBar` docked at the bottom of the screen. It doesn't float over content.

## Radius

| Token | Value | Use |
|---|---|---|
| `AppRadius.sm` | 8 | Chips, tags, small thumbnails |
| `AppRadius.md` | 12 | Buttons, inputs, capture slots, icon tiles |
| `AppRadius.lg` | 16 | Cards |
| `AppRadius.xl` | 20 | Dialogs, top of bottom sheets |
| Stadium | full | Status badges, pills, filter counts |

Don't nest rounded containers more than one level deep inside a card.

## Icons

Use Material **rounded** icons, or **outlined** for unselected or empty variants.

| `AppIconSize.` | Size | Use |
|---|---|---|
| `sm` | 16 | Next to captions and meta text, inside badges |
| `md` | 20 | Default: buttons, list tiles, field prefixes |
| `lg` | 24 | App bar, bottom navigation, icon buttons |
| `xl` | 32 | Empty, error and loading illustrations |

Icons on their own need a `tooltip` (on `IconButton`) or a `Semantics` label.

## Components

### Buttons
- **`PrimaryButton`:** one per screen or sheet; 52dp, full width. Pass `loading: true` while it runs. Pass `color: fail` for destructive actions.
- **`SecondaryButton`:** an outlined 52dp button. Use it for the second action of a pair (Cancel, Reset). Place it to the left of the primary button, usually with `flex: 1` against the primary's `flex: 2`.
- **Inline buttons:** the theme's `FilledButton` / `OutlinedButton` / `TextButton` (48dp minimum), e.g. "Retest" on a card.
- **Labels:** use verbs ("Sign in", "Save address", "Log out"), not "Yes"/"OK".

### Cards: `AppCard`
- White, 16 radius, hairline border, no shadow. Pass `onTap` to make the whole card a tap target.
- Show state with `borderColor`: `pass` or `fail` at about 35–45% alpha. Don't fill the card with colour.

### Inputs: `CustomTextField` / theme `InputDecoration`
- Put a `FieldLabel` above the field. Placeholder text only gives an example.
- Borders: 1dp `border` normally, 1.5dp `appColor` when focused, `fail` for errors.
- Always set `textInputAction`, and `autofillHints` where it applies.

### Status: `StatusBadge`
Use the named constructors so a status always looks the same:

- `pass`, `fail` – inspection outcome
- `pending` – waiting for a result
- `captured` – media saved on the device but not yet uploaded
- `uploading`, `processing` – work in progress
- `uploaded` – media successfully sent
- `error` – something went wrong
- `neutral` – informational

`StatusBadge.fromResult` converts API "Pass"/"Fail" strings. Badges always pair an icon with text, so status never relies on colour alone.

### Section labels: `SectionHeader`
UPPERCASE overline above a group ("Settings", "Category", "Remark"). It's marked as a header for screen readers.

### Bottom sheets: `AppBottomSheet`
- Drag handle, optional title and subtitle. It scrolls and stays above the keyboard.
- Open it with `showModalBottomSheet(isScrollControlled: true, backgroundColor: Colors.transparent)`. The theme supplies the scrim.
- Actions go at the bottom: `SecondaryButton` + `PrimaryButton`.

### Dialogs: `AppDialog` (via `customShowDialog` / `customConfirmationDialogBox`)
- Tinted icon tile, title, message, and equal-width actions with the secondary first.
- Use `iconColor: fail` with `destructive: true` for irreversible actions.
- Dialogs are for confirmations and blocking alerts only. For anything with input, use a bottom sheet.

### Loading
| Situation | Use |
|---|---|
| First load of a list | Shimmer placeholders shaped like the cards (`HomeShimmer`) |
| First load of a screen or panel | `AppLoadingView(message: …)` / `CustomLoader.loader()` |
| Blocking action (save, upload, sign in) | `CustomLoader.showLoader` overlay, plus `PrimaryButton(loading: true)` |
| Load more | Small spinner at the end of the list |
| Pull to refresh | `RefreshIndicator`; wrap empty and error states in `PullToRefreshFill` |

### Empty and error states: `AppStateView`
- **`AppStateView.empty`:** neutral. Say what's missing and how to get it, e.g. "No matching appointments" or "Try another category, or pull down to refresh".
- **`AppStateView.error`:** red. Say what failed in plain words, and always give a Retry that repeats the same request. Never show stack traces or developer text.

### Feedback messages
- `CustomLoader.message` / `errorMessage`: short toasts for quick confirmations and validation.
- `CustomLoader.showCustomErrorSnackBar`: for errors the user needs time to read.

## Accessibility checklist
- [ ] Touch targets at least 48dp. Give small visual controls a padded tap area.
- [ ] Text contrast at least 4.5:1, icons at least 3:1 (no `textMuted` for meaningful content).
- [ ] Every icon-only control has a tooltip or `Semantics` label.
- [ ] Status shown with an icon and text, never colour alone.
- [ ] Long values ellipsize (`maxLines` + `TextOverflow.ellipsis`) instead of overflowing.
