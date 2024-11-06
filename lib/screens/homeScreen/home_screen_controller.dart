import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/api.dart';
import '../../model/carbon_intensity_model.dart';
import '../../shared/snackbar.dart';
import '../../utils/internet_connection.dart';
import '../../utils/session_manager.dart';

class HomeScreenController extends GetxController {
  var loading = false.obs;
  var currentCarbonIntensity = ''.obs;
  var currentCarbonIndex = ''.obs;
  var lastUpdatedTime = ''.obs;
  var carbonList = [].obs;
  var intensityList = <Intensity>[].obs;
  var noInternet = false.obs;
  var maxForecastValue = 0.obs;
  var minForecastValue = 0.obs;

  @override
  void onInit() {
    getCurrentCarbonIntensity();
    super.onInit();
  }

  getCurrentCarbonIntensity() async {
    try {
      loading(true);
      bool isConnected = await InternetConnection.isConnectedToInternet();
      if (!isConnected) {
        noInternet(true);
        currentCarbonIntensity.value = await SessionManager().getCarbonValue();
        currentCarbonIndex.value = await SessionManager().getIndexValue();
        lastUpdatedTime.value = await SessionManager().getLastUpdatedValue();
        loading(false);
        showNoInternetDialog();
        return;
      }
      noInternet(false);
      var response = await Api().getCurrentCarbonIntensity();
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var resp = responseBody['data'][0];
        final carbonIntensity = carbonIntensityFromJson(jsonEncode(resp));

        currentCarbonIntensity.value =
            carbonIntensity.intensity.actual.toString();
        currentCarbonIndex.value = carbonIntensity.intensity.index;

        SessionManager().setCarbonValue(currentCarbonIntensity.value);
        SessionManager().setIndexValue(currentCarbonIndex.value);
        var date = DateTime.now();
        var lastUpdatedTime = '${date.hour}:${date.minute}';
        SessionManager().setLastUpdatedValue(lastUpdatedTime);
        await getCurrentDayCarbonIntensity();
        loading(false);
      } else if (response.statusCode == 400) {
        loading(false);
        MySnackbar.showErrorSnackbar(
          'Failed to fetch Current Carbon Intensity! Try again later.',
        );
      }
    } catch (error) {
      loading(false);
      MySnackbar.showErrorSnackbar(
        'Failed to fetch Current Carbon Intensity! Try again later here.',
      );
    }
  }

  getCurrentDayCarbonIntensity() async {
    try {
      loading(true);
      var date = DateTime.now();
      var newdate = DateTime(date.year, date.month, date.day).toIso8601String();

      var response = await Api().getCurrentDayCarbonIntensity(newdate);
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        carbonList.value = responseBody['data'];
        intensityList.clear();
        minForecastValue.value = carbonList[0]['intensity']['forecast'];
        for (var carbon in carbonList) {
          var intensityJson = carbon['intensity'];
          var intensity = Intensity.fromJson(intensityJson);
          intensityList.add(intensity);
          if (intensity.forecast > maxForecastValue.value) {
            maxForecastValue.value = intensity.forecast;
          }
          if (intensity.forecast < minForecastValue.value) {
            minForecastValue.value = intensity.forecast;
          }
        }
        loading(false);
      } else if (response.statusCode == 400) {
        loading(false);
        MySnackbar.showErrorSnackbar(
          "Failed to fetch Today's Carbon Intensity! Try again later.",
        );
      }
    } catch (error) {
      loading(false);
      MySnackbar.showErrorSnackbar(
        "Failed to fetch Today's Carbon Intensity! Try again later. $error",
      );
    }
  }

  void showNoInternetDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Internet"),
          content:
              const Text("Please enable internet connection and try again."),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
