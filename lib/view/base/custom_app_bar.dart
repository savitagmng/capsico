import 'package:flutter/material.dart';
import 'package:flutter_grocery/provider/category_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

import '../../helper/responsive_helper.dart';
import '../../helper/route_helper.dart';
import '../../provider/cart_provider.dart';
import '../../provider/splash_provider.dart';
import '../../utill/images.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function onBackPressed;
  final bool isCenter;
  final bool isElevation;
  final bool fromCategoryScreen;
  CustomAppBar({@required this.title, this.isBackButtonExist = true, this.onBackPressed,this.isCenter=true,this.isElevation=false,this.fromCategoryScreen = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).textTheme.bodyText1.color)),
      centerTitle: isCenter?true:false,
      leading: isBackButtonExist ? IconButton(
        icon: Icon(Icons.arrow_back_ios,color: Theme.of(context).textTheme.bodyText1.color),
        color: Theme.of(context).textTheme.bodyText1.color,
        onPressed: () => onBackPressed != null ? onBackPressed() : Navigator.pop(context),
      ) : SizedBox(),
      backgroundColor: Theme.of(context).cardColor,
      elevation: isElevation?2:0,

      actions: [
        fromCategoryScreen ? Row(
          children: [

            IconButton(
                icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(Images.cart_icon,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .color,
                          width: 25),
                      Positioned(
                        top: -7,
                        right: -2,
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context)
                                  .primaryColor),
                          child: Text(
                              '${Provider.of<CartProvider>(context).cartList.length}',
                              style: TextStyle(
                                  color:
                                  Theme.of(context)
                                      .cardColor,
                                  fontSize: 10)),
                        ),
                      ),
                    ]),
                onPressed: () {
                  Navigator.pop(context);
                  Provider.of<SplashProvider>(context, listen: false).getsidBarClickTrue(false);

                  Provider.of<SplashProvider>(context, listen: false).setPageIndex(1);



                }),
            PopupMenuButton(
                color: ColorResources.getWhiteColor(context),
                elevation: 20,
                enabled: true,
                icon: Icon(Icons.more_vert,color: Theme.of(context).textTheme.bodyText1.color,),
                onSelected: (value) {
                  int _index = Provider.of<ProductProvider>(context,listen: false).allSortBy.indexOf(value);
                  Provider.of<ProductProvider>(context,listen: false).sortCategoryProduct(_index);
                },

                itemBuilder:(context) {
                  return Provider.of<ProductProvider>(context,listen: false).allSortBy.map((choice) {
                    return PopupMenuItem(
                      value: choice,
                      child: Text("$choice"),
                    );
                  }).toList();
                }
            ),
          ],
        ) : SizedBox(),
      ],
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 50);
}
