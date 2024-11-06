import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tewke_task/screens/homeScreen/carbon_intensity_chart.dart';

import 'home_screen_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  static const routeName = '/home-screen';
  final HomeScreenController homeScreenCont = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DASHBOARD',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              homeScreenCont.getCurrentCarbonIntensity();
            },
            icon: const Icon(
              Icons.restart_alt,
              color: Colors.white,
              size: 20,
            ),
          )
        ],
      ),
      body: Obx(() {
        return Container(
          height: Get.height,
          width: Get.width,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 49, 51, 65),
          ),
          child: homeScreenCont.loading.value
              ? PopScope(
                  canPop: false,
                  child: Center(
                    child: LoadingAnimationWidget.threeArchedCircle(
                      color: Colors.blue,
                      size: 80,
                    ),
                  ),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      carbonIntensity(),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(
                          height: 0,
                          color: Colors.grey[700],
                          thickness: 2,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      legendWidget(),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: IntensityChart(
                            dataPoints: homeScreenCont.intensityList,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                        child: Text(
                          'Current Day Carbon Intensity',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        );
      }),
    );
  }

  Widget carbonIntensity() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Center(
              child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Carbon Intensity ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 216, 211, 211),
                        fontSize: 24,
                      ),
                    ),
                    const TextSpan(text: '(gCO'),
                    WidgetSpan(
                      child: Transform.translate(
                        offset: const Offset(0, 4),
                        child: const Text(
                          '2',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 216, 211, 211),
                            fontFeatures: [FontFeature.subscripts()],
                          ),
                        ),
                      ),
                    ),
                    const TextSpan(text: '/kWh)'),
                  ],
                  style: const TextStyle(
                    color: Color.fromARGB(255, 216, 211, 211),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Center(
              child: Text(
                homeScreenCont.currentCarbonIntensity.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          indexWidget(
            homeScreenCont.currentCarbonIndex.value,
          ),
          homeScreenCont.noInternet.value
              ? noInternetWidget()
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget indexWidget(String indexValue) {
    Color indexValueColor = Colors.black;

    switch (indexValue) {
      case 'very low':
        indexValueColor = Colors.green;
        break;
      case 'low':
        indexValueColor = Colors.yellow;
        break;
      case 'moderate':
        indexValueColor = Colors.orangeAccent;
        break;
      case 'high':
        indexValueColor = const Color.fromARGB(255, 255, 123, 0);
        break;
      case 'very high':
        indexValueColor = Colors.red;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: 'Index: ',
            style: const TextStyle(
              color: Color.fromARGB(255, 216, 211, 211),
              fontSize: 24,
            ),
            children: [
              TextSpan(
                text: homeScreenCont.currentCarbonIndex.value.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: indexValueColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget noInternetWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 5),
          child: Icon(
            Icons.signal_wifi_statusbar_connected_no_internet_4_rounded,
            color: Colors.amber,
          ),
        ),
        Text(
          'No Internet! - Last Updated: ${homeScreenCont.lastUpdatedTime.value}',
          style: const TextStyle(color: Colors.amber),
        ),
      ],
    );
  }

  Widget legendWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Forecast:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Container(
                height: 10,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Actual:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Container(
                height: 10,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
