import '../../shared/visuals/squad_ping_assets.dart';

enum SquadPingTab {
  beacon(
    SquadPingAssets.tabBeaconActive,
    SquadPingAssets.tabBeaconInactive,
    'Beacon',
  ),
  chat(SquadPingAssets.tabChatActive, SquadPingAssets.tabChatInactive, 'Chat'),
  voice(
    SquadPingAssets.tabVoiceActive,
    SquadPingAssets.tabVoiceInactive,
    'Voice',
  ),
  emblem(
    SquadPingAssets.tabEmblemActive,
    SquadPingAssets.tabEmblemInactive,
    'Information',
  ),
  forum(
    SquadPingAssets.tabForumActive,
    SquadPingAssets.tabForumInactive,
    'Mine',
  );

  const SquadPingTab(this.activeAsset, this.inactiveAsset, this.caption);

  final String activeAsset;
  final String inactiveAsset;
  final String caption;
}
