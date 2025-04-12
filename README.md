# blink

From work to leisure, people are spending increasing amounts of their day looking at a screen, raising concerns from optometrists about the risk of digital eye strain. To mitigate this, experts recommend following the 20:20:20 rule — every 20 minutes, focusing on something 20 feet away for at least 20 seconds. To help users practice these guidelines, we set out to create Blink, an application that seamlessly integrates with the user's workflow, promoting healthier screen time habits, gently encouraging regular eye breaks without disrupting productivity.

**Table of Contents:**
* [What it does](#what-it-does)
* [Screenshots](#screenshots)
* [How we built it](#how-we-built-it)
* [Challenges we ran into](#challenges-we-ran-into)
* [Accomplishments that we're proud of](#accomplishments-that-were-proud-of)
* [What we learned](#what-we-learned)
 
## What it does

Blink is a native Mac application designed to help users manage their screen time more effectively, thereby reducing their risk of eye strain and improving overall digital well-being. It gently reminds users to take short breaks at regular intervals, encouraging them to look away from their screens and relax their eyes. Users can customise the frequency and duration of these breaks according to their personal preferences and work needs. Blink tracks user progress and provides statistics for insights into their digital habits.

## Screenshots

| ![Light Mode Dashboard View](https://github.com/AdityaMuthukattu/blink/assets/19423025/c0606d3a-b630-4a1c-bcfb-ccdfd5a27c28) | ![Dark Mode Dashboard View](https://github.com/AdityaMuthukattu/blink/assets/19423025/f6e355c4-2861-4745-b0d1-3a6d9d26f06d) | 
|:-----------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------:| 
| Light Mode Dashboard View | Dark Mode Dashboard View |

![Light Mode Break View](https://github.com/user-attachments/assets/b74b7104-e122-4e31-a7d9-84fbb7576c1a)

## How we built it

We built Blink using Swift and the SwiftUI framework, leveraging the powerful capabilities of macOS development. The application runs in the background, with keyboard shortcuts and a status bar menu for easy access to its features. We used `UNUserNotificationCenter` for scheduling, `NSStatusBar` as well as other Native UI Elements to create an accessible and intuitive user interface. We also made a conscious effort to conform to Apple's Human Interface Guidelines, ensuring accessibility, and cohesiveness with the system UI.

## Challenges we ran into

State management was a significant challenge that we faced. We chose to centralise the application's state within the GlobalState class, making it the single source of truth. By using `Combine` and marking our state variables with `@Published`, we enabled automatic updates to the UI whenever these properties changed. This reactive approach ensured that the UI always reflects the current state without manual intervention.

## Accomplishments that we're proud of

We are particularly proud of creating an application that strikes a balance between simplicity and functionality. Blink's intuitive design and customizable settings make it a versatile tool for anyone looking to mitigate the effects of prolonged screen time. We also wanted to ensure that the break notifications would not disrupt the user's workflow but still be noticeable enough to encourage action. This took a significant amount of time working with mockups, and A-B testing different implementations to reach our final blurred overlay. We're also proud of the technical implementation, including the seamless background operation and data persistence.

## What we learned

Working with Swift and SwiftUI, we learnt a lot about working with the API's and features of MacOS, to rapidly go from concpet to implementation. The project also taught us the importance of thoughtful architecture in managing complex state in modern applications. It also highlighted the benefits of reactive programming in creating responsive and user-friendly interfaces.




