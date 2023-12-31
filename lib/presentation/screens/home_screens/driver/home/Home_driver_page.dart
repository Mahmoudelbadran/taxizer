import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:taxizer/bussinus_logic/driver_logic/home_driver_logic.dart';
import 'package:taxizer/bussinus_logic/login_register_logic/login_and_register_logic.dart';
import 'package:taxizer/data/local/my_cache.dart';

import '../../../../../bussinus_logic/payment_logic/payment_logic.dart';
import '../../../../../bussinus_logic/user_logic/home_user_logic.dart';
import '../../../../../bussinus_logic/user_logic/system_logic.dart';
import '../../../../../core/chang_page/controle_page.dart';
import '../../../../../core/contant/constant.dart';
import '../../../../../core/my_cache_keys/my_cache_keys.dart';
import '../../../../style/style.dart';
import '../alert_dialog_call/alert_dialog_call.dart';
import '../item_bulider_user_call/item_bulider_user_call.dart';

class HomeDriverPage extends StatefulWidget {
  const HomeDriverPage({Key? key}) : super(key: key);

  @override
  State<HomeDriverPage> createState() => _HomeDriverPageState();
}

class _HomeDriverPageState extends State<HomeDriverPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late HomeUserLogic cubit ;
  late HomeDriveLogic drive ;
  late PaymentLogic payment;
  late LoginAndRegisterLogic userData ;
  late String? tokenDriver;
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      String? title = message.notification!.title;
      String? body = message.notification!.body;
      AwesomeNotifications().createNotification(
          content: NotificationContent(id: 123, channelKey: "call_channel",
            title: title,
            body: body,
            category: NotificationCategory.Call,
            wakeUpScreen: true,
            fullScreenIntent: true,
            autoDismissible: false,
            backgroundColor: Colors.orange,

          ),
          actionButtons: [
            NotificationActionButton(key: "Accept", label: "Accept Call",color: Colors.green
              ,autoDismissible: true,
            ),
            NotificationActionButton(key: "Reject", label: "Reject Call",color: Colors.red
              ,autoDismissible: true,
            ),

          ]
      );
      AwesomeNotifications().actionStream.listen((event){
        if(event.buttonKeyInput=="Reject"){
          print("call Reject");
          setState(() {
            isCall = false;
          });
        }else if(event.buttonKeyInput=="Accept"){
          print("call Accept");
          if (mounted) {
            setState(() {
              isCall = false;
            });
          }
          Navigator.push(context, HomeUserScreen as Route<Object?>);
        }else{
          print("click of notification");

          if (mounted) {
            setState(() {
              isCall = false;
            });
          }
        }

      });
    });
    drive = HomeDriveLogic.get(context);
    cubit = HomeUserLogic.get(context);
    userData = LoginAndRegisterLogic.get(context);
    payment =PaymentLogic.get(context)..getPaymentUser(token:userData.loginDriverResponse.token);
    tokenDriver=MyCache.getString(keys: MyCacheKeys.tokenDriver);
    cubit
        .requestLocationPermission(context)
        .then((value) => cubit.getCurrentLocation())
        .then((value) => cubit.getLocation());
    drive.locationDriver(
        token: tokenDriver.toString(),
        type: "type",
        lat: cubit.lat,
        lng: cubit.lng);

    super.initState();
  }

  bool isCall = false;
  void showCall() {
    setState(() {
      isCall = !isCall;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeUserLogic, HomeUserState>(
      builder: (context, state) {
        return BlocBuilder<SystemLogic, SystemState>(
          builder: (context, state) {
            return BlocBuilder<HomeUserLogic, HomeUserState>(
              builder: (context, state) {
                return BlocBuilder<HomeDriveLogic, HomeDriveState>(
                  builder: (context, state) {
                    return Scaffold(
                      key: _scaffoldKey,
                      backgroundColor: backgroundcolor,
                      appBar: AppBar(
                        backgroundColor: backgroundcolor,
                        elevation: 0,
                        actions: [
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AlertCall();
                                    });
                                showCall();
                              },
                              icon: const Icon(
                                Icons.share_location,
                                color: Colors.black,
                              ))
                        ],
                        centerTitle: true,
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                Text(
                                  "موقعك الحالي",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 12.sp),
                                ),
                              ],
                            ),
                            Text(
                              cubit.address,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      floatingActionButton: FloatingActionButton(
                        heroTag: "btn1",
                        onPressed: () async {
                          await cubit
                              .requestLocationPermission(context)
                              .then((value) => cubit.getCurrentLocation())
                              .then((value) => cubit.getLocation());
                        },
                        backgroundColor: ycolor,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                        ),
                      ),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.startFloat,
                      extendBody: true,
                      body: Stack(
                        children: [
                          SizedBox(
                            width: 100.w,
                            height: 100.h,
                            child: GoogleMap(
                              polylines: drive.polyline,
                              mapType: MapType.terrain,
                              initialCameraPosition:
                                  cubit.currentLocation != null
                                      ? CameraPosition(
                                          target: LatLng(
                                              cubit.currentLocation!.longitude,
                                              cubit.currentLocation!.latitude),
                                          zoom: 14,
                                        )
                                      : initialCameraPosition,
                              onTap: (location) async {
                                cubit.getAddress();
                                cubit.pickerLocation = location;
                              },
                              markers: {
                                if (cubit.currentLocation != null)
                                  Marker(
                                      markerId:
                                          const MarkerId('Current Location'),
                                      position: cubit.currentLocation!,
                                      icon:
                                          BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueAzure,
                                      ),
                                      onTap: () {}),
                                if (cubit.pickerLocation != null)
                                  Marker(
                                      markerId:
                                          const MarkerId('Picker Location'),
                                      position: cubit.pickerLocation!,
                                      icon:
                                          BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueAzure,
                                      ),
                                      onTap: () {}),
                                if (cubit.goGetLocation != null)
                                  Marker(
                                    markerId:
                                        const MarkerId('point_locationOne'),
                                    position: cubit.goGetLocation!,
                                    icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueOrange,
                                    ),
                                  ),
                                if (cubit.goGetLocationPointOne != null)
                                  Marker(
                                    markerId: const MarkerId('point_location'),
                                    position: cubit.goGetLocationPointOne!,
                                    icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueOrange,
                                    ),
                                  ),
                              },
                              onMapCreated: (GoogleMapController controller) {
                                cubit.mapController = controller;
                              },
                            ),
                          ),
                          Visibility(
                            visible: isCall,
                            child: const Wrap(
                              children: [UserCall()],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    cubit.mapController?.dispose();
    super.dispose();
  }
}
