import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class HistoryRequested extends HistoryEvent {
  const HistoryRequested({this.limit});

  final int? limit;

  @override
  List<Object?> get props => [limit];
}