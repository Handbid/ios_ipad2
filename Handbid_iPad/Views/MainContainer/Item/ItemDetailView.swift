// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class ItemDetailState: ObservableObject {
	@Published var selectedImage: String?
	@Published var remainingTime: Int = 60
	@Published var progress: CGFloat = 1.0
	private var timer: Timer?

	func startTimer() {
		stopTimer()
		progress = 1.0
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
			guard let self else { return }
			if remainingTime > 0 {
				remainingTime -= 1
				progress = CGFloat(remainingTime) / 60.0
			}
			else {
				stopTimer()
			}
		}
	}

	func stopTimer() {
		timer?.invalidate()
		timer = nil
	}

	func reset() {
		stopTimer()
		selectedImage = nil
		remainingTime = 60
		progress = 1.0
	}

	func resetTimer() {
		remainingTime = 60
		progress = 1.0
	}
}

struct DeviceRotationViewModifier: ViewModifier {
	let action: (UIDeviceOrientation) -> Void

	func body(content: Content) -> some View {
		content
			.onAppear()
			.onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
				let orientation = UIDevice.current.orientation
				if orientation.isValidInterfaceOrientation {
					action(orientation)
				}
			}
	}
}

extension View {
	func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
		modifier(DeviceRotationViewModifier(action: action))
	}
}

import SwiftUI

struct ItemDetailView: View {
	@Binding var isVisible: Bool
	@Binding var loadImages: Bool
	@ObservedObject var detailState: ItemDetailState
	@State private var offset: CGFloat = 0
	@State private var showPaddleInput = false
	@State private var valueType: ItemValueType = .none
	@State private var selectedAction: ActionButtonType? = nil
	@ObservedObject var viewModel: ItemDetailViewModel
	@State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape

	init(isVisible: Binding<Bool>, loadImages: Binding<Bool>, item: ItemModel, detailState: ItemDetailState) {
		self._isVisible = isVisible
		self._loadImages = loadImages
		self.detailState = detailState
		self.viewModel = ItemDetailViewModel(item: item)
	}

	var body: some View {
		GeometryReader { geometry in
			let isPad = UIDevice.current.userInterfaceIdiom == .pad

			ZStack {
				VStack(spacing: 10) {
					if isPad, isLandscape {
						landscapeView
					}
					else {
						portraitView(geometry: geometry)
					}
				}
				.background(Color.white)
				.cornerRadius(20)
				.offset(y: offset)
				// .gesture(dragGesture(geometry: geometry))
				.animation(.easeInOut(duration: 0.4), value: offset)
				.padding(10)

				VStack {
					if isLandscape {
						HStack {
							Spacer()
							if offset == 0 {
								closeButton
							}
						}
					}
					Spacer()
				}
			}
			.gesture(TapGesture().onEnded {
				detailState.resetTimer()
			})
		}
		.background(Color.clear)
		.onRotate { newOrientation in
			isLandscape = newOrientation.isLandscape
		}
	}

	private var landscapeView: some View {
		GeometryReader { geometry in
			HStack(spacing: 0) {
				ImageGalleryView(
					detailState: detailState,
					loadImages: $loadImages,
					item: viewModel.item,
					images: viewModel.item.images ?? [ItemImageModel(itemImageUrl: viewModel.item.imageUrl)]
				)
				.accessibilityIdentifier("imageGalleryView")
				.background(showPaddleInput ? Color.accentGrayBackground : Color.white)
				.frame(width: geometry.size.width * 0.5)

				ZStack {
					VStack(spacing: 10) {
						ScrollView {
							DetailInfoView(isVisible: $isVisible, resetTimer: detailState.resetTimer, item: viewModel.item)
								.background(Color.clear)
								.frame(maxHeight: .infinity)
								.clipped()
								.accessibilityIdentifier("detailInfoView")
								.padding(.top, 20)
						}
						.simultaneousGesture(DragGesture().onChanged { _ in detailState.resetTimer() })

						BottomSectionItemView(
							item: viewModel.item,
							resetTimer: detailState.resetTimer,
							showPaddleInput: $showPaddleInput,
							valueType: $valueType,
							selectedAction: $selectedAction
						)
						.frame(maxWidth: .infinity)
						.accessibilityIdentifier("buttonSectionView")
						.padding(.bottom, 10)
					}
					.background(Color.accentGrayBackground)

					if showPaddleInput {
						// PaddleInputView code
					}
				}
			}
			.padding(.top, 0)
		}
	}

	private func portraitView(geometry _: GeometryProxy) -> some View {
		VStack(spacing: 0) {
			HStack {
				Spacer()
				closeButton
					.padding([.top, .trailing], 20)
			}
			if showPaddleInput {
				// PaddleInputView code
			}
			else {
				ScrollView {
					VStack(spacing: 10) { // Reduced spacing in portrait mode
						ImageGalleryView(
							detailState: detailState,
							loadImages: $loadImages,
							item: viewModel.item,
							images: viewModel.item.images ?? [ItemImageModel(itemImageUrl: viewModel.item.imageUrl)]
						)
						.accessibilityIdentifier("imageGalleryView")

						DetailInfoView(isVisible: $isVisible, resetTimer: detailState.resetTimer, item: viewModel.item)
							.background(Color.white)
							.accessibilityIdentifier("detailInfoView")
					}
				}
				.simultaneousGesture(DragGesture().onChanged { _ in detailState.resetTimer() })

				BottomSectionItemView(
					item: viewModel.item,
					resetTimer: detailState.resetTimer,
					showPaddleInput: $showPaddleInput,
					valueType: $valueType,
					selectedAction: $selectedAction
				)
				.frame(maxWidth: .infinity)
				.accessibilityIdentifier("buttonSectionView")
			}
		}
		.padding(10)
	}

	private var closeButton: some View {
		Button(action: {
			withAnimation {
				isVisible = false
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
		.accessibilityIdentifier("closeButton")
	}

	private func dragGesture(geometry: GeometryProxy) -> some Gesture {
		DragGesture()
			.onChanged { gesture in
				if gesture.translation.height > 0 {
					offset = gesture.translation.height
				}
				detailState.resetTimer()
			}
			.onEnded { gesture in
				if gesture.translation.height > 100 {
					withAnimation {
						offset = geometry.size.height
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
							isVisible = false
							offset = 0
						}
					}
				}
				else {
					withAnimation {
						offset = 0
					}
				}
			}
	}
}
