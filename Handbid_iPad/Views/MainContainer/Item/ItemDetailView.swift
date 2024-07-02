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
				VStack(spacing: 10) {
					ScrollView {
						DetailInfoView(isVisible: $isVisible, resetTimer: resetTimer, item: item)
							.background(Color.clear)
							.frame(maxHeight: .infinity)
							.clipped()
							.accessibilityIdentifier("detailInfoView")
					}
					.simultaneousGesture(DragGesture().onChanged { _ in resetTimer() })
					BottomSectionItemView(item: item, resetTimer: resetTimer, showPaddleInput: $showPaddleInput)
						.frame(maxWidth: .infinity)
						.accessibilityIdentifier("buttonSectionView")
				}
				.background(Color.accentGrayBackground)
				.padding(.bottom, 10)

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
				BottomSectionItemView(item: item, resetTimer: resetTimer, showPaddleInput: $showPaddleInput)
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
