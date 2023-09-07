import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/responsive.dart';
import '../../view_module/providers/view_provider.dart';
import '../providers/meeting_provider.dart';
import '../states/meeting_states.dart';

class ParticipantsScreen extends ConsumerWidget {
  const ParticipantsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final participants = ref.watch(participantProvider);
    final responsiveDevice = Responsive().getDeviceType(context);
    final viewType = ref.read(viewProvider).viewType;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Participants'),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          actions: [
            GestureDetector(
              onTap: () {
                if (responsiveDevice == ResponsiveDevice.desktop) {
                  ref
                      .read(viewProvider.notifier)
                      .openParticipantsInDesktop(false);
                  return;
                }
                viewType == ViewType.fullScreen
                    ? SystemChrome.setPreferredOrientations([
                        DeviceOrientation.landscapeLeft,
                      ])
                    : null;
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.asset(
                  'assets/icons/cancel.png',
                  width: 12,
                  height: 12,
                ),
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0),
            child: Container(
              color: Colors.white.withOpacity(0.1),
              height: 1.0,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ListView.builder(
              itemCount: participants.length,
              itemBuilder: (context, index) {
                // final participant = participants[index] as Participant;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white.withOpacity(0.08),
                              child: Image.asset(
                                'assets/icons/user.png',
                                width: 20,
                                height: 20,
                              )),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            participants[index].name == '' ||
                                    participants[index].name == null
                                ? participants[index].identity
                                : participants[index].name,
                            style: textTheme.labelSmall?.copyWith(
                                color: Colors.white.withOpacity(0.75)),
                          ),
                        ],
                      ),
                      participants[index].name == 'Host'
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: responsiveDevice !=
                                          ResponsiveDevice.desktop
                                      ? 4
                                      : 6,
                                  horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                'Host',
                                style: textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontSize: responsiveDevice !=
                                            ResponsiveDevice.desktop
                                        ? 10
                                        : 12),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                );
              }),
        ));
  }
}
