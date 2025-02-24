/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/providers/providers.dart';
import 'package:stackwallet/providers/wallet/public_private_balance_state_provider.dart';
import 'package:stackwallet/services/coins/firo/firo_wallet.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/amount/amount_formatter.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/text_styles.dart';

class FiroBalanceSelectionSheet extends ConsumerStatefulWidget {
  const FiroBalanceSelectionSheet({
    Key? key,
    required this.walletId,
  }) : super(key: key);

  final String walletId;

  @override
  ConsumerState<FiroBalanceSelectionSheet> createState() =>
      _FiroBalanceSelectionSheetState();
}

class _FiroBalanceSelectionSheetState
    extends ConsumerState<FiroBalanceSelectionSheet> {
  late final String walletId;

  final stringsToLoopThrough = [
    "Loading balance",
    "Loading balance.",
    "Loading balance..",
    "Loading balance...",
  ];

  @override
  void initState() {
    walletId = widget.walletId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");

    final manager = ref.watch(walletsChangeNotifierProvider
        .select((value) => value.getManager(walletId)));
    final firoWallet = manager.wallet as FiroWallet;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).extension<StackColors>()!.popupBG,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 10,
          bottom: 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .extension<StackColors>()!
                      .textFieldDefaultBG,
                  borderRadius: BorderRadius.circular(
                    Constants.size.circularBorderRadius,
                  ),
                ),
                width: 60,
                height: 4,
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select balance",
                  style: STextStyles.pageTitleH2(context),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    final state =
                        ref.read(publicPrivateBalanceStateProvider.state).state;
                    if (state != "Private") {
                      ref.read(publicPrivateBalanceStateProvider.state).state =
                          "Private";
                    }
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Radio(
                                activeColor: Theme.of(context)
                                    .extension<StackColors>()!
                                    .radioButtonIconEnabled,
                                value: "Private",
                                groupValue: ref
                                    .watch(
                                        publicPrivateBalanceStateProvider.state)
                                    .state,
                                onChanged: (x) {
                                  ref
                                      .read(publicPrivateBalanceStateProvider
                                          .state)
                                      .state = "Private";

                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row(
                              //   children: [
                              Text(
                                "Private balance",
                                style: STextStyles.titleBold12(context),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                ref
                                    .watch(pAmountFormatter(manager.coin))
                                    .format(
                                      firoWallet.availablePrivateBalance(),
                                    ),
                                style: STextStyles.itemSubtitle(context),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          //   ],
                          // ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    final state =
                        ref.read(publicPrivateBalanceStateProvider.state).state;
                    if (state != "Public") {
                      ref.read(publicPrivateBalanceStateProvider.state).state =
                          "Public";
                    }
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Radio(
                                activeColor: Theme.of(context)
                                    .extension<StackColors>()!
                                    .radioButtonIconEnabled,
                                value: "Public",
                                groupValue: ref
                                    .watch(
                                        publicPrivateBalanceStateProvider.state)
                                    .state,
                                onChanged: (x) {
                                  ref
                                      .read(publicPrivateBalanceStateProvider
                                          .state)
                                      .state = "Public";
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row(
                              //   children: [
                              Text(
                                "Public balance",
                                style: STextStyles.titleBold12(context),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                ref
                                    .watch(pAmountFormatter(manager.coin))
                                    .format(
                                      firoWallet.availablePublicBalance(),
                                    ),
                                style: STextStyles.itemSubtitle(context),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
