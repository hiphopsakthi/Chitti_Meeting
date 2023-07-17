import 'package:chitti_meeting/modules/meeting_module/providers/meeting_provider.dart';
import 'package:chitti_meeting/modules/meeting_module/repositories/meeting_respositories.dart';
import 'package:chitti_meeting/modules/meeting_module/states/meeting_states.dart';
import 'package:chitti_meeting/modules/view_module/widgets/participant_widget.dart';
import 'package:chitti_meeting/services/locator.dart';
import 'package:chitti_meeting/services/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livekit_client/livekit_client.dart';
import '../providers/view_provider.dart';
// import '../widgets/page_number.dart';

class ViewScreen extends ConsumerStatefulWidget {
  const ViewScreen({super.key});

  @override
  ConsumerState<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends ConsumerState<ViewScreen> {
  late final PageController _pageController;
  final Room room = locator<Room>();
  final MeetingRepositories meetingRepositories =
      locator<MeetingRepositories>();
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveDevice responsiveDevice =
        Responsive().getDeviceType(context);
    ref.watch(participantProvider);
    final ViewType viewType = ref.watch(viewProvider);
    final List<dynamic> participants = meetingRepositories.sortParticipant(
        responsiveDevice == ResponsiveDevice.desktop &&
                viewType == ViewType.standard
            ? ViewType.speaker
            : viewType,
        ref);
    return participants.isNotEmpty
        ? responsiveDevice != ResponsiveDevice.desktop ||
                viewType != ViewType.standard
            ? PageView.builder(
                padEnds: false,
                controller: _pageController,
                itemCount: participants.length,
                itemBuilder: (context, index) {
                  final participantTracks = viewType != ViewType.speaker
                      ? participants[index] as List<dynamic>
                      : participants;
                  return viewType == ViewType.standard
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: participantTracks.map((e) {
                            return SizedBox(
                              height: 200,
                              child: ParticipantWidget(
                                participant: e,
                              ),
                            );
                          }).toList(),
                        )
                      : viewType == ViewType.gallery
                          ? Center(
                              child: GridView.builder(
                                gridDelegate:
                                     SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  mainAxisExtent:responsiveDevice!=ResponsiveDevice.mobile?
                                      MediaQuery.of(context).size.height / 2.5:null,
                                ),
                                itemCount: participantTracks.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    height: 200,
                                    child: ParticipantWidget(
                                      participant: participantTracks[index],
                                    ),
                                  );
                                },
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ParticipantWidget(
                                  participant: participants[index],
                                ),
                              ],
                            );
                })
            : Row(children: [
                Expanded(
                    flex: 2,
                    child: ParticipantWidget(
                      participant: participants[0],
                    )),
                Container(
                    width: 250,
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      children: participants.sublist(1).map((e) {
                        return SizedBox(
                            height: 200,
                            child: ParticipantWidget(
                              participant: e,
                            ));
                      }).toList(),
                    ))
              ])
        : const Center(
            child: CircularProgressIndicator(
            color: Colors.white,
          ));
  }
}

class ParticipantWithoutVideo extends StatelessWidget {
  const ParticipantWithoutVideo({
    super.key,
    required this.participantName,
  });
  final String participantName;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
        // padding: const EdgeInsets.all(15),
        width: double.infinity,
        height: 200,
        color: Colors.white.withOpacity(0.04),
        child: Stack(
          children: [
            Center(
                child: Image.asset(
              'assets/icons/user_rounded.png',
              width: 44,
              height: 44,
            )),
            Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: Row(
                    children: [
                      Text(
                        participantName,
                        style: textTheme.labelSmall?.copyWith(fontSize: 12),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Image.asset(
                        'assets/icons/mic_off.png',
                        width: 16,
                        height: 16,
                      )
                    ],
                  ),
                ))
          ],
        ));
  }
}
