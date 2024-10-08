import 'package:flutter/material.dart';
import 'package:invoc/utils/invoc_app_theme.dart';

class TitleAndPrice extends StatelessWidget {
  const TitleAndPrice({
    this.title,
    this.country,
    this.price,
  });

  final String? title, country;
  final int? price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$title\n",
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: InvocAppTheme.darkerText,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: country,
                  style: TextStyle(
                    fontSize: 20,
                    color: InvocAppTheme.lightWhite,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Text(
            "\$$price",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: InvocAppTheme.lightWhite),
          )
        ],
      ),
    );
  }
}
