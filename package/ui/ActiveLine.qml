import QtQuick 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: activeIndicator
    property bool showProgress: false

    Rectangle {
        id: activeLine
        anchors.bottom: parent.bottom
        anchors.bottomMargin: PlasmaCore.Units.smallSpacing * 0.5 + 1
        anchors.horizontalCenter: parent.horizontalCenter

        radius: 2

        width: {
            return indicator.isActive ? parent.width * 0.3 : parent.width * 0.15;
        }

        height: root.lineThickness

        color: {
            if (indicator.hasActive && progressLoader.status !== Loader.Null) {
               return "#a0a0a0"
            }
            else if (indicator.hasActive && progressLoader.status === Loader.Null)
                return theme.highlightColor //root.activeColor
            return "#9A9A9A"
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
                    height: root.lineThickness
                    color: theme.highlightColor
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
                clip: true

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
