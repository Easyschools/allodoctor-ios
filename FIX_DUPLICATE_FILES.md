# Fix Duplicate Files Error

## Problem
You're seeing "Multiple commands produce" errors because:
1. ❌ Duplicate model files in Common/Models
2. ❌ Duplicate HospitalProfile folders
3. ❌ Files exist in wrong locations

## Quick Fix (5 minutes)

### Step 1: Delete Duplicate Files in Finder

**Delete these duplicate files:**

```bash
# Navigate to your project
cd /Users/mohamedahmed/Desktop/Company/allodoctor-ios/Allo-Doctor

# Delete duplicate model files
rm "Common/Models/HospitalFilter 2.swift"
rm "Common/Models/UnifiedHospital 2.swift"

# Delete files from wrong location (Utilities/Extentions)
rm "Utilities/Extentions/Cities.swift"
rm "Utilities/Extentions/Favourites.swift"
rm "Utilities/Extentions/DeleteResponse.swift"

# Delete duplicate HospitalProfile folder if it exists
rm -rf "Modules/ServicesModules/HospitalProfile 2"
```

Or run the cleanup script:
```bash
./cleanup_duplicates.sh
```

### Step 2: Clean Xcode

1. **In Xcode:**
   - Product → Clean Build Folder (⌘ + Shift + K)

2. **Delete Derived Data:**
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```

3. **Close and Reopen Xcode**

4. **Build Again:**
   - Product → Build (⌘ + B)

### Step 3: Fix File References in Xcode

If files show as red (missing) in Xcode:

1. Select the red file
2. Press Delete
3. Choose "Remove Reference" (not Move to Trash)
4. Re-add the correct file if needed

---

## What Happened?

The duplicate files were created during the implementation. Here's what should exist:

### ✅ Correct File Locations:

**Models (should only be in Common/Models):**
- `Common/Models/Cities.swift` ✅
- `Common/Models/Favourites.swift` ✅
- `Common/Models/DeleteResponse.swift` ✅
- `Common/Models/UnifiedHospital.swift` ✅
- `Common/Models/HospitalFilter.swift` ✅

**New Cell (only one location):**
- `Modules/ServicesModules/HospitalProfile/RelatedViews/InsuranceCollectionViewCell.swift` ✅

**Old Cell (keep this one):**
- `Modules/ProfileModules/ProfileMedicalInsurance/.../InsuranceCollectionViewCell.swift` ✅

### ❌ Should NOT Exist:

- ~~Common/Models/HospitalFilter 2.swift~~ DELETE
- ~~Common/Models/UnifiedHospital 2.swift~~ DELETE
- ~~Utilities/Extentions/Cities.swift~~ DELETE
- ~~Utilities/Extentions/Favourites.swift~~ DELETE
- ~~Utilities/Extentions/DeleteResponse.swift~~ DELETE
- ~~Modules/ServicesModules/HospitalProfile 2/~~ DELETE FOLDER

---

## Automated Fix

Run this cleanup script:

```bash
cd /Users/mohamedahmed/Desktop/Company/allodoctor-ios
./cleanup_duplicates.sh
```

Then clean and rebuild in Xcode.

---

## Manual Fix in Xcode

If you prefer to do it in Xcode:

1. **In Project Navigator**, look for files with "2" suffix:
   - `HospitalFilter 2.swift`
   - `UnifiedHospital 2.swift`

2. **Right-click** each file → **Delete**

3. Choose **"Move to Trash"** (not just remove reference)

4. Look for **"HospitalProfile 2"** folder and delete it

5. Clean Build Folder and rebuild

---

## After Cleanup

You should have:
- ✅ 0 duplicate files
- ✅ All models in Common/Models only
- ✅ Only one HospitalProfile folder
- ✅ Clean build with no "multiple commands" errors

---

## Verification

After cleanup, run:
```bash
./verify_files.sh
```

Should show all files present with no duplicates.
