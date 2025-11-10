// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'dart:async';

// // State
// class ConnectivityState extends Equatable {
//   final bool isConnected;
//   final String connectionType; // 'wifi', 'mobile', 'none'
//   final String message;

//   const ConnectivityState({
//     required this.isConnected,
//     required this.connectionType,
//     required this.message,
//   });

//   factory ConnectivityState.initial() {
//     return const ConnectivityState(
//       isConnected: true,
//       connectionType: 'unknown',
//       message: 'Checking connection...',
//     );
//   }

//   factory ConnectivityState.connected(String type) {
//     return ConnectivityState(
//       isConnected: true,
//       connectionType: type,
//       message: 'Connected via $type',
//     );
//   }

//   factory ConnectivityState.disconnected() {
//     return const ConnectivityState(
//       isConnected: false,
//       connectionType: 'none',
//       message: 'No internet connection',
//     );
//   }

//   @override
//   List<Object?> get props => [isConnected, connectionType, message];
// }

// // Cubit
// class ConnectivityCubit extends Cubit<ConnectivityState> {
//   final Connectivity _connectivity;
//   StreamSubscription<ConnectivityResult>? _connectivitySubscription;

//   ConnectivityCubit({Connectivity? connectivity})
//       : _connectivity = connectivity ?? Connectivity(),
//         super(ConnectivityState.initial()) {
//     _init();
//   }

//   void _init() async {
//     // Check initial connectivity
//     final result = await _connectivity.checkConnectivity();
//     _updateConnectionStatus(result);

//     // Listen to connectivity changes
//     _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
//       _updateConnectionStatus,
//     );
//   }

//   void _updateConnectionStatus(ConnectivityResult result) {
//     if (result == ConnectivityResult.none) {
//       emit(ConnectivityState.disconnected());
//     } else if (result == ConnectivityResult.wifi) {
//       emit(ConnectivityState.connected('WiFi'));
//     } else if (result == ConnectivityResult.mobile) {
//       emit(ConnectivityState.connected('Mobile Data'));
//     } else {
//       emit(ConnectivityState.connected('Unknown'));
//     }
//   }

//   // Manual check
//   Future<void> checkConnectivity() async {
//     final result = await _connectivity.checkConnectivity();
//     _updateConnectionStatus(result);
//   }

//   @override
//   Future<void> close() {
//     _connectivitySubscription?.cancel();
//     return super.close();
//   }
// }