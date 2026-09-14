import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'package:rml_fakebank_app/common/realtime/reverb_config_provider.dart';
import 'package:rml_fakebank_app/common/realtime/reverb_event_models.dart';

abstract class IReverbService {
  Stream<ReverbAppEvent> get events;

  Future<void> connect();
  Future<void> disconnect();
}

class ReverbService implements IReverbService {
  ReverbService({IReverbConfigProvider? configProvider})
    : _configProvider = configProvider ?? GetIt.I<IReverbConfigProvider>();

  final IReverbConfigProvider _configProvider;
  final _eventsController = StreamController<ReverbAppEvent>.broadcast();

  @override
  Stream<ReverbAppEvent> get events => _eventsController.stream;

  @override
  Future<void> connect() async {
    debugPrint('Reverb connecting to ${_configProvider.connection.host}');
  }

  @override
  Future<void> disconnect() async {
    debugPrint('Reverb disconnected');
  }

  void dispose() {
    _eventsController.close();
  }
}
