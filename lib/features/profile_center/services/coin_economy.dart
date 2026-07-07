class CoinPack {
  const CoinPack({
    required this.productId,
    required this.coins,
    required this.priceLabel,
    this.isBestValue = false,
  });

  final String productId;
  final int coins;
  final String priceLabel;
  final bool isBestValue;
}

class CoinSpendRule {
  const CoinSpendRule({
    required this.title,
    required this.cost,
    required this.detail,
  });

  final String title;
  final int cost;
  final String detail;
}

abstract final class CoinEconomy {
  static const welcomeGiftCoins = 120;
  static const communityPostCost = 20;
  static const videoHighlightCost = 30;
  static const tacticalBriefCost = 15;

  static const coinPacks = <CoinPack>[
    CoinPack(productId: 'ivdupywnbqlxlpet', coins: 50, priceLabel: r'$0.99'),
    CoinPack(productId: 'hwwptufcgsullrae', coins: 100, priceLabel: r'$1.99'),
    CoinPack(productId: 'cvafpwnzpjfhwurb', coins: 250, priceLabel: r'$4.99'),
    CoinPack(
      productId: 'tuyqasergivtopsz',
      coins: 500,
      priceLabel: r'$9.99',
      isBestValue: true,
    ),
    CoinPack(productId: 'wyrmqimdhzkoncve', coins: 1000, priceLabel: r'$19.99'),
    CoinPack(productId: 'dqilvdljbaziwbpp', coins: 2500, priceLabel: r'$49.99'),
    CoinPack(productId: 'cwlkfeexbutyfqvh', coins: 5000, priceLabel: r'$99.99'),
  ];

  static const spendRules = <CoinSpendRule>[
    CoinSpendRule(
      title: 'Community post',
      cost: communityPostCost,
      detail: 'Publish one community post with real local photos.',
    ),
    CoinSpendRule(
      title: 'Video highlight post',
      cost: videoHighlightCost,
      detail: 'Publish one gameplay highlight from the video feed.',
    ),
    CoinSpendRule(
      title: 'Tactical brief forge',
      cost: tacticalBriefCost,
      detail: 'Create one saved squad plan with roles, comms, and reset rules.',
    ),
  ];
}
