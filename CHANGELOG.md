### CHANGELOG

#### Version 0.8.1

* Fixed a little graphical glitch with the gradients when windows are grouped.
* The indicator line should be touching to the "border" for real this time.

#### Version 0.8.0

* Much more accurate "grouping effect", which should also work better with bigger panel sizes now.
* Renamed the "Progress animation in background" option to "Progress animation in the indicator line", to make its purpose actually make sense.

#### Version 0.7.2

* Reduced the minimum possible Task Length value from 25% to 15%, per request by skyhaus178.

#### Version 0.7.1

* Moved the indicator line 1px closer to the screen edge (aka it should be "touching" to the "border" again).

#### Version 0.7.0

* Animations for the following states:
 - Pressing on a task (slightly buggy)
 - Adding/removing a window to/from a group
 - Window getting minimized by clicking on its icon.
* Ability to change the icon scale of tasks.
NOTE: These changes above bump the minimum required version of Latte to 0.10.4, due to use of the properties introduced in the said version.
* Renamed ActiveLine to FrontLayer, so that it will always render above everything else.
* Some minor cosmetic changes.

#### Version 0.6.0

* Reduced the amount of "grouped windows" to 2, to match it with how it actually is in Win11 (and 10).
An option is provided to return back to the previous behaviour (3 windows in a group - a la Win7).
* Improved the appearance of tasks, with the "slightly glowing top section" tweak being taken from the other Win11 indicator: https://github.com/JM-Enthusiast/latte-indicator-win11/
* Stylization for top panels.

#### Version 0.5.0

* Slight changes on how the indicator looks, that should make it appear more in line with Win11's style.
* Active window line should be more brighter now, provided you use a theme that supports setting up custom accent colors.
* Some cleanups.

#### Version 0.4.0

* Further correction on colors.
* Light and Dark modes.
* Better looking progress bar.

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
