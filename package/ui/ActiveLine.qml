import QtQuick 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: activeIndicator
    property bool showProgress: false
    property int indicatorMode: root.indicatorMode

    Rectangle {
        id: activeLine
        anchors.bottom: parent.bottom
        anchors.bottomMargin: PlasmaCore.Units.smallSpacing * 0.5 + 1
        anchors.horizontalCenter: parent.horizontalCenter

        radius: 2

        width: {
            return (indicator.isActive || progressLoader.status !== Loader.Null) ? parent.width * 0.3 : parent.width * 0.15;
        }

        height: root.lineThickness

        color: {
            if (progressLoader.status !== Loader.Null) {
               return indicatorMode === 0 /* Light */ ? "#b5b5b5" : "#2a2a2a"
            }
            else if (indicator.hasActive && progressLoader.status === Loader.Null)
                return theme.highlightColor //root.activeColor
            return indicatorMode === 0 /* Light */ ? "#858585" : "#9a9a9a"
        }

        visible: !indicator.isApplet && (indicator.isActive || indicator.isWindow)

        Behavior on width {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutQuad
            }

        }
        Behavior on color {
            ColorAnimation {
                duration: 120
                //easing.type: Easing.OutQuad
            }
        }
    }

    Loader {
        id: progressLoader
        anchors.fill: activeLine
        asynchronous: true
        active: indicator.configuration.progressAnimationEnabled && activeIndicator.showProgress && indicator.progress > 0
        sourceComponent: Item {
            Item {
                id: progressFrame
                anchors.fill: parent
                Rectangle {
                    width: activeLine.width * (Math.min(indicator.progress, 100) / 100)
                    height: root.lineThickness;
                    color: indicator.isActive ? theme.highlightColor : (indicatorMode === 0 /* Light */ ? "#7e7e7e" : "#9e9e9e")
                }

                visible: false
            }

            Item {
                id: progressMask
                anchors.fill: parent

                Rectangle {
                    anchors.fill: parent
                    radius: activeLine.radius
                    color: "red"
                }
                visible: false
            }

            Rectangle {
                anchors.fill: parent
                radius: activeLine.radius
                color: "transparent"
                //clip: true

                OpacityMask {
                    anchors.fill: parent
                    source: progressFrame
                    maskSource: progressMask
                    opacity: 0.8
                }
            }
        }
    }
}
