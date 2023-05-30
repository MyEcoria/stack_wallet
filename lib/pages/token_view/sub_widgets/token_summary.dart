import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackwallet/models/isar/models/ethereum/eth_contract.dart';
import 'package:stackwallet/pages/buy_view/buy_in_wallet_view.dart';
import 'package:stackwallet/pages/exchange_view/wallet_initiated_exchange_view.dart';
import 'package:stackwallet/pages/receive_view/receive_view.dart';
import 'package:stackwallet/pages/send_view/token_send_view.dart';
import 'package:stackwallet/pages/token_view/token_view.dart';
import 'package:stackwallet/pages/wallet_view/sub_widgets/wallet_refresh_button.dart';
import 'package:stackwallet/providers/global/locale_provider.dart';
import 'package:stackwallet/providers/global/prefs_provider.dart';
import 'package:stackwallet/providers/global/price_provider.dart';
import 'package:stackwallet/providers/global/wallets_provider.dart';
import 'package:stackwallet/services/event_bus/events/global/wallet_sync_status_changed_event.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/themes/theme_providers.dart';
import 'package:stackwallet/utilities/amount/amount.dart';
import 'package:stackwallet/utilities/amount/amount_formatter.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/widgets/conditional_parent.dart';
import 'package:stackwallet/widgets/rounded_container.dart';
import 'package:tuple/tuple.dart';

class TokenSummary extends ConsumerWidget {
  const TokenSummary({
    Key? key,
    required this.walletId,
    required this.initialSyncStatus,
  }) : super(key: key);

  final String walletId;
  final WalletSyncStatus initialSyncStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token =
        ref.watch(tokenServiceProvider.select((value) => value!.tokenContract));
    final balance =
        ref.watch(tokenServiceProvider.select((value) => value!.balance));

    return Stack(
      children: [
        RoundedContainer(
          color: Theme.of(context).extension<StackColors>()!.tokenSummaryBG,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.svg.walletDesktop,
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .tokenSummaryTextSecondary,
                    width: 12,
                    height: 12,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    ref.watch(
                      walletsChangeNotifierProvider.select(
                        (value) => value.getManager(walletId).walletName,
                      ),
                    ),
                    style: STextStyles.w500_12(context).copyWith(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .tokenSummaryTextSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ref.watch(pAmountFormatter(Coin.ethereum)).format(
                          balance.total,
                          ethContract: token,
                        ),
                    style: STextStyles.pageTitleH1(context).copyWith(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .tokenSummaryTextPrimary,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CoinTickerTag(
                    walletId: walletId,
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                "${(balance.total.decimal * ref.watch(
                          priceAnd24hChangeNotifierProvider.select(
                            (value) => value.getTokenPrice(token.address).item1,
                          ),
                        )).toAmount(
                      fractionDigits: 2,
                    ).fiatString(
                      locale: ref.watch(
                        localeServiceChangeNotifierProvider.select(
                          (value) => value.locale,
                        ),
                      ),
                    )} ${ref.watch(
                  prefsChangeNotifierProvider.select(
                    (value) => value.currency,
                  ),
                )}",
                style: STextStyles.subtitle500(context).copyWith(
                  color: Theme.of(context)
                      .extension<StackColors>()!
                      .tokenSummaryTextPrimary,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TokenWalletOptions(
                walletId: walletId,
                tokenContract: token,
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: WalletRefreshButton(
            walletId: walletId,
            initialSyncStatus: initialSyncStatus,
            tokenContractAddress: ref.watch(
              tokenServiceProvider.select(
                (value) => value!.tokenContract.address,
              ),
            ),
            overrideIconColor:
                Theme.of(context).extension<StackColors>()!.topNavIconPrimary,
          ),
        ),
      ],
    );
  }
}

class TokenWalletOptions extends ConsumerWidget {
  const TokenWalletOptions({
    Key? key,
    required this.walletId,
    required this.tokenContract,
  }) : super(key: key);

  final String walletId;
  final EthContract tokenContract;

  void _onExchangePressed(BuildContext context) async {
    unawaited(
      Navigator.of(context).pushNamed(
        WalletInitiatedExchangeView.routeName,
        arguments: Tuple3(
          walletId,
          Coin.ethereum,
          tokenContract,
        ),
      ),
    );
  }

  void _onBuyPressed(BuildContext context) {
    unawaited(
      Navigator.of(context).pushNamed(
        BuyInWalletView.routeName,
        arguments: Tuple2(
          Coin.ethereum,
          tokenContract,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TokenOptionsButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              ReceiveView.routeName,
              arguments: Tuple2(
                walletId,
                tokenContract,
              ),
            );
          },
          subLabel: "Receive",
          iconAssetPathSVG: Assets.svg.arrowDownLeft,
        ),
        const SizedBox(
          width: 16,
        ),
        TokenOptionsButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              TokenSendView.routeName,
              arguments: Tuple3(
                walletId,
                Coin.ethereum,
                tokenContract,
              ),
            );
          },
          subLabel: "Send",
          iconAssetPathSVG: Assets.svg.arrowUpRight,
        ),
        const SizedBox(
          width: 16,
        ),
        TokenOptionsButton(
          onPressed: () => _onExchangePressed(context),
          subLabel: "Swap",
          iconAssetPathSVG: ref.watch(
            themeProvider.select(
              (value) => value.assets.exchange,
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        TokenOptionsButton(
          onPressed: () => _onBuyPressed(context),
          subLabel: "Buy",
          iconAssetPathSVG: Assets.svg.creditCard,
        ),
      ],
    );
  }
}

class TokenOptionsButton extends StatelessWidget {
  const TokenOptionsButton({
    Key? key,
    required this.onPressed,
    required this.subLabel,
    required this.iconAssetPathSVG,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String subLabel;
  final String iconAssetPathSVG;

  @override
  Widget build(BuildContext context) {
    final iconSize = subLabel == "Send" || subLabel == "Receive" ? 12.0 : 24.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RawMaterialButton(
          fillColor:
              Theme.of(context).extension<StackColors>()!.tokenSummaryButtonBG,
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          constraints: const BoxConstraints(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Constants.size.circularBorderRadius,
            ),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ConditionalParent(
              condition: iconSize < 24,
              builder: (child) => RoundedContainer(
                padding: const EdgeInsets.all(6),
                color: Theme.of(context)
                    .extension<StackColors>()!
                    .tokenSummaryIcon
                    .withOpacity(0.4),
                radiusMultiplier: 10,
                child: Center(
                  child: child,
                ),
              ),
              child: iconAssetPathSVG.startsWith("assets/")
                  ? SvgPicture.asset(
                      iconAssetPathSVG,
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .tokenSummaryIcon,
                      width: iconSize,
                      height: iconSize,
                    )
                  : SvgPicture.file(
                      File(iconAssetPathSVG),
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .tokenSummaryIcon,
                      width: iconSize,
                      height: iconSize,
                    ),
            ),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          subLabel,
          style: STextStyles.w500_12(context).copyWith(
            color: Theme.of(context)
                .extension<StackColors>()!
                .tokenSummaryTextPrimary,
          ),
        )
      ],
    );
  }
}

class CoinTickerTag extends ConsumerWidget {
  const CoinTickerTag({
    Key? key,
    required this.walletId,
  }) : super(key: key);

  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RoundedContainer(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      radiusMultiplier: 0.25,
      color: Theme.of(context).extension<StackColors>()!.ethTagBG,
      child: Text(
        ref.watch(
          walletsChangeNotifierProvider
              .select((value) => value.getManager(walletId).coin.ticker),
        ),
        style: STextStyles.w600_12(context).copyWith(
          color: Theme.of(context).extension<StackColors>()!.ethTagText,
        ),
      ),
    );
  }
}
