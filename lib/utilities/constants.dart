/*
 * This file is part of Stack Wallet.
 *
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:io';

import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/util.dart';

class _LayoutSizing {
  const _LayoutSizing();

  double get circularBorderRadius => 8.0;
  double get checkboxBorderRadius => 4.0;

  double get standardPadding => 16.0;
}

abstract class Constants {
  static const size = _LayoutSizing();

  static void exchangeForExperiencedUsers(int count) {
    enableExchange =
        Util.isDesktop || Platform.isAndroid || count > 5 || !Platform.isIOS;
  }

  static bool enableExchange = Util.isDesktop || !Platform.isIOS;
  // just use enable exchange flag
  // static bool enableBuy = enableExchange;
  // // true; // true for development,
  static final BigInt _satsPerCoinECash = BigInt.from(100);
  static final BigInt _satsPerCoinEthereum = BigInt.from(1000000000000000000);
  static final BigInt _satsPerCoinMonero = BigInt.from(1000000000000);
  static final BigInt _satsPerCoinWownero = BigInt.from(100000000000);
  static final BigInt _satsPerCoinNano =
      BigInt.parse("1000000000000000000000000000000"); // 1*10^30
  static final BigInt _satsPerCoinBanano =
      BigInt.parse("100000000000000000000000000000"); // 1*10^29
  static final BigInt _satsPerCoinStellar = BigInt.from(
      10000000); // https://developers.stellar.org/docs/fundamentals-and-concepts/stellar-data-structures/assets#amount-precision
  static final BigInt _satsPerCoin = BigInt.from(100000000);
  static final BigInt _satsPerCoinTezos = BigInt.from(1000000);
  static const int _decimalPlaces = 8;
  static const int _decimalPlacesNano = 30;
  static const int _decimalPlacesBanano = 29;
  static const int _decimalPlacesWownero = 11;
  static const int _decimalPlacesMonero = 12;
  static const int _decimalPlacesEthereum = 18;
  static const int _decimalPlacesECash = 2;
  static const int _decimalPlacesStellar = 7;
  static const int _decimalPlacesTezos = 6;

  static const int notificationsMax = 0xFFFFFFFF;
  static const Duration networkAliveTimerDuration = Duration(seconds: 10);

  // Enable Logger.print statements
  static const bool disableLogger = false;

  static const int currentDataVersion = 11;

  static const int rescanV1 = 1;

  static BigInt satsPerCoin(Coin coin) {
    switch (coin) {
      case Coin.bitcoin:
      case Coin.litecoin:
      case Coin.litecoinTestNet:
      case Coin.bitcoincash:
      case Coin.bitcoincashTestnet:
      case Coin.dogecoin:
      case Coin.firo:
      case Coin.bitcoinTestNet:
      case Coin.dogecoinTestNet:
      case Coin.firoTestNet:
      case Coin.epicCash:
      case Coin.namecoin:
      case Coin.particl:
        return _satsPerCoin;

      case Coin.nano:
        return _satsPerCoinNano;

      case Coin.banano:
        return _satsPerCoinBanano;

      case Coin.wownero:
        return _satsPerCoinWownero;

      case Coin.monero:
        return _satsPerCoinMonero;

      case Coin.ethereum:
        return _satsPerCoinEthereum;

      case Coin.eCash:
        return _satsPerCoinECash;

      case Coin.stellar:
      case Coin.stellarTestnet:
        return _satsPerCoinStellar;

      case Coin.tezos:
        return _satsPerCoinTezos;
    }
  }

  static int decimalPlacesForCoin(Coin coin) {
    switch (coin) {
      case Coin.bitcoin:
      case Coin.litecoin:
      case Coin.litecoinTestNet:
      case Coin.bitcoincash:
      case Coin.bitcoincashTestnet:
      case Coin.dogecoin:
      case Coin.firo:
      case Coin.bitcoinTestNet:
      case Coin.dogecoinTestNet:
      case Coin.firoTestNet:
      case Coin.epicCash:
      case Coin.namecoin:
      case Coin.particl:
        return _decimalPlaces;

      case Coin.nano:
        return _decimalPlacesNano;

      case Coin.banano:
        return _decimalPlacesBanano;

      case Coin.wownero:
        return _decimalPlacesWownero;

      case Coin.monero:
        return _decimalPlacesMonero;

      case Coin.ethereum:
        return _decimalPlacesEthereum;

      case Coin.eCash:
        return _decimalPlacesECash;

      case Coin.stellar:
      case Coin.stellarTestnet:
        return _decimalPlacesStellar;

      case Coin.tezos:
        return _decimalPlacesTezos;
    }
  }

  static List<int> possibleLengthsForCoin(Coin coin) {
    final List<int> values = [];
    switch (coin) {
      case Coin.bitcoin:
      case Coin.litecoin:
      case Coin.litecoinTestNet:
      case Coin.bitcoincash:
      case Coin.bitcoincashTestnet:
      case Coin.dogecoin:
      case Coin.firo:
      case Coin.bitcoinTestNet:
      case Coin.dogecoinTestNet:
      case Coin.firoTestNet:
      case Coin.eCash:
      case Coin.epicCash:
      case Coin.ethereum:
      case Coin.namecoin:
      case Coin.particl:
      case Coin.nano:
      case Coin.stellar:
      case Coin.stellarTestnet:
        values.addAll([24, 12]);
        break;
      case Coin.banano:
        values.addAll([24, 12]);
        break;
      case Coin.tezos:
        values.addAll([24, 12]);

      case Coin.monero:
        values.addAll([25]);
        break;
      case Coin.wownero:
        values.addAll([14, 25]);
        break;
    }
    return values;
  }

  static int targetBlockTimeInSeconds(Coin coin) {
    // TODO verify values
    switch (coin) {
      case Coin.bitcoin:
      case Coin.bitcoinTestNet:
      case Coin.bitcoincash:
      case Coin.bitcoincashTestnet:
      case Coin.eCash:
        return 600;

      case Coin.dogecoin:
      case Coin.dogecoinTestNet:
        return 60;

      case Coin.litecoin:
      case Coin.litecoinTestNet:
        return 150;

      case Coin.firo:
      case Coin.firoTestNet:
        return 150;

      case Coin.epicCash:
        return 60;

      case Coin.ethereum:
        return 15;

      case Coin.monero:
        return 120;

      case Coin.wownero:
        return 120;

      case Coin.namecoin:
        return 600;

      case Coin.particl:
        return 600;

      case Coin.nano: // TODO: Verify this
      case Coin.banano: // TODO: Verify this
        return 1;

      case Coin.stellar:
      case Coin.stellarTestnet:
        return 5;

      case Coin.tezos:
        return 60;
    }
  }

  static int defaultSeedPhraseLengthFor({required Coin coin}) {
    switch (coin) {
      case Coin.bitcoin:
      case Coin.bitcoinTestNet:
      case Coin.bitcoincash:
      case Coin.bitcoincashTestnet:
      case Coin.eCash:
      case Coin.dogecoin:
      case Coin.dogecoinTestNet:
      case Coin.litecoin:
      case Coin.litecoinTestNet:
      case Coin.firo:
      case Coin.firoTestNet:
      case Coin.epicCash:
      case Coin.namecoin:
      case Coin.particl:
      case Coin.ethereum:
        return 12;

      case Coin.wownero:
        return 14;

      case Coin.nano:
      case Coin.banano:
      case Coin.stellar:
      case Coin.stellarTestnet:
      case Coin.tezos:
        return 24;

      case Coin.monero:
        return 25;
    }
  }

  static const Map<int, String> monthMapShort = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec',
  };

  static const Map<int, String> monthMap = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };
}
