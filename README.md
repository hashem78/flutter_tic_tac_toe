

# flutter_tic_tac_toe

<div align="center">
<img src="https://i.imgur.com/IpEYqkv.png"/>
</div>



This project is a way for me to pratice what I learned in an AI course I picked up in university last semester in addition to me wanting to learn about websockets. I also used Socket.io to create a simple online multiplayer mode.

# Compatible with
* Android (tested)
* Windows (tested)
* Linux (tested)

# Architecture 

#### these two flow charts should give you a basic idea on how this project works.


| Flow chart 1  |  Flow chart 2 |
|:-:|:-------------------------------:|
|![](https://i.imgur.com/1yk8dSQ.png)|![](https://i.imgur.com/8lEyEo3.png)|


local app state is handeled using riverpod and flutter_hooks.


# Server
This app uses a Client-Server model to to enable multiplayer gameplay, the server is written in dart and uses Socket.io to handel the websockets part.
You can find the server file on my github https://github.com/hashem78

# How to play
1. Start server on local host the default port number is 19281.

```dart
    dart run server.dart
```
2. Start a couple of clients

3. Select Online from the dropdown menu

4. On one client create a room and join in it on the other.

5. Enjoy.


# Game play and setup
![](https://i.imgur.com/JK55FIC.gif)

# Downloads
Please check the releases section on github.


# Notes

* The clients expect that the server is run on local host, if you want to deploy to a server you'll have to change the links in OnlineGameEngine.
* You can choose to play localy aganist an Ai (it uses minimaxing to choose the best moves).
* The AI spawns an Isolate to make the computations (basically threading) to avoid janking the ui.

# Ideas for the future
* Add difficulty levels for the Ai
* Implement other algorithms.
* Add spectating to online gameplay.
* Make more computations server-sided when playing online.

