// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct InvoiceView: View {
	@ObservedObject var viewModel: InvoiceViewModel
	@Binding var isPresented: Bool

	var body: some View {
		VStack {
			HStack {
				Spacer()

				Text("Invocie")
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
			content
				.padding()
		}
		.background(Color.white)
		.edgesIgnoringSafeArea(.all)
		.onAppear {
			viewModel.fetchInvoice()
		}
	}

	private var content: some View {
		GeometryReader { geometry in
			HStack(spacing: 0) {
				leftColumn
					.frame(width: geometry.size.width * 0.6)
					.padding()
				rightColumn
					.padding()
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
	}

	// MARK: - Left Column

	private var leftColumn: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 5) {
				Text("Invoice Date: \(viewModel.invoiceDateString)")
					.font(.body)
					.frame(height: 30)

				Text(viewModel.auctionName)
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

				ForEach(viewModel.invoiceItems) { item in
					VStack(alignment: .leading, spacing: 5) {
						HStack {
							Text(item.name)
								.font(.body)
								.fontWeight(.bold)
								.foregroundColor(.primary)
								.fixedSize(horizontal: false, vertical: true)
							Spacer()
							Text("$\(String(format: "%.2f", item.amount))")
								.font(.body)
								.fontWeight(.bold)
								.foregroundColor(.primary)
								.fixedSize(horizontal: false, vertical: true)
						}

						HStack {
							Text("#\(item.id)")
								.font(.subheadline)
								.foregroundColor(.secondary)
								.fixedSize(horizontal: false, vertical: true)
							Spacer()
							Text("\(item.tax)% FMV")
								.font(.subheadline)
								.foregroundColor(.secondary)
								.fixedSize(horizontal: false, vertical: true)
						}
					}
					.padding([.top, .bottom], 10)
					.frame(maxWidth: .infinity, alignment: .leading)
					.background(Color.white)
					.cornerRadius(8)
					Divider()
				}

				Toggle(isOn: $viewModel.coverFees) {
					Text("I would like to cover the transaction fees so 100% of my purchase goes to Acme Foundation")
						.font(.subheadline)
						.fontWeight(.light)
						.foregroundColor(.black)
				}
				.padding([.top, .bottom], 10)
				.toggleStyle(CheckboxToggleStyle())
				Divider()

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
					if let due = viewModel.due {
						summaryRow(title: "DUE", amount: due)
					}
				}
				.padding(.top)
			}
			.padding(.trailing, 10)
		}
	}

	private func summaryRow(title: String, amount: Double) -> some View {
		HStack {
			if title == "DUE" {
				Text(title)
					.fontWeight(.bold)
					.font(.title)
					.foregroundColor(Color.accentViolet)
				Spacer()
				Text("$\(String(format: "%.2f", amount))")
					.fontWeight(.bold)
					.font(.title)
					.foregroundColor(Color.accentViolet)
			}
			else {
				Text(title)
				Spacer()
				Text("$\(String(format: "%.2f", amount))")
			}
		}
	}

	// MARK: - Right Column

	private var rightColumn: some View {
		VStack(alignment: .leading, spacing: 20) {
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
