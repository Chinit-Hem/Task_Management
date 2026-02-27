# 🎨 TaskManagement Design System

Complete design specifications for Figma implementation.

---

## 📋 Color Palette

### Primary Colors
| Name | Hex | RGB | Usage |
|------|-----|-----|-------|
| **Primary** | `#4A6CF7` | RGB(74, 108, 247) | Main brand color, buttons, active states |
| **Primary Light** | `#6B7FFF` | RGB(107, 127, 255) | Hover states, highlights |
| **Primary Dark** | `#2A3DB0` | RGB(42, 61, 176) | Pressed states, shadows |
| **Secondary** | `#6C63FF` | RGB(108, 99, 255) | Accents, secondary actions |

### Background Colors
| Name | Hex | RGB | Usage |
|------|-----|-----|-------|
| **Background Light** | `#F5F6FA` | RGB(245, 246, 250) | App background (light mode) |
| **Background White** | `#FFFFFF` | RGB(255, 255, 255) | Cards, surfaces |
| **Background Dark** | `#121212` | RGB(18, 18, 18) | App background (dark mode) |
| **Surface Dark** | `#1E1E1E` | RGB(30, 30, 30) | Cards, surfaces (dark mode) |
| **Card Dark** | `#2C2C2C` | RGB(44, 44, 44) | Elevated cards (dark mode) |

### Text Colors
| Name | Hex | RGB | Usage |
|------|-----|-----|-------|
| **Text Primary** | `#212121` | RGB(33, 33, 33) | Headlines, primary text |
| **Text Secondary** | `#858585` | RGB(133, 133, 133) | Subtitles, hints, placeholders |
| **Text Light** | `#FFFFFF` | RGB(255, 255, 255) | Text on dark backgrounds |

### Semantic Colors
| Name | Hex | RGB | Usage |
|------|-----|-----|-------|
| **Priority High** | `#F44336` | RGB(244, 67, 54) | High priority tasks, errors |
| **Priority Medium** | `#4CAF50` | RGB(76, 175, 80) | Medium priority, success states |
| **Priority Low** | `#3D5CFF` | RGB(61, 92, 255) | Low priority tasks |
| **Error** | `#FF4D4F` | RGB(255, 77, 79) | Error messages, validation |
| **Success** | `#388E3C` | RGB(56, 142, 60) | Success confirmations |
| **Divider** | `#E0E0E0` | RGB(224, 224, 224) | Separators, borders |
| **Input Background** | `#F5F5F5` | RGB(245, 245, 245) | Text field backgrounds |

---

## 🔤 Typography System

### Font Families
| Purpose | Font | Weight Range |
|---------|------|--------------|
| **Primary (Headlines)** | Poppins | 400-700 |
| **Secondary (Body/UI)** | Inter | 400-600 |

### Type Scale

| Style | Font | Size | Weight | Line Height | Letter Spacing | Usage |
|-------|------|------|--------|-------------|----------------|-------|
| **H1** | Poppins | 32px | 700 (Bold) | 40px | -0.5px | Page titles |
| **H2** | Poppins | 24px | 600 (SemiBold) | 32px | 0px | Section headers |
| **H3** | Poppins | 20px | 600 (SemiBold) | 28px | 0px | Card titles, AppBar |
| **H4** | Poppins | 18px | 600 (SemiBold) | 26px | 0px | Subsection titles |
| **Body Large** | Poppins | 16px | 400 (Regular) | 24px | 0px | Primary body text |
| **Body** | Poppins | 14px | 400 (Regular) | 20px | 0px | Secondary text |
| **Body Small** | Poppins | 12px | 400 (Regular) | 16px | 0px | Captions, labels |
| **Button** | Inter | 16px | 600 (SemiBold) | 24px | 0.5px | Button text |
| **Label** | Poppins | 12px | 600 (SemiBold) | 16px | 0.5px | Form labels, nav labels |
| **Chip** | Poppins | 14px | 400 (Regular) | 20px | 0px | Category tags |

---

## 📐 Spacing System

| Token | Value | Usage |
|-------|-------|-------|
| **xs** | 4px | Tight spacing, icon padding |
| **sm** | 8px | Small gaps, compact elements |
| **md** | 16px | Standard padding, card gutters |
| **lg** | 24px | Section padding, large gaps |
| **xl** | 32px | Major section separations |
| **xxl** | 48px | Hero sections, large containers |

### Component Spacing
- **Card Padding**: 16px (internal)
- **Screen Padding**: 24px (horizontal)
- **Section Gap**: 24px (vertical)
- **List Item Gap**: 12px
- **Button Padding**: 24px horizontal, 16px vertical

---

## 🔲 Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| **Small** | 8px | Small buttons, chips, tags |
| **Medium** | 12px | Input fields, small cards |
| **Large** | 16px | Cards, modals, main containers |
| **XL** | 24px | Bottom sheets, large dialogs |
| **Full** | 999px | Pills, circular buttons |

---

## 🎯 Shadow System

### Light Mode
| Level | Shadow | Usage |
|-------|--------|-------|
| **Elevation 0** | None | Flat elements |
| **Elevation 2** | `0 2px 8px rgba(0,0,0,0.08)` | Cards, raised buttons |
| **Elevation 4** | `0 4px 12px rgba(0,0,0,0.12)` | FAB, dropdowns |
| **Elevation 8** | `0 8px 24px rgba(0,0,0,0.16)` | Modals, bottom nav |

### Dark Mode
| Level | Shadow | Usage |
|-------|--------|-------|
| **Elevation 2** | `0 2px 8px rgba(0,0,0,0.3)` | Cards |
| **Elevation 4** | `0 4px 12px rgba(0,0,0,0.4)` | FAB |
| **Elevation 8** | `0 8px 24px rgba(0,0,0,0.5)` | Modals |

---

## 🧩 Component Specifications

### Buttons

#### Primary Button
- **Height**: 56px
- **Padding**: 24px horizontal
- **Background**: Primary (#4A6CF7)
- **Text**: White, Inter 16px SemiBold
- **Border Radius**: 16px
- **Shadow**: Elevation 0 (flat)

#### Secondary/Outlined Button
- **Height**: 48px
- **Padding**: 24px horizontal
- **Background**: Transparent
- **Border**: 1px solid Primary
- **Text**: Primary color, Poppins 16px SemiBold
- **Border Radius**: 12px

### Cards
- **Background**: White (light) / Card Dark #2C2C2C (dark)
- **Border Radius**: 16px
- **Padding**: 16px
- **Shadow**: Elevation 2
- **Elevation**: 2dp

### Input Fields
- **Height**: 56px
- **Background**: Input Background (#F5F5F5)
- **Border Radius**: 12px
- **Padding**: 20px horizontal, 18px vertical
- **Text**: Text Primary, Poppins 14px
- **Placeholder**: Text Secondary, Poppins 14px
- **Focus Border**: 2px solid Primary

### Chips/Tags
- **Height**: 32px
- **Padding**: 12px horizontal
- **Background**: Grey 200 (#E0E0E0) / Grey 800 (dark)
- **Selected**: Primary color
- **Border Radius**: 16px (full)
- **Text**: 14px Poppins

### Bottom Navigation
- **Height**: 80px (including safe area)
- **Background**: White (light) / Surface Dark (dark)
- **Selected Color**: Primary
- **Unselected Color**: Grey
- **Label**: 12px Poppins
- **Elevation**: 8dp shadow

---

## 🎨 Priority Indicators

| Priority | Color | Icon Style |
|----------|-------|------------|
| **High** | #F44336 (Red) | Exclamation mark / Flag |
| **Medium** | #4CAF50 (Green) | Circle / Check |
| **Low** | #3D5CFF (Blue) | Down arrow / Minus |

---

## 📱 Layout Grid

- **Container Max Width**: 600px (mobile-first)
- **Grid Columns**: 4 columns on mobile, 12 on tablet+
- **Gutter**: 16px
- **Margin**: 24px horizontal

---

## 🌓 Dark Mode Mapping

| Light Mode | Dark Mode |
|------------|-----------|
| Background Light (#F5F6FA) | Background Dark (#121212) |
| Background White (#FFFFFF) | Surface Dark (#1E1E1E) |
| Card Background (#FFFFFF) | Card Dark (#2C2C2C) |
| Text Primary (#212121) | Text Light (#FFFFFF) |
| Text Secondary (#858585) | Text Secondary (#858585) |
| Input Background (#F5F5F5) | Card Dark (#2C2C2C) |

---

## 🏷️ Category Colors (Default)

| Category | Suggested Color |
|----------|-----------------|
| Work | #FF6B6B (Coral) |
| Personal | #4ECDC4 (Teal) |
| Urgent | #F44336 (Red) |
| School | #9C27B0 (Purple) |
| Design | #FF9800 (Orange) |
| Development | #2196F3 (Blue) |
| Meeting | #795548 (Brown) |

---

## 📦 Figma Setup Checklist

- [ ] Create Color Styles (all hex values above)
- [ ] Create Text Styles (all typography specs)
- [ ] Create Effect Styles (shadows)
- [ ] Set up 4-column grid (16px gutter, 24px margin)
- [ ] Create Component Library:
  - [ ] Primary Button
  - [ ] Secondary Button
  - [ ] Input Field
  - [ ] Card
  - [ ] Chip/Tag
  - [ ] Task Item
  - [ ] Bottom Nav Bar
  - [ ] App Bar
  - [ ] Priority Badge
  - [ ] Checkbox
  - [ ] Modal/Dialog

---

**Font Import for Figma:**
- Google Fonts: Poppins (weights: 400, 500, 600, 700)
- Google Fonts: Inter (weights: 400, 500, 600)
