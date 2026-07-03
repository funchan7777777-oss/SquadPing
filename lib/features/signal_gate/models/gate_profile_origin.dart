enum GateProfileOrigin {
  localAccount(nextCaption: 'Next'),
  appleIdentity(nextCaption: 'Enter');

  const GateProfileOrigin({required this.nextCaption});

  final String nextCaption;
}
