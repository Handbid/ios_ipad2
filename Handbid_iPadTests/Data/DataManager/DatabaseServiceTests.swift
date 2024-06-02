// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import XCTest

final class DatabaseServiceTests: XCTestCase {
	var databaseService: DatabaseService!

	override func setUp() {
		super.setUp()
		databaseService = DatabaseService()
	}

	override func tearDown() {
		databaseService = nil
		super.tearDown()
	}

	func testSaveAndFetchOneUser() throws {
		let userModel = UserModel(id: "1", name: "Test User")
		try databaseService.save(userModel, modelType: .user)

		let fetchedUser: UserModel? = try databaseService.fetchOne(UserModel.self, modelType: .user, id: "1")
		XCTAssertNotNil(fetchedUser)
		XCTAssertEqual(fetchedUser?.id, userModel.id)
		XCTAssertEqual(fetchedUser?.name, userModel.name)
	}

	func testSaveAndFetchOneAuction() throws {
		let auctionModel = AuctionModel(id: "1", name: "Test Auction")
		try databaseService.save(auctionModel, modelType: .auction)

		let fetchedAuction: AuctionModel? = try databaseService.fetchOne(AuctionModel.self, modelType: .auction, id: "1")

		XCTAssertNotNil(fetchedAuction)
		XCTAssertEqual(fetchedAuction?.id, auctionModel.id)
	}

	func testFetchAllUsers() throws {
		let userModel1 = UserModel(id: "1", name: "Test User 1")
		let userModel2 = UserModel(id: "2", name: "Test User 2")
		try databaseService.save(userModel1, modelType: .user)
		try databaseService.save(userModel2, modelType: .user)

		let fetchedUsers: [UserModel] = try databaseService.fetchAll(UserModel.self, modelType: .user)
		XCTAssertEqual(fetchedUsers.count, 2)
	}

	func testFetchAllAuctions() throws {
		let auctionModel1 = AuctionModel(id: "1", name: "Test Auction 1")
		let auctionModel2 = AuctionModel(id: "2", name: "Test Auction 2")
		try databaseService.save(auctionModel1, modelType: .auction)
		try databaseService.save(auctionModel2, modelType: .auction)

		let fetchedAuctions: [AuctionModel] = try databaseService.fetchAll(AuctionModel.self, modelType: .auction)
		XCTAssertEqual(fetchedAuctions.count, 2)
	}

	func testUpdateUser() throws {
		var userModel = UserModel(id: "1", name: "Test User")
		try databaseService.save(userModel, modelType: .user)

		userModel.name = "Updated Test User"
		try databaseService.update(userModel, modelType: .user)

		let fetchedUser: UserModel? = try databaseService.fetchOne(UserModel.self, modelType: .user, id: "1")
		XCTAssertEqual(fetchedUser?.name, "Updated Test User")
	}

	func testUpdateAuction() throws {
		var auctionModel = AuctionModel(id: "1", name: "Test Auction")
		try databaseService.save(auctionModel, modelType: .auction)

		auctionModel.name = "Updated Test Auction"
		try databaseService.update(auctionModel, modelType: .auction)

		let fetchedAuction: AuctionModel? = try databaseService.fetchOne(AuctionModel.self, modelType: .auction, id: "1")
		XCTAssertEqual(fetchedAuction?.name, "Updated Test Auction")
	}

	func testDeleteUser() throws {
		let userModel = UserModel(id: "1", name: "Test User")
		try databaseService.save(userModel, modelType: .user)

		try databaseService.delete(userModel, modelType: .user)

		let fetchedUser: UserModel? = try databaseService.fetchOne(UserModel.self, modelType: .user, id: "1")
		XCTAssertNil(fetchedUser)
	}

	func testDeleteAuction() throws {
		let auctionModel = AuctionModel(id: "1", name: "Test Auction")
		try databaseService.save(auctionModel, modelType: .auction)

		try databaseService.delete(auctionModel, modelType: .auction)

		let fetchedAuction: AuctionModel? = try databaseService.fetchOne(AuctionModel.self, modelType: .auction, id: "1")
		XCTAssertNil(fetchedAuction)
	}

	func testUpdateWithSameUserData() throws {
		let userModel = UserModel(id: "1", name: "Test User")
		try databaseService.save(userModel, modelType: .user)

		try databaseService.update(userModel, modelType: .user)

		let fetchedUser: UserModel? = try databaseService.fetchOne(UserModel.self, modelType: .user, id: "1")
		XCTAssertEqual(fetchedUser?.name, "Test User")
	}

	func testUpdateWithSameAuctionData() throws {
		let auctionModel = AuctionModel(id: "1", name: "Test Auction")
		try databaseService.save(auctionModel, modelType: .auction)

		try databaseService.update(auctionModel, modelType: .auction)

		let fetchedAuction: AuctionModel? = try databaseService.fetchOne(AuctionModel.self, modelType: .auction, id: "1")
		XCTAssertEqual(fetchedAuction?.name, "Test Auction")
	}
}
