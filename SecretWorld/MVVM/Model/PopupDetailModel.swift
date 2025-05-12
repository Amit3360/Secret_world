import Foundation
// MARK: - PopupDetailModel
struct PopupDetailModel: Codable {
    let status, message: String?
    let statusCode: Int?
    let data: PopupDetailData?
}

// MARK: - DataClass
struct PopupDetailData: Codable {
    let id, name, usertype,place,deals: String?
    let businessLogo,image: String?
    let description: String?
    let addProducts: [AddProducts]?
    let addItems: [AddItems]?
    let lat, long,rating: Double?
    let startDate, endDate: String?
    let status: Status?
    let closedDays: [String]?
    let productImages:[String]?
    let createdAt, updatedAt: String?
    let user: UserDetaa?
    let reviews:[PopUpReview]?
    let Requests,timeStatus,storeType,categoryType,availability,hitCount: Int?
    let endSoon,isClosed:Bool?
    let popupStatus:String?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, usertype,timeStatus
        case businessLogo = "business_logo"
        case description, addProducts, lat, long, startDate, endDate, status, createdAt, updatedAt, user,place,Requests,image,storeType,categoryType,deals,productImages,rating,availability,hitCount,reviews,endSoon,popupStatus,addItems,closedDays,isClosed
       
    }
}
// MARK: - Status
struct Status: Codable {
    let id: String?
    let status: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status
    }
}

// MARK: - AddProduct
struct PopUpReview: Codable {
    let comment,media,createdAt,updatedAt: String?
    let starCount: Int?
    let id: String?
    let userId:UserDetaa?
    enum CodingKeys: String, CodingKey {
        case comment,media,createdAt,starCount,userId,updatedAt
        case id = "_id"
    }
}
// MARK: - AddProduct
struct AddProducts: Codable {
    let productName: String?
    let price: Int?
    let id: String?
    let description:String?
    let image: [String]?
    var isHide: Bool?
    enum CodingKeys: String, CodingKey {
        case productName, price,image,description,isHide
        case id = "_id"
    }
}

// MARK: - AddItems
struct AddItems: Codable {
    let itemName: String?
    let price: Double?
    let id: String?
    let discount:Double?
    let discountType:Int?
    let itemCategory:String?
    let sellingPrice:Double?
    let sellingType:Int?
    let stockType:Int?
    let totalStock:Double?
    var isSelected: Bool = false
    var selectedQuantity: Double? = nil
    let description:String?
    let image: [String]?
    var isHide: Bool?
    let soldItems:Double?
    enum CodingKeys: String, CodingKey {
        case itemName,price,discount,discountType,itemCategory,sellingPrice,sellingType,stockType,totalStock,description,image,isHide,soldItems,isSelected,selectedQuantity
        case id = "_id"
    }
}

// MARK: - User
struct UserDetaa: Codable {
    let id, name: String?
    let profilePhoto: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case profilePhoto = "profile_photo"
    }
}

