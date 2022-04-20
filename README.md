# Latte Win11 Indicator
This is a Win11 style indicator for [Latte Dock](https://phabricator.kde.org/source/latte-dock/repository/master/), based on [Latte Win10 indicator](https://github.com/psifidotos/latte-indicator-win10), with the "glow on the top" portion is taken from [this other Win11 indicator by JM-Enthusiast](https://github.com/JM-Enthusiast/latte-indicator-win11).

<p align="center">
<img src="https://imgur.com/x6muc4u.png" width="560" ><br/>
<i>Light Mode with Breeze Light Theme, using a custom accent color</i>
</p>

<p align="center">
<img src="https://imgur.com/YeCckCA.png" width="560" ><br/>
<i>Light Mode with Win11OS-light theme</i>
</p>

<p align="center">
<img src="https://imgur.com/bShfks2.png" width="560" ><br/>
<i>Dark Mode with Breeze Dark style, using a custom accent color</i>
</p>

<p align="center">
<img src="https://imgur.com/BFGjeef.png" width="560" ><br/>
<i>Dark Mode with Win11OS-dark theme</i>
</p>

<p align="center">
<img src="https://imgur.com/zXu0qeF.png" width="560" ><br/>
<i>Settings page as of 0.8.0</i>
</p>

# Notes

* Top and bottom panels have stylisations, while the remaining two use the bottom one's (for now?).

* The "separator curve" can look a bit thinner when the display scale is set to 100%. It was appearing correct when I used 106.25% and 112.5% scales. I even had it not showing up at all when I switched distros so I have no idea what exactly happens there.

* I don't (and cannot) use Win11, so I have no idea how accurate this indicator is. It is becoming better in that regard but still, any suggestions are appreciated!

# Requires

- Version >= 0.7.0 requires Latte >= 0.10.4

- 0.6.0 and earlier versions require Latte >= v0.9.2

# Install

<br>Download and install the indicator from https://www.opendesktop.org/p/1620476

<br>Or

<br>Clone this repo in one way or another, and cd to the folder newly created.

<br>From command line: ``kpackagetool5 -i . -t Latte/Indicator``

# Update

<br>From command line: ``kpackagetool5 -u . -t Latte/Indicator``
