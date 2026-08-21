import 'package:flutter/material.dart';
import '../services/sound_service.dart';

class SoundSettings extends StatefulWidget {
  const SoundSettings({super.key});

  @override
  State<SoundSettings> createState() => _SoundSettingsState();
}

class _SoundSettingsState extends State<SoundSettings> {
  bool _enabled = SoundService.instance.isEnabled;
  double _volume = SoundService.instance.volume;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sound Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Enable Sounds'),
              subtitle: const Text('Play feedback sounds on actions'),
              value: _enabled,
              activeColor: const Color(0xFFD4AF37),
              onChanged: (val) {
                setState(() => _enabled = val);
                SoundService.instance.setEnabled(val);
              },
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Volume'),
              subtitle: Slider(
                value: _volume,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                activeColor: const Color(0xFFD4AF37),
                label: '${(_volume * 100).toInt()}%',
                onChanged: _enabled
                    ? (val) {
                        setState(() => _volume = val);
                        SoundService.instance.setVolume(val);
                      }
                    : null,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _enabled
                    ? () {
                        SoundService.instance.tap();
                      }
                    : null,
                icon: const Icon(Icons.volume_up),
                label: const Text('TEST SOUND'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
