### CHANGELOG

#### Version 0.3.1

* Changed the metadata info, in order to prevent a name conflict with the other Win11 indicator: https://github.com/JM-Enthusiast/latte-indicator-win11

NOTE: Due to this change, you CANNOT update from previous version, you'll need to remove the old one first, either from store or using this command below

kpackagetool5 -r org.kde.latte.win11 -t Latte/Indicator

Then install the new version. I am sorry for this inconvenience and it is my hoping that this won't happen again.

#### Version 0.3.0

* Added a border around the tasks
* Moved the "bottom line" code to ActiveLine.qml, and added a progress bar effect to it.

#### Version 0.2.0

* Fixed the appearance of "more than one window effect"
* Correction on some colors
* Moved the "bottom line" code to main.qml, which in turn ensures that it always stays at the center.

#### Version 0.1.0

* Initial release
* Based on Latte Win10 indicator
