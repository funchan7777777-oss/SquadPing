import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/safety/safety_action_sheet.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../services/coin_economy.dart';
import '../services/profile_wallet_store.dart';

class ProfileCoinShopScreen extends StatefulWidget {
  const ProfileCoinShopScreen({super.key});

  @override
  State<ProfileCoinShopScreen> createState() => _ProfileCoinShopScreenState();
}

class _ProfileCoinShopScreenState extends State<ProfileCoinShopScreen> {
  final _walletStore = ProfileWalletStore.instance;
  late final StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;
  var _storeProducts = <String, ProductDetails>{};
  var _isReady = false;
  String? _buyingProductId;

  @override
  void initState() {
    super.initState();
    _purchaseSubscription = InAppPurchase.instance.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: _handlePurchaseStreamError,
    );
    _initialize();
    _walletStore.addListener(_refresh);
  }

  @override
  void dispose() {
    _purchaseSubscription.cancel();
    _walletStore.removeListener(_refresh);
    super.dispose();
  }

  Future<void> _initialize() async {
    await _walletStore.initialize();
    await _loadStoreProducts();
    if (mounted) {
      setState(() => _isReady = true);
    }
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handlePurchaseStreamError(Object _) {
    _showSnack('Apple purchase service is unavailable. Try again later.');
    if (mounted) {
      setState(() => _buyingProductId = null);
    }
  }

  Future<void> _loadStoreProducts() async {
    try {
      final available = await InAppPurchase.instance.isAvailable();
      if (!available) {
        return;
      }
      final response = await InAppPurchase.instance.queryProductDetails(
        CoinEconomy.coinPacks.map((pack) => pack.productId).toSet(),
      );
      if (response.error != null || !mounted) {
        return;
      }
      _storeProducts = {
        for (final product in response.productDetails) product.id: product,
      };
    } catch (_) {
      return;
    }
  }

  Future<void> _buy(CoinPack pack) async {
    if (_buyingProductId != null) {
      return;
    }
    setState(() => _buyingProductId = pack.productId);
    var purchaseStarted = false;
    try {
      final available = await InAppPurchase.instance.isAvailable();
      if (!available) {
        _showSnack('Apple purchase service is unavailable.');
        return;
      }

      var productDetails = _storeProducts[pack.productId];
      if (productDetails == null) {
        final response = await InAppPurchase.instance.queryProductDetails({
          pack.productId,
        });
        if (response.error != null) {
          _showSnack(response.error!.message);
          return;
        }

        for (final product in response.productDetails) {
          if (product.id == pack.productId) {
            productDetails = product;
            break;
          }
        }
        if (productDetails != null) {
          _storeProducts = {
            ..._storeProducts,
            productDetails.id: productDetails,
          };
        }
        if (response.notFoundIDs.isNotEmpty) {
          _showSnack(
            'This coin pack is not available in App Store Connect yet.',
          );
          return;
        }
      }

      if (productDetails == null) {
        _showSnack('This coin pack is not available in App Store Connect yet.');
        return;
      }

      final started = await InAppPurchase.instance.buyConsumable(
        purchaseParam: PurchaseParam(productDetails: productDetails),
        autoConsume: true,
      );
      purchaseStarted = started;
      if (!started) {
        _showSnack('Purchase was not started. Please try again.');
      }
    } catch (_) {
      _showSnack('Unable to open Apple purchase. Please try again.');
    } finally {
      if (mounted && !purchaseStarted) {
        setState(() => _buyingProductId = null);
      }
    }
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        if (mounted) {
          setState(() => _buyingProductId = purchase.productID);
        }
        continue;
      }

      if (purchase.status == PurchaseStatus.error) {
        _showSnack(purchase.error?.message ?? 'Purchase failed.');
      }

      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        await _deliverPurchase(purchase);
      }

      if (purchase.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchase);
      }
    }

    if (mounted) {
      setState(() => _buyingProductId = null);
    }
  }

  Future<void> _deliverPurchase(PurchaseDetails purchase) async {
    final pack = _packForProductId(purchase.productID);
    if (pack == null) {
      return;
    }

    final credited = await _walletStore.addPurchasedCoins(
      purchaseId: _purchaseKey(purchase),
      coins: pack.coins,
    );
    if (!credited || !mounted) {
      return;
    }

    await showSafetyFeedbackDialog(
      context: context,
      title: 'Gold coins added',
      message:
          '${pack.coins} gold coins were added to your balance. Your wallet updates instantly.',
    );
  }

  CoinPack? _packForProductId(String productId) {
    for (final pack in CoinEconomy.coinPacks) {
      if (pack.productId == productId) {
        return pack;
      }
    }
    return null;
  }

  String _purchaseKey(PurchaseDetails purchase) {
    final purchaseId = purchase.purchaseID;
    if (purchaseId != null && purchaseId.isNotEmpty) {
      return purchaseId;
    }
    final verificationData = purchase.verificationData.serverVerificationData;
    if (verificationData.isNotEmpty) {
      return '${purchase.productID}-$verificationData';
    }
    return '${purchase.productID}-${purchase.transactionDate ?? DateTime.now().microsecondsSinceEpoch}';
  }

  void _showSnack(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
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
                    const Color(0xFF6337EE).withValues(alpha: 0.78),
                    const Color(0xFF7C40F6).withValues(alpha: 0.66),
                    const Color(0xFFE653EA).withValues(alpha: 0.22),
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
                          30,
                        ),
                        children: [
                          _ShopHeader(
                            onBack: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(height: 16),
                          _WalletPanel(coins: _walletStore.coins),
                          const SizedBox(height: 16),
                          const _ShopExplainer(),
                          const SizedBox(height: 18),
                          _SectionTitle(
                            title: 'Recharge packs',
                            trailing: 'App Store IAP',
                          ),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: CoinEconomy.coinPacks.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1.05,
                                ),
                            itemBuilder: (context, index) {
                              final pack = CoinEconomy.coinPacks[index];
                              return _CoinProductCard(
                                pack: pack,
                                priceLabel:
                                    _storeProducts[pack.productId]?.price ??
                                    pack.priceLabel,
                                isBuying: _buyingProductId == pack.productId,
                                onBuy: () => _buy(pack),
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          const _SpendRulesPanel(),
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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7D38FF), Color(0xFFE452D8)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.42)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2A0E70).withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Live Balance',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '$coins',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      SquadPingAssets.profileCoinIcon,
                      width: 28,
                      height: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Updates after gifts, purchases, and releases.',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.76),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(SquadPingAssets.profileCoinIcon, width: 84, height: 84),
        ],
      ),
    );
  }
}

class _ShopExplainer extends StatelessWidget {
  const _ShopExplainer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_open_rounded, color: Color(0xFFFFD85F)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Coins unlock fixed-price publishing and planning tools. Chat, comments, follows, and direct messages stay free.',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.86),
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.trailing});

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: Text(
            trailing,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.82),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _CoinProductCard extends StatelessWidget {
  const _CoinProductCard({
    required this.pack,
    required this.priceLabel,
    required this.isBuying,
    required this.onBuy,
  });

  final CoinPack pack;
  final String priceLabel;
  final bool isBuying;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final highlighted = pack.isBestValue;
    return Container(
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFE34BD8) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlighted
              ? const Color(0xFFFFD85F)
              : Colors.white.withValues(alpha: 0.62),
          width: highlighted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                SquadPingAssets.profileCoinIcon,
                width: 38,
                height: 38,
              ),
              const Spacer(),
              if (highlighted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Popular',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${pack.coins}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: highlighted ? Colors.white : const Color(0xFF2A2531),
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            'gold coins',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: highlighted
                  ? Colors.white.withValues(alpha: 0.76)
                  : const Color(0xFF7A7387),
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Text(
                  priceLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: highlighted ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(
                width: 74,
                height: 36,
                child: FilledButton(
                  onPressed: isBuying ? null : onBuy,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: highlighted
                        ? const Color(0xFF6337EE)
                        : Colors.black,
                    disabledBackgroundColor: Colors.black.withValues(
                      alpha: 0.35,
                    ),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: isBuying
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Buy',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpendRulesPanel extends StatelessWidget {
  const _SpendRulesPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Where coins are used',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          for (final rule in CoinEconomy.spendRules) ...[
            _SpendRuleTile(rule: rule),
            const SizedBox(height: 10),
          ],
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              'Purchased coins do not expire. Coins have no cash value and are never used for odds-based rewards, contests, wagers, chat, likes, follows, or profile edits.',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.80),
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpendRuleTile extends StatelessWidget {
  const _SpendRuleTile({required this.rule});

  final CoinSpendRule rule;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFFFD85F).withValues(alpha: 0.16),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: Color(0xFFFFD85F),
            size: 22,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      rule.title,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Image.asset(
                    SquadPingAssets.profileCoinIcon,
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${rule.cost}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                rule.detail,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.70),
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
