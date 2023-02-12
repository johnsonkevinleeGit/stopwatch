# stopwatch_application

A stopwatch Flutter project.

## Getting Started

This project uses the Flutter SDK, VS Code, and the VS Code Flutter plugin.

1. Install Flutter SDK<br/>
Windows: https://docs.flutter.dev/get-started/install/windows <br/>
Mac: https://docs.flutter.dev/get-started/install/macos

2. Install VS Code: https://code.visualstudio.com/download

3. Clone this repo and open it in VS Code. You may need to download the GitHub CLI to use the git commands.<br/>
https://cli.github.com/

4. Navigate to your cloned repo folder, open a terminal and run ```flutter pub get``` to install the dependencies.

5. At the bottom right of the VSCode window, select the device to run the application either Chrome, Android, or iOS.<br/>
In order to create Android emulators you'll need to install Android Studio. https://developer.android.com/studio <br/>
In order to run on iOS, you'll need to install the latest Xcode on the mac App Store. 

## Requirements

You work for a company that, in general, makes stopwatches. Often times, though, a given stopwatch evolves into something much larger with many additional features beyond what would be considered part of a standard stopwatch.

The company would like to be able to deploy to many environments using a single codebase if possible.

You have been newly hired and have been asked to build out a functional and deployable interface for the base case. Here are the requirements:

- As a user I want to be able to start the stopwatch so that I can track an event

- As a user I want to be able to stop the stopwatch so that I can end tracking an event when it is over

- As a user I want to be able to optionally track smaller chunks of an event

- When tracking smaller chunks of an event, I want to know what order they were tracked in

- When tracking smaller chunks of an event, I want to know how many chunks there are

- As a user I want to be able to reset the stopwatch

- Resetting means that all optionally created smaller chunks of the event are reset

- Resetting means that all tracking data is reset

You can write this in whatever language you like using whatever frameworks you like. The finished product should, at a minimum, build to iOS and Android devices (Simulator/Emulator is okay).

## Considerations

1. I wanted to base this project on something that has been done before and so I looked to the iPhone stopwatch as inspiration. The dynamic button switching allows for 4 buttons to become 2 based on state.
2. I created a TimerButton class for reusability so that it would be easy to modify existing design or if more buttons were needed.
3. The timer_utils.dart file contains resuable functions to parse the timer data. Additional functions could be added here.
4. The Lap class was added in order to condense the lap code inside of a scrollable ListView. 
5. The iPhone stopwatch version scrolls the current lap under the main timer but I left the current lap at the top of the list in case a user would like to easily compare the current lap against prior laps, especially when scrolling off the screen. This aspect could be adjusted though depending on requirements.
