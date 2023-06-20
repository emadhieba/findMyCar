import 'package:find_my_car/screens/LOGIN/loginScreen.dart';
import 'package:find_my_car/screens/LOGIN/phone_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../sheard/componant.dart';

// ignore: must_be_immutable
class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key}) : super(key: key);

  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();


  Widget buildDrawerHeader(context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsetsDirectional.fromSTEB(70, 10, 70, 10),

          child: Image.asset(
            'images/gps-0.jpg',
            fit: BoxFit.cover,


          ),
        ),
        Text(
          'Emad heiba',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        BlocProvider<PhoneAuthCubit>(
            create: (context) => phoneAuthCubit,
            child: Text(
              '${phoneAuthCubit.getLoggedInUser().phoneNumber}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
      ],
    );
  }

  Widget buildDrawerListItem(
      {required IconData leadingIcon,
        required String title,
        Widget? trailing,
        Function()? onTap,
        Color? color}) {
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: color ?? Colors.blueGrey,
      ),
      title: Text(title),
      trailing: trailing ??= Icon(
        Icons.arrow_right,
        color: Colors.blueGrey,
      ),
      onTap: onTap,
    );
  }

  Widget buildDrawerListItemsDivider() {
    return Divider(
      height: 0,
      thickness: 1,
      indent: 18,
      endIndent: 24,
    );
  }

  void _launchURL(String url) async {
    await canLaunchUrlString(url ) ? await launchUrlString(url) : throw 'Could not launch $url';
  }

  Widget buildIcon(IconData icon, String _url) {
    return InkWell(
      onTap: () => _launchURL(_url),
      child: Icon(
        icon,
        color: Colors.blueGrey,
        size: 35,
      ),
    );
  }

  Widget buildSocialMediaIcons() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16),
      child: Row(
        children: [
          buildIcon(
            FontAwesomeIcons.facebook,
            'https://www.facebook.com/profile.php?id=100010091050849&mibextid=ZbWKwL',
          ),
          const SizedBox(

            width: 20,
          ),
          buildIcon(
            FontAwesomeIcons.telegram,
            'https://t.me/Emadh45',
          ),
        ],
      ),
    );
  }

  Widget buildLogoutBlocProvider(context) {
    return Container(
      child: BlocProvider<PhoneAuthCubit>(
        create: (context) => phoneAuthCubit,
        child: buildDrawerListItem(
          leadingIcon: Icons.logout,
          title: 'Logout',
          onTap: () async {
            await phoneAuthCubit.logOut();
            navigateAndFinish(context, LoginScreen());
          },
          color: Colors.red,
          trailing: SizedBox(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 280,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey[200]),
              child: buildDrawerHeader(context),
            ),
          ),
          buildDrawerListItem(leadingIcon: Icons.person, title: 'My Profile'),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(
            leadingIcon: Icons.history,
            title: 'Places History',
            onTap: () {},
          ),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(leadingIcon: Icons.settings, title: 'Settings'),
          buildDrawerListItemsDivider(),
          buildDrawerListItem(leadingIcon: Icons.help, title: 'Help'),
          buildDrawerListItemsDivider(),
          buildLogoutBlocProvider(context),
          const SizedBox(
            height: 180,
          ),
          ListTile(
            leading: Text(
              'Follow us',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          buildSocialMediaIcons(),
        ],
      ),
    );
  }
}