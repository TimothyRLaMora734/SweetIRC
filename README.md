# SweetIRC
IRC client for macOS 12, Monterey, written in Swift with SwiftUI, and URLSession for plain TCP/IP connection.


## About

SweetIRC is still in prototype phase, it can currently receive messages, join rooms, stay alive by sending PONG responses to the IRC Server, it can also send messages, but the GUI needs some work done


<<<<<<< HEAD
=======
### How does it look?

This is the initial screen, where you enter your data and possibly credentials:

<img width="412" alt="image" src="https://user-images.githubusercontent.com/10388612/158570446-a5c96070-3995-4978-8528-c0335ca88df4.png">

When you connect, there's a small transition animation, thanks to SwiftUI transitions and annimations. And you're imeidatly connected to a so called _system room_
, where you can see messages from the server:

<img width="912" alt="image" src="https://user-images.githubusercontent.com/10388612/158570623-9925f998-5668-4626-a93d-e4ca358eb924.png">

You can then go on and connect to other channels (aka rooms), like **##programming** in this example, where messages start kicking in:

<img width="912" alt="image" src="https://user-images.githubusercontent.com/10388612/158570993-4d7eb53d-c1a8-4a5c-9ca3-03014969ef36.png">

## Work in progress...
I'm currently working on prototyping joining rooms:

<img width="912" alt="image" src="https://user-images.githubusercontent.com/10388612/158571289-a14a27ba-cbf7-4526-93fd-6660d12d6280.png">
>>>>>>> 0e5eebd1d632299015803086a3169433ae922365



## Volunteering?

Anyone is welcomed to volunteer. Refactor, improve, implement further the [IRC Protocol](https://datatracker.ietf.org/doc/html/rfc2812#section-3.2.1), report or solve bugs, or simply propose things.
