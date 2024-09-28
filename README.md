# Kaapi_picker
This app fetches random coffee images from an API and allows users to save their favorite images to their device's gallery.

## Project Overview
This app uses Cubit state management with flutter_bloc, cached network images, and permission handling, image_gallery_saver to save images locally on both Android and iOS devices.

## Features
-	Fetches a random coffee image from the coffee api (https://coffee.alexflipnote.dev/random.json)
-	Gets a new coffee image if the current one is not the user’s favourite provided by 'Skip' option.
-	Saves favorite coffee image to the device's gallery for offline access.
-	The app also displays loading indicators during network requests and handles errors.

### Dependencies
-	flutter_bloc: For state management.
- http: For making HTTP requests.
- google_fonts: For custom fonts.
-	cached_network_image: For caching images from the network.
-	flutter_cache_manager: For accessing the images cache
-	path_provider: To access the device’s filesystem.
-	percent_indicator: To display a percent indicator when saving images.
-	permission_handler: For storage/gallery permissions.
-	image_gallery_saver: To save images to the device's gallery.
-	equatable: For state comparisons in Bloc.

### Dev Dependencies
-	flutter_test:  Unit testing Flutter widgets.
-	mocktail  For mocking 
-	bloc_test: For testing Bloc state management.

## Folders:
1. Cubit
   - Contains Coffee Cubit, which has coffee_cubit.dart that has the network call.
   - Contains Coffee State, which has coffee_state.dart that manages the different states
2. Custom Components
   - Contains custom_button.dart, which is a custom widget to handle customisation for a UI component.
3. Models
   - Contains Coffee Model for the Api response.
4. Test
   - Contains Coffee Cubit Unit tests
   - Contains Coffee Cubit Widget tests
     
## Setup and Installation

To set up and run this Flutter app:

### Prerequisites
-	Install Flutter
-	Android Studio or VS Code for development.
-	Xcode (macOS) for iOS development.

### Instructions to run the app:
1.	Clone the repository: git clone https://github.com/akastha97/kaapi_image_picker.git
2.	Go to project folder: cd kaapi_picker
3.	Install the dependencies: flutter pub get
4.	Connect a device or simulator, and then run the app: flutter run
5.	To run the tests: flutter test

### App Flow:
1. Once the app loads, Gallery/ Storage permissions are requested by the application, and a Coffee Image is fetched from the Api.
2. If the user denies the permission, a Snackbar message is displayed, telling the user to Grant Permissions in device Settings.
3. Below the image, user is presented with two options, to skip or save.
4. If the user clicks on 'Skip', a new Coffee Image is fetched from the Api, replacing the current one.
5. If the user clicks on 'Save', the current coffee image is dowloaded to the device's gallery. Photos app in case of iOS and Gallery/ Google Photos in case of Android device.
6. If the user clicks on 'Save', a linear indicator is displayed to show the progress of the saving process.
7. Once the download is completed, the linear indicator and 'Save' button are hidden, and a toast/ snackbar message is displayed to intimate the user of completion.

## Key Takeaways:
1. State Management:
  -	The app uses Cubit state management that uses flutter_bloc package. 
  -	It handles different states, including loading, success, and error states, while fetching coffee images from the API.
  -	This solves the separation of concerns making the code more structured, readable and maintainable. 
2. Image Caching and Saving:
  -	Images are cached using cached_network_image and flutter_cache_manager.
  -	Users can save their favorite coffee images to the device's gallery.
  -	The image is picked from cache_manager and then saved using image_gallery_saver package, with progress shown via a linear percent indicator.
  -	Once the user saves the image, the ‘Save’ button is hidden.
  -	By doing this, there is performance optimisation, as we dont have to reload the image from the internet, instead get it from the cache. 
3. Permission Handling:
  -	The app checks and requests for storage or gallery permissions using the permission_handler package.
  -	Changes are also made in Info.plist, podfile, Android Manifest file and build.gradle files. 

   

