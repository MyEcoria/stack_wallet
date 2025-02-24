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
import 'package:flutter_svg/svg.dart';
import 'package:stackwallet/pages/ordinals/widgets/ordinals_list.dart';
import 'package:stackwallet/providers/global/wallets_provider.dart';
import 'package:stackwallet/services/mixins/ordinals_interface.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/show_loading.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/widgets/background.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';

class OrdinalsView extends ConsumerStatefulWidget {
  const OrdinalsView({
    super.key,
    required this.walletId,
  });

  static const routeName = "/ordinalsView";

  final String walletId;

  @override
  ConsumerState<OrdinalsView> createState() => _OrdinalsViewState();
}

class _OrdinalsViewState extends ConsumerState<OrdinalsView> {
  late final TextEditingController searchController;
  late final FocusNode searchFocus;

  String _searchTerm = "";

  @override
  void initState() {
    searchController = TextEditingController();
    searchFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SafeArea(
        child: Scaffold(
          backgroundColor:
              Theme.of(context).extension<StackColors>()!.background,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: const AppBarBackButton(),
            title: Text(
              "Ordinals",
              style: STextStyles.navBarTitle(context),
            ),
            titleSpacing: 0,
            actions: [
              AspectRatio(
                aspectRatio: 1,
                child: AppBarIconButton(
                  size: 36,
                  icon: SvgPicture.asset(
                    Assets.svg.arrowRotate,
                    width: 20,
                    height: 20,
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .topNavIconPrimary,
                  ),
                  onPressed: () async {
                    // show loading for a minimum of 2 seconds on refreshing
                    await showLoading(
                      whileFuture: Future.wait<void>([
                        Future.delayed(const Duration(seconds: 2)),
                        (ref
                                .read(walletsChangeNotifierProvider)
                                .getManager(widget.walletId)
                                .wallet as OrdinalsInterface)
                            .refreshInscriptions()
                      ]),
                      context: context,
                      message: "Refreshing...",
                    );
                  },
                ),
              ),
              // AspectRatio(
              //   aspectRatio: 1,
              //   child: AppBarIconButton(
              //     size: 36,
              //     icon: SvgPicture.asset(
              //       Assets.svg.filter,
              //       width: 20,
              //       height: 20,
              //       color: Theme.of(context)
              //           .extension<StackColors>()!
              //           .topNavIconPrimary,
              //     ),
              //     onPressed: () {
              //       Navigator.of(context).pushNamed(
              //         OrdinalsFilterView.routeName,
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
            ),
            child: Column(
              children: [
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(
                //     Constants.size.circularBorderRadius,
                //   ),
                //   child: TextField(
                //     autocorrect: Util.isDesktop ? false : true,
                //     enableSuggestions: Util.isDesktop ? false : true,
                //     controller: searchController,
                //     focusNode: searchFocus,
                //     onChanged: (value) {
                //       setState(() {
                //         _searchTerm = value;
                //       });
                //     },
                //     style: STextStyles.field(context),
                //     decoration: standardInputDecoration(
                //       "Search",
                //       searchFocus,
                //       context,
                //     ).copyWith(
                //       prefixIcon: Padding(
                //         padding: const EdgeInsets.symmetric(
                //           horizontal: 10,
                //           vertical: 16,
                //         ),
                //         child: SvgPicture.asset(
                //           Assets.svg.search,
                //           width: 16,
                //           height: 16,
                //         ),
                //       ),
                //       suffixIcon: searchController.text.isNotEmpty
                //           ? Padding(
                //               padding: const EdgeInsets.only(right: 0),
                //               child: UnconstrainedBox(
                //                 child: Row(
                //                   children: [
                //                     TextFieldIconButton(
                //                       child: const XIcon(),
                //                       onTap: () async {
                //                         setState(() {
                //                           searchController.text = "";
                //                           _searchTerm = "";
                //                         });
                //                       },
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             )
                //           : null,
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 16,
                // ),
                Expanded(
                  child: OrdinalsList(
                    walletId: widget.walletId,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
