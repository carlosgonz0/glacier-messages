/* Copyright (C) 2018-2021 Chupligin Sergey <neochapay@gmail.com>
 * Copyright (C) 2012 John Brooks <john.brooks@dereferenced.net>
 *
 * You may use this file under the terms of the BSD license as follows:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *   * Neither the name of Nemo Mobile nor the names of its contributors
 *     may be used to endorse or promote products derived from this
 *     software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import QtQuick 2.6

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.messages.internal 1.0
import org.nemomobile.commhistory 1.0

Item {
    property alias model: view.model
    // The event model is in descending order, but we need to display ascending.
    // There is no sane way to invert the view, but we can use this incredibly
    // bad hack: rotate the view, then rotate the delegate to be upright.
    rotation: 180

    ListView {
        id: view
        spacing: Theme.itemSpacingSmall
        anchors.fill: parent

        clip: true

        Connections {
            target: model || null
            onRowsInserted: {
                if (first == 0)
                    view.positionViewAtBeginning()
            }
            onModelReset: view.positionViewAtBeginning()
        }

        delegate: Item{
            id: messageLine
            width: view.width*0.8+Theme.itemSpacingSmall*2
            height: childrenRect.height

            clip: true

            anchors{
                left: model.direction == CommHistory.Outbound ? undefined : parent.left
                leftMargin: Theme.itemSpacingSmall
                right: model.direction == CommHistory.Outbound ? parent.right : undefined
                rightMargin: Theme.itemSpacingSmall
            }

            Rectangle{
                id: messageBaloon
                height: messageText.paintedHeight + Theme.itemSpacingSmall*2
                width: messageText.paintedWidth + Theme.itemSpacingSmall*2

                color: model.direction == CommHistory.Outbound ? Theme.fillColor : Theme.accentColor

                rotation: 180

                anchors{
                    left: model.direction == CommHistory.Outbound ? undefined : parent.left
                    right: model.direction == CommHistory.Outbound ? parent.right : undefined
                }

                NemoIcon{
                    id: statusIcon
                    visible:  model.direction === CommHistory.Outbound
                    height: parent.height/4
                    width: height

                    anchors{
                        bottom: messageBaloon.bottom
                        left: messageBaloon.left
                    }

                    source: calcMessageIcon()

                    function calcMessageIcon() {
                        if(model.status === CommHistory.SendingStatus) {
                            return "image://theme/upload"
                        }

                        if(model.status === CommHistory.SentStatus) {
                            return "image://theme/check"
                        }

                        if(model.status === CommHistory.DeliveredStatus) {
                            return "image://theme/check-double"
                        }

                        if(model.status === CommHistory.FailedStatus) {
                            return "image://theme/exclamation-triangle"
                        }

                        if(model.status === CommHistory.DownloadingStatus) {
                            return "image://theme/download"
                        }
                        statusIcon.visible = false
                        return ""
                    }
                }

                Text {
                    id: messageText
                    text: model.freeText
                    height: paintedHeight
                    wrapMode: Text.Wrap
                    color: Theme.textColor
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeMedium
                    anchors{
                        left: messageBaloon.left
                        leftMargin: Theme.itemSpacingSmall
                        top: messageBaloon.top
                        topMargin: Theme.itemSpacingSmall
                    }

                    Component.onCompleted: {
                        if(messageText.paintedWidth > messageLine.width) {
                            messageText.width = messageLine.width
                        }
                    }
                }
            }
        }

        ScrollDecorator {
            flickable: view
        }
    }
}

