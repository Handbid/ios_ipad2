// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct OverlayInternalView<Content: View>: View {
    @State private var contentHeight: CGFloat = 0
    @State private var keyboardHeight: CGFloat = 0
    let overlayContent: () -> Content
    let cornerRadius: CGFloat
    let backgroundColor: Color?

    init(cornerRadius: CGFloat,
         backgroundColor: Color? = .white,
         @ViewBuilder overlayContent: @escaping () -> Content) {
        self.cornerRadius = cornerRadius
        self.overlayContent = overlayContent
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        ResponsiveView { layoutProperties in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(backgroundColor)
                        .cornerRadius(cornerRadius)
                        .frame(
                            width: calculateWidth(layoutProperties: layoutProperties),
                            height: max(contentHeight, keyboardHeight)
                        )
                        .overlay(
                            overlayContent()
                                .background(GeometryReader { geo in
                                    Color.clear.onAppear {
                                        self.contentHeight = geo.size.height
                                    }
                                })
                        )
                        .padding(.bottom, keyboardHeight)
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    keyboardHeight = keyboardSize.height
                }
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                keyboardHeight = 0
            }
        }
    }
    
	private func calculateWidth(layoutProperties: LayoutProperties) -> CGFloat {
		switch UIDevice.current.userInterfaceIdiom {
		case .pad:
			layoutProperties.landscape ? layoutProperties.width * 0.5 : layoutProperties.width * 0.7
		case .phone:
			layoutProperties.landscape ? layoutProperties.width * 0.8 : layoutProperties.width * 0.9
		case .tv:
			layoutProperties.width * 0.6
		case .carPlay:
			layoutProperties.width * 0.7
		case .mac:
			layoutProperties.width * 0.8
		case .vision:
			layoutProperties.width * 0.9
		default:
			layoutProperties.width * 0.7
		}
	}

	private func calculateHeight(layoutProperties: LayoutProperties) -> CGFloat {
		switch UIDevice.current.userInterfaceIdiom {
		case .pad:
			layoutProperties.landscape ? layoutProperties.height * 0.6 : layoutProperties.height * 0.5
		case .phone:
			layoutProperties.landscape ? layoutProperties.height * 0.95 : layoutProperties.height * 0.8
		case .tv:
			layoutProperties.height * 0.5
		case .carPlay:
			layoutProperties.height * 0.6
		case .mac:
			layoutProperties.height * 0.7
		case .vision:
			layoutProperties.height * 0.8
		default:
			layoutProperties.height * 0.6
		}
	}
}
