/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:async';
import 'dart:typed_data';

import 'package:bitbox/bitbox.dart' as bb;
import 'package:bitcoindart/bitcoindart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stackwallet/db/hive/db.dart';
import 'package:stackwallet/electrumx_rpc/cached_electrumx.dart';
import 'package:stackwallet/electrumx_rpc/electrumx.dart';
import 'package:stackwallet/notifications/show_flush_bar.dart';
import 'package:stackwallet/providers/global/debug_service_provider.dart';
import 'package:stackwallet/providers/providers.dart';
import 'package:stackwallet/services/coins/bitcoincash/bitcoincash_wallet.dart';
import 'package:stackwallet/services/mixins/electrum_x_parsing.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/address_utils.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/widgets/background.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/onetime_popups/tor_has_been_add_dialog.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';

class HiddenSettings extends StatelessWidget {
  const HiddenSettings({Key? key}) : super(key: key);

  static const String routeName = "/hiddenSettings";

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Theme.of(context).extension<StackColors>()!.background,
        appBar: AppBar(
          leading: Util.isDesktop
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppBarIconButton(
                    size: 32,
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .textFieldDefaultBG,
                    shadows: const [],
                    icon: SvgPicture.asset(
                      Assets.svg.arrowLeft,
                      width: 18,
                      height: 18,
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .topNavIconPrimary,
                    ),
                    onPressed: Navigator.of(context).pop,
                  ),
                )
              : Container(),
          title: Text(
            "Dev options",
            style: STextStyles.navBarTitle(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Consumer(builder: (_, ref, __) {
                          return GestureDetector(
                            onTap: () async {
                              final notifs =
                                  ref.read(notificationsProvider).notifications;

                              for (final n in notifs) {
                                await ref
                                    .read(notificationsProvider)
                                    .delete(n, false);
                              }
                              await ref
                                  .read(notificationsProvider)
                                  .delete(notifs[0], true);

                              if (context.mounted) {
                                unawaited(
                                  showFloatingFlushBar(
                                    type: FlushBarType.success,
                                    message: "Notification history deleted",
                                    context: context,
                                  ),
                                );
                              }
                            },
                            child: RoundedWhiteContainer(
                              child: Text(
                                "Delete notifications",
                                style: STextStyles.button(context).copyWith(
                                    color: Theme.of(context)
                                        .extension<StackColors>()!
                                        .accentColorDark),
                              ),
                            ),
                          );
                        }),
                        // const SizedBox(
                        //   height: 12,
                        // ),
                        // Consumer(builder: (_, ref, __) {
                        //   return GestureDetector(
                        //     onTap: () async {
                        //       final trades =
                        //           ref.read(tradesServiceProvider).trades;
                        //
                        //       for (final trade in trades) {
                        //         ref.read(tradesServiceProvider).delete(
                        //             trade: trade, shouldNotifyListeners: false);
                        //       }
                        //       ref.read(tradesServiceProvider).delete(
                        //           trade: trades[0], shouldNotifyListeners: true);
                        //
                        //       // ref.read(notificationsProvider).DELETE_EVERYTHING();
                        //     },
                        //     child: RoundedWhiteContainer(
                        //       child: Text(
                        //         "Delete trade history",
                        //         style: STextStyles.button(context).copyWith(
                        //           color: Theme.of(context).extension<StackColors>()!.accentColorDark
                        //         ),
                        //       ),
                        //     ),
                        //   );
                        // }),
                        const SizedBox(
                          height: 12,
                        ),
                        Consumer(builder: (_, ref, __) {
                          return GestureDetector(
                            onTap: () async {
                              await ref
                                  .read(debugServiceProvider)
                                  .deleteAllLogs();

                              if (context.mounted) {
                                unawaited(
                                  showFloatingFlushBar(
                                    type: FlushBarType.success,
                                    message: "Debug Logs deleted",
                                    context: context,
                                  ),
                                );
                              }
                            },
                            child: RoundedWhiteContainer(
                              child: Text(
                                "Delete Debug Logs",
                                style: STextStyles.button(context).copyWith(
                                    color: Theme.of(context)
                                        .extension<StackColors>()!
                                        .accentColorDark),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(
                          height: 12,
                        ),
                        Consumer(builder: (_, ref, __) {
                          return GestureDetector(
                            onTap: () async {
                              await showOneTimeTorHasBeenAddedDialogIfRequired(
                                context,
                              );
                            },
                            child: RoundedWhiteContainer(
                              child: Text(
                                "Test tor stacy popup",
                                style: STextStyles.button(context).copyWith(
                                    color: Theme.of(context)
                                        .extension<StackColors>()!
                                        .accentColorDark),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(
                          height: 12,
                        ),
                        Consumer(builder: (_, ref, __) {
                          return GestureDetector(
                            onTap: () async {
                              final box = await Hive.openBox<bool>(
                                  DB.boxNameOneTimeDialogsShown);
                              await box.clear();
                            },
                            child: RoundedWhiteContainer(
                              child: Text(
                                "Reset tor stacy popup",
                                style: STextStyles.button(context).copyWith(
                                    color: Theme.of(context)
                                        .extension<StackColors>()!
                                        .accentColorDark),
                              ),
                            ),
                          );
                        }),
                        // const SizedBox(
                        //   height: 12,
                        // ),
                        // Consumer(builder: (_, ref, __) {
                        //   return GestureDetector(
                        //     onTap: () async {
                        //       final x =
                        //           await MajesticBankAPI.instance.getRates();
                        //       print(x);
                        //     },
                        //     child: RoundedWhiteContainer(
                        //       child: Text(
                        //         "Click me",
                        //         style: STextStyles.button(context).copyWith(
                        //             color: Theme.of(context)
                        //                 .extension<StackColors>()!
                        //                 .accentColorDark),
                        //       ),
                        //     ),
                        //   );
                        // }),
                        // const SizedBox(
                        //   height: 12,
                        // ),
                        // Consumer(builder: (_, ref, __) {
                        //   return GestureDetector(
                        //     onTap: () async {
                        //       ref
                        //           .read(priceAnd24hChangeNotifierProvider)
                        //           .tokenContractAddressesToCheck
                        //           .add(
                        //               "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48");
                        //       ref
                        //           .read(priceAnd24hChangeNotifierProvider)
                        //           .tokenContractAddressesToCheck
                        //           .add(
                        //               "0xdAC17F958D2ee523a2206206994597C13D831ec7");
                        //       await ref
                        //           .read(priceAnd24hChangeNotifierProvider)
                        //           .updatePrice();
                        //
                        //       final x = ref
                        //           .read(priceAnd24hChangeNotifierProvider)
                        //           .getTokenPrice(
                        //               "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48");
                        //
                        //       print(
                        //           "PRICE 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48: $x");
                        //     },
                        //     child: RoundedWhiteContainer(
                        //       child: Text(
                        //         "Click me",
                        //         style: STextStyles.button(context).copyWith(
                        //             color: Theme.of(context)
                        //                 .extension<StackColors>()!
                        //                 .accentColorDark),
                        //       ),
                        //     ),
                        //   );
                        // }),
                        // const SizedBox(
                        //   height: 12,
                        // ),
                        // Consumer(builder: (_, ref, __) {
                        //   return GestureDetector(
                        //     onTap: () async {
                        //       // final erc20 = Erc20ContractInfo(
                        //       //   contractAddress: 'some con',
                        //       //   name: "loonamsn",
                        //       //   symbol: "DD",
                        //       //   decimals: 19,
                        //       // );
                        //       //
                        //       // final json = erc20.toJson();
                        //       //
                        //       // print(json);
                        //       //
                        //       // final ee = EthContractInfo.fromJson(json);
                        //       //
                        //       // print(ee);
                        //     },
                        //     child: RoundedWhiteContainer(
                        //       child: Text(
                        //         "Click me",
                        //         style: STextStyles.button(context).copyWith(
                        //             color: Theme.of(context)
                        //                 .extension<StackColors>()!
                        //                 .accentColorDark),
                        //       ),
                        //     ),
                        //   );
                        // }),
                        const SizedBox(
                          height: 12,
                        ),
                        Consumer(
                          builder: (_, ref, __) {
                            if (ref.watch(prefsChangeNotifierProvider
                                    .select((value) => value.familiarity)) <
                                6) {
                              return GestureDetector(
                                onTap: () async {
                                  final familiarity = ref
                                      .read(prefsChangeNotifierProvider)
                                      .familiarity;
                                  if (familiarity < 6) {
                                    ref
                                        .read(prefsChangeNotifierProvider)
                                        .familiarity = 6;

                                    Constants.exchangeForExperiencedUsers(6);
                                  }
                                },
                                child: RoundedWhiteContainer(
                                  child: Text(
                                    "Enable exchange",
                                    style: STextStyles.button(context).copyWith(
                                        color: Theme.of(context)
                                            .extension<StackColors>()!
                                            .accentColorDark),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Consumer(
                          builder: (_, ref, __) {
                            return GestureDetector(
                              onTap: () async {
                                try {
                                  final p = TT();

                                  final n = ref
                                      .read(nodeServiceChangeNotifierProvider)
                                      .getPrimaryNodeFor(
                                          coin: Coin.bitcoincash)!;

                                  final e = ElectrumX.from(
                                    node: ElectrumXNode(
                                      address: n.host,
                                      port: n.port,
                                      name: n.name,
                                      id: n.id,
                                      useSSL: n.useSSL,
                                    ),
                                    prefs:
                                        ref.read(prefsChangeNotifierProvider),
                                    failovers: [],
                                  );

                                  final ce =
                                      CachedElectrumX(electrumXClient: e);

                                  final txids = [
                                    "", //  cashTokenTxid
                                    "6a0444358bc41913c5b04a8dc06896053184b3641bc62502d18f954865b6ce1e", // normalTxid
                                    "67f13c375f9be897036cac77b7900dc74312c4ba6fe22f419f5cb21d4151678c", // fusionTxid
                                    "c0ac3f88b238a023d2a87226dc90c3b0f9abc3eeb227e2730087b0b95ee5b3f9", // slpTokenSendTxid
                                    "7a427a156fe70f83d3ccdd17e75804cc0df8c95c64ce04d256b3851385002a0b", // slpTokenGenesisTxid
                                  ];

                                  // final json =
                                  //     await e.getTransaction(txHash: txids[1]);
                                  // await p.parseBchTx(json, "NORMAL TXID:");
                                  //
                                  // final json2 =
                                  //     await e.getTransaction(txHash: txids[2]);
                                  // await p.parseBchTx(json2, "FUSION TXID:");
                                  //
                                  // // print("CASH TOKEN TXID:");
                                  // // final json3 =
                                  // //     await e.getTransaction(txHash: txids[2]);
                                  // // await p.parseBchTx(json3);
                                  //
                                  await p.getTransaction(
                                      txids[3],
                                      Coin.bitcoincash,
                                      "lol",
                                      ce,
                                      "SLP TOKEN SEND TXID:");
                                  await p.getTransaction(
                                      "009d31380d2dbfb5c91500c861d55b531a8b762b0abb19353db884548dbac8b6",
                                      Coin.bitcoincash,
                                      "lol",
                                      ce,
                                      "COINBASE TXID:");

                                  // final json5 =
                                  //     await e.getTransaction(txHash: txids[4]);
                                  // await p.parseBchTx(
                                  //     json5, "SLP TOKEN GENESIS TXID:");
                                } catch (e, s) {
                                  print("$e\n$s");
                                }
                              },
                              child: RoundedWhiteContainer(
                                child: Text(
                                  "Parse BCH tx test",
                                  style: STextStyles.button(context).copyWith(
                                      color: Theme.of(context)
                                          .extension<StackColors>()!
                                          .accentColorDark),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Consumer(
                          builder: (_, ref, __) {
                            return GestureDetector(
                              onTap: () async {
                                try {
                                  final p = TT();

                                  final n = ref
                                      .read(nodeServiceChangeNotifierProvider)
                                      .getPrimaryNodeFor(
                                          coin: Coin.bitcoincash)!;

                                  final e = ElectrumX.from(
                                    node: ElectrumXNode(
                                      address: n.host,
                                      port: n.port,
                                      name: n.name,
                                      id: n.id,
                                      useSSL: n.useSSL,
                                    ),
                                    prefs:
                                        ref.read(prefsChangeNotifierProvider),
                                    failovers: [],
                                  );

                                  final address =
                                      "qzmd5vxgh9m22m6fgvm57yd6kjnjl9qnwyztz2p80d";

                                  List<int> _base32Decode(String string) {
                                    final data = Uint8List(string.length);
                                    for (int i = 0; i < string.length; i++) {
                                      final value = string[i];
                                      if (!_CHARSET_INVERSE_INDEX
                                          .containsKey(value))
                                        throw FormatException(
                                            "Invalid character '$value'");
                                      data[i] =
                                          _CHARSET_INVERSE_INDEX[string[i]]!;
                                    }

                                    return data.sublist(1);
                                  }

                                  final dec = _base32Decode(address);

                                  final pd = PaymentData(
                                      pubkey: Uint8List.fromList(dec));

                                  final p2pkh =
                                      P2PKH(data: pd, network: bitcoincash);

                                  // final addr = p2pkh.data.address!;

                                  final addr = bb.Address.toLegacyAddress(
                                    "bitcoincash:qp352c2skpdxwzzd090mec3v37au5dmfwgwfw686sz",
                                  );

                                  final scripthash =
                                      AddressUtils.convertToScriptHash(
                                          addr, bitcoincash);

                                  final utxos =
                                      await e.getUTXOs(scripthash: scripthash);

                                  Util.printJson(utxos, "UTXOS for $address");

                                  final hist = await e.getTransaction(
                                    txHash: utxos.first["tx_hash"] as String,
                                  );

                                  Util.printJson(hist, "HISTORY for $address");
                                } catch (e, s) {
                                  print("$e\n$s");
                                }
                              },
                              child: RoundedWhiteContainer(
                                child: Text(
                                  "UTXOs",
                                  style: STextStyles.button(context).copyWith(
                                      color: Theme.of(context)
                                          .extension<StackColors>()!
                                          .accentColorDark),
                                ),
                              ),
                            );
                          },
                        ),
                        // const SizedBox(
                        //   height: 12,
                        // ),
                        // GestureDetector(
                        //   onTap: () async {
                        //     showDialog<void>(
                        //       context: context,
                        //       builder: (_) {
                        //         return StackDialogBase(
                        //           child: SizedBox(
                        //             width: 300,
                        //             child: Lottie.asset(
                        //               Assets.lottie.plain(Coin.bitcoincash),
                        //             ),
                        //           ),
                        //         );
                        //       },
                        //     );
                        //   },
                        //   child: RoundedWhiteContainer(
                        //     child: Text(
                        //       "Lottie test",
                        //       style: STextStyles.button(context).copyWith(
                        //           color: Theme.of(context)
                        //               .extension<StackColors>()!
                        //               .accentColorDark),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

const _CHARSET_INVERSE_INDEX = {
  'q': 0,
  'p': 1,
  'z': 2,
  'r': 3,
  'y': 4,
  '9': 5,
  'x': 6,
  '8': 7,
  'g': 8,
  'f': 9,
  '2': 10,
  't': 11,
  'v': 12,
  'd': 13,
  'w': 14,
  '0': 15,
  's': 16,
  '3': 17,
  'j': 18,
  'n': 19,
  '5': 20,
  '4': 21,
  'k': 22,
  'h': 23,
  'c': 24,
  'e': 25,
  '6': 26,
  'm': 27,
  'u': 28,
  'a': 29,
  '7': 30,
  'l': 31,
};
