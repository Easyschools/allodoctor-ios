#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🧹 Cleaning up duplicate files..."
echo ""

cd /Users/mohamedahmed/Desktop/Company/allodoctor-ios/Allo-Doctor

# Delete duplicate model files with "2" suffix
echo "Removing duplicate model files..."
if [ -f "Common/Models/HospitalFilter 2.swift" ]; then
    rm "Common/Models/HospitalFilter 2.swift"
    echo -e "${GREEN}✓${NC} Deleted: HospitalFilter 2.swift"
else
    echo -e "${YELLOW}⊘${NC} Not found: HospitalFilter 2.swift (already clean)"
fi

if [ -f "Common/Models/UnifiedHospital 2.swift" ]; then
    rm "Common/Models/UnifiedHospital 2.swift"
    echo -e "${GREEN}✓${NC} Deleted: UnifiedHospital 2.swift"
else
    echo -e "${YELLOW}⊘${NC} Not found: UnifiedHospital 2.swift (already clean)"
fi

# Delete model files from wrong location (Utilities/Extentions)
echo ""
echo "Removing files from wrong location (Utilities/Extentions)..."

if [ -f "Utilities/Extentions/Cities.swift" ]; then
    rm "Utilities/Extentions/Cities.swift"
    echo -e "${GREEN}✓${NC} Deleted: Utilities/Extentions/Cities.swift"
else
    echo -e "${YELLOW}⊘${NC} Not found: Cities.swift in Extentions (already clean)"
fi

if [ -f "Utilities/Extentions/Favourites.swift" ]; then
    rm "Utilities/Extentions/Favourites.swift"
    echo -e "${GREEN}✓${NC} Deleted: Utilities/Extentions/Favourites.swift"
else
    echo -e "${YELLOW}⊘${NC} Not found: Favourites.swift in Extentions (already clean)"
fi

if [ -f "Utilities/Extentions/DeleteResponse.swift" ]; then
    rm "Utilities/Extentions/DeleteResponse.swift"
    echo -e "${GREEN}✓${NC} Deleted: Utilities/Extentions/DeleteResponse.swift"
else
    echo -e "${YELLOW}⊘${NC} Not found: DeleteResponse.swift in Extentions (already clean)"
fi

# Delete duplicate HospitalProfile folder
echo ""
echo "Checking for duplicate HospitalProfile folder..."

if [ -d "Modules/ServicesModules/HospitalProfile 2" ]; then
    rm -rf "Modules/ServicesModules/HospitalProfile 2"
    echo -e "${GREEN}✓${NC} Deleted: HospitalProfile 2 folder"
else
    echo -e "${YELLOW}⊘${NC} Not found: HospitalProfile 2 folder (already clean)"
fi

# Delete duplicate HospitalSpecialty folder if exists
if [ -d "Modules/ServicesModules/HospitalSpecialty 2" ]; then
    rm -rf "Modules/ServicesModules/HospitalSpecialty 2"
    echo -e "${GREEN}✓${NC} Deleted: HospitalSpecialty 2 folder"
else
    echo -e "${YELLOW}⊘${NC} Not found: HospitalSpecialty 2 folder (already clean)"
fi

# Delete duplicate HospitalSelection folder if exists
if [ -d "Modules/Search/HospitalSelection 2" ]; then
    rm -rf "Modules/Search/HospitalSelection 2"
    echo -e "${GREEN}✓${NC} Deleted: HospitalSelection 2 folder"
else
    echo -e "${YELLOW}⊘${NC} Not found: HospitalSelection 2 folder (already clean)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✅ Cleanup Complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Open Xcode"
echo "2. Product → Clean Build Folder (⌘⇧K)"
echo "3. Delete Derived Data: rm -rf ~/Library/Developer/Xcode/DerivedData"
echo "4. Close and reopen Xcode"
echo "5. Product → Build (⌘B)"
echo ""
echo "All 'Multiple commands produce' errors should be gone!"
