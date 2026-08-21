# SIGN BRO Sound System

## State-Aware AR Sound Sequence

The sound system provides audio feedback throughout the AR sign scanning workflow:

```
CAMERA → Searching (subtle pulse)
       → Sign detected (detection tone)  
       → Corners locked (lock sound)
       → Measurement ready (confirmation)
       → AI analysis (processing pulse)
       → Result ready (success tone)
```

## Sound Map

| Event              | Sound File        | Trigger Location                     |
|--------------------|-------------------|--------------------------------------|
| Navigation tap     | navigation.mp3    | Bottom nav destination change        |
| Scan start         | scan_start.mp3    | Camera initialized in ScanPage       |
| Lock sign          | lock.mp3          | Scan FAB pressed (corners locked)    |
| Success            | success.mp3       | Analysis complete, sign data ready   |
| Quotation          | quote.mp3         | GENERATE QUOTATION button pressed    |
| General tap        | tap.mp3           | Scan FAB button tap                  |
| Error              | error.mp3         | Available for error states           |

## Usage

```dart
import 'services/sound_service.dart';

// Play a sound
SoundService.instance.tap();
SoundService.instance.lock();
SoundService.instance.success();

// Control
SoundService.instance.setEnabled(false);  // mute
SoundService.instance.setVolume(0.5);     // 50% volume
```

## Settings

Users can control sounds via `SoundSettings` widget:
- Enable/disable toggle
- Volume slider (0-100%)
- Test sound button

## Asset Requirements

Place MP3 files in `assets/sounds/`:
- tap.mp3
- scan_start.mp3
- lock.mp3
- success.mp3
- error.mp3
- navigation.mp3
- quote.mp3

All sounds should be short (< 1 second), subtle UI feedback tones.
