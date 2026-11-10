import 'dart:io';

class LimparTela {
  LimparTela() {
    stdout.write('\x1B[2J\x1B[3J\x1B[H');
  }
}