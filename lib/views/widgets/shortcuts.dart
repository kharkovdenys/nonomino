import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DelIntent extends Intent {
  const DelIntent();
}

class DownIntent extends Intent {
  const DownIntent();
}

class EightIntent extends Intent {
  const EightIntent();
}

class FiveIntent extends Intent {
  const FiveIntent();
}

class FourIntent extends Intent {
  const FourIntent();
}

class LeftIntent extends Intent {
  const LeftIntent();
}

class NewIntent extends Intent {
  const NewIntent();
}

class NineIntent extends Intent {
  const NineIntent();
}

class NoteIntent extends Intent {
  const NoteIntent();
}

class OneIntent extends Intent {
  const OneIntent();
}

class RecordsIntent extends Intent {
  const RecordsIntent();
}

class RightIntent extends Intent {
  const RightIntent();
}

class SettingIntent extends Intent {
  const SettingIntent();
}

class SevenIntent extends Intent {
  const SevenIntent();
}

class SixIntent extends Intent {
  const SixIntent();
}

class ThreeIntent extends Intent {
  const ThreeIntent();
}

class TwoIntent extends Intent {
  const TwoIntent();
}

class UpIntent extends Intent {
  const UpIntent();
}

class ShortcutsScaffold extends StatelessWidget {
  final Function() getRecords, newGame, settingsSudoku, toggleNotes;
  final Function(int) tapNumber, moveSelect;
  final Scaffold child;
  const ShortcutsScaffold({
    Key? key,
    required this.child,
    required this.getRecords,
    required this.newGame,
    required this.settingsSudoku,
    required this.tapNumber,
    required this.moveSelect,
    required this.toggleNotes,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.delete): const DelIntent(),
          LogicalKeySet(LogicalKeyboardKey.backspace): const DelIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const SettingIntent(),
          LogicalKeySet(LogicalKeyboardKey.tab): const NoteIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit1): const OneIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit2): const TwoIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit3): const ThreeIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit4): const FourIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit5): const FiveIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit6): const SixIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit7): const SevenIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit8): const EightIntent(),
          LogicalKeySet(LogicalKeyboardKey.digit9): const NineIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowUp): const UpIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowDown): const DownIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowRight): const RightIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowLeft): const LeftIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyR):
              const RecordsIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
              const NewIntent(),
        },
        child: Actions(actions: <Type, Action<Intent>>{
          RecordsIntent: CallbackAction<RecordsIntent>(
              onInvoke: (RecordsIntent intent) => getRecords()),
          NewIntent: CallbackAction<NewIntent>(
            onInvoke: (NewIntent intent) => newGame(),
          ),
          SettingIntent: CallbackAction<SettingIntent>(
            onInvoke: (SettingIntent intent) => settingsSudoku(),
          ),
          OneIntent: CallbackAction<OneIntent>(
            onInvoke: (OneIntent intent) => tapNumber(1),
          ),
          TwoIntent: CallbackAction<TwoIntent>(
            onInvoke: (TwoIntent intent) => tapNumber(2),
          ),
          ThreeIntent: CallbackAction<ThreeIntent>(
            onInvoke: (ThreeIntent intent) => tapNumber(3),
          ),
          FourIntent: CallbackAction<FourIntent>(
            onInvoke: (FourIntent intent) => tapNumber(4),
          ),
          FiveIntent: CallbackAction<FiveIntent>(
            onInvoke: (FiveIntent intent) => tapNumber(5),
          ),
          SixIntent: CallbackAction<SixIntent>(
            onInvoke: (SixIntent intent) => tapNumber(6),
          ),
          SevenIntent: CallbackAction<SevenIntent>(
            onInvoke: (SevenIntent intent) => tapNumber(7),
          ),
          EightIntent: CallbackAction<EightIntent>(
            onInvoke: (EightIntent intent) => tapNumber(8),
          ),
          NineIntent: CallbackAction<NineIntent>(
            onInvoke: (NineIntent intent) => tapNumber(9),
          ),
          UpIntent: CallbackAction<UpIntent>(
            onInvoke: (UpIntent intent) => moveSelect(0),
          ),
          DownIntent: CallbackAction<DownIntent>(
            onInvoke: (DownIntent intent) => moveSelect(1),
          ),
          LeftIntent: CallbackAction<LeftIntent>(
            onInvoke: (LeftIntent intent) => moveSelect(2),
          ),
          RightIntent: CallbackAction<RightIntent>(
            onInvoke: (RightIntent intent) => moveSelect(3),
          ),
          DelIntent: CallbackAction<DelIntent>(
            onInvoke: (DelIntent intent) => tapNumber(0),
          ),
          NoteIntent: CallbackAction<NoteIntent>(
            onInvoke: (NoteIntent intent) => toggleNotes(),
          ),
        }, child: Focus(autofocus: true, child: child)));
  }
}
