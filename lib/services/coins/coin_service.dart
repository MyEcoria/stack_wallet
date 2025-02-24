/*
 * This file is part of Stack Wallet.
 *
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:stackwallet/electrumx_rpc/cached_electrumx.dart';
import 'package:stackwallet/electrumx_rpc/electrumx.dart';
import 'package:stackwallet/models/balance.dart';
import 'package:stackwallet/models/isar/models/isar_models.dart' as isar_models;
import 'package:stackwallet/models/node_model.dart';
import 'package:stackwallet/models/paymint/fee_object_model.dart';
import 'package:stackwallet/services/coins/banano/banano_wallet.dart';
import 'package:stackwallet/services/coins/bitcoin/bitcoin_wallet.dart';
import 'package:stackwallet/services/coins/bitcoincash/bitcoincash_wallet.dart';
import 'package:stackwallet/services/coins/dogecoin/dogecoin_wallet.dart';
import 'package:stackwallet/services/coins/ecash/ecash_wallet.dart';
import 'package:stackwallet/services/coins/epiccash/epiccash_wallet.dart';
import 'package:stackwallet/services/coins/ethereum/ethereum_wallet.dart';
import 'package:stackwallet/services/coins/firo/firo_wallet.dart';
import 'package:stackwallet/services/coins/litecoin/litecoin_wallet.dart';
import 'package:stackwallet/services/coins/monero/monero_wallet.dart';
import 'package:stackwallet/services/coins/namecoin/namecoin_wallet.dart';
import 'package:stackwallet/services/coins/nano/nano_wallet.dart';
import 'package:stackwallet/services/coins/particl/particl_wallet.dart';
import 'package:stackwallet/services/coins/stellar/stellar_wallet.dart';
import 'package:stackwallet/services/coins/tezos/tezos_wallet.dart';
import 'package:stackwallet/services/coins/wownero/wownero_wallet.dart';
import 'package:stackwallet/services/transaction_notification_tracker.dart';
import 'package:stackwallet/utilities/amount/amount.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/flutter_secure_storage_interface.dart';
import 'package:stackwallet/utilities/prefs.dart';

/*
 * This file implements the CoinServiceAPI abstract class that is used by wallet files to implement the coin specific functionality.
 * @param coin: The coin type
 * @param walletId: The wallet id
 * @param walletName: The wallet name
 * @param secureStorageInterface: The interface for securely storing data like private keys, mnemonics, passphrases, etc.
 * @param node: The node to connect to
 * @param tracker: The transaction notification tracker
 * @param prefs: The preferences
 * @return: The coin service API
 */

abstract class CoinServiceAPI {
  CoinServiceAPI();

  factory CoinServiceAPI.from(
    Coin coin,
    String walletId,
    String walletName,
    SecureStorageInterface secureStorageInterface,
    NodeModel node,
    TransactionNotificationTracker tracker,
    Prefs prefs,
    List<NodeModel> failovers,
  ) {
    final electrumxNode = ElectrumXNode(
      address: node.host,
      port: node.port,
      name: node.name,
      id: node.id,
      useSSL: node.useSSL,
    );
    final client = ElectrumX.from(
      node: electrumxNode,
      failovers: failovers
          .map((e) => ElectrumXNode(
                address: e.host,
                port: e.port,
                name: e.name,
                id: e.id,
                useSSL: e.useSSL,
              ))
          .toList(),
      prefs: prefs,
    );
    final cachedClient = CachedElectrumX.from(
      electrumXClient: client,
    );
    switch (coin) {
      case Coin.firo:
        return FiroWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStore: secureStorageInterface,
          client: client,
          cachedClient: cachedClient,
          tracker: tracker,
        );
      case Coin.firoTestNet:
        return FiroWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStore: secureStorageInterface,
          client: client,
          cachedClient: cachedClient,
          tracker: tracker,
        );

      case Coin.bitcoin:
        return BitcoinWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStore: secureStorageInterface,
          client: client,
          cachedClient: cachedClient,
          tracker: tracker,
        );

      case Coin.litecoin:
        return LitecoinWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStore: secureStorageInterface,
          client: client,
          cachedClient: cachedClient,
          tracker: tracker,
        );

      case Coin.litecoinTestNet:
        return LitecoinWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStore: secureStorageInterface,
          client: client,
          cachedClient: cachedClient,
          tracker: tracker,
        );

      case Coin.bitcoinTestNet:
        return BitcoinWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStore: secureStorageInterface,
          client: client,
          cachedClient: cachedClient,
          tracker: tracker,
        );

      case Coin.bitcoincash:
        return BitcoinCashWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStore: secureStorageInterface,
          client: client,
          cachedClient: cachedClient,
          tracker: tracker,
        );

      case Coin.bitcoincashTestnet:
        return BitcoinCashWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStore: secureStorageInterface,
          client: client,
          cachedClient: cachedClient,
          tracker: tracker,
        );

      case Coin.dogecoin:
        return DogecoinWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStore: secureStorageInterface,
          client: client,
          cachedClient: cachedClient,
          tracker: tracker,
        );

      case Coin.epicCash:
        return EpicCashWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStore: secureStorageInterface,
          // tracker: tracker,
        );

      case Coin.ethereum:
        return EthereumWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStore: secureStorageInterface,
          tracker: tracker,
        );

      case Coin.monero:
        return MoneroWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStorage: secureStorageInterface,
          // tracker: tracker,
        );

      case Coin.particl:
        return ParticlWallet(
            walletId: walletId,
            walletName: walletName,
            coin: coin,
            secureStore: secureStorageInterface,
            client: client,
            cachedClient: cachedClient,
            tracker: tracker);

      case Coin.stellar:
        return StellarWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStore: secureStorageInterface,
          tracker: tracker,
        );

      case Coin.stellarTestnet:
        return StellarWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStore: secureStorageInterface,
          tracker: tracker,
        );

      case Coin.tezos:
        return TezosWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStore: secureStorageInterface,
          tracker: tracker,
        );

      case Coin.wownero:
        return WowneroWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStorage: secureStorageInterface,
          // tracker: tracker,
        );

      case Coin.namecoin:
        return NamecoinWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStore: secureStorageInterface,
          tracker: tracker,
          cachedClient: cachedClient,
          client: client,
        );

      case Coin.nano:
        return NanoWallet(
            walletId: walletId,
            walletName: walletName,
            coin: coin,
            tracker: tracker,
            secureStore: secureStorageInterface);

      case Coin.banano:
        return BananoWallet(
            walletId: walletId,
            walletName: walletName,
            coin: coin,
            tracker: tracker,
            secureStore: secureStorageInterface);

      case Coin.dogecoinTestNet:
        return DogecoinWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStore: secureStorageInterface,
          client: client,
          cachedClient: cachedClient,
          tracker: tracker,
        );

      case Coin.eCash:
        return ECashWallet(
          walletId: walletId,
          walletName: walletName,
          coin: coin,
          secureStore: secureStorageInterface,
          client: client,
          cachedClient: cachedClient,
          tracker: tracker,
        );
    }
  }

  Coin get coin;
  bool get isRefreshing;
  bool get shouldAutoSync;
  set shouldAutoSync(bool shouldAutoSync);
  bool get isFavorite;
  set isFavorite(bool markFavorite);

  Future<Map<String, dynamic>> prepareSend({
    required String address,
    required Amount amount,
    Map<String, dynamic>? args,
  });

  Future<String> confirmSend({required Map<String, dynamic> txData});

  Future<FeeObject> get fees;
  Future<int> get maxFee;

  Future<String> get currentReceivingAddress;

  Balance get balance;

  Future<List<isar_models.Transaction>> get transactions;
  Future<List<isar_models.UTXO>> get utxos;

  Future<void> refresh();

  Future<void> updateNode(bool shouldRefresh);

  // setter for updating on rename
  set walletName(String newName);

  String get walletName;
  String get walletId;

  bool validateAddress(String address);

  Future<List<String>> get mnemonic;
  Future<String?> get mnemonicString;
  Future<String?> get mnemonicPassphrase;

  Future<bool> testNetworkConnection();

  Future<void> recoverFromMnemonic({
    required String mnemonic,
    String? mnemonicPassphrase,
    required int maxUnusedAddressGap,
    required int maxNumberOfIndexesToCheck,
    required int height,
  });

  Future<void> initializeNew(
    ({String mnemonicPassphrase, int wordCount})? data,
  );
  Future<void> initializeExisting();

  Future<void> exit();
  bool get hasCalledExit;

  Future<void> fullRescan(
      int maxUnusedAddressGap, int maxNumberOfIndexesToCheck);

  void Function(bool isActive)? onIsActiveWalletChanged;

  bool get isConnected;

  Future<Amount> estimateFeeFor(Amount amount, int feeRate);

  Future<bool> generateNewAddress();

  // used for electrumx coins
  Future<void> updateSentCachedTxData(Map<String, dynamic> txData);

  int get storedChainHeight;

  // Certain outputs return address as an array/list of strings like List<String> ["addresses"][0], some return it as a string like String ["address"]
  String? getAddress(dynamic output) {
    // Julian's code from https://github.com/cypherstack/stack_wallet/blob/35a8172d35f1b5cdbd22f0d56c4db02f795fd032/lib/services/coins/coin_paynym_extension.dart#L170 wins codegolf for this, I'd love to commit it now but need to retest this section ... should make unit tests for this case
    // final String? address = output["scriptPubKey"]?["addresses"]?[0] as String? ?? output["scriptPubKey"]?["address"] as String?;
    String? address;
    if (output.containsKey('scriptPubKey') as bool) {
      // Make sure the key exists before using it
      if (output["scriptPubKey"].containsKey('address') as bool) {
        address = output["scriptPubKey"]["address"] as String?;
      } else if (output["scriptPubKey"].containsKey('addresses') as bool) {
        address = output["scriptPubKey"]["addresses"][0] as String?;
        // TODO determine cases in which there are multiple addresses in the array
      }
    } /*else {
      // TODO detect cases in which no scriptPubKey exists
      Logging.instance.log("output type not detected; output: ${output}",
          level: LogLevel.Info);
    }*/

    return address;
  }

  // Firo wants an array/list of address strings like List<String>
  List? getAddresses(dynamic output) {
    // Inspired by Julian's code as referenced above, need to test before committing
    // final List? addresses = output["scriptPubKey"]?["addresses"] as List? ?? [output["scriptPubKey"]?["address"]] as List?;
    List? addresses;
    if (output.containsKey('scriptPubKey') as bool) {
      if (output["scriptPubKey"].containsKey('addresses') as bool) {
        addresses = output["scriptPubKey"]["addresses"] as List?;
      } else if (output["scriptPubKey"].containsKey('address') as bool) {
        addresses = [output["scriptPubKey"]["address"]];
      }
    } /*else {
      // TODO detect cases in which no scriptPubKey exists
      Logging.instance.log("output type not detected; output: ${output}",
          level: LogLevel.Info);
    }*/

    return addresses;
  }
}
