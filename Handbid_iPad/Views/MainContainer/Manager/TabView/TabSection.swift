//Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUICore

struct TabSection: Hashable {
    private let text: String
    let iconName: String
    var localizedText: LocalizedStringKey {
        .init(text)
    }
    
    init(text: String, iconName: String) {
        self.text = text
        self.iconName = iconName
    }
    
    static let sections: [TabSection] = [
        .init(text: "manager_label_dashboard", iconName: "house"),
        .init(text: "manager_label_guestList", iconName: "person"),
        .init(text: "manager_label_live", iconName: "gearshape"),
        .init(text: "manager_label_activity", iconName: ""),
        .init(text: "manager_label_stream", iconName: ""),
        .init(text: "manager_label_appeals", iconName: "")
        
    ]
}
