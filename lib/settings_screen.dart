    import 'package:flutter/material.dart';

    class SettingsScreen extends StatefulWidget {
      @override
      _SettingsScreenState createState() => _SettingsScreenState();
    }

    class _SettingsScreenState extends State<SettingsScreen> {
      bool notificationsEnabled = true;
      String defaultRiceType = 'White Rice';
      bool darkModeEnabled = false;

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text('Settings')),
          body: ListView(
            children: [
              SwitchListTile(
                title: const Text('Enable Notifications'),
                subtitle: const Text('Get notified when cooking is complete'),
                value: notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
              ListTile(
                title: const Text('Default Rice Type'),
                subtitle: Text(defaultRiceType),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Show rice type selection dialog
                },
              ),
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Toggle dark theme'),
                value: darkModeEnabled,
                onChanged: (bool value) {
                  setState(() {
                    darkModeEnabled = value;
                  });
                },
              ),
              ListTile(
                title: const Text('About'),
                subtitle: Text('App version 1.0.0'),
                onTap: () {
                  // Show about dialog
                },
              ),
            ],
          ),
        );
      }
    }