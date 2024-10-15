//Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUICore

enum TabSection: Hashable, CaseIterable {
    case dashboard
    case guestList
    case live
    case activity
    case stream
    case appeals
    
    var iconName: String {
        switch self {
        case .dashboard: "managerDashboardIcon"
        case .guestList: "managerGuestListIcon"
        case .live: "managerLiveIcon"
        case .activity: "managerActivityIcon"
        case .stream: "managerStreamIcon"
        case .appeals: "managerAppealsIcon"
        }
    }
    var localizedText: LocalizedStringKey {
        switch self {
        case .dashboard: LocalizedStringKey("manager_label_dashboard")
        case .guestList: LocalizedStringKey("manager_label_guestList")
        case .live: LocalizedStringKey("manager_label_live")
        case .activity: LocalizedStringKey("manager_label_activity")
        case .stream: LocalizedStringKey("manager_label_stream")
        case .appeals: LocalizedStringKey("manager_label_appeals")
        }
    }
}
