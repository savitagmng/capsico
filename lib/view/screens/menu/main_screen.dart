import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/html_type.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/location_provider.dart';
import 'package:flutter_grocery/provider/profile_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/third_party_chat_widget.dart';
import 'package:flutter_grocery/view/screens/address/address_screen.dart';
import 'package:flutter_grocery/view/screens/cart/cart_screen.dart';
import 'package:flutter_grocery/view/screens/category/all_category_screen.dart';
import 'package:flutter_grocery/view/screens/chat/chat_screen.dart';
import 'package:flutter_grocery/view/screens/coupon/coupon_screen.dart';
import 'package:flutter_grocery/view/screens/home/home_screens.dart';
import 'package:flutter_grocery/view/screens/html/html_viewer_screen.dart';
import 'package:flutter_grocery/view/screens/menu/widget/custom_drawer.dart';
import 'package:flutter_grocery/view/screens/order/my_order_screen.dart';
import 'package:flutter_grocery/view/screens/refer_and_earn/refer_and_earn_screen.dart';
import 'package:flutter_grocery/view/screens/settings/setting_screen.dart';
import 'package:flutter_grocery/view/screens/wallet/wallet_screen.dart';
import 'package:flutter_grocery/view/screens/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

import '../../../provider/search_provider.dart';
import '../../base/custom_text_field.dart';
import '../search/search_result_screen.dart';
import '../search/search_screen.dart';

List<MainScreenModel> screenList = [
  MainScreenModel(HomeScreen(), 'home', Images.home),
  // MainScreenModel(AllCategoryScreen(), 'all_categories', Images.list),
  MainScreenModel(CartScreen(), 'shopping_bag', Images.order_bag),
  MainScreenModel(WishListScreen(), 'favourite', Images.favourite_icon),
  MainScreenModel(MyOrderScreen(), 'my_order', Images.order_list),
  MainScreenModel(AllCategoryScreen(), 'all_categories', Images.list),
//  MainScreenModel(AddressScreen(), 'address', Images.location),
  // MainScreenModel(CouponScreen(), 'coupon', Images.coupon),
  MainScreenModel(
      ChatScreen(
        orderModel: null,
      ),
      'live_chat',
      Images.chat),
  MainScreenModel(SettingsScreen(), 'settings', Images.settings),
  if (Provider.of<SplashProvider>(Get.context, listen: false)
      .configModel
      .walletStatus)
    MainScreenModel(WalletScreen(fromWallet: true), 'wallet', Images.wallet),
  if (Provider.of<SplashProvider>(Get.context, listen: false)
      .configModel
      .loyaltyPointStatus)
    MainScreenModel(
        WalletScreen(fromWallet: false), 'loyalty_point', Images.loyalty_icon),
  MainScreenModel(HtmlViewerScreen(htmlType: HtmlType.TERMS_AND_CONDITION),
      'terms_and_condition', Images.terms_and_conditions),
  MainScreenModel(HtmlViewerScreen(htmlType: HtmlType.PRIVACY_POLICY),
      'privacy_policy', Images.privacy),
  MainScreenModel(HtmlViewerScreen(htmlType: HtmlType.ABOUT_US), 'about_us',
      Images.about_us),
  if (Provider.of<SplashProvider>(Get.context, listen: false)
      .configModel
      .returnPolicyStatus)
    MainScreenModel(HtmlViewerScreen(htmlType: HtmlType.RETURN_POLICY),
        'return_policy', Images.return_policy),

  if (Provider.of<SplashProvider>(Get.context, listen: false)
      .configModel
      .refundPolicyStatus)
    MainScreenModel(HtmlViewerScreen(htmlType: HtmlType.REFUND_POLICY),
        'refund_policy', Images.refund_policy),

  if (Provider.of<SplashProvider>(Get.context, listen: false)
      .configModel
      .cancellationPolicyStatus)
    MainScreenModel(HtmlViewerScreen(htmlType: HtmlType.CANCELLATION_POLICY),
        'cancellation_policy', Images.cancellation_policy),

  MainScreenModel(HtmlViewerScreen(htmlType: HtmlType.FAQ), 'faq', Images.faq),
];

class MainScreen extends StatefulWidget {
  final CustomDrawerController drawerController;

  MainScreen({@required this.drawerController});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  TextEditingController _searchController = TextEditingController();

   PageController _pageController;
  int _pageIndex = 0;
  List<Widget> _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();


  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _screens = [
      HomeScreen(),
      AllCategoryScreen(),
      //CartScreen(),
      //   WishListScreen(),
      MyOrderScreen(),
      AddressScreen(),
      CouponScreen(),
      //   ChatScreen(orderModel: null),
      //  SettingsScreen(),
    ];

    HomeScreen.loadData(true, Get.context);
  }
  @override
  void dispose() {
    _pageController.dispose(); // Don't forget to dispose the PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print("call this screen");

    return Consumer<SplashProvider>(
      builder: (context, splash, child) {
        return WillPopScope(
          onWillPop: () async {
            if (splash.pageIndex != 0) {
              splash.setPageIndex(0);
              return false;
            } else {
              return true;
            }
          },
          child: Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
            final _referMenu = MainScreenModel(
                ReferAndEarnScreen(), 'refer_and_earn', Images.referral_icon);
            if (splash.configModel.referEarnStatus &&
                profileProvider.userInfoModel != null &&
                profileProvider.userInfoModel.referCode != null &&
                screenList[9].title != 'refer_and_earn') {
              screenList
                  .removeWhere((menu) => menu.screen == _referMenu.screen);
              screenList.insert(9, _referMenu);






            }

            print("screen${screenList.length}");
            print("screen${screenList[0].screen}");


            return Consumer<LocationProvider>(
              builder: (context, locationProvider, child) => Scaffold(
                floatingActionButton: !ResponsiveHelper.isDesktop(context)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50.0),
                        child: ThirdPartyChatWidget(),
                      )
                    : null,
                appBar: ResponsiveHelper.isDesktop(context)
                    ? null
                    : AppBar(
                        backgroundColor: Theme.of(context).cardColor,
                        leading: IconButton(
                            icon: Image.asset(Images.more_icon,
                                color: Theme.of(context).primaryColor,
                                height: 30,
                                width: 30),
                            onPressed: () {
                              widget.drawerController.toggle();
                            }),
                        title: splash.pageIndex == 0
                            ? Row(children: [
                                Image.asset(Images.app_logo, width: 25),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                Expanded(
                                    child: Text(
                                  AppConstants.APP_NAME,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: poppinsMedium.copyWith(
                                      color: Theme.of(context).primaryColor),
                                )),
                              ])
                            : Text(
                                getTranslated(
                                    screenList[splash.pageIndex].title,
                                    context),
                                style: poppinsMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                    color: Theme.of(context).primaryColor),
                              ),
                        actions: splash.pageIndex == 0
                            ? [
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
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      fontSize: 10)),
                                            ),
                                          ),
                                        ]),
                                    onPressed: () {

                                      splash
                                          .getsidBarClickTrue(false);

                                      print("call here cart values");
                                      ResponsiveHelper.isMobilePhone()? splash.setPageIndex(1): Navigator.pushNamed(context, RouteHelper.cart);
                                    }),
                                /*IconButton(
                                    icon: Icon(Icons.search,
                                        size: 30,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .color),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, RouteHelper.searchProduct);
                                    }),*/
                              ]
                            : splash.pageIndex == 2
                                ? [
                                    Center(child: Consumer<CartProvider>(
                                        builder: (context, cartProvider, _) {
                                      return Text(
                                          '${cartProvider.cartList.length} ${getTranslated('items', context)}',
                                          style: poppinsMedium.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor));
                                    })),
                                    SizedBox(width: 20)
                                  ]
                                : null,
                      ),


                bottomNavigationBar: /*splash.sidBarClickTrue
                    ?*/ BottomNavigationBar(
                        selectedItemColor: Theme.of(context).primaryColor,
                        unselectedItemColor: Colors.grey,
                        showUnselectedLabels: true,
                        currentIndex: splash.pageIndexBottomBar,
                        type: BottomNavigationBarType.fixed,
                        items: [
                          _barItem(
                              Images.home, getTranslated('home', context), 0),
                          _barItem(
                              Images.list, getTranslated('All', context), 1),
                          //   _barItem(Images.order_bag, getTranslated('shopping_bag', context), 2),
                          //  _barItem(Images.order_bag, getTranslated('favourite', context), 3),
                          _barItem(Images.order_list,
                              getTranslated('my_order', context), 2),
                          _barItem(Images.location,
                              getTranslated('address', context), 3),
                          _barItem(Images.coupon,
                              getTranslated('coupon', context), 4),
                          //   _barItem(Images.chat, getTranslated('live_chat', context), 7),
                          //   _barItem(Images.settings, getTranslated('', context), 8),
                        ],
                        onTap: (int index) {

                          print("which index call${index}");
                          _setPage(index);
                        },
                      ),
                   /* : SizedBox(
                        height: 0,
                      ),*/
                body: Stack(
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: splash.sidBarClickTrue
                          ? Stack(
                        children: [
                          _screens[splash.pageIndexBottomBar],
                       /*   PageView.builder(
                            controller: _pageController,
                            itemCount: _screens.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return _screens[index];
                            },
                          ),*/
                          /* Container(
                                child: CustomTextField(
                                  hintText:
                                      getTranslated('search_item_here', context),
                                  isShowBorder: true,
                                  isShowPrefixIcon: true,
                                  prefixIconUrl: Icons.search,
                                  controller: _searchController,
                                  inputAction: TextInputAction.search,
                                  isIcon: true,
                                  onSubmit: (text) {
                                    if (_searchController.text.length > 0) {
                                      List<int> _encoded =
                                          utf8.encode(_searchController.text);
                                      String _data = base64Encode(_encoded);
                                      Provider.of<SearchProvider>(context,
                                              listen: false)
                                          .saveSearchAddress(
                                              _searchController.text);
                                      Navigator.pushNamed(context,
                                          RouteHelper.searchResult + '?text=$_data',
                                          arguments: SearchResultScreen(
                                              searchString:
                                                  _searchController.text));
                                      _searchController.text = "";
                                    }
                                  },
                                ),
                              )*/
                        ],
                      )
                          : screenList[splash.pageIndex].screen,
                    ),
                    Container(
                      child: CustomTextField(
                        hintText:
                        getTranslated('search_item_here', context),
                        isShowBorder: true,
                        isShowPrefixIcon: true,
                        prefixIconUrl: Icons.search,
                        controller: _searchController,
                        inputAction: TextInputAction.search,
                        isIcon: true,
                        onSubmit: (text) {
                          if (_searchController.text.length > 0) {
                            List<int> _encoded =
                            utf8.encode(_searchController.text);
                            String _data = base64Encode(_encoded);
                            Provider.of<SearchProvider>(context,
                                listen: false)
                                .saveSearchAddress(
                                _searchController.text);
                            Navigator.pushNamed(context,
                                RouteHelper.searchResult + '?text=$_data',
                                arguments: SearchResultScreen(
                                    searchString:
                                    _searchController.text));
                            _searchController.text = "";
                          }
                        },
                      ),
                    ),

                  ],

                ),
              ),
            );
          }),
        );
      },
    );
  }

  BottomNavigationBarItem _barItem(String icon, String label, int index) {

    print("check data ${index} data${Provider.of<SplashProvider>(context, listen: false).pageIndexBottomBar}");
    return BottomNavigationBarItem(
      icon: Image.asset(icon,
          color: index == Provider.of<SplashProvider>(context, listen: false).pageIndexBottomBar
              ? Theme.of(context).primaryColor
              : Colors.grey,
          width: 25),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      Provider.of<SplashProvider>(context, listen: false).setpageIndexBottomBar(pageIndex);

      Provider.of<SplashProvider>(context, listen: false).getsidBarClickTrue(true);
      Provider.of<SplashProvider>(context, listen: false).setPageIndex(0);

      if(_pageController==null)
        {
          _pageController = PageController();
        }
      _pageController.jumpToPage(pageIndex);
  //    _pageIndex = pageIndex;

    });
  }
}

class MainScreenModel {
  final Widget screen;
  final String title;
  final String icon;

  MainScreenModel(this.screen, this.title, this.icon);
}
