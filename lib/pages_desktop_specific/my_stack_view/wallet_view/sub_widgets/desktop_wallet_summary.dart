import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/models/balance.dart';
import 'package:stackwallet/pages/token_view/token_view.dart';
import 'package:stackwallet/pages/wallet_view/sub_widgets/wallet_refresh_button.dart';
import 'package:stackwallet/pages_desktop_specific/my_stack_view/wallet_view/sub_widgets/desktop_balance_toggle_button.dart';
import 'package:stackwallet/providers/providers.dart';
import 'package:stackwallet/providers/wallet/wallet_balance_toggle_state_provider.dart';
import 'package:stackwallet/services/coins/firo/firo_wallet.dart';
import 'package:stackwallet/services/event_bus/events/global/wallet_sync_status_changed_event.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/amount/amount.dart';
import 'package:stackwallet/utilities/amount/amount_formatter.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/enums/wallet_balance_toggle_state.dart';
import 'package:stackwallet/utilities/text_styles.dart';

class DesktopWalletSummary extends ConsumerStatefulWidget {
  const DesktopWalletSummary({
    Key? key,
    required this.walletId,
    required this.initialSyncStatus,
    this.isToken = false,
  }) : super(key: key);

  final String walletId;
  final WalletSyncStatus initialSyncStatus;
  final bool isToken;

  @override
  ConsumerState<DesktopWalletSummary> createState() =>
      _WDesktopWalletSummaryState();
}

class _WDesktopWalletSummaryState extends ConsumerState<DesktopWalletSummary> {
  late final String walletId;

  @override
  void initState() {
    walletId = widget.walletId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");

    final externalCalls = ref.watch(
      prefsChangeNotifierProvider.select(
        (value) => value.externalCalls,
      ),
    );
    final coin = ref.watch(
      walletsChangeNotifierProvider.select(
        (value) => value.getManager(widget.walletId).coin,
      ),
    );
    final locale = ref.watch(
        localeServiceChangeNotifierProvider.select((value) => value.locale));

    final baseCurrency = ref
        .watch(prefsChangeNotifierProvider.select((value) => value.currency));

    final tokenContract = widget.isToken
        ? ref
            .watch(tokenServiceProvider.select((value) => value!.tokenContract))
        : null;

    final priceTuple = widget.isToken
        ? ref.watch(priceAnd24hChangeNotifierProvider
            .select((value) => value.getTokenPrice(tokenContract!.address)))
        : ref.watch(priceAnd24hChangeNotifierProvider
            .select((value) => value.getPrice(coin)));

    final _showAvailable =
        ref.watch(walletBalanceToggleStateProvider.state).state ==
            WalletBalanceToggleState.available;

    Balance balance = widget.isToken
        ? ref.watch(tokenServiceProvider.select((value) => value!.balance))
        : ref.watch(walletsChangeNotifierProvider
            .select((value) => value.getManager(walletId).balance));

    Amount balanceToShow;
    if (coin == Coin.firo || coin == Coin.firoTestNet) {
      Balance? balanceSecondary = ref
          .watch(
            walletsChangeNotifierProvider.select(
              (value) =>
                  value.getManager(widget.walletId).wallet as FiroWallet?,
            ),
          )
          ?.balancePrivate;
      final showPrivate =
          ref.watch(walletPrivateBalanceToggleStateProvider.state).state ==
              WalletBalanceToggleState.available;

      if (_showAvailable) {
        balanceToShow =
            showPrivate ? balanceSecondary!.spendable : balance.spendable;
      } else {
        balanceToShow = showPrivate ? balanceSecondary!.total : balance.total;
      }
    } else {
      if (_showAvailable) {
        balanceToShow = balance.spendable;
      } else {
        balanceToShow = balance.total;
      }
    }

    return Consumer(
      builder: (context, ref, __) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    ref
                        .watch(pAmountFormatter(coin))
                        .format(balanceToShow, ethContract: tokenContract),
                    style: STextStyles.desktopH3(context),
                  ),
                ),
                if (externalCalls)
                  Text(
                    "${Amount.fromDecimal(
                      priceTuple.item1 * balanceToShow.decimal,
                      fractionDigits: 2,
                    ).fiatString(
                      locale: locale,
                    )} $baseCurrency",
                    style: STextStyles.desktopTextExtraSmall(context).copyWith(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .textSubtitle1,
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 8,
            ),
            WalletRefreshButton(
              walletId: walletId,
              initialSyncStatus: widget.initialSyncStatus,
            ),
            if (coin == Coin.firo || coin == Coin.firoTestNet)
              const SizedBox(
                width: 8,
              ),
            if (coin == Coin.firo || coin == Coin.firoTestNet)
              const DesktopPrivateBalanceToggleButton(),
            const SizedBox(
              width: 8,
            ),
            const DesktopBalanceToggleButton(),
          ],
        );
      },
    );
  }
}
