# Flutter Boilerplate
This is the base code for creating cross-platform application using Flutter.

- [Flutter Boilerplate](#flutter-boilerplate)
- [Getting Started](#getting-started)
    - [Rename App name and package name](#rename-app-name-and-package-name)
    - [Update App Launcher Icon :](#update-app-launcher-icon-)
        - [1. Setup the config file](#1-setup-the-config-file)
        - [2. Run the package](#2-run-the-package)
    - [Environment Variables](#environment-variables)
        - [Usage](#usage)
        - [Code Magic Setup](#code-magic-setup)
            - [Adding environment variables](#adding-environment-variables)
            - [Creating .env file with Codemagic](#creating-env-file-with-codemagic)
    - [App Signing](#app-signing)
        - [Release Using Codemagic :](#release-using-codemagic-)
    - [Google Sign In](#google-sign-in)
        - [Android](#android)
            - [Generating a keystore](#generating-a-keystore)
            - [Generate SHA-1](#generate-sha-1)
            - [Ios](#ios)
            - [Web :](#web-)
                - [Starting flutter in  http://localhost:5000](#starting-flutter-in--httplocalhost5000)
- [Architecture](#architecture)
    - [Separation of concerns](#separation-of-concerns)
    - [Drive UI from data models](#drive-ui-from-data-models)
    - [Single source of truth](#single-source-of-truth)
    - [Unidirectional Data Flow](#unidirectional-data-flow)
    - [Package by Feature](#package-by-feature)
    - [App Components](#app-components)
        - [Core :](#core-)
            - [Configs :](#configs-)
            - [Constants :](#constants-)
            - [DI :](#di-)
            - [Navigation :](#navigation-)
            - [Utils :](#utils-)
            - [Widgets:](#widgets)
        - [Features :](#features-)
        - [Shared :](#shared-)
    - [References :](#references-)


# Getting Started
To use this template to create new flutter application,
Follow these steps to start creating your own app:
1. Click use this template to create a new repository with this code.
2. Clone the new repo to your local machine.
3. Go to ``pubspec.yaml`` and update name, description and version for the new app.

## Rename App name and package name
To rename app name & package name, we use [Rename package](https://pub.dev/packages/rename) to update them.

You can install Rename package globally using:
 ```Shell
 flutter pub global activate rename  
 ```

then if you don't pass **-t or --target** parameter it will try to rename all available platform project folders inside flutter project.

_**Run this command inside your flutter project root.**_
```Shell
    flutter pub global run rename setBundleId --value "com.example.bundleId"
    flutter pub global run rename setAppName --targets ios,android --value "YourAppName"
```  

## Update App Launcher Icon :
Use [Flutter launcher icon](https://pub.dev/packages/flutter_launcher_icons) package to update app launcher icons.
### 1. Setup the config file[](https://pub.dev/packages/flutter_launcher_icons#1-setup-the-config-file)

Add your Flutter Launcher Icons configuration to your  `pubspec.yaml`  or create a new config file called  `flutter_launcher_icons.yaml`. An example is shown below. More complex examples  [can be found in the example projects](https://github.com/fluttercommunity/flutter_launcher_icons/tree/master/example).

```yaml
dev_dependencies:
  flutter_launcher_icons: "^0.13.1"

flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon/icon.png"
  min_sdk_android: 21 # android min sdk min:16, default 21
  web:
    generate: true
    image_path: "path/to/image.png"
    background_color: "#hexcode"
    theme_color: "#hexcode"
  windows:
    generate: true
    image_path: "path/to/image.png"
    icon_size: 48 # min:48, max:256, default: 48
  macos:
    generate: true
    image_path: "path/to/image.png"
```

If you name your configuration file something other than  `flutter_launcher_icons.yaml`  or  `pubspec.yaml`  you will need to specify the name of the file when running the package.

```shell
flutter pub get
flutter pub run flutter_launcher_icons -f <your config file name here>
```

Note: If you are not using the existing  `pubspec.yaml`  ensure that your config file is located in the same directory as it.

### 2. Run the package[](https://pub.dev/packages/flutter_launcher_icons#2-run-the-package)

After setting up the configuration, all that is left to do is run the package.

```shell
flutter pub get
flutter pub run flutter_launcher_icons
```

In the above configuration, the package is setup to replace the existing launcher icons in both the Android and iOS project with the icon located in the image path specified above and given the name "launcher_icon" in the Android project and "Example-Icon" in the iOS project.

## Environment Variables
Environment variables are useful for making  the credentials, configuration files or API keys that are required for successful building or integration with external services while not publishing them to external repos.

We can load configuration at runtime from a  `.env`  file which can be used throughout the application.

>  Env vars are easy to change between deploys without changing any code... they are a language- and OS-agnostic standard.

### Usage

1.  Create a  `.env`  file in the root of your project with the example content:

```sh
FOO=foo
BAR=true
FOOBAR=$FOO$BAR
ESCAPED_DOLLAR_SIGN='$1000'
# This is a comment

```


2.  Add the  `.env`  file to your assets bundle in  `pubspec.yaml`.  **Ensure that the path corresponds to the location of the .env file!**

```yml
assets:
  - assets/env/
```

3.  Remember to add the  `.env`  file as an entry in your  `.gitignore`  if it isn't already unless you want it included in your version control.

```txt
*.env
```

4. Load the environment variables in your app:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}
```

### Code Magic Setup
We can setup codemagic to use enviroment variables that were configured form the app.
This is helpful for conifguring the app with environment variables like api key without publishing them to Github, conifguring the app with different variables for each workflow and track.

For more information about the use of environment variables and a list of Codemagic read-only environment variables, refer  [here](https://docs.codemagic.io/yaml-basic-configuration/environment-variables).

#### Adding environment variables

You can add environment variables to your Flutter projects in  **App settings > Environment variables**.

1.  Enter the name  of the variable for example `ENVIROMENT_KEY`.
2. Copy the content of the `.env` file into the variable value field.
3.  Check  **Secure**  if you wish to hide the value both in the UI and in build logs and disable editing of the variable. Such variables can be accessed only by the build machines during the build.
4. If we want to encrypt the variables, they first need to be  **_base64 encoded_**  locally. To use the vars, you will have to decode them during the build.
5.  Click  **Add**.

####  Creating .env file with Codemagic

In order to use the enivroment variable stored in `keys_env`, We need to add a post clone script that copy the content of the `keys_env` env into  `.env` file in app assets.

You can add the script variables to your Flutter projects in  **App settings > Post-clone script** which is located after `Dependency caching`.

then add this command :

```shell

# Create directory if it doesn't exist
mkdir -p $CM_BUILD_DIR/assets/env

# Write out the environment variable file
echo "$ENVIROMENT_KEY" >> $CM_BUILD_DIR/assets/env/keys.env
```



## App Signing
Any android app need to be signed to use google sign in and to be ready for publishing to Google play.

To use features like google play sign in the app needs to be signed in debug and release mode.
1. Create a  keystore file and put it in the ``android`` directory of your project.
2.  Create a file named  `keystore.properties`  in the ``android`` directory of your project that contains your signing information, as follows:
```shell
    storePassword=myStorePassword
    keyPassword=mykeyPassword
    keyAlias=myKeyAlias
    storeFile=myStoreFileLocation (../key.jks) it should be like this if keystore in android directory
```
**Make sure don't push this file to the repo as it should be secret.**

### Release Using Codemagic :

For release version,  The app need to be signed on code magic using a keystore file.
For more info check :
https://docs.codemagic.io/flutter-code-signing/android-code-signing/
https://docs.codemagic.io/yaml-code-signing/signing-android/


## Google Sign In
To setup Google sign in  in our flutter project, There is some configuration that needs to be done:

## Android
To use Google sign in in our app we need to sign our app with a keystore and extracts it's SHA key to be provided for the backend to register the app in Google cloud console with app package name and SHA key.

### Generating a keystore

If you need to create a new keystore file for signing your release builds, you can do so with the Java Keytool utility by running the following command:

```Shell
 keytool -genkey -v -keystore sourcya_keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias sourcya_key -keypass sourcya135 -storepass sourcya135 -dname "CN=Sourcya, OU=Sourcya, O=Sourcya, L=Egypt, ST=Alexandria, C=EG" 
```

Keytool then prompts you to enter your personal details for creating the certificate, as well as provide passwords for the keystore and the key. It then generates the keystore as a file called  **sourcya_keystore.jks**  in the directory you’re in. The key is valid for 10,000 days.


### Generate SHA-1

We can generate SHA-1  using the Java Keytool utility by running the following command:

```Shell
keytool -list -v -keystore "sourcya_key.jks" -alias sourcya_key -storepass sourcya135 -keypass sourcya135
```

### Ios
To use Google sign in in our app, The backend should create a client for ios using ios app bundle id.
Then a client id should be generated and put in ``core/keys.dart``.

1.  [First register your application](https://firebase.google.com/docs/ios/setup).
2.  Make sure the file you download in step 1 is named  `GoogleService-Info.plist`.
3.  Move or copy  `GoogleService-Info.plist`  into the  `[my_project]/ios/Runner`  directory.
4.  Open Xcode, then right-click on  `Runner`  directory and select  `Add Files to "Runner"`.
5.  Select  `GoogleService-Info.plist`  from the file manager.
6.  A dialog will show up and ask you to select the targets, select the  `Runner`  target.
7. Update the  `CFBundleURLTypes`  attributes below into the  `[my_project]/ios/Runner/Info.plist`  file.

```xml
<!-- Put me in the [my_project]/ios/Runner/Info.plist file -->
<!-- Google Sign-in Section -->
<key>CFBundleURLTypes</key>
<array>
<dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
        <!-- TODO Replace this value: -->
        <string>com.googleusercontent.apps.861823949799-vc35cprkp249096uujjn0vvnmcvjppkn</string>
    </array>
</dict>
</array>
    <!-- End of the Google Sign-in Section -->

```

### Web :
On your  `web/index.html`  file, add the following  `meta`  tag, somewhere in the  `head`  of the document:

```html
<meta name="google-signin-client_id" content="YOUR_GOOGLE_SIGN_IN_OAUTH_CLIENT_ID.apps.googleusercontent.com">
```

For this client to work correctly, the last step is to configure the  **Authorized JavaScript origins**, which  _identify the domains from which your application can send API requests._  When in local development, this is normally  `localhost`  and some port.

You can do this by:

1.  Going to the  [Credentials page](https://console.developers.google.com/apis/credentials).
2.  Clicking "Edit" in the OAuth 2.0 Web application client that you created above.
3.  Adding the URIs you want to the  **Authorized JavaScript origins**.

For local development, you must add two  `localhost`  entries:

-   `http://localhost`  and
-   `http://localhost:5000`  (or any port that is free in your machine)

#### Starting flutter in  [http://localhost:5000](http://localhost:5000/)

Normally  `flutter run`  starts in a random port. In the case where you need to deal with authentication like the above, that's not the most appropriate behavior.

You can tell  `flutter run`  to listen for requests in a specific host and port with the following:

```sh
flutter run -d chrome --web-hostname localhost --web-port 5000
```

Or from Android studio click on ``Main.dart`` next to run button
Then click on ``Edit Configuration`` a window will appear, on ``Addition run args``
add :  ``--web-port 5000``
now our web app run on the right configuration.



# Architecture
An app architecture defines the boundaries between parts of the app and the responsibilities each part should have. In order to meet the needs mentioned above, you should design your app architecture to follow a few specific principles.

### Separation of concerns

The most important principle to follow is [separation of concerns](https://en.wikipedia.org/wiki/Separation_of_concerns). It's a common mistake to write all your code in `Widgets` . These UI-based classes should only contain logic that handles UI and operating system interactions. By keeping these classes as lean as possible, you can avoid many problems related to the component lifecycle, and improve the testability of these classes.

### Drive UI from data models

Another important principle is that you should drive your UI from data models, preferably persistent models. Data models represent the data of an app. They're independent from the UI elements and other components in your app. This makes the app more testable and robust.

### Single source of truth

When a new data type is defined in your app, you should assign a Single Source of Truth (SSOT) to it. The SSOT is the  _owner_ of that data, and only the SSOT can modify or mutate it. To achieve this, the SSOT exposes the data using an immutable type, and to modify the data, the SSOT exposes functions or receive events that other types can call.

This pattern brings multiple benefits:
- It centralizes all the changes to a particular type of data in one place.
- It protects the data so that other types cannot tamper with it.
- It makes changes to the data more traceable. Thus, bugs are easier to spot.


### Unidirectional Data Flow

The  single source of truth principle  is often used with the Unidirectional Data Flow (UDF) pattern. In UDF,  **state** flows in only one direction. The  **events** that modify the data flow in the opposite direction.

In Android, state or data usually flow from the higher-scoped types of the hierarchy to the lower-scoped ones. Events are usually triggered from the lower-scoped types until they reach the SSOT for the corresponding data type. For example, application data usually flows from data sources to the UI. User events such as button presses flow from the UI to the SSOT where the application data is modified and exposed in an immutable type.

This pattern better guarantees data consistency, is less prone to errors, is easier to debug and brings all the benefits of the SSOT pattern.



## Package by Feature
In this project structure, packages contain all classes that are required for a feature. The independence of the package is ensured by placing closely related classes in the same package. An example of this structure is given below:
```├── lib    
    └── generated  
        ├── assets  
        └── l10n
    └── src    
        ├── core  
            ├── configs  
            ├── constants  
            ├── di  
            ├── navigation  
            └── utils  
        ├── features  
            └── feature1  
                ├── data  
                    ├── datasources  
                    ├── models  
                    └── repositories
                ├── domain (optional) 
                    ├── entities  
                    ├── repositories  
                    └── usecases
                ├── navigation  
                └── presentation
                    ├── managers  
                    ├── pages  
                    └── widgets
        └── shared  
            ├── data  
                ├── datasources  
                ├── models
                └── repositories  
            ├── drivers  
                ├── local  
                └── remote  
            ├── extensions  
            ├── mixins  
            └── presentation  
                ├── managers  
                ├── pages  
                └── widgets  
                    ├── display  
                    └── interactive  
```  
— Package by Feature has packages with  **high cohesion, low coupling** and  **high modularity.**

— Package by Feature allows some classes to set their access modifier  `package-private` instead of  `public`, so it increases  **encapsulation**. On the other hand, Package by Layer forces you to set nearly all classes  `public`.

— Package by Feature reduces the need to navigate between packages since all classes needed for a feature are in the same package.

— Package by Feature is like microservice architecture. Each package is limited to classes related to a particular feature. On the other hand, Package By Layer is monolithic. As an application grows in size, the number of classes in each package will increase without bound.



## App Components
Our app consists of 3 components:

### Core :
This component contains different pieces of code that are shared between the whole app.
It contains different components:
#### Configs :
This component contains app configuration like playx configuration, keys and constants .
#### Constants :
App constant strings, like routes names and regexes.
#### DI :
Dependency injection.
#### Navigation :
Handles app navigation in one place.   
First create your app routes.  
Then every navigation between routes should be done in app navigation class.  
To make it easier to maintain same behavior for navigation and make it easy if we want to use another solution for navigation in the future.
#### Utils :
Provides different utilities for whole app like alerts, pickers, app utils and more.


### Features :
This component is responsible for all app features as it contains each feature that are packaged together by Feature as described in previous example.
Each Feature has:
- **data**
    - **datasources** — connect to local db or remote API. **Interfaces are created for Datasources, Services, and Drivers**. The *<name>_<layer>_impl.dart* file is where the code is. Using interfaces increases decoupling and helps to build tests with Mock classes.
    - **models** — Classes that extend from Entities to transform data (DTO). Each model is responsible for converting unstructured data (JSON, etc.) into Dart objects by using certain methods (fromJSON, toJSON, etc.)
    - **repositories** — Business logic classes. The implementation of abstract repository.
- **domain (optional)**
    - **entities** — Classes to store data. Entity is the final result that the view will use.
    - **repositories** — Business logic classes. The abstract repository isn't really needed unless you plan on creating multiple implementation of this.
    - **usecases** — The usecases must run the necessary logic to solve a specific problem. If the usecase needs the any external access, this access may be done through interface contacts that will be implemented by the lower-level layers.
- **presentation**
    - **managers** — State management classes.
    - **pages** — Visual components classes.
    - **widgets** — Visual components classes (dialog, fields).

The domain layer is responsible for encapsulating complex business logic, or simple business logic that is reused by multiple ViewModels / Controllers. This layer is optional because not all apps will have these requirements. You should only use it when needed-for example, to handle complexity or favor reusability.

<p align="center">  
  <img width= "50%"  src="https://developer.android.com/static/topic/libraries/architecture/images/mad-arch-overview.png">  
</p>  

### Shared :
The shared component contains code that is shared between different layers and features of the application. It provides a common set of tools and utilities that can be used by any part of the application.



## References :

1. [Sourcya Flutter Boilerplate](https://github.com/sourcya/flutter-boilerplate/blob/main/README.md) By Sourcya
2. [Folder structure for Flutter with clean architecture.](https://felipeemidio.medium.com/folder-structure-for-flutter-with-clean-architecture-how-i-do-bbe29225774f) By Felipe Emídio
3. [UI Layer](https://developer.android.com/topic/architecture/ui-layer) By android
4. [Domain Layer](https://developer.android.com/topic/architecture/domain-layer) By android
5. [Data Layer](https://developer.android.com/topic/architecture/data-layer) By android