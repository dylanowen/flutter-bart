import 'dart:async';

class GlobalEvents {

  bool canSend = false;
  StreamController<Event> _controller;

  GlobalEvents() {
    _controller = new StreamController.broadcast(
        onListen: _onListen,
        onCancel: _onCancel
    );
  }

  bool emit(Event event) {
    if (canSend) {
      _controller.add(event);
    }

    return canSend;
  }

  StreamSubscription<T> listen<T extends Event>(void onData(T event)) {
    return _controller.stream
        .where((event) => event is T)
        .listen(onData);
  }

  _onListen() {
    canSend = true;
  }

  _onCancel() {
    canSend = false;
  }
}

abstract class Event {}



class FavoriteStationAdded implements Event {



  FavoriteStationAdded() {

  }
}