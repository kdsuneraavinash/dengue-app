abstract class BLoC {
  void dispose();

  void streamConnect();

  BLoC() {
    streamConnect();
  }
}
