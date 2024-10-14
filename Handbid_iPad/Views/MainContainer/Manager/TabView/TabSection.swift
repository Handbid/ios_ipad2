//Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUICore

struct TabSection: Hashable {
    private let text: String
    let iconName: String
    var localizedText: LocalizedStringKey {
        LocalizedStringKey(text)
    }
    
    init(text: String, iconName: String) {
        self.text = text
        self.iconName = iconName
    }
    
    static let sections: [TabSection] = [
        .init(text: "manager_label_dashboard", iconName: "managerDashboardIcon"),
        .init(text: "manager_label_guestList", iconName: "managerGuestListIcon"),
        .init(text: "manager_label_live", iconName: "managerLiveIcon"),
        .init(text: "manager_label_activity", iconName: "managerActivityIcon"),
        .init(text: "manager_label_stream", iconName: "managerStreamIcon"),
        .init(text: "manager_label_appeals", iconName: "managerAppealsIcon")
        
    ]
}
