/*
 * Copyright 2011 Robin Burchell
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    EmptyConversations {
        id: emptyListView
        anchors.fill: parent
        onClicked: {
            pageStack.push(Qt.resolvedUrl("ConversationPage.qml"))
        }
    }

    ListModel {
        id: peopleModel
        ListElement {
            personavatarPath: "image://theme/icon-m-telephony-contact-avatar"
            persondisplayLabel: "Nemo Mobile"
            personfavorite: false
        }
    }

    ListView {
        id: cardListView
        anchors.fill: parent
        snapMode: ListView.SnapToItem
        highlightFollowsCurrentItem: false
        focus: true
        keyNavigationWraps: false
        clip: true
        opacity: 0
        model: peopleModel

        delegate: ConversationListDelegate {
            onClicked: {
                pageStack.push(Qt.resolvedUrl("ConversationPage.qml"))
            }
        }
    }

    Binding {
        target: emptyListView;
        property: "opacity";
        value: ((cardListView.count == 0) ? 1 : 0);
    }
    Binding {
        target: cardListView;
        property: "opacity";
        value: ((cardListView.count > 0) ? 1 : 0);
    }
}
