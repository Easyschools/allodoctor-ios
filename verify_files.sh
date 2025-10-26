#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🔍 Verifying Hospital-First Flow Files..."
echo ""

# Base directory
BASE_DIR="/Users/mohamedahmed/Desktop/Company/allodoctor-ios/Allo-Doctor"

# Array of required files
declare -a FILES=(
    # Models
    "Common/Models/UnifiedHospital.swift"
    "Common/Models/HospitalFilter.swift"

    # Extensions
    "Utilities/Extentions/Array+Extensions.swift"
    "Utilities/Extentions/Int+Extensions.swift"
    "Utilities/Extentions/Double+Extensions.swift"

    # HospitalSelection Module
    "Modules/Search/HospitalSelection/View/HospitalSelectionViewController.swift"
    "Modules/Search/HospitalSelection/ViewModel/HospitalSelectionViewModel.swift"
    "Modules/Search/HospitalSelection/RelatedViews/HospitalSelectionTableViewCell.swift"
    "Modules/Search/HospitalSelection/RelatedViews/HospitalFilterViewController.swift"
    "Modules/Search/HospitalSelection/RelatedViews/HospitalSortViewController.swift"

    # HospitalProfile Module
    "Modules/ServicesModules/HospitalProfile/View/HospitalProfileViewController.swift"
    "Modules/ServicesModules/HospitalProfile/ViewModel/HospitalProfileViewModel.swift"
    "Modules/ServicesModules/HospitalProfile/RelatedViews/HospitalSpecialtyTableViewCell.swift"
    "Modules/ServicesModules/HospitalProfile/RelatedViews/ReviewCollectionViewCell.swift"
    "Modules/ServicesModules/HospitalProfile/RelatedViews/InsuranceCollectionViewCell.swift"

    # HospitalSpecialty Module
    "Modules/ServicesModules/HospitalSpecialty/View/HospitalSpecialtyViewController.swift"
    "Modules/ServicesModules/HospitalSpecialty/ViewModel/HospitalSpecialtyViewModel.swift"
)

missing_files=0
found_files=0

# Check each file
for file in "${FILES[@]}"; do
    full_path="$BASE_DIR/$file"
    if [ -f "$full_path" ]; then
        echo -e "${GREEN}✓${NC} $file"
        ((found_files++))
    else
        echo -e "${RED}✗${NC} $file ${RED}(MISSING)${NC}"
        ((missing_files++))
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Summary:"
echo -e "${GREEN}Found: $found_files files${NC}"
echo -e "${RED}Missing: $missing_files files${NC}"
echo ""

if [ $missing_files -eq 0 ]; then
    echo -e "${GREEN}✅ All files are in place!${NC}"
    echo ""
    echo "Next step: Add these files to Xcode project"
    echo "Follow the instructions in: FIX_XCODE_ERRORS.md"
else
    echo -e "${RED}❌ Some files are missing!${NC}"
    echo "Please check the file creation process."
fi
