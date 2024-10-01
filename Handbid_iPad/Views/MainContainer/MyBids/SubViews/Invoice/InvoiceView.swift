// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct InvoiceView: View {
	@ObservedObject var viewModel: InvoiceViewModel
	@Binding var isPresented: Bool

	var body: some View {
		VStack {
			headerView

			LoadingOverlay(isLoading: Binding<Bool>(
				get: { !viewModel.isDataLoaded },
				set: { _ in }
			)) {
				content
					.padding()
			}
		}
		.background(Color.white)
		.edgesIgnoringSafeArea(.all)
		.onAppear {
			viewModel.isDataLoaded = false
			viewModel.fetchInvoice()
		}
		.alert(isPresented: $viewModel.showAlert) {
			Alert(
				title: Text(viewModel.alertMessage.contains("success") ? "Success" : "Error"),
				message: Text(viewModel.alertMessage),
				dismissButton: .default(Text("OK"))
			)
		}
	}

	// MARK: - Header View

	private var headerView: some View {
		HStack {
			Spacer()

			Text("Invoice")
				.fontWeight(.bold)
				.font(.body)
			Spacer()

			Button(action: {
				withAnimation {
					isPresented = false
				}
			}) {
				Image(systemName: "xmark")
					.foregroundColor(.black)
					.padding(10)
					.background(Color.white)
					.clipShape(Circle())
					.overlay(
						Circle().stroke(Color.accentGrayBorder, lineWidth: 1)
					)
			}
			.padding(.top, 20)
			.padding()
		}
	}

	// MARK: - Content View

	private var content: some View {
		GeometryReader { geometry in
			HStack(spacing: 10) {
				leftColumn
					.frame(width: geometry.size.width * 0.6)
				rightColumn
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
	}

	// MARK: - Left Column

	private var leftColumn: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 5) {
				Text(convertTimestampToDate(timestamp: TimeInterval(viewModel.receipt?.dateInserted ?? -1)))
					.font(.body)
					.frame(height: 30)

				Text(viewModel.receipt?.name ?? "")
					.fontWeight(.bold)
					.font(.title2)
					.foregroundColor(Color.accentViolet)
					.frame(height: 70)

				HStack {
					Text("Item Name #")
						.fontWeight(.light)
					Spacer()
					Text("Bid")
						.fontWeight(.light)
				}
				.frame(height: 30)
				Divider()

				ForEach(viewModel.lineItems) { item in
					lineItemView(item: item)
					Divider()
				}

				coverFeesToggle
				Divider()

				totalsView
					.padding(.top)
			}
			.padding(.trailing, 10)
		}
	}

	private func lineItemView(item: ReceiptLineItemModel) -> some View {
		VStack(alignment: .leading, spacing: 5) {
			HStack {
				Text(item.name ?? "")
					.font(.body)
					.fontWeight(.bold)
					.foregroundColor(.primary)
					.fixedSize(horizontal: false, vertical: true)
				Spacer()
				Text(Double(item.grandTotal ?? -1).formatted(.currency(code: viewModel.receipt?.currencyCode ?? "")))
					.font(.body)
					.fontWeight(.bold)
					.foregroundColor(.primary)
					.fixedSize(horizontal: false, vertical: true)
			}

			HStack {
				Text("#\(String(item.itemId ?? -1))")
					.font(.subheadline)
					.foregroundColor(.secondary)
					.fixedSize(horizontal: false, vertical: true)
				Spacer()
				Text("\(item.tax ?? -1)% FMV")
					.font(.subheadline)
					.foregroundColor(.secondary)
					.fixedSize(horizontal: false, vertical: true)
			}
		}
		.padding([.top, .bottom], 10)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(Color.white)
		.cornerRadius(8)
	}

	private var coverFeesToggle: some View {
		Toggle(isOn: $viewModel.coverFees) {
			Text("I would like to cover the transaction fees so 100% of my purchase goes to Acme Foundation")
				.font(.subheadline)
				.fontWeight(.light)
				.foregroundColor(.black)
		}
		.padding([.top, .bottom], 10)
		.toggleStyle(CheckboxToggleStyle())
	}

	private var totalsView: some View {
		VStack(spacing: 10) {
			if let subtotal = viewModel.subtotal {
				summaryRow(title: "Subtotal", amount: subtotal)
			}
			if let transactionFees = viewModel.transactionFees {
				summaryRow(title: "Transaction Fees", amount: transactionFees)
			}
			if let ccThxFees = viewModel.ccThxFees {
				summaryRow(title: "CC Thx Fees", amount: ccThxFees)
			}
			if let alreadyPaid = viewModel.alreadyPaid {
				summaryRow(title: "Already Paid", amount: alreadyPaid)
			}

			if let paid = viewModel.isPaid {
				let amountDue = paid ? viewModel.alreadyPaid : viewModel.due
				summaryRow(title: paid ? "PAID" : "DUE", amount: amountDue ?? -1.0, isPaid: paid, isSummary: true)
			}
		}
	}

	private func summaryRow(title: String, amount: Double, isPaid: Bool = false, isSummary: Bool = false) -> some View {
		HStack {
			Text(title)
				.fontWeight(isSummary ? .bold : .regular)
				.font(isSummary ? .title : .body)
				.foregroundColor(!isSummary ? .black : isPaid ? Color.green : Color.accentViolet)
			Spacer()
			Text(amount.formatted(.currency(code: viewModel.receipt?.currencyCode ?? "")))
				.fontWeight(isSummary ? .bold : .regular)
				.font(isSummary ? .title : .body)
				.foregroundColor(!isSummary ? .black : isPaid ? Color.green : Color.accentViolet)
		}
	}

	// MARK: - Right Column

	private var rightColumn: some View {
		VStack(alignment: .leading, spacing: 20) {
			Spacer()
				.frame(height: 100)

			CustomDropdownCreditCardPicker(selectedCard: $viewModel.selectedCard, creditCards: viewModel.creditCards)

			Button<Text>.styled(config: .secondaryButtonStyle, action: {
				withAnimation {
					viewModel.makePayment()
				}
			}, label: {
				Text("MAKE PAYMENT")
					.textCase(.uppercase)
			})

			Button<Text>.styled(config: .fifthButtonStyle, action: {
				viewModel.sendSMSInvoice()
			}, label: {
				Text("SMS INVOICE")
					.textCase(.uppercase)
			})

			Button<Text>.styled(config: .fifthButtonStyle, action: {
				viewModel.sendEmailInvoice()
			}, label: {
				Text("EMAIL INVOICE")
					.textCase(.uppercase)
			})

			Spacer()
		}
	}
}
