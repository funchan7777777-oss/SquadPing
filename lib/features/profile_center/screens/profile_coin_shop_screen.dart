import 'package:flutter/material.dart';

import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/safety/safety_action_sheet.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../services/profile_wallet_store.dart';

class ProfileCoinShopScreen extends StatefulWidget {
  const ProfileCoinShopScreen({super.key});

  @override
  State<ProfileCoinShopScreen> createState() => _ProfileCoinShopScreenState();
}

class _ProfileCoinShopScreenState extends State<ProfileCoinShopScreen> {
  final _walletStore = ProfileWalletStore.instance;
  var _isReady = false;

  @override
  void initState() {
    super.initState();
    _initialize();
    _walletStore.addListener(_refresh);
  }

  @override
  void dispose() {
    _walletStore.removeListener(_refresh);
    super.dispose();
  }

  Future<void> _initialize() async {
    await _walletStore.initialize();
    if (mounted) {
      setState(() => _isReady = true);
    }
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _buy(_CoinProduct product) async {
    await _walletStore.addCoins(product.amount);
    if (!mounted) {
      return;
    }
    await showSafetyFeedbackDialog(
      context: context,
      title: 'Gold coins added',
      message:
          '${product.amount} gold coins have been added to your local wallet.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7138F5),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              SquadPingAssets.profileShopBackdrop,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF6337EE).withValues(alpha: 0.76),
                    const Color(0xFF7C40F6).withValues(alpha: 0.62),
                    Colors.white.withValues(alpha: 0.16),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: !_isReady
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : ListView(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          squadCompactTopPadding(context),
                          16,
                          28,
                        ),
                        children: [
                          _ShopHeader(
                            onBack: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(height: 16),
                          _WalletPanel(coins: _walletStore.coins),
                          const SizedBox(height: 14),
                          Text(
                            'Gold coins can be used to post your highlights.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.76),
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 20),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _products.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 0.70,
                                ),
                            itemBuilder: (context, index) {
                              return _CoinProductCard(
                                product: _products[index],
                                highlight: index == 0,
                                onBuy: () => _buy(_products[index]),
                              );
                            },
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopHeader extends StatelessWidget {
  const _ShopHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
        ),
        Expanded(
          child: Text(
            'shop',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _WalletPanel extends StatelessWidget {
  const _WalletPanel({required this.coins});

  final int coins;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: const Color(0xFF6B35F1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Gold Coins',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '$coins',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      SquadPingAssets.profileCoinIcon,
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Image.asset(SquadPingAssets.profileCoinIcon, width: 76, height: 76),
        ],
      ),
    );
  }
}

class _CoinProductCard extends StatelessWidget {
  const _CoinProductCard({
    required this.product,
    required this.highlight,
    required this.onBuy,
  });

  final _CoinProduct product;
  final bool highlight;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFE34BD8) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
      child: Column(
        children: [
          Image.asset(SquadPingAssets.profileCoinIcon, width: 38, height: 38),
          const SizedBox(height: 4),
          Text(
            '${product.amount}',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: highlight ? Colors.white : const Color(0xFF2A2531),
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          Text(
            product.price,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: highlight ? Colors.white : Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: onBuy,
            child: SizedBox(
              width: double.infinity,
              height: 34,
              child: Image.asset(
                highlight
                    ? SquadPingAssets.profileRewardBuyButton
                    : SquadPingAssets.profileBuyButton,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinProduct {
  const _CoinProduct(this.amount, this.price);

  final int amount;
  final String price;
}

const _products = [
  _CoinProduct(123, r'$1.99'),
  _CoinProduct(300, r'$3.99'),
  _CoinProduct(680, r'$7.99'),
  _CoinProduct(1280, r'$14.99'),
  _CoinProduct(2580, r'$29.99'),
  _CoinProduct(5180, r'$59.99'),
  _CoinProduct(9980, r'$99.99'),
  _CoinProduct(19800, r'$149.99'),
  _CoinProduct(32800, r'$199.99'),
];
