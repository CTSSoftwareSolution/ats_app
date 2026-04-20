
import 'package:ats_app/Core/network/InternetCheck/network_status.dart';
import 'package:ats_app/utilities/color_data.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


class CheckInternetScreen extends StatefulWidget {
  const CheckInternetScreen({super.key});

  @override
  State<CheckInternetScreen> createState() => _CheckInternetScreenState();
}

class _CheckInternetScreenState extends State<CheckInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<NetworkStatus>(
          builder: (context, networkStatus, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  networkStatus.isConnected ? Icons.wifi : Icons.wifi_off,
                  size: 80,
                  color: networkStatus.isConnected ? greenColor : redColor,
                ),
                const SizedBox(height: 20),
                Text(
                  networkStatus.isConnected
                      ? 'Connected to the Internet'
                      : 'No Internet Connection',
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

