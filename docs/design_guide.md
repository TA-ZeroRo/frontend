# Design Guide

## Colors (AppColors)

Defined in `lib/core/theme/app_color.dart` as the global app color set.

### When to Use

- **Page Backgrounds**: As background colors for `Scaffold` or `Container`
- **Button Styling**: For consistent button design across the app
- **Theme Consistency**: To ensure the same colors are used throughout the app

---

## Typography (AppTextStyle)

Defined in `lib/core/theme/app_text_style.dart` based on the Material Design 3 typography system.

### Typography Hierarchy

#### Display (Screen Titles)

Used for large titles on big screens or landing pages

- `displayLarge`: 57sp – App splash screen, large titles
- `displayMedium`: 45sp – Large section headers
- `displaySmall`: 36sp – Smaller section headers

#### Headline (Headings)

Used for main titles of pages or sections

- `headlineLarge`: 32sp – Page main titles
- `headlineMedium`: 28sp – Key section titles
- `headlineSmall`: 24sp – Subsection titles

#### Title (Subtitles)

Used for titles in cards, dialogs, or list items

- `titleLarge`: 22sp (Medium weight) – Dialog titles, card headers
- `titleMedium`: 16sp (SemiBold weight) – List titles, AppBar titles
- `titleSmall`: 14sp (SemiBold weight) – Smaller list titles

#### Body (Body Text)

Used for general text content

- `bodyLarge`: 16sp – Highlighted body text, important descriptions
- `bodyMedium`: 14sp – Default body text
- `bodySmall`: 12sp – Secondary text, captions

#### Label (Labels)

Used for labels on buttons, tabs, and chips

- `labelLarge`: 14sp (SemiBold) – Large button text
- `labelMedium`: 12sp (SemiBold) – Regular buttons, tab labels
- `labelSmall`: 11sp (SemiBold) – Small chips, badges

---

## Best Practices

### 1. Maintain Consistency

- Always use the same style for identical UI elements
- Keep colors and typography consistent across the app

### 2. Semantic Usage

- Choose styles based on the text’s role and hierarchy
- Follow the order: Display > Headline > Title > Body > Label

### 3. Accessibility Considerations

- Ensure sufficient color contrast (WCAG 2.1 AA standard)
- Use appropriate font sizes (minimum 12sp)
- Maintain proper line height (line spacing)

### 4. Extensibility

- Add new colors or styles in the dedicated files when needed
- Define one-off styles inline within the widget itself
