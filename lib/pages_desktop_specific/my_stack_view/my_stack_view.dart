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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stackwallet/pages/settings_views/global_settings_view/hidden_settings.dart';
import 'package:stackwallet/pages/wallets_view/sub_widgets/empty_wallets.dart';
import 'package:stackwallet/pages_desktop_specific/my_stack_view/my_wallets.dart';
import 'package:stackwallet/providers/global/wallets_provider.dart';
import 'package:stackwallet/themes/theme_providers.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/widgets/animated_widgets/rotate_icon.dart';
import 'package:stackwallet/widgets/background.dart';
import 'package:stackwallet/widgets/desktop/desktop_app_bar.dart';

class MyStackView extends ConsumerStatefulWidget {
  const MyStackView({Key? key}) : super(key: key);

  static const String routeName = "/myStackDesktop";

  @override
  ConsumerState<MyStackView> createState() => _MyStackViewState();
}

class _MyStackViewState extends ConsumerState<MyStackView> {
  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");
    final hasWallets = ref.watch(walletsChangeNotifierProvider).hasWallets;

    return Background(
      child: Column(
        children: [
          const DesktopAppBar(
            isCompactHeight: true,
            leading: DesktopMyStackTitle(),
          ),
          Expanded(
            child: hasWallets ? const MyWallets() : const EmptyWallets(),
          ),
        ],
      ),
    );
  }
}

class DesktopMyStackTitle extends ConsumerStatefulWidget {
  const DesktopMyStackTitle({super.key});

  @override
  ConsumerState<DesktopMyStackTitle> createState() =>
      _DesktopMyStackTitleState();
}

class _DesktopMyStackTitleState extends ConsumerState<DesktopMyStackTitle> {
  late final RotateIconController _rotateIconController;

  DateTime _hiddenTime = DateTime.now();
  int _hiddenCount = 0;

  void _hiddenOptions() {
    _rotateIconController.reset?.call();
    _rotateIconController.forward?.call();
    if (_hiddenCount == 5) {
      Navigator.of(context).pushNamed(HiddenSettings.routeName);
    }
    final now = DateTime.now();
    const timeout = Duration(seconds: 1);
    if (now.difference(_hiddenTime) < timeout) {
      _hiddenCount++;
    } else {
      _hiddenCount = 0;
    }
    _hiddenTime = now;
  }

  @override
  void initState() {
    _rotateIconController = RotateIconController();

    super.initState();
  }

  @override
  dispose() {
    _rotateIconController.forward = null;
    _rotateIconController.reverse = null;
    _rotateIconController.reset = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 24,
        ),
        GestureDetector(
          onTap: _hiddenOptions,
          child: RotateIcon(
            icon: SizedBox(
              width: 32,
              height: 32,
              child: SvgPicture.file(
                File(
                  ref.watch(
                    themeProvider.select(
                      (value) => value.assets.stackIcon,
                    ),
                  ),
                ),
              ),
            ),
            curve: Curves.easeInOutCubic,
            rotationPercent: 1.0,
            controller: _rotateIconController,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Text(
          "My Stack",
          style: STextStyles.desktopH3(context),
        )
      ],
    );
  }
}
