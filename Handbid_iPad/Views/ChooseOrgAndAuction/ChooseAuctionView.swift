// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ChooseAuctionView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@ObservedObject private var viewModel: ChooseAuctionViewModel
	@State private var isBlurred = false
	@FocusState var focusedField: Field?
	var inspection = Inspection<Self>()

	init(viewModel: ChooseAuctionViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		ZStack {
			content
		}
		.onAppear {
			isBlurred = false
		}
		.background {
			backgroundView(for: .color(.red))
		}
		.onReceive(inspection.notice) {
			inspection.visit(self, $0)
		}
	}

	//    var body: some View {
	//        VStack(spacing: 0) {
	//            TopBar(content: topBarContent(for: selectedView))
	//            GeometryReader { geometry in
	//                if deviceContext.isPhone {
	//                    phoneView(geometry: geometry)
	//                }
	//                else {
	//                    tabletView(geometry: geometry)
	//                }
	//            }
	//        }
	//    }

	private var content: some View {
		OverlayInternalView(cornerRadius: 40) {
			VStack {
				//                getHeaderText()
				//                getListView()
				//                getButtons()
			}
			.blur(radius: isBlurred ? 10 : 0)
			.padding()
		}
	}
}
