import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AccountCard extends StatelessWidget {
  final String name;
  final Icon icon;
  final VoidCallback? onTap;

  const AccountCard({
    super.key,
    required this.onTap,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: 70,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              margin: const EdgeInsets.only(
                right: 20,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                color: AppColor.placeholderBg,
              ),
              child: Row(
                children: [
                  Container(
                      width: 50,
                      height: 50,
                      decoration: const ShapeDecoration(
                        shape: CircleBorder(),
                        color: AppColor.placeholder,
                      ),
                      child: icon),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 30,
                height: 30,
                decoration: const ShapeDecoration(
                  shape: CircleBorder(),
                  color: AppColor.placeholderBg,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColor.secondary,
                  size: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
