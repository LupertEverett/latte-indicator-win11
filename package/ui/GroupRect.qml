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
import QtGraphicalEffects 1.15

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: groupRoot
    width: root.groupItemLength + 4 //layerWidth
    height: parent.height

    Item {
        anchors.fill: parent

        BackLayer {
            id: secondRect
            anchors.right: parent.right
            anchors.top: parent.top
            width: 4 * parent.width
            height: parent.height
        }

        Rectangle {
            id: mask
            anchors.left: parent.left
            anchors.top: parent.top
            width: parent.width
            height: parent.height
            color: "transparent"
            visible: false

            Rectangle {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 2

                height: 0.9 * parent.height
                width: 0.3 * root.groupItemLength

                color: "black"

                radius: 2
            }

            Rectangle {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 1
                color: "black"

                height: 0.8 * parent.height + 1
                width: 0.6 * root.groupItemLength

                radius: 6
            }
        }

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: mask
            invert: true
        }
    }
}
