/*
*  Copyright 2020  Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of Latte-Dock
*
*  Latte-Dock is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License as
*  published by the Free Software Foundation; either version 2 of
*  the License, or (at your option) any later version.
*
*  Latte-Dock is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item{
    property bool isActive: indicator.isActive || (indicator.isWindow && indicator.hasActive)
    property int indicatorMode: root.indicatorMode

    readonly property bool isOnTopEdge: (plasmoid.location === PlasmaCore.Types.TopEdge)

    readonly property int baseMargin: PlasmaCore.Units.smallSpacing * 0.6

    layer.enabled: true

    Rectangle {
        id: mainRect
        anchors.fill: parent

        radius: indicator.currentIconSize / 6
        color: indicatorMode === 0 /* light */ ? "#f8f8f8" : "#b0b0b0"
        visible: opacity > 0
        opacity: root.backgroundOpacity
        //border.width: 1
        border.color: indicatorMode === 0 /* light */ ? "#c8c8c8" : "#f0f0f0"

        clip: true

        anchors.topMargin: baseMargin
        anchors.leftMargin: anchors.topMargin * (indicator.isTask ? 2 : 0)
        anchors.bottomMargin: !isOnTopEdge ? baseMargin - 1 : baseMargin
        anchors.rightMargin: anchors.topMargin * (indicator.isTask ? 2 : 0) - (indicator.windowsCount >= 2 ? groupItemLength * 0.6 : 0)

        Behavior on opacity {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutQuad
            }
        }
    }

    // Slight "glow" on the top of the task is taken from:
    // https://github.com/JM-Enthusiast/latte-indicator-win11/blob/main/package/ui/BackLayer.qml

    Rectangle {
        id: backRect
        anchors.centerIn: parent
        width: mainRect.width
        height: mainRect.height
        radius: mainRect.radius
        color: "transparent"
        border.width: 1
        visible: false
    }

    Rectangle {
        id: borderEffect
        anchors.fill: parent
        radius: mainRect.radius
        gradient: !isOnTopEdge ? bottomGradient : topGradient
        visible: false
    }

    OpacityMask {
        anchors.centerIn: parent
        width: mainRect.width
        height: mainRect.height
        source: borderEffect
        maskSource: backRect
        visible: mainRect.visible
        opacity: mainRect.opacity + 0.05
    }

    // Gradients for Top and Bottom edges

    Gradient {
        id: bottomGradient
        GradientStop {
            position: 0.0
            color: mainRect.border.color
        }
        GradientStop {
            position: 0.1
            color: "transparent"
        }
    }

    Gradient {
        id: topGradient
        GradientStop {
            position: 0.9
            color: "transparent"
        }
        GradientStop {
            position: 1.0
            color: mainRect.border.color
        }
    }
}
