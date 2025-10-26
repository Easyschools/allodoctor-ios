# Xcode Integration Guide - Hospital-First Flow

## Overview
This guide will walk you through integrating the hospital-first flow code into your Xcode project.

---

## Step 1: Add New Files to Xcode Project

### 1.1 Add Model Files
1. In Xcode, right-click on `Common/Models` group
2. Select "Add Files to 'Allo-Doctor'..."
3. Navigate to and select:
   - `Common/Models/UnifiedHospital.swift`
   - `Common/Models/HospitalFilter.swift`
4. Ensure "Copy items if needed" is **unchecked** (files are already in the folder)
5. Ensure "Create groups" is selected
6. Click "Add"

### 1.2 Add Extension Files
1. Right-click on `Utilities/Extentions` group
2. Add these files:
   - `Utilities/Extentions/Array+Extensions.swift`
   - `Utilities/Extentions/Int+Extensions.swift`
   - `Utilities/Extentions/Double+Extensions.swift`

### 1.3 Add HospitalSelection Module
1. Right-click on `Modules/Search` group
2. Select "New Group" and name it "HospitalSelection"
3. Inside HospitalSelection, create subgroups:
   - `View`
   - `ViewModel`
   - `RelatedViews`
4. Add files to respective groups:
   - View: `HospitalSelectionViewController.swift`
   - ViewModel: `HospitalSelectionViewModel.swift`
   - RelatedViews: All filter/sort/cell files

### 1.4 Add HospitalProfile Module
1. Right-click on `Modules/ServicesModules` group
2. Create "HospitalProfile" group with subgroups: View, ViewModel, RelatedViews
3. Add all HospitalProfile files to respective groups

### 1.5 Add HospitalSpecialty Module
1. Right-click on `Modules/ServicesModules` group
2. Create "HospitalSpecialty" group with subgroups: View, ViewModel
3. Add HospitalSpecialty files

---

## Step 2: Create XIB Files

### 2.1 HospitalSelectionViewController.xib

**Create XIB:**
1. Right-click on `Modules/Search/HospitalSelection/View`
2. New File → User Interface → View
3. Name it `HospitalSelectionViewController.xib`

**Configure File's Owner:**
1. Select "File's Owner" in Document Outline
2. In Identity Inspector, set Class to `HospitalSelectionViewController`

**Add UI Elements:**
```
- UIView (Main View)
  ├── UIView (upperView) - top section with rounded bottom corners
  │   ├── CustomNavigationBackButton (navBackButton)
  │   ├── SearchView (searchBar)
  │   ├── UIButton (filterButton) - "Filter"
  │   └── UIButton (sortButton) - "Sort"
  ├── UITableView (hospitalsTableView)
  ├── UIStackView (noResultsStackView) - hidden by default
  │   ├── UIImageView - empty state icon
  │   └── UILabel - "No hospitals found"
  └── UIActivityIndicatorView (loadingIndicator) - centered
```

**Connect Outlets:**
- Right-click File's Owner → Drag to connect each @IBOutlet
- Connect actions (@IBAction) for buttons

**Auto Layout Constraints:**
- upperView: top, leading, trailing to superview; height 180
- searchBar: inside upperView with margins
- hospitalsTableView: below upperView, leading, trailing, bottom to superview
- noResultsStackView: center in superview
- loadingIndicator: center in superview

### 2.2 HospitalSelectionTableViewCell.xib

**Create Cell XIB:**
1. New File → User Interface → Empty
2. Name it `HospitalSelectionTableViewCell.xib`
3. Add TableView Cell from Object Library
4. Set Class to `HospitalSelectionTableViewCell` in Identity Inspector
5. Set Identifier to `HospitalSelectionTableViewCell`

**Add UI Elements:**
```
- UITableViewCell
  └── contentView
      └── UIView (containerView) - with shadow
          ├── UIImageView (hospitalImageView) - 80x80, rounded
          ├── UILabel (hospitalNameLabel) - bold, 16pt
          ├── UILabel (hospitalAddressLabel) - gray, 14pt
          ├── UIStackView (ratingStackView) - horizontal
          │   ├── UIImageView (starImageView) - star.fill
          │   ├── UILabel (ratingLabel)
          │   └── UILabel (reviewsCountLabel) - gray
          ├── UILabel (distanceLabel) - blue, 12pt
          ├── UILabel (districtLabel) - gray, 12pt
          └── UILabel (specialtiesCountLabel) - green, 12pt
```

**Cell Height:** Set to 120pt minimum

### 2.3 HospitalFilterViewController.xib

**UI Elements:**
```
- UIView
  ├── UILabel (titleLabel) - "Filter Hospitals"
  ├── UILabel - "Districts"
  ├── UICollectionView (districtsCollectionView) - flow layout, horizontal scroll
  ├── UILabel - "Specialties"
  ├── UICollectionView (specialtiesCollectionView) - flow layout, horizontal scroll
  ├── UILabel - "Minimum Rating"
  ├── UISegmentedControl (ratingSegmentedControl)
  ├── UIButton (applyButton) - "Apply Filters", blue
  └── UIButton (clearButton) - "Clear All", gray
```

### 2.4 FilterOptionCollectionViewCell.xib

**Simple Chip Design:**
```
- UICollectionViewCell
  └── contentView
      └── UIView (containerView) - rounded, bordered
          └── UILabel (titleLabel) - center aligned
```

**Size:** Auto-sizing based on content

### 2.5 HospitalSortViewController.xib

**UI Elements:**
```
- UIView (height ~300)
  ├── UILabel (titleLabel) - "Sort By"
  └── UITableView (sortTableView) - 4 rows, no scroll
```

### 2.6 SortOptionTableViewCell.xib

```
- UITableViewCell
  └── contentView
      ├── UILabel (titleLabel)
      └── UIImageView (checkmarkImageView) - checkmark icon, trailing
```

**Height:** 50pt

### 2.7 HospitalProfileViewController.xib

**Complex Layout with ScrollView:**
```
- UIScrollView (scrollView)
  └── UIStackView (vertical, fill)
      ├── UIImageView (headerImageView) - height 200
      ├── UIView - Hospital Info Section
      │   ├── UILabel (hospitalNameLabel) - bold, 20pt
      │   ├── UILabel (hospitalAddressLabel)
      │   ├── UIStackView (ratingStackView)
      │   ├── UILabel (descriptionLabel) - multiline
      │   └── UILabel (aboutLabel) - multiline
      ├── UIStackView (horizontal) - Action Buttons
      │   ├── UIButton (phoneButton) - "Call"
      │   ├── UIButton (locationButton) - "Location"
      │   └── UIButton (favoriteButton) - heart icon
      ├── UILabel (specialtiesTitleLabel) - "Available Specialties"
      ├── UITableView (specialtiesTableView) - dynamic height
      ├── UILabel (reviewsTitleLabel) - "Reviews"
      ├── UICollectionView (reviewsCollectionView) - horizontal
      ├── UILabel (insuranceTitleLabel) - "Accepted Insurance"
      └── UICollectionView (insuranceCollectionView) - horizontal
```

**Important:** Add height constraint to specialtiesTableView and connect to `specialtiesTableHeightConstraint` outlet

### 2.8 HospitalSpecialtyTableViewCell.xib

```
- UITableViewCell (height 80)
  └── contentView
      └── UIView (containerView) - rounded, bordered
          ├── UIImageView (specialtyIconImageView) - 50x50
          ├── UILabel (specialtyNameLabel) - bold
          ├── UILabel (specialtyDescriptionLabel) - 2 lines, gray
          ├── UILabel (doctorsCountLabel) - blue, small
          └── UIImageView (arrowImageView) - chevron.right
```

### 2.9 ReviewCollectionViewCell.xib

```
- UICollectionViewCell (280x120)
  └── contentView
      └── UIView (containerView) - rounded, bordered
          ├── UIImageView (userImageView) - 40x40, circle
          ├── UILabel (userNameLabel) - bold
          ├── UIStackView (starStackView) - horizontal, 5 star images
          ├── UILabel (ratingLabel)
          ├── UILabel (commentLabel) - 3 lines
          └── UILabel (dateLabel) - gray, small
```

### 2.10 InsuranceCollectionViewCell.xib

```
- UICollectionViewCell (80x80)
  └── contentView
      └── UIView (containerView) - rounded
          ├── UIImageView (insuranceImageView) - 60x60
          └── UILabel (insuranceNameLabel) - 2 lines, center, small
```

### 2.11 HospitalSpecialtyViewController.xib

```
- UIView
  ├── CustomNavigationBackButton (navBackButton)
  ├── UILabel (specialtyNameLabel) - bold, 20pt
  ├── UILabel (specialtyDescriptionLabel) - multiline
  ├── UILabel (doctorsCountLabel)
  ├── UITableView (doctorsTableView)
  ├── UIStackView (noResultsStackView) - hidden
  └── UIActivityIndicatorView (loadingIndicator)
```

**DoctorCell is inline** in the ViewController file (SpecialtyDoctorTableViewCell)

---

## Step 3: Design Guidelines

### Colors
Use existing app colors from `UIColor+Extention.swift`:
- Primary Blue: `.darkBlue_295DA8`
- Gray Text: `.lightGray`
- Success Green: `.systemGreen`
- Error Red: `.systemRed`
- Background: `.white`

### Fonts
- Titles: `UIFont.boldSystemFont(ofSize: 18-20)`
- Body: `UIFont.systemFont(ofSize: 14-16)`
- Small text: `UIFont.systemFont(ofSize: 12)`

### Spacing
- Standard padding: 16pts
- Tight padding: 8pts
- Section spacing: 24pts

### Rounded Corners
- Cards: 12pts radius
- Buttons: 8pts radius
- Images: 8pts radius

### Shadows (for cards)
```swift
layer.shadowColor = UIColor.black.cgColor
layer.shadowOpacity = 0.1
layer.shadowOffset = CGSize(width: 0, height: 2)
layer.shadowRadius = 4
```

---

## Step 4: Update Existing XIBs (if needed)

The code is backward compatible with existing screens. No changes needed to existing XIBs.

---

## Step 5: Build and Test

### 5.1 Clean Build
1. Product → Clean Build Folder (Cmd+Shift+K)
2. Close and reopen Xcode
3. Build (Cmd+B)

### 5.2 Fix Build Errors

**Common Errors:**

**Error: "Cannot find type 'HospitalServiceType' in scope"**
- Solution: Make sure `HospitalFilter.swift` is added to project target

**Error: "Use of unresolved identifier 'FWIPNSheetViewController'"**
- Solution: FittedSheets library already exists in project, check imports

**Error: "Cannot find 'NSLocalizedString' in scope"**
- Solution: Import Foundation in the file

**Error: Missing XIB file**
- Solution: Create the XIB as described above

### 5.3 Run on Simulator
1. Select iPhone 14 Pro simulator (or your preference)
2. Product → Run (Cmd+R)
3. Navigate to Services → Hospitals or Clinics
4. Test the new flow

---

## Step 6: Connect to Backend

### 6.1 Backend Team Checklist
Share with backend team:

**New Endpoints Needed:**
1. `GET /admin/hospital/all` - Returns list of hospitals with filters
2. `GET /admin/hospital/get?id={id}` - Returns hospital profile with specialties
3. `GET /admin/hospital/specialties?hospital_id={id}` - Returns specialties for hospital
4. `GET /admin/hospital/specialty-detail?hospital_id={id}&specialty_id={id}` - Doctors in specialty
5. `GET /admin/district/all` - Returns districts for filtering
6. `GET /admin/speciality/all` - Already exists, confirm it returns specialty list

**Expected Response Formats:**
Refer to models in `UnifiedHospital.swift` for exact JSON structure.

### 6.2 API Testing

**Test with Mock Data:**
If backend is not ready, you can temporarily modify the ViewModels to return mock data:

```swift
// In HospitalSelectionViewModel.swift
func fetchHospitals() {
    // TEMPORARY: Mock data for testing
    let mockHospitals = [
        UnifiedHospital(id: 1, name: "Test Hospital", ...),
        UnifiedHospital(id: 2, name: "Another Hospital", ...)
    ]
    self.hospitals = mockHospitals
    self.applyFiltersLocally()
}
```

**Remove mock data** once backend is ready.

---

## Step 7: Testing Checklist

### Functional Testing
- [ ] Hospital selection screen loads
- [ ] Search filters hospitals correctly
- [ ] Filter by district works
- [ ] Filter by specialty works
- [ ] Sort by name/rating/distance works
- [ ] Selecting hospital navigates to profile
- [ ] Hospital profile displays correctly
- [ ] Specialties list shows all items
- [ ] Selecting specialty shows doctors
- [ ] Doctor list displays with all information
- [ ] Back navigation works throughout
- [ ] Arabic language displays correctly (RTL)
- [ ] Empty states show when no data

### UI Testing
- [ ] All images load correctly
- [ ] Text doesn't overlap or truncate
- [ ] Buttons are tappable
- [ ] ScrollViews scroll smoothly
- [ ] Loading indicators show/hide properly
- [ ] Colors match design
- [ ] Spacing is consistent
- [ ] Works on different screen sizes (SE, Pro Max)

### Integration Testing
- [ ] All sub-services route through hospital selection
- [ ] Filter presets work (One Day Care, Operations, etc.)
- [ ] Favorites add/remove works
- [ ] Call button opens phone app
- [ ] Location button works (if map integration exists)
- [ ] Navigate to doctor profile works
- [ ] Booking flow works end-to-end

---

## Step 8: Common Issues & Solutions

### Issue: XIB Not Loading
**Symptom:** Black screen or crash when opening screen
**Solution:**
1. Check File's Owner class name matches ViewController
2. Verify all outlets are connected
3. Check view is set as "view" outlet on File's Owner

### Issue: TableView/CollectionView Not Showing Data
**Symptom:** Blank list even though data exists
**Solution:**
1. Check cell identifier matches in code and XIB
2. Verify cell XIB is added to project target
3. Check `registerCell()` is called in setupUI
4. Confirm dataSource and delegate are set

### Issue: Constraints Breaking
**Symptom:** Auto Layout warnings in console
**Solution:**
1. Check all constraints have proper priorities
2. Verify no conflicting constraints
3. Set `translatesAutoresizingMaskIntoConstraints = false` if creating views programmatically

### Issue: Images Not Loading
**Symptom:** Placeholder or broken images
**Solution:**
1. Verify URL is valid and image exists
2. Check network permissions in Info.plist
3. Confirm `UIImageView+Extentions.swift` is in project
4. Test with a known working image URL

### Issue: Localization Not Working
**Symptom:** Showing keys instead of translated text
**Solution:**
1. Verify .strings files are in project
2. Check strings match exactly (case-sensitive)
3. Confirm LocalizationManager is working for other screens
4. Clean build and retry

---

## Step 9: Performance Optimization (Optional)

### Image Caching
Consider adding Kingfisher pod for better image loading:
```ruby
pod 'Kingfisher'
```

Then replace `loadImage(from:)` with:
```swift
imageView.kf.setImage(with: URL(string: urlString))
```

### Table View Performance
- Use `estimatedRowHeight` for dynamic cells
- Implement `prepareForReuse()` in cells
- Cache calculated heights if needed

### Network Performance
- Implement pagination for large hospital lists
- Add pull-to-refresh
- Cache filter options locally

---

## Step 10: Final Checklist Before Release

- [ ] All XIBs created and working
- [ ] All backend APIs connected
- [ ] Testing completed
- [ ] No console warnings or errors
- [ ] Memory leaks checked with Instruments
- [ ] Works in both Portrait and Landscape (if supported)
- [ ] Accessibility labels added (for VoiceOver)
- [ ] Analytics events added (if using analytics)
- [ ] Error handling covers all cases
- [ ] Loading states implemented everywhere
- [ ] Offline behavior handled gracefully

---

## Getting Help

If you encounter issues:

1. **Check Implementation Guide:** `HOSPITAL_FIRST_FLOW_IMPLEMENTATION.md`
2. **Check Main Docs:** `claude.md`
3. **Console Logs:** Enable detailed logging in ViewModels
4. **Breakpoints:** Set breakpoints in navigation methods to debug flow
5. **Compare with Existing:** Look at similar screens (DoctorSearch, etc.) for reference

---

## Quick Reference: File Locations

```
Models:
├── Common/Models/UnifiedHospital.swift
└── Common/Models/HospitalFilter.swift

Extensions:
├── Utilities/Extentions/Array+Extensions.swift
├── Utilities/Extentions/Int+Extensions.swift
└── Utilities/Extentions/Double+Extensions.swift

Hospital Selection:
├── Modules/Search/HospitalSelection/View/
│   ├── HospitalSelectionViewController.swift
│   └── HospitalSelectionViewController.xib
├── Modules/Search/HospitalSelection/ViewModel/
│   └── HospitalSelectionViewModel.swift
└── Modules/Search/HospitalSelection/RelatedViews/
    ├── HospitalSelectionTableViewCell.swift + .xib
    ├── HospitalFilterViewController.swift + .xib
    └── HospitalSortViewController.swift + .xib

Hospital Profile:
├── Modules/ServicesModules/HospitalProfile/View/
│   ├── HospitalProfileViewController.swift
│   └── HospitalProfileViewController.xib
├── Modules/ServicesModules/HospitalProfile/ViewModel/
│   └── HospitalProfileViewModel.swift
└── Modules/ServicesModules/HospitalProfile/RelatedViews/
    ├── HospitalSpecialtyTableViewCell.swift + .xib
    ├── ReviewCollectionViewCell.swift + .xib
    └── InsuranceCollectionViewCell.swift + .xib

Hospital Specialty:
└── Modules/ServicesModules/HospitalSpecialty/
    ├── View/HospitalSpecialtyViewController.swift + .xib
    └── ViewModel/HospitalSpecialtyViewModel.swift

Updated Files:
├── Services/NetworkLayer/APIRouter/ApiRouter.swift
├── Utilities/Coordinator/HomeCoordinator/HomeCoordinator.swift
├── Modules/TabBarModules/Services/View/ServicesViewController.swift
├── Modules/TabBarModules/Services/ViewModel/ServicesViewModel.swift
└── Modules/ServicesModules/SubService/View/SubServiceViewController.swift
```

---

*Last Updated: 2025-10-26*
*For Allo-Doctor iOS App - Hospital-First Flow*
