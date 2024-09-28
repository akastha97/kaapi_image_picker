import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:kaapi_picker/cubit/coffee_cubit.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'cubit/coffee_state.dart';
import 'custom_components/custom_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _progress = 0.0;
  bool _showProgressIndicator = false;
  Timer? _timer;

  bool isSaved = false;

  /// Method to get the permission type for the current platform
  Permission getPermissionForPlatform() {
    if (Platform.isAndroid) {
      return Permission.storage;
    } else {
      return Permission.photos;
    }
  }

  /// Method to request for permissions
  Future<bool> requestPermissions(Permission permission) async {
    return await permission.request().isGranted;
  }

  /// Method that handles gallery permissions for the app
  Future<bool> getGalleryPermissions() async {
    Permission permission = getPermissionForPlatform();
    PermissionStatus status = await permission.status;

    if (!status.isGranted) {
      bool isGranted = await requestPermissions(permission);
      if (!isGranted) {
        if (mounted) {
          dislayPermissionDeniedSnackBar(context);
        }
        return false;
      }
      return true;
    } else {
      debugPrint("Permissions already granted");
      return true;
    }
  }

  /// Method to display SnackBar when permission is denied
  void dislayPermissionDeniedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text(
          'Permission denied. Change your app settings to grant permissions.',
        ),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: () {
            openAppSettings();
          },
        ),
      ),
    );
  }

  // Method to save the image to Gallery of the device
  void saveImageToGallery(String imageUrl) async {
    bool hasPermission = await getGalleryPermissions();

    if (!hasPermission) {
      debugPrint("No permission given");
    } else {
      setState(() {
        _showProgressIndicator = true;
      });
      startTimer();
      await saveImageToLocal(imageUrl);
    }
  }

  /// Timer that decrements to handle the progress of the percent indicator
  void startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      setState(() {
        _progress = _progress + 0.02;
        if (_progress >= 1.0) {
          _progress = 1.0;
          _timer!.cancel();
        }
      });
    });
  }

  /// Saves an image from the given URL to the local device's gallery
  ///
  /// This method fetches the image using the cache manager and saves it to the
  /// device's gallery using the [ImageGallerySaver] package
  Future<void> saveImageToLocal(String imageUrl) async {
    try {
      final image = await DefaultCacheManager().getSingleFile(imageUrl);

      Uint8List cachedImageBytes = await image.readAsBytes();

      await ImageGallerySaver.saveImage(cachedImageBytes);

      setState(() {
        _progress = 1.0;
        _showProgressIndicator = false;
        isSaved = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            showCloseIcon: true,
            duration: Duration(seconds: 3),
            content: Text('Image Saved Successfully!'),
          ),
        );
      }
    } catch (e) {
      return Future.error(e);
    } finally {
      _timer!.cancel();
    }
  }

  @override
  void initState() {
    getGalleryPermissions();
    context.read<CoffeeCubit>().fetchImageUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) =>
              CoffeeCubit(client: http.Client())..fetchImageUrl(),
          child: BlocBuilder<CoffeeCubit, CoffeeState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const Text(
                    "Coffee Picture of the Day!!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          if (state is CoffeeLoading)
                            const Center(
                              child: CircularProgressIndicator(
                                key: ValueKey('loading'),
                                color: Colors.black,
                                strokeWidth: 4,
                              ),
                            )
                          else if (state is CoffeeError)
                            Center(
                                key: ValueKey('error'),
                                child: Text(state.errorMessage))
                          else if (state is CoffeeSuccess) ...[
                            Card(
                              key: const ValueKey('imageCard'),
                              elevation: 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: state.imageUrl,
                                  height: 417,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                  key: const ValueKey('skipBtn'),
                                  text: 'Skip',
                                  backgroundColor: const Color(0xffF5F2F0),
                                  onPressed: () {
                                    setState(() {
                                      isSaved = false;
                                    });
                                    context.read<CoffeeCubit>().fetchImageUrl();
                                  },
                                ),
                                Visibility(
                                  visible: !isSaved,
                                  child: CustomButton(
                                    key: const ValueKey('saveBtn'),
                                    text: 'Save',
                                    backgroundColor: const Color(0xffE5801A),
                                    onPressed: () {
                                      saveImageToGallery(state.imageUrl);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Visibility(
                                visible: _showProgressIndicator,
                                child: LinearPercentIndicator(
                                  lineHeight: 8,
                                  percent: _progress,
                                  progressColor: Colors.black,
                                  backgroundColor: Colors.grey[300],
                                )),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
