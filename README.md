# rngtrainer_frontend

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#project-setup">Project Setup</a></li>
      </ul>
    </li>
    <li><a href="#roadmap">Roadmap</a></li>
  </ol>
</details>

## About The Project

### Built With

* [Flutter](https://flutter.dev/)

## Getting Started

### Prerequisites
#### Option 1: Using docker!
The easiest way to get the frontend running is by using Visual Studio Code and its extensions + Docker. With docker you don't need to install the Flutter and Android SDK on your developer machine.

* [Install Visual Studio Code](https://code.visualstudio.com/) 
* [Install Docker](https://www.docker.com/products/docker-desktop)

Inside VsCode, install following extensions:
* [Docker extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
* [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)


The configuration for the dockerfile can be found in the following repository file:
[Configuration of dockerfile](.devcontainer/devcontainer.json).

For debugging, the following chrome extension is needed:
[Chrome Debug Extension](https://chrome.google.com/webstore/detail/dart-debug-extension/eljbmlghnomdjgdjmbdekegdkbabckhm).
After installing that please navigate to lib/main.dart and press F5. This will launch a new browser tab and you have to click the Dart debug plugin to finally open the app.

#### Option 2: Get it run without docker!
* [Install Visual Studio Code](https://code.visualstudio.com/) 

Inside VsCode, install following extensions:
* [Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)
* [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

Use the following command in the terminal to check wheter flutter is installed correctly.
```sh
flutter doctor -v
```

### Project Setup

**Step 1:**
Download or clone this repo by using the link below:

```
https://github.com/Master-Project-RNG/rgntrainer_frontend.git
```

**Step 2:**
Open the project folder in VScode. 

If you run your application with the help of the container, click on the green button on the left buttom corner. 
![image](https://user-images.githubusercontent.com/22227408/117004803-c7d4ce00-ace6-11eb-92f2-849fdfa6aaa3.png)

Then choose `Remote - Containers: Reopen in Container`

**Step 3 :**
Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```


**Step 4:**
Befor starting the frontend, make sure that the backend is running. Change the api BASE URL in [host.dart](lib/host.dart) so that it accesses a running backend.


**Step 5:**
Start the application. 

Wihtout container
```
flutter run -d chrome
```

With container
```
`Press F5` in main.dart
```

<!-- ROADMAP -->
## Roadmap
See the [open issues](https://github.com/Master-Project-RNG/rgntrainer_frontend/issues) for a list of proposed features (and known issues).


