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

import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.latte.core 0.2 as LatteCore
import org.kde.latte.components 1.0 as LatteComponents

LatteComponents.IndicatorItem {
    id: root
    needsIconColors: true
    providesFrontLayer: true
    providesHoveredAnimation: true
    providesClickedAnimation: true
    minThicknessPadding: 0.03
    minLengthPadding: 0.25

    providesTaskLauncherAnimation: true
    providesGroupedWindowAddedAnimation: true
    providesGroupedWindowRemovedAnimation: true

    readonly property bool progressVisible: indicator.hasOwnProperty("progressVisible") ? indicator.progressVisible : false
    readonly property bool isHorizontal: plasmoid.formFactor === PlasmaCore.Types.Horizontal
    readonly property bool isVertical: !isHorizontal

    readonly property int screenEdgeMargin: indicator.hasOwnProperty("screenEdgeMargin") ? indicator.screenEdgeMargin : 0
    readonly property int thickness: !isHorizontal ? width - screenEdgeMargin : height - screenEdgeMargin

    readonly property int indicatorMode: indicator.configuration.indicatorMode

    readonly property bool showThreeTasksInGroup: indicator.configuration.showThreeTasksInGroup

    readonly property int groupItemLength: indicator.currentIconSize * 0.13
    readonly property int groupsSideMargin: {
        if (indicator.windowsCount <= 1)
            return 0
        return Math.min(indicator.windowsCount - 1, (showThreeTasksInGroup ? 2 : 1) ) * root.groupItemLength
    }

    property int previouslyMinimizedWindowsCount: 0

    readonly property double taskIconScale: indicator.configuration.taskIconScaling

    //readonly property real backColorBrightness: colorBrightness(indicator.palette.backgroundColor)
    readonly property color activeColor: indicator.palette.linkColor
    /*readonly property color outlineColor: {
        if (!indicator.configuration.drawShapesBorder) {
            return "transparent"
        }

        return backColorBrightness < 127 ? indicator.palette.backgroundColor : indicator.palette.textColor;
    }*/
    //readonly property color backgroundColor: indicator.palette.backgroundColor

    function colorBrightness(color) {
        return colorBrightnessFromRGB(color.r * 255, color.g * 255, color.b * 255);
    }

    // formula for brightness according to:
    // https://www.w3.org/TR/AERT/#color-contrast
    function colorBrightnessFromRGB(r, g, b) {
        return (r * 299 + g * 587 + b * 114) / 1000
    }

    // Extremely amazing-ly silly attempt of checking if a window got minimized
    function didAWindowMinimizeJustNow() {
        var result = false

        if (root.previouslyMinimizedWindowsCount < indicator.windowsMinimizedCount)
            result = true

        root.previouslyMinimizedWindowsCount = indicator.windowsMinimizedCount
        return result
    }

    readonly property int lineThickness: Math.max(indicator.currentIconSize * indicator.configuration.lineThickness, 2)
    readonly property int shrinkLengthEdge: 0.13 * parent.width

    readonly property real opacityStep: {
        if (indicator.configuration.maxBackgroundOpacity >= 0.3) {
            return 0.1;
        }

        return 0.05;
    }

    readonly property real backgroundOpacity: {
        if (indicator.isHovered && indicator.hasActive) {
            return indicator.configuration.maxBackgroundOpacity;
        } else if (indicator.hasActive) {
            return indicator.configuration.maxBackgroundOpacity - opacityStep;
        } else if (indicator.isHovered) {
            return indicator.configuration.maxBackgroundOpacity - 2*opacityStep;
        }

        return 0;
    }

    //! Bindings for properties that have introduced
    //! later on Latte versions > 0.9.2

    Binding{
        target: level.requested
        property: "iconOffsetX"
        when: level && level.requested && level.requested.hasOwnProperty("iconOffsetX") && showThreeTasksInGroup
        value: -root.groupsSideMargin / 6
    }

    Binding{
        target: indicator.isTask && level.requested // So that we don't accidentally scale down the clock applet
        property: "iconScale"
        when: level && level.requested && level.requested.hasOwnProperty("iconScale")
        value: root.taskIconScale
    }

    Binding{
        target: root
        property: "appletLengthPadding"
        when: root.hasOwnProperty("appletLengthPadding")
        value: indicator.configuration.appletPadding
    }

    Binding{
        target: root
        property: "enabledForApplets"
        when: root.hasOwnProperty("enabledForApplets")
        value: indicator.configuration.enabledForApplets
    }

    Binding{
        target: root
        property: "lengthPadding"
        when: root.hasOwnProperty("lengthPadding")
        value: indicator.configuration.lengthPadding
    }

    //! Background Layer
    Item {
        id: floater
        anchors.fill: parent
        anchors.topMargin: plasmoid.location === PlasmaCore.Types.TopEdge ? root.screenEdgeMargin : 0
        anchors.bottomMargin: plasmoid.location === PlasmaCore.Types.BottomEdge ? root.screenEdgeMargin : 0
        anchors.leftMargin: plasmoid.location === PlasmaCore.Types.LeftEdge ? root.screenEdgeMargin : 0
        anchors.rightMargin: plasmoid.location === PlasmaCore.Types.RightEdge ? root.screenEdgeMargin : 0

        Loader{
            id: backLayer
            anchors.fill: parent
            anchors.rightMargin: groupsSideMargin
            active: level.isBackground && !indicator.inRemoving

            sourceComponent: BackLayer{
            }
        }

        Loader {
            id: secondStackedLoader
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: (showThreeTasksInGroup && indicator.windowsCount > 2 && active) ? groupItemLength : 0

            height: parent.height
            active: indicator.windowsCount>=2 && !indicator.inRemoving
            opacity: 0.7

            readonly property bool isUnhoveredSecondStacked: active && !indicator.isHovered && root.backgroundOpacity === 0

            sourceComponent: GroupRect {
            }
        }

        Loader {
            id: thirdStackedLoader
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            height: parent.height
            active: showThreeTasksInGroup && indicator.windowsCount>=3 && backgroundOpacity > 0 && !secondStackedLoader.isUnhoveredSecondStacked && !indicator.inRemoving
            opacity: 0.4

            sourceComponent: GroupRect {
            }
        }

        Loader {
            id: activeLine
            anchors.fill: parent

            active: indicator.isWindow

            sourceComponent: FrontLayer {
                showProgress: root.progressVisible
            }
        }
    }

    // Animations

    Connections {
        target: level
        enabled: indicator.animationsEnabled && indicator.isTask && level.isBackground

        onTaskGroupedWindowAdded: {
            if (!windowAddedAnimation.running) {
                windowAddedAnimation.start();
            }
        }

        onTaskGroupedWindowRemoved: {
            if (!windowRemovedAnimation.running) {
                windowRemovedAnimation.start();
            }
        }
    }

    Connections {
        target: level
        enabled: indicator.animationsEnabled && indicator.isLauncher && level.isBackground
        onTaskLauncherActivated: {
            if (!pressedAnim.running) {
                pressedAnim.start();
            }
        }
    }

    // When clicked on a taskbar item, Win11 scales the icon of it briefly.

    // Slightly buggy: Animation abruptly ends when there are no active windows and the user clicks on the icon for a short period of time,
    // even if alwaysRunToEnd is set to true.
    // It works properly when there is at least one active window, and I have no idea why.
    // The new animations from 0.10.4 cannot be used here, as in Win11, the animation itself runs as long as the user clicks on the task.

    NumberAnimation {
        id: pressedAnim
        running: (indicator.isLauncher || indicator.isTask) && indicator.isPressed // && !indicator.hasActive && !indicator.inRemoving
        alwaysRunToEnd: true

        target: level ? level.requested : null
        property: "iconScale"

        loops: Animation.Infinite

        to: root.taskIconScale * 0.8
        duration: indicator.durationTime * 100
        easing.type: Easing.InQuad

        onStopped: {
            pressedAnimEnd.start();
        }
    }

    NumberAnimation {
        id: pressedAnimEnd
        target: level ? level.requested : null
        property: "iconScale"

        to: root.taskIconScale
        duration: indicator.durationTime * 100
        easing.type: Easing.OutQuad

        onStopped: {
            if (indicator.windowsCount === 1 && didAWindowMinimizeJustNow()) {
                windowRemovedAnimation.start()
            }
        }
    }

    // When a grouped window is added, Win11 moves the app icon upwards very briefly.

    SequentialAnimation {
        id: windowAddedAnimation
        alwaysRunToEnd: true

        readonly property int animationStep: 125

        readonly property string toProperty: isHorizontal ? "iconOffsetY" : "iconOffsetX"

        PropertyAnimation {
            target: level ? level.requested : null
            property: windowRemovedAnimation.toProperty
            to: (indicator.currentIconSize / 10) * ( (plasmoid.location === PlasmaCore.Types.TopEdge || plasmoid.location === PlasmaCore.Types.LeftEdge) ? 1 : -1 )
            duration: indicator.durationTime * windowRemovedAnimation.animationStep
            easing.type: Easing.Linear
        }

        PropertyAnimation {
            target: level ? level.requested : null
            property: windowRemovedAnimation.toProperty
            to: 0
            duration: 2.7 * indicator.durationTime * windowRemovedAnimation.animationStep
            easing.type: Easing.OutBounce
        }
    }

    // When a grouped window is closed, or a window is minimized, Win11 moves the app icon downwards very briefly.

    SequentialAnimation {
        id: windowRemovedAnimation
        alwaysRunToEnd: true

        readonly property int animationStep: 125

        readonly property string toProperty: isHorizontal ? "iconOffsetY" : "iconOffsetX"

        PropertyAnimation {
            target: level ? level.requested : null
            property: windowRemovedAnimation.toProperty
            to: (indicator.currentIconSize / 10) * ( (plasmoid.location === PlasmaCore.Types.TopEdge || plasmoid.location === PlasmaCore.Types.LeftEdge) ? -1 : 1 )
            duration: indicator.durationTime * windowRemovedAnimation.animationStep
            easing.type: Easing.Linear
        }

        PropertyAnimation {
            target: level ? level.requested : null
            property: windowRemovedAnimation.toProperty
            to: 0
            duration: 2.7 * indicator.durationTime * windowRemovedAnimation.animationStep
            easing.type: Easing.OutBounce
        }
    }
}
