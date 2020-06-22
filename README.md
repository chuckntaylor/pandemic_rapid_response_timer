# Pandemic Rapid Response Timer

Assistant timer app for the [Pandemic Rapid Response](https://www.zmangames.com/en/products/pandemic-rapid-response/) boardgame by Z-man Games. This project is a Flutter application which operates on both iOS and Android devices in either portrait or landscape modes.

![Pandemic Rapid Response Timer App in Action](https://chucktaylor.dev/public/images/pandemic.gif)

## App Details

While I enjoy many of the games in the Pandemic universe, Rapid Response is quite different in that it is a **real-time** game where you need to make quick decisions. Throughout the game your team has to race against the clock to deliver supplies to cities in need. The remaining time is measured through the use of a sand timer and time tokens. Whenever the sand timer runs out, a time token is discarded from a pool and the timer is flipped again. If the timer runs out and there are no time tokens remaining while there are unresolved cities in play, the game is lost.

Now, as the sand timer is completely silent, it is **very** easy to either not notice that time has run out, or to forget to discard a token. Additionally, when a city is resolved, a token is added to the pool. Because there is a lot to manage to keep track of time, and everyone is focused on making the most of their precious seconds, instead of staring at the sand timer, I have developed this app to keep track of the time and tokens, alert the players with audio, and provide reminders for drawing new cards from the city deck.

## Features

* Localization (English and French)
* Layouts for portrait and landscape modes
* Automated unit testing
* Shared Preferences for data persistence
* Vector animations
* Custom Painter classes for ui elements