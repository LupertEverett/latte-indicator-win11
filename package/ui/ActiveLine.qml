import QtQuick 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: activeIndicator
    property bool showProgress: false
    property int indicatorMode: root.indicatorMode

    readonly property bool isOnTopEdge: (plasmoid.location === PlasmaCore.Types.TopEdge)

    readonly property int lineMargin: PlasmaCore.Units.smallSpacing * 0.5 + 2

    Rectangle {
        id: activeLine
        anchors.bottom: parent.bottom
        anchors.topMargin: isOnTopEdge ? lineMargin : 0
        anchors.bottomMargin: !isOnTopEdge ? lineMargin : 0
        anchors.horizontalCenter: parent.horizontalCenter

        radius: 2

        width: (indicator.hasActive || progressLoader.status !== Loader.Null) ? parent.width * 0.3 : parent.width * 0.15;

        height: root.lineThickness

        color: {
            if (progressLoader.status !== Loader.Null) {
               return indicatorMode === 0 /* Light */ ? "#b5b5b5" : "#2a2a2a"
            }
            else if (indicator.hasActive && progressLoader.status === Loader.Null)
                // Note: Your Plasma Style MUST support custom color schemes if you want to
                // be able to change the color with the custom accent color option
                return root.activeColor
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
            }
        }
    }

    Loader {
        id: progressLoader
        anchors.fill: activeLine
        asynchronous: true
        active: indicator.configuration.progressAnimationEnabled && activeIndicator.showProgress && indicator.progressVisible /*indicator.progress > 0*/
        sourceComponent: Item {
            Item {
                id: progressFrame
                anchors.fill: parent
                Rectangle {
                    width: activeLine.width * (Math.min(indicator.progress, 100) / 100)
                    height: root.lineThickness
                    color: indicator.isActive ? theme.linkColor : (indicatorMode === 0 /* Light */ ? "#7e7e7e" : "#9e9e9e")
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

                OpacityMask {
                    anchors.fill: parent
                    source: progressFrame
                    maskSource: progressMask
                    opacity: 0.8
                }
            }
        }
    }

    states: [
        State {
            name: "bottom"
            when: plasmoid.location === PlasmaCore.Types.BottomEdge

            AnchorChanges {
                target: activeLine
                anchors {
                    bottom: parent.bottom
                    top: undefined
                    horizontalCenter: parent.horizontalCenter
                }
            }

            AnchorChanges {
                target: progressLoader
                anchors {
                    bottom: parent.bottom
                    top: undefined
                    horizontalCenter: parent.horizontalCenter
                }
            }
        },
        State {
            name: "top"
            when: plasmoid.location === PlasmaCore.Types.TopEdge

            AnchorChanges {
                target: activeLine
                anchors {
                    bottom: undefined
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                }
            }

            AnchorChanges {
                target: progressLoader
                anchors {
                    bottom: undefined
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }
    ]
}
