import 'package:chitti_meeting/modules/meeting_module/repositories/meeting_respositories.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../modules/meeting_module/providers/meeting_provider.dart';
import 'package:livekit_client/livekit_client.dart';

final locator = GetIt.instance;

void setup() {
  // locator.registerLazySingleton<DyteMobileClient>(() => DyteMobileClient());
  locator.registerLazySingleton<Room>(() => Room());
  locator.registerLazySingleton<Dio>(() => Dio());
  locator.registerLazySingleton<MeetingStateNotifier>(
      () => MeetingStateNotifier());
  locator.registerLazySingleton<MeetingRepositories>(
      () => MeetingRepositories(dio: locator<Dio>(), room: locator<Room>()));
  locator.registerLazySingleton<EventsListener>(
      () => locator<Room>().createListener());
}
