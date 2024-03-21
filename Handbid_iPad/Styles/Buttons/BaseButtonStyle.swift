// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

protocol BaseButtonStyle: ButtonStyle {
	var backgroundColor: UIColor { get }
}

extension BaseButtonStyle {
	var padding: EdgeInsets {
		.init(top: 12.0, leading: 24.0, bottom: 12.0, trailing: 24.0)
	}

	var cornerRadius: CGFloat {
		40.0
	}

	var textColor: Color {
		.white
	}

	var fontWieght: Font.Weight {
		.semibold
	}
}
