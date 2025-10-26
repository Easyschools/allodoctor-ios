# Allo-Doctor iOS App - Complete Technical Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Project Structure](#project-structure)
4. [Main Modules](#main-modules)
5. [Networking Layer](#networking-layer)
6. [Data Models](#data-models)
7. [Authentication](#authentication)
8. [Core Services](#core-services)
9. [Key Files Reference](#key-files-reference)

---

## Project Overview

**Project Name:** Allo-Doctor
**Platform:** iOS (Swift)
**Architecture:** MVVM + Coordinator Pattern
**Current Branch:** feature-message-attachment
**Base API URL:** https://backend.allo-doctor.com/api

### Purpose
Healthcare platform connecting users with doctors, pharmacies, labs, and emergency services across multiple Egyptian cities.

---

## Architecture

### Design Patterns

#### 1. **MVVM (Model-View-ViewModel)**
Each feature follows this structure:
- **ViewController**: UI updates and user interactions
- **ViewModel**: Business logic, state management, API calls using Combine publishers
- **Model**: Codable data structures

#### 2. **Coordinator Pattern**
- **AppCoordinator**: Root coordinator managing app-level navigation
- **HomeCoordinator**: Manages all in-app navigation flows (89+ navigation methods)
- **NavigationModules**: Separate coordinators for Auth, Doctor, Pharmacy flows

#### 3. **Reactive Programming**
- **Combine Framework**: Publishers/Subscribers for reactive data binding
- **BaseViewController**: Generic ViewController with ViewModel support
- **@Published properties**: ViewModel state propagation

### External Frameworks
- Alamofire: HTTP networking
- Firebase: Push notifications, FCM tokens
- GoogleMaps & GooglePlaces: Map integration and location
- Reachability: Network status monitoring
- FittedSheets: Custom sheet presentations

---

## Project Structure

```
Allo-Doctor/
├── AppDelegate.swift                    # Firebase, FCM, notifications
├── SceneDelegate.swift                  # App coordinator initialization
├── Bases/
│   └── BaseViewController.swift          # Generic base VC
├── Common/
│   ├── Models/                          # Shared data models
│   ├── SharedDataManager/               # Data caching
│   └── UIViews/                         # Reusable UI components
├── Modules/                             # Feature modules
│   ├── AuthModules/                     # Authentication flow
│   ├── TabBarModules/                   # Main tabs
│   ├── ServicesModules/                 # Healthcare services
│   ├── SubServicesModules/              # Operations, ICU, home care
│   ├── EmergencyModule/                 # Emergency requests
│   ├── ChatModule/                      # Messaging
│   ├── ProfileModules/                  # Profile management
│   └── Search/                          # Search functionality
├── Services/                            # Core services
│   ├── NetworkLayer/                    # API client & router
│   ├── UserDefault/                     # Persistence
│   ├── Localization/                    # Multi-language
│   └── Firebase/                        # Push notifications
└── Utilities/                           # Helpers, extensions, constants
```

---

## Main Modules

### 1. Authentication Module (`Modules/AuthModules/`)

**Screens:**
- `LaunchScreen`: App initialization
- `OnBoardingScreens`: Welcome/tutorial
- `SelectLanguage`: Language selection (en/ar)
- `PhoneNumber`: Phone number input with validation
- `OTPScreen`: OTP verification
- `Register`: User registration (name, gender, age, district)
- `UserModule/`: Address management

**Flow:**
```
Launch → Language Selection → Phone Number → OTP → Registration → Tab Bar
```

**Key Models:**
- `UserDataResponse`: id, name, gender, age, phone_number, district_id, token
- `OtpVerifyResponse`: OTP verification data
- `LoginResponse`: Complete user profile

---

### 2. Tab Bar Modules (`Modules/TabBarModules/`)

**Main Tabs:**
1. **Services**: Browse healthcare services (doctors, pharmacies, labs, etc.)
2. **MyActivity**: User bookings, appointments, orders
3. **Offers**: Promotional banners and offers
4. **MyProfile**: User profile management
5. **Review**: Submit ratings and reviews

---

### 3. Services Modules (`Modules/ServicesModules/`)

#### A. Doctor Services
- `DoctorProfile`: View doctor details, ratings, services
- `AppointmentDoctorTime`: Browse available appointment slots
- `BookingConfirmation`: Confirm appointment booking

**Key Models:**
```swift
DoctorProfile:
  - id, name, title, gender, description
  - rate (avg_rating), reviews_count
  - price, price_after_discount
  - waiting_time (minutes)
  - services, speciality, images
  - lat, long, address, district
```

#### B. Pharmacy Services
- `PharmacyHome`: Browse pharmacies with location filtering
- `PharmacyCategory`: Product categories
- `PharmacyProducts`: Browse products by category
- `ProductDetails`: Detailed product information
- `PharmacyCart`: Shopping cart management
- `PharmaciesCart`: Multi-pharmacy orders
- `PharmacyOrder`: Order placement and tracking
- `PharmacyGlobalSearch`: Search across all pharmacies
- `UploadPrescription`: Upload prescription images
- `Payment`: Payment gateway integration

**Key Models:**
```swift
Pharmacy:
  - id, name, title, description
  - address, lat, long, distance
  - delivery_time, delivery_fees, pickup
  - categories, avg_rating, reviews_count

Product:
  - id, name, description
  - price, quantity
  - category_id, pharmacy_id
  - image, stock status
```

#### C. Labs & Scans
- `LabsAndScanProfile`: Lab information and services
- `LabsAndScanAppointments`: Schedule appointments
- `LabsAndScanBooking`: Confirm booking

#### D. Clinic Profile
- `ClinicProfile`: Clinic information
- `AboutClinic`: Clinic details
- `ClinicDoctors`: Doctors at clinic
- `ClinicInsurance`: Insurance acceptance
- `Reviews`: Clinic reviews

---

### 4. Sub-Services Modules (`Modules/SubServicesModules/`)

#### Operations
- `OperationSearch`: Find surgical procedures
- `OperationHospitals`: Available hospitals
- `OperationAppointments`: Schedule operations
- `OperationBooking`: Confirm operation booking
- `OperationProcedure`: View procedure details

#### One Day Care
- `OneDayCareHospitals`: Find day care facilities
- `OneDayCareProfile`: Hospital profile
- `OneDayCareAppointments`: Book appointments

#### Intensive Care & Incubations
- `IntensiveCareUnits`: Browse ICU options
- `IntensiveCareBooking`: Book ICU beds
- `Incubations`: Book incubator services

#### Home Services
- `HomeVisit`: Schedule doctor home visits
- `HomeNursing`: Schedule nursing services

---

### 5. Emergency Module (`Modules/EmergencyModule/`)
- Emergency request booking
- Patient/Other person modes
- Location submission
- Rapid response booking

---

### 6. Chat Module (`Modules/ChatModule/`)
- `SelectChatType`: Choose chat recipient type
- `ChatService`: Real-time messaging

**Models:**
```swift
ChatMessage:
  - receiver_id, sender_id, sender_name
  - message, support_type
  - attachment_url (optional)

chatType Enum:
  - doctor_customer_service
  - customer_service
```

---

### 7. Profile Modules (`Modules/ProfileModules/`)
- `ProfileEdit`: Edit user information
- `ProfileFavourites`: Saved favorites
- `ProfileMedical`: Medical records
- `ProfileMedicalInsurance`: Manage insurance
- `ProfileSettings`: App settings
- `ProfileSupport`: Customer support
- `ChangeLanguage`: Language selection

---

### 8. Search Modules (`Modules/Search/`)
- `GlobalSearch`: Search across all entities
- `DoctorSearch`: Find doctors with filters (type, rating, price, waiting time)
- `ClinicSearch`: Find clinics
- `LabsSearch`: Find labs and scan centers
- `HospitalSearch`: Find hospitals

---

## Networking Layer

### Architecture

**File Structure:**
```
Services/NetworkLayer/
├── APIRouter/ApiRouter.swift          # 67+ endpoint routes
├── APIClient/APIClient.swift          # HTTP request handling
├── APIClient/AlamoFire/               # Alamofire wrapper
├── AuthManger/AuthManger.swift        # Token management
└── APIConstants/ApiConstants.swift    # Base URL, headers
```

### Key API Endpoints (67+ total)

#### Authentication
```
POST /auth/register                    # User registration
POST /auth/save-fcm-token              # Firebase token registration
```

#### User Management
```
GET /admin/user/get                    # Fetch user details
PUT /admin/user/update                 # Update user profile
```

#### Services & Specialties
```
GET /admin/service/all                 # All healthcare services
GET /admin/speciality/all              # Medical specialties
GET /admin/sub-service/all             # Sub-services
```

#### Doctors
```
GET /admin/doctor/all                  # List doctors
GET /admin/appointment-doctor/get-available-appointment  # Slots
POST /admin/booking/create             # Book appointment
```

#### Pharmacies
```
GET /admin/pharmacy/all                # Pharmacies with location
GET /admin/filter/all-medications      # Products with filtering
POST /admin/cart/create                # Add to cart
GET /admin/order/grand-total           # Cart total
POST /admin/order/create               # Create order
DELETE /admin/cart/delete              # Remove from cart
```

#### Labs & Scans
```
GET /admin/lab/get                     # Lab information
GET /admin/appointment-lab/get-available-appointment  # Slots
```

#### Operations
```
GET /admin/operation/all               # Operations list
POST /admin/operation/booking-operation  # Book operation
GET /admin/procedure/get               # Procedure details
```

#### Home Services
```
POST /admin/home-visit/create          # Book home visit
POST /admin/nurse-visit/create         # Book nursing
POST /admin/incubator/create           # Book incubation
POST /admin/intensive-care/create      # Book intensive care
```

#### Emergency
```
POST /admin/emergency/create           # Request emergency
```

#### Favorites
```
POST /admin/favorite/create            # Add to favorites
GET /admin/favorite/all                # Get all favorites
DELETE /admin/favorite/delete          # Remove favorite
```

#### Chat
```
POST /admin/chat/send-message          # Send message with attachment
```

#### Medical Info
```
GET /admin/medical-info/get            # Medical records
POST /admin/medical-info/create        # Add medical info
PUT /admin/medical-info/update         # Update medical info
```

#### Offers & Banners
```
GET /admin/offer/all                   # Promotional offers
GET /admin/offer/all?banner=1          # App banners
```

#### Bookings
```
GET /admin/my-bookings/all             # User bookings
DELETE /admin/my-bookings/delete       # Cancel booking
```

### HTTP Methods
- **GET**: Fetching data
- **POST**: Creating resources (registration, bookings, orders)
- **PUT**: Updating resources (user profile, medical data)
- **DELETE**: Removing resources (cart items, favorites)

### Authentication
- Token stored in UserDefaults: `"User_Token"`
- Header format: `"Authorization": "Bearer <token>"`
- Managed by `AuthManager.shared.getAuthorizationHeader()`
- Auto-included in all requests via APIRouter

### APIClient Features

**Request Types:**
1. `fetchData()`: GET requests with Decodable response
2. `postData()`: POST requests with JSON body
3. `postDataImage()`: Multipart form-data with images
4. `sendImageAttachment()`: Chat message attachments
5. `fetchAllPages()`: Recursive pagination support

**Response Handling:**
- Automatic JSON decoding via Codable
- Error response parsing with `ErrorResponse` struct
- Status code validation (200-299)
- Custom `NetworkError` enum

**Publisher Pattern:**
```swift
APIClient.shared.fetchData(from: url, as: [DoctorProfile].self)
    .receive(on: DispatchQueue.main)
    .sink { completion in ... }
    receiveValue: { doctors in ... }
```

---

## Data Models

### User Models

```swift
RegisterResponse / UserDataResponse:
  - id: Int
  - name: String
  - gender: String
  - age: String
  - phone_number: String
  - district_id: Int
  - default_language: String
  - token: String

LoginResponse:
  - id, name, gender, age, phone, email
  - active, otp, otp_expires_at
  - default_language, default_country
  - image, district_id, token
```

### Appointment Models

```swift
DoctorAppointment:
  - appointment_day_hour_id
  - day: DoctorDay
  - hour: [DoctorHour]

DoctorDay:
  - id, name_en, name_ar, available, date

DoctorHour:
  - id, from, to, appointment_day_hour_id
```

### Order Models

```swift
PharmacyCart:
  - pharmacy_id, product_id
  - quantity, price
  - coupon_code, delivery_address

Order:
  - id, user_id, pharmacy_id
  - total_price, delivery_fees
  - status (pending, confirmed, delivered)
  - order_items: [OrderItem]
```

---

## Authentication

### Flow

1. **Phone Number Entry**: User enters phone with country code
2. **OTP Verification**: Server sends OTP code
3. **Registration**: Complete profile if new user
4. **Token Storage**: JWT token saved to UserDefaults
5. **Auto-login**: Token persisted across app launches

### Token Management

**AuthManager** (Singleton):
```swift
- setToken(String)                    # Save token
- getAuthorizationHeader() -> String? # Get "Bearer <token>"
- clearToken()                        # Remove token on logout
- hasToken() -> String?               # Check if authenticated
```

### Firebase Cloud Messaging

**FCMTokenManager**:
- Handles FCM token updates
- Sends to server: `POST /auth/save-fcm-token`
- Parameters: fcm_token, old_fcm_token, phone, platform
- Token refresh handling

---

## Core Services

### 1. UserDefaults Manager (`Services/UserDefault/`)

**Singleton pattern** for local persistence.

**Keys:**
```swift
- User_Token              # JWT token
- User_Name               # User's name
- IsLoggedIn              # Auth status
- Mobile_Number           # Phone number
- IsVerifiedNumber        # OTP verified
- User_Id                 # User ID
- Latitude/Longitude      # Location
- selectedAreaName        # Selected area
- AppLanguage             # en/ar
- isJustDownloaded        # First launch
- HasSeenOnboarding       # Onboarding complete
- fcmToken                # Firebase token
```

### 2. Localization Manager (`Services/Localization/`)

**Features:**
- Multi-language support (English, Arabic)
- RTL/LTR layout support
- Dynamic language switching without restart
- Delegate pattern for UI refresh

**Usage:**
```swift
LocalizationManager.shared.setAppLanguage(lang: "ar")
```

### 3. Reachability Manager (`Services/NetworkLayer/`)

**Features:**
- Network status monitoring
- Slow connection detection
- Notifications: goodConnection, slowConnection, noConnection
- Singleton implementation

### 4. Shared Data Manager (`Common/SharedDataManager/`)

**Purpose:**
- Caches frequently accessed data
- Publishers for shared state
- Prevents redundant API calls

### 5. Firebase & Notifications

**AppDelegate Configuration:**
```swift
- Firebase initialization
- FCM setup
- Push notification registration
- Foreground/Background notification handling
- Notification tap handling
```

---

## Key Files Reference

| File | Location | Purpose |
|------|----------|---------|
| `AppDelegate.swift` | Root | Firebase, FCM, notifications setup |
| `SceneDelegate.swift` | Root | Window setup, coordinator init |
| `AppCoordinator.swift` | Root | Root navigation coordinator |
| `HomeCoordinator.swift` | Root | 89+ navigation methods for all features |
| `APIRouter.swift` | Services/NetworkLayer | 67+ API endpoint definitions |
| `APIClient.swift` | Services/NetworkLayer | HTTP request/response handling |
| `AuthManager.swift` | Services/NetworkLayer | Token management |
| `UserDefaultsManager.swift` | Services/UserDefault | Local data persistence |
| `LocalizationManager.swift` | Services/Localization | Multi-language support |
| `ReachabilityManager.swift` | Services/NetworkLayer | Network monitoring |
| `FCMTokenManager.swift` | Services/Firebase | Firebase token handling |
| `BaseViewController.swift` | Bases/ | Generic VC with ViewModel support |

---

## Data Flow & State Management

### Typical Feature Flow

```
User Interaction (View)
    ↓
ViewController calls ViewModel method
    ↓
ViewModel uses APIClient to fetch data
    ↓
APIRouter constructs request + headers
    ↓
URLSession makes HTTP request
    ↓
Response decoded to Model (Codable)
    ↓
ViewModel publishes @Published property
    ↓
ViewController receives update via Combine
    ↓
UI updates with new data
```

### ViewModel Pattern

```swift
class DoctorViewModel {
    @Published var doctors: [DoctorProfile] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?

    func fetchDoctors() {
        isLoading = true
        APIClient.shared.fetchData(from: url, as: [DoctorProfile].self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                // Handle error
            } receiveValue: { [weak self] doctors in
                self?.doctors = doctors
            }
            .store(in: &cancellables)
    }
}
```

### ViewController Subscription

```swift
viewModel.$doctors
    .receive(on: DispatchQueue.main)
    .sink { [weak self] doctors in
        self?.updateUI(with: doctors)
    }
    .store(in: &cancellables)
```

---

## Error Handling

### NetworkError Enum

```swift
enum NetworkError: Error {
    case serverError(message: String, errors: [String: [String]]?)
    case invalidResponse
    case unauthorized          // 401
    case forbidden            // 403
    case notFound             // 404
    case noInternetConnection
    case timeout
    case connectionLost
    case networkError(Error)
    case unknown(statusCode: Int)
}
```

### User Feedback
- LocalizedDescription for error messages
- RecoverySuggestion for actions
- Alert dialogs via handleError()
- Reachability checks before requests

---

## App Lifecycle

### AppDelegate
- Firebase configuration
- FCM and push notifications setup
- Google Maps/Places API initialization
- Device token registration
- Remote notification handling

### SceneDelegate
- Create main UIWindow
- Initialize AppCoordinator
- Set initial navigation controller
- Configure LocalizationManager
- Handle language changes
- Reset to splash on logout

### AppCoordinator Flow
```
App Launch
    ↓
SceneDelegate creates AppCoordinator
    ↓
AppCoordinator.start()
    ↓
displayHomeFlow() → Create HomeCoordinator
    ↓
HomeCoordinator determines first screen:
  - Not logged in → Language Selection
  - Logged in → Tab Bar
```

---

## Current Branch

**Branch:** `feature-message-attachment`

**Recent Changes:**
1. Fix OTP Verification
2. Add Register new account of OTP
3. Handle OTP Code
4. Update Authentication of Phone Number (support numbers with/without leading zero)
5. Updated URL Base Domain

**Main Branch:** `master` (for PRs)

---

## Project Statistics

- **Total API Endpoints:** 67+
- **Main Modules:** 8 major feature modules
- **View Controllers:** 100+
- **Data Models:** 80+ Codable structures
- **Core Services:** 6 (Network, UserDefaults, Localization, Reachability, Firebase, Coordination)

---

## Adding New Features

### To Add a New Module

1. **Create folder** in `Modules/`
2. **Implement** ViewController, ViewModel, Model
3. **Add navigation** to HomeCoordinator
4. **Register endpoints** in APIRouter
5. **Test** with Combine bindings

### To Add a New API Endpoint

1. **Define route** in `APIRouter.swift`
2. **Create model** (Codable struct)
3. **Implement in ViewModel** using APIClient
4. **Subscribe** in ViewController

### To Add a New Service

1. **Create in** `Services/` directory
2. **Implement as Singleton** if global state needed
3. **Add initialization** in AppDelegate/SceneDelegate
4. **Use throughout app** via shared instance

---

## Security Considerations

### Token Storage
- Currently stored in UserDefaults
- Consider Keychain for enhanced security
- Auto-cleared on logout

### Network Security
- HTTPS enforced (base URL)
- Status code validation
- Error response parsing
- Bearer token authentication

### Image Upload
- JPEG compression (quality: 0.8)
- Multipart form-data
- File type validation (JPEG, PNG)

---

## Testing Recommendations

### Unit Testing
- Test ViewModels with mock APIClient
- Test Codable models with sample JSON
- Test AuthManager token operations
- Test UserDefaultsManager persistence

### Integration Testing
- Test complete user flows (registration, booking)
- Test network layer with staging environment
- Test offline scenarios with Reachability

### UI Testing
- Test navigation flows
- Test form validations
- Test language switching
- Test error states

---

## Code Style & Conventions

### Naming
- ViewControllers: `<Feature>ViewController`
- ViewModels: `<Feature>ViewModel`
- Models: Descriptive nouns (DoctorProfile, Order)
- Coordinators: `<Feature>Coordinator`

### File Organization
- One class/struct per file
- Group by feature in Modules/
- Shared code in Common/ or Utilities/

### Swift Conventions
- Use `let` for constants
- Prefer `guard` for early returns
- Use `weak self` in closures to avoid retain cycles
- Mark protocols with `// MARK: -`

---

## Troubleshooting

### Common Issues

**"No internet connection" even when online:**
- Check ReachabilityManager initialization
- Verify network permissions in Info.plist

**Token expired errors:**
- AuthManager.clearToken() and force re-login
- Implement token refresh mechanism

**FCM token not updating:**
- Check Firebase configuration
- Verify APNs certificates
- Check FCMTokenManager.saveFCMTokenToServer()

**Language not switching:**
- Ensure LocalizationDelegate implemented
- Call resetAppAfterChangeLanguge() in SceneDelegate

---

## Future Enhancements

### Recommended Improvements

1. **Security:**
   - Migrate from UserDefaults to Keychain for token storage
   - Implement SSL pinning
   - Add biometric authentication

2. **Performance:**
   - Implement image caching
   - Add database (Core Data/Realm) for offline support
   - Optimize large list rendering with pagination

3. **Architecture:**
   - Add dependency injection framework
   - Implement unit tests (target 80% coverage)
   - Add SwiftUI for new features

4. **Features:**
   - Video consultations with doctors
   - In-app payment integration
   - Telemedicine prescriptions
   - Health tracking dashboard

---

## Contact & Resources

**Documentation:** This file
**API Documentation:** Contact backend team
**Design:** Check Figma/design files
**Bug Reports:** Use project issue tracker

---

*Last Updated: 2025-10-26*
*Branch: feature-message-attachment*
*Version: 1.0*
