import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/db/isar/main_db.dart';
import 'package:stackwallet/models/isar/models/ethereum/eth_contract.dart';
import 'package:stackwallet/providers/providers.dart';
import 'package:stackwallet/services/coins/ethereum/ethereum_wallet.dart';
import 'package:stackwallet/services/coins/firo/firo_wallet.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/amount/amount.dart';
import 'package:stackwallet/utilities/amount/amount_formatter.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/util.dart';

class WalletInfoRowBalance extends ConsumerWidget {
  const WalletInfoRowBalance({
    Key? key,
    required this.walletId,
    this.contractAddress,
  }) : super(key: key);

  final String walletId;
  final String? contractAddress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.watch(ref
        .watch(walletsChangeNotifierProvider.notifier)
        .getManagerProvider(walletId));

    Amount totalBalance;
    EthContract? contract;
    if (contractAddress == null) {
      totalBalance = manager.balance.total;
      if (manager.coin == Coin.firo || manager.coin == Coin.firoTestNet) {
        totalBalance =
            totalBalance + (manager.wallet as FiroWallet).balancePrivate.total;
      }
      contract = null;
    } else {
      final ethWallet = manager.wallet as EthereumWallet;
      contract = MainDB.instance.getEthContractSync(contractAddress!)!;
      totalBalance = ethWallet.getCachedTokenBalance(contract).total;
    }

    return Text(
      ref
          .watch(pAmountFormatter(manager.coin))
          .format(totalBalance, ethContract: contract),
      style: Util.isDesktop
          ? STextStyles.desktopTextExtraSmall(context).copyWith(
              color: Theme.of(context).extension<StackColors>()!.textSubtitle1,
            )
          : STextStyles.itemSubtitle(context),
    );
  }
}
