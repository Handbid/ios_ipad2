// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ItemDetailView: View {
	var item: ItemModel
	@Binding var isVisible: Bool
	@State private var offset: CGFloat = 0
	@State private var selectedImage: String? = nil
	@State private var timer: Timer?
	@State private var remainingTime: Int = 60
	@State private var progress: CGFloat = 1.0
	@State private var showPaddleInput = false

	var body: some View {
		GeometryReader { geometry in
			let isLandscape = geometry.size.width > geometry.size.height
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
				.gesture(dragGesture(geometry: geometry))
				.animation(.easeInOut(duration: 0.4), value: offset)
				.onAppear {
					startTimer()
				}
				.onDisappear {
					stopTimer()
				}
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
				resetTimer()
			})
		}
		.background(Color.clear)
	}

	private var landscapeView: some View {
		HStack {
			ImageGalleryView(selectedImage: $selectedImage, remainingTime: $remainingTime, progress: $progress, item: item, images: item.images ?? .init(), resetTimer: resetTimer)
				.accessibilityIdentifier("imageGalleryView")
				.background(showPaddleInput ? Color.accentGrayBackground : Color.white)
			ZStack {
				VStack(spacing: 0) {
					ScrollView {
						DetailInfoView(isVisible: $isVisible, resetTimer: resetTimer, item: item)
							.background(Color.clear)
							.frame(maxHeight: .infinity)
							.clipped()
							.accessibilityIdentifier("detailInfoView")
					}
					.simultaneousGesture(DragGesture().onChanged { _ in resetTimer() })
					ButtonSectionItemView(item: item, resetTimer: resetTimer, showPaddleInput: $showPaddleInput)
						.background(Color.clear)
						.frame(maxWidth: .infinity)
						.clipped()
						.padding()
						.accessibilityIdentifier("buttonSectionView")
				}
				.background(Color.accentGrayBackground)

				if showPaddleInput {
					PaddleInputView(isVisible: $showPaddleInput, resetTimer: resetTimer)
						.background(Color.white)
						.transition(.opacity)
						.zIndex(1)
				}
			}
		}
		.padding(.top, 0)
	}

	private func portraitView(geometry: GeometryProxy) -> some View {
		VStack(spacing: 0) {
			HStack {
				Spacer()
				closeButton
					.padding([.top, .trailing], 20)
			}
			if showPaddleInput {
				PaddleInputView(isVisible: $showPaddleInput, resetTimer: resetTimer)
					.background(Color.white)
					.transition(.opacity)
					.zIndex(1)
			}
			else {
				ScrollView {
					VStack(spacing: 0) {
						ImageGalleryView(selectedImage: $selectedImage, remainingTime: $remainingTime, progress: $progress, item: item, images: item.images ?? .init(), resetTimer: resetTimer)
							.frame(height: geometry.size.height * 0.5)
							.accessibilityIdentifier("imageGalleryView")
						DetailInfoView(isVisible: $isVisible, resetTimer: resetTimer, item: item)
							.background(Color.white)
							.frame(maxHeight: .infinity, alignment: .top)
							.clipped()
							.accessibilityIdentifier("detailInfoView")
					}
				}
				.simultaneousGesture(DragGesture().onChanged { _ in resetTimer() })
				ButtonSectionItemView(item: item, resetTimer: resetTimer, showPaddleInput: $showPaddleInput)
					.background(Color.white)
					.frame(maxWidth: .infinity)
					.padding(.bottom, 10)
					.accessibilityIdentifier("buttonSectionView")
			}
		}
		.padding(.horizontal, 10)
		.padding(.top, 10)
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
				resetTimer()
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

	private func startTimer() {
		stopTimer()
		remainingTime = 60
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
			if remainingTime > 0 {
				remainingTime -= 1
				progress = CGFloat(remainingTime) / 60.0
			}
			else {
				isVisible = false
			}
		}
	}

	private func stopTimer() {
		timer?.invalidate()
		timer = nil
	}

	private func resetTimer() {
		remainingTime = 60
		progress = 1.0
	}
}

struct PaddleInputView: View {
	@Binding var isVisible: Bool
	@State private var inputText: String = ""
	@State private var activeKey: String? = nil
	@State private var pressedKeys: Set<String> = []
	let resetTimer: () -> Void

	var body: some View {
		VStack {
			Spacer()
			VStack(spacing: 40) {
				Text("Enter your paddle number")
					.font(.headline)
					.fontWeight(.bold)
					.padding()

				ZStack {
					VStack {
						Text(inputText)
							.frame(height: 30)
							.font(.largeTitle)
							.fontWeight(.semibold)
							.frame(maxWidth: .infinity, alignment: .center)

						Rectangle()
							.frame(height: 1)
							.foregroundColor(inputText.isEmpty ? .black : Color.accentViolet)
							.frame(maxWidth: .infinity, alignment: .center)
							.padding([.leading, .trailing], 60)
					}
					.padding([.leading, .trailing], 40)
				}

				VStack(spacing: 20) {
					ForEach(["1 2 3", "4 5 6", "7 8 9", "0 ⌫"], id: \.self) { row in
						HStack(spacing: 20) {
							ForEach(row.split(separator: " "), id: \.self) { key in
								Button(action: {
									handleKeyPress(String(key))
									animateButtonPress(String(key))
									resetTimer()
								}) {
									Text(key)
										.font(.headline)
										.frame(width: 80, height: 80)
										.fontWeight(.medium)
										.background(Color.white)
										.foregroundColor(.black)
										.clipShape(Circle())
										.overlay(
											Circle()
												.stroke(pressedKeys.contains(String(key)) ? Color.accentViolet : Color.accentGrayBorder, lineWidth: 1)
										)
								}
							}
						}
					}
				}
				.padding(.bottom, 0)

				HStack {
					Button<Text>.styled(config: .thirdButtonStyle, action: {
						isVisible = false
						resetTimer()
					}) {
						Text("Cancel")
							.textCase(.uppercase)
					}.accessibilityIdentifier("Cancel")
						.padding(.leading)

					Button<Text>.styled(config: .secondaryButtonStyle, action: {
						isVisible = false
						resetTimer()
					}) {
						Text("Confirm")
							.textCase(.uppercase)
					}.accessibilityIdentifier("Confirm")
						.padding(.trailing)
				}
			}
			.frame(maxWidth: .infinity)
			Spacer()
		}
		.onTapGesture {
			resetTimer()
		}
		.frame(maxHeight: .infinity)
	}

	private func handleKeyPress(_ key: String) {
		if key == "⌫" {
			if !inputText.isEmpty {
				inputText.removeLast()
			}
		}
		else if inputText.isEmpty, key == "0" {
			return
		}
		else if inputText.count < 6 {
			inputText.append(key)
		}
	}

	private func animateButtonPress(_ key: String) {
		pressedKeys.insert(key)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			pressedKeys.remove(key)
		}
	}
}
