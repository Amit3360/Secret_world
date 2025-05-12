//
//  Constant.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/01/24.
//

import Foundation
import UIKit
//MARK: - URL + KEYS

//let commonBaseURL = "http://18.218.117.223/secretWorld/v1/"
//let imageURL = "http://18.218.117.223/secretWorld/v1/"
//let baseURL = "http://18.218.117.223/secretWorld/v1/"
let commonBaseURL = "https://api.secretworld.ai/v1/"
let imageURL = "https://api.secretworld.ai/v1/"
let baseURL = "https://api.secretworld.ai/v1/"

public typealias parameters = [String:Any]
let securityKey = ""
var noInternetConnection = "No Internet Connection Available"
var appName = "Secret-World"
var productId = ""
var verifyPromo = false
var isWithdrawWithBank = false
var isAddFunds = false
var isOtpInvalid = false
var loadHomeData = false
var myPopUpLat = 0.0
var myPopUpLong = 0.0
var addPopUp = false
let window = UIApplication.shared.windows.first
var isComingSocial = false
var socialDetail = [String:Any]()
var paymentPopUp = false
var isRefresh = false
var isCall = false
var myCurrentLat = 0.0
var myCurrentLong = 0.0

//MARK: - Filter Variables

 var minPrice:Int = 1
 var maxPrice:Int = 10000
 var maxTime:Int = 24
 var minTime:Int = 1
 var radius:Int = 50
 var popularity = 1
 var endingSoon = 1
var popUpMiles = 0.0
var businessMiles = 0.0
 var rating = 0
 var minDeal = 1
 var maxDeal = 100
 var isSelectGigPrice = false
 var isSelectGigTime = false
var selectHomeIndex = 5
var typeIndex = 0
 var isSelectPopularity = false
 var isSelectEndingSoon = false
 var isSelectPopUpDistance = false
var isSelectBusinessDistance = false
var isSelectMomentDistance = false
var momentMiles = 0.0
 var isSelectDealing = false
 var isSelectRating = false
var isSelectAnother = false

var uploadDuplicateImg = false
var arrDuplicationImage = [[UIImagePickerController.InfoKey: Any]]()
//MARK: - StoryBoard
enum AppStoryboard: String{
    case Main = "Main"
   // case tabBar = "TabbarController"
    var instance: UIStoryboard{
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}
var rootVC: UIViewController?{
    get{
        return UIApplication.shared.windows.first?.rootViewController
    }
    set{
        UIApplication.shared.windows.first?.rootViewController = newValue
    }
}

//MARK: - STORE FILE
enum DefaultKeys: String{
    case role
    case authKey
    case userDetails
    case businessDetail
    case autoLogin
    case deviceToken
    case security_key
    case Authorization
    case loginUser
    case UserDetail
    case BusinessUserDetail
    case profileNotComplete
    case filterdata
    case notesId
    case userName
    case filterDetail
    case age
    case LogoImage
    case BusinessIdImage
    case CoverImage
    case UserProfileImage
    case UserProfileViewImage
    case SearchCategories
    case SubCategoriesId
    case ServiceDetailData
    case ServiceId
    case BusinessUserIdForReview
    case UserProfilePicSignupTime
    case isUserParticipantsList
    case BUserDetails
    case UserDetails
    case GigImg
    case ServiceImages
    case aboutHeight
    case reviewHeight
    case EditUserProfileImag
    case RecentSearch
    case Popup
    case bdetail
    case userId
    case searchResult
    case recevrID
    case SubCategories
    case connectSocket
    case myPopUpData
    case getPopUp
    case userLatLong
    case userNotificationCount
    case buisnessNotificationCount
    case tabBarNotificationPosted
    case WalletAmount
    case commisionAmount
    case GigFees
    case AddGigDetail
    case AddGigImage
    case isLocationSelected
    case businessLatLong
    case ButtonArrowStatus
    case gigDetail
    case GigType
    case MarkerLogo
    case BusinessAnnotation
    case ServiceImg
    case MapRadius
    case isSelectTab
    case ParticipantsImgs
    case CurrentUserId
    case ProductsImages
    case filterData
    case filterDataPopUp
    case filterDataBusiness
    case isSelectGigFilter
    case isSelectPopUpFilter
    case isSelectBusinessFilter
    case taskMiles
    case VerificationStatus
    case MomentLat
    case MomentLong
}


//MARK: API - SERVICES
enum Services: String
{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

//MARK: API - ENUM
enum API: String
{
    //MARK: API - USER
    case sendMobileOtp = "auth/mobileloginsignup"
    case mobileVerificationOtp = "auth/otpVerificationmobile"
    case resendOtp = "auth/resendOtpmobile"
    case createAccount = "auth/createAccount"
    case userFunctionsList = "admin/user/usersfunctions_list"
    case createUserFuntion = "admin/user/create_user_functions"
    case completeUserAccount = "auth/usercompleteAccount"
    case getServies = "admin/user/getServices"
    case createBusinessAccount = "auth/businessusercompleteAccount"
    case getServiceCategories = "buser/getuserServices"
    case getSubcategory = "buser/getSubCategory"
    case addService = "buser/createServices"
    case getUserProfile = "user/getProfile"
    case getUserProfileView = "buser/getBuserProfile"
    case getBusinessUserProfile = "buser/getProfile"
    case getPolicyTerm = "user/policy/getPolicyTerms"
    case getHelpCenter = "user/help/getallHelp"
    case logout = "auth/logout"
    case chnageMobileNumber = "auth/changeMobileOtp"
    case otpForChangeMObileNumber = "auth/verifyAndChangeMobile"
    case updateUserProfile = "user/updateUserProfile"
    case updateBusinessProfile = "buser/updateBuserProfile"
    case verificationStatus = "auth/VerificationStatus"
    case verificationRequest = "auth/VerificationRequest"
    case getAllBusinessService = "buser/getBuserAllServices"
    case getSelectedCategory = "buser/getSingleuserServices"
    case getServiceDetail = "buser/getSingleService"
    case deleteService = "buser/deleteService"
    case getUserExplore = "user/getBusinessExplore"
    case getUserServiceDetail = "user/getBusinessDetails"
    case addBusinessReview = "user/review/createReview"
    case getReviews = "user/review/getReview"
    case addGig = "buser/gig/createGig"
    case checkGigAdd = "buser/gig/checkGigAdd"
    case checkGigUpdate = "buser/gig/checkGigUpdate"
    case getGigList = "buser/gig/getAllGigs"
    case getAllBusiness = "user/seeAllBusiness"
    case getBusinessGigs = "buser/gig/getUserGigs"
    case businessGigDetails = "buser/gig/getGigDetails"
    case UserGigDetails = "user/gig/getUserGigDetails"
    case applyGig = "user/gig/applyGig"
    case getUserParticipants = "buser/gig/getGigsRequest"
    case getGroupParticipant = "user/getGroupMembers"
    case getBusinessParticipants = "user/gig/businessGigsRequest"
    case hireForGig = "buser/gig/GigAccept"
    case updateGig = "buser/gig/updateGig"
    case cancelGig = "buser/gig/deleteGig"
    case getBusiessallGigsList = "buser/gig/getBusinessListGigs"
    case completeGig = "buser/gig/GigComplete"
    case getAppliedGig = "user/gig/getUserAppliedGig"
    case getServiceDetailUserSide = "user/UserService"
    case addGigReviewUserSide = "user/review/createGigReview"
    case addServiceReview = "user/review/createServiceReview"
    case UpdateService = "buser/updateService"
    case GetUserPromoCodes = "user/getUserPromoCode"
    case verifyPromoCode = "buser/gig/verifyPromoCode"
    case addPopup = "buser/createPopup"
    case popupDetail = "buser/getPopupDetails"
    case deletePopup = "buser/deletepopup"
    case updatePopup = "buser/updatePopup"
    case acceptRejectPopupRequests = "buser/popupAcceptReject"
    case getPopupRequests = "buser/getPopupRequest"
    case GetPopupList = "buser/getMyPopupList"
    case applyPopup = "user/applyPopup"
    case getAllPopup = "buser/seeAllPopups"
    case searchAll = "user/searchAll"
    case searchHomeData = "user/home"
    case uploadImage = "buser/uploadImage"
    case addReport = "user/report"
    case getUserDetail = "user/getUserDetailById"
    case getReportReason = "user/reportReasons"
    case completeGigRequests = "buser/gig/GigCompleteUserList"
    case socialLogin = "auth/sociallogin"
    case promoCodeStatus = "user/gig/updatePromoStatus"
    case getNotification = "user/getNotifications"
    case updateReview = "user/review/updateReview"
    case addWallet = "user/wallet/addWallet"
    case getWallet = "user/wallet/getWalletDetails"
    case withdrawRequest = "user/wallet/withdrawRequest"
    case getComission = "user/getSingleCommission"
    case addBank = "user/bank/add"
    case getBankDetail = "user/bank"
    case editBankDetail = "user/bank/edit"
    case deleteBank = "user/bank/delete"
    case getTransaction = "user/transactions"
    case defaultBank = "user/bank/mark-default"
    case addItitnerary = "user/itinerary/add"
    case updateItinerary = "user/itinerary/update"
    case getItitnerary = "user/itinerary/getAll"
    case deleteItinerary = "user/itinerary/delete"
    case getHitStats = "user/hitstats"
    case addPopupReview = "user/review/createPopupReview"
    case updatePopupReview = "user/review/updatePopupReview"
    case deletePopupReview = "user/review/deletePopupReview"
    case createDeals = "user/deal/createDeal"
    case updateDeals = "user/deal/updateDeal"
    case getDeals = "user/deal/getDeals"
    case deleteDeals = "user/deal/deleteDeal"
    case createSubServices = "buser/createSubServices"
    case addMoment = "buser/moment/createMoment"
    case getMomentDeatils = "buser/moment/getMoment"
    case getMomentList = "buser/moment/getUserMoments"
    case deleteMOment = "buser/moment/deleteMoment"
    case updateMoment = "buser/moment/editMoment"
    case applyMoment = "buser/moment/applyMoment"
    case momentParticipants = "buser/moment/getMomentsRequest"
    case rejectMomentRequest = "buser/moment/momentReject"
    case acceptMomentRequest = "buser/moment/momentAccept"
    case appliedMoments = "buser/moment/getappliedmoments"
    case gigRejected = "buser/gig/GigReject"
    case checkMomentAdd = "buser/moment/checkMomentAdd"
    case createItemCategory = "buser/createitemcategory"
    case getItemsCategory = "buser/getitemcategory"
    case createItemDiscount = "buser/createitemdiscount"
    case getitemdiscount = "buser/getitemdiscount"
    case editItem = "buser/editadditems"
    case deleteItem = "buser/deleteadditems"
    case addSingleItem = "buser/addsingleitem"
    case markSoldItem = "buser/markitemsold"
    case getAllItems = "buser/getallitems"
    case addSelfReview = "user/selfreview"
    case getSelfReview = "user/getselfreview"
    case openCloseStore = "buser/changeclosed"
    case createMOmentReview = "user/review/createmomentreview"
    case markSelectedItem = "buser/markitemselected"
    case getusermomentreviews = "user/review/getusermomentreviews"
    case getReviewMedia = "user/review/getreviewmedia"
    case getReviewComments = "user/review/getreviewcomments"
    case addReviewByUser = "user/review/createownerreview"
    case createMembership = "buser/membership/createmembership"
    case getMembership = "buser/membership/getallmembership"
    case deleteMembership = "buser/membership/deletemembership"
    case editMembership = "buser/membership/editmembership"
    case updateMembershipStatus = "buser/membership/setmembershipstatus"
}
enum dateFormat: String {
    case fullDate = "MM_dd_yy_HH:mm:ss.SS"
    case MonthDayYear = "MMM d, yyyy"
    case MonthDay = "MMM dd EEE"
    case DateAndTime = "dd/M/yyyy hh:mm a"
    case TimeWithAMorPMandMonthDay = "hh:mm a MMM dd EEE"
    case TimeWithAMorPMandDate = "hh:mm a MMM d, yyyy"
    case dateTimeFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    case yearMonthFormat = "yyyy-MM-dd"
    case slashDate = "dd/MM/yyyy"
    case timeAmPm = "hh:mm a"
    case BackEndFormat  = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case dateTime = "hh:mm a "
    case hh_mm_a = "hh:mm a MMM yy"
}
//MARK: REGEX - MESSAGE
enum RegexMessage: String {
    case invalidBlnkEmail               = "Please enter email"
    case invalidNameCount               = "Please"
    case invalidImage                   = "Please select image"
    case invalidAddress                 = "Please enter address"
    case streetandHouse                 = "Please enter street & house number"
    case invalidCountryCode             = "Please select country code"
    case invalidCountry                 = "Please enter country"
    case invalidPassword                = "Please enter password"
    case passwordRangeError             = "Password must be in 9 - 16 digit "
    case invalidOldPassword             = "Please enter old password"
    case invalidNewPassword             = "Please enter new password"
    case invalidConfPassword            = "Please enter confirm password"
    case enterMessage                   = "Please enter message"
    case invalidCode                    = "Please enter valid code"
    case invalidCity                    = "Please enter city"
    case invalidState                   = "Please enter state"
    case postalcode                     = "Please enter postal code"
    case invalidName                    = "Please enter name"
    case invalidAlphabetName            = "Please enter valid name"
    case invalidRating                  = "Please add your review"
    case emptyRating                    = "Please add your rating"
    case invalidZipCode                 = "Please enter zipcode"
    case invalidPinCode                 = "Please enter pincode"
    case invalidEmail                   = "Please enter valid email"
    case invalidPhnNo                   = "Please enter mobile number"
    case phoneNumberIncorrectError      = "Please enter atleast 9 digits in phone number"
    case phoneLimitExceedError          = "Phone number must be between 9-11 digits"
    case invalidTerms                   = "Please accept terms and conditions"
    case invalidConfirmPassword         = "Password and confirm password do not match"
}

func selectLogin_TF(anyview: UIView){
    anyview.layer.cornerRadius = 8
    anyview.backgroundColor = .white
    anyview.layer.borderWidth = 1
    anyview.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
}

func selectPassword_TF(anyview: UIView){
    anyview.layer.borderWidth = 0
    anyview.layer.borderColor = #colorLiteral(red: 0.9136453271, green: 0.9137768149, blue: 0.9136165977, alpha: 1)
    anyview.layer.cornerRadius = 0
    anyview.backgroundColor = #colorLiteral(red: 0.9136453271, green: 0.9137768149, blue: 0.9136165977, alpha: 1)
}

func reset_TF(anyview: UIView){
    anyview.layer.borderWidth = 0
    anyview.layer.borderColor = #colorLiteral(red: 0.9136453271, green: 0.9137768149, blue: 0.9136165977, alpha: 1)
    anyview.layer.cornerRadius = 0
    anyview.backgroundColor = #colorLiteral(red: 0.9136453271, green: 0.9137768149, blue: 0.9136165977, alpha: 1)
}

enum constantMessages:String{
    
    case internetError    = "Please check your internet connectivity"
    case emptyName        = "Please enter your name"
    case emptyFullName   = "Please enter full name"
    case emptyLastName    = "Please enter your last name"
    case emptyCountryCode = "Please select your country code"
    case emptyPhone       = "Please enter Phone Number"
    case emptyEmail       = "Please enter your email"
    case emptyPassword    = "Please enter password"
    case emptyOldPassword = "Please enter old password"
    case emptyNewPassword = "Please enter new password"
    case emptyConfirmPassword = "Please enter confirm password"
    case minimumPassword = "Please enter minimum 6 characters"
  
   
    case emptyOtp         = "Please enter OTP"
    case emptyImage       = "Please upload images"
    case emptyGender      = "Please select your gender"
    case emptyLocation    = "Please enter your location"
    case emptyDob         = "Please enter your date of birth"
    case emptyBio         = "Please enter about yourself"
    case emptyAge         = "Please enter your age"
    case emptyHeight      = "Please enter your height"
    case emptymessage     = "Please write something"
    case emptyInterest    = "Please select your interests"
    case emptyHobbies     = "Please select your hobbies"
    case emptyImageOrVideo = "Please add an image or a video"
    case emptyTitle       = "Please add a title"
    case emptyDescription = "Please add description"
    case emptyJobType     = "Please enter job type"
    case emptyPickup      = "Please enter your pick up location"
    case emptydrop        = "Please enter your drop location"
    case emptyDate        = "Please select your date"
    case emptyColor       = "Please enter color"
    case emptyTime        = "Please select your Time"
    case emptyVehicleName = "Please enter your vehicle name"
    case emptyVehicleModel = "Please enter your vehicle model"
    case emptyYear        = "Please select your year"
    case emptyDeriveTerrian = "Please select your drive terrrian"
    case emptyAddReview   = "Please enter your comment"
    case emptyProviderId = "Provider Id nil"
    case passwordCharacterLimit = "Password must be 6 digits long"
    case emptyCardNumber = "Please enter your card number"
    case emptyExpiryDate = "Please enter your card expiry date"
    case emptyCvc = "Plase enter your cvv/vcv number"
     
    
    case acceptTerms      = "Please accept terms & conditions"
    case invalidPhone     = "Please enter valid phone number"
    case invalidEmail     = "Please enter valid email"
    case invalidCPassword = "Password and confirm password doesn't match"
    case invalidOtp       = "Please enter valid OTP"
    case invalidImage     = "You cannot select more than five images"
        
    case blockedUser      = "Please Unblock this user before sending message"
    case blockedByUser    = "You have been blocked by this user"
    case callRejected     = "Call rejected"
    case callEnded        = "Call ended"
    case callNoAnswer     = "No answer"
    
    case resendOtp        = "OTP send your linked phone number"
    var instance : String {
        return self.rawValue
    }
}
