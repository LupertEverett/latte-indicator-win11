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
    id: rectangleItem

    property bool isActive: indicator.isActive || (indicator.isWindow && indicator.hasActive)
    property bool isSecondStackedBackLayer: false
    //property bool isThirdStackedBackLayer: false
    property bool showProgress: false
    property int indicatorMode: root.indicatorMode

    Rectangle {
        anchors.fill: parent

        radius: backRect.radius
        color:  indicatorMode === 0 /* light */ ? "#f8f8f8" : "#b0b0b0"
        visible: opacity > 0
        opacity: root.backgroundOpacity
        border.width: 1
        border.color: indicatorMode === 0 /* light */ ? "#c8c8c8" : "#f0f0f0"

        anchors.topMargin: PlasmaCore.Units.smallSpacing * 0.6
        anchors.leftMargin: anchors.topMargin * 2
        anchors.bottomMargin: anchors.topMargin
        anchors.rightMargin: anchors.topMargin * 2 - (indicator.windowsCount >= 2 ? groupItemLength * 0.6 : 0)

        Behavior on opacity {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutQuad
            }
        }
    }

    Rectangle {
        id: backRect
        anchors.fill: parent
        radius: 4 //indicator.currentIconSize / 8
        color: "transparent"
        clip: true
    }
}
