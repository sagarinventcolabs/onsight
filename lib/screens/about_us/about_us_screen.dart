import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:on_sight_application/generated/assets.dart';
import 'package:on_sight_application/utils/constants.dart';
import 'package:on_sight_application/utils/dimensions.dart';
import 'package:on_sight_application/utils/functions/functions.dart';
import 'package:on_sight_application/utils/shared_preferences.dart';
import 'package:on_sight_application/utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    Theme.of(context) == Brightness.dark;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    colorFilter: Get.isDarkMode ? ColorFilter.mode(ColourConstants.black.withOpacity(0.1), BlendMode.color) : ColorFilter.mode(Colors.purple.shade900, BlendMode.color,),
                    opacity: Get.isDarkMode ? 0.2 : 0.3,
                    image: AssetImage(Assets.bgAboutUs),
                  ),
              ),
            ),
            Visibility(
              visible: !Get.isDarkMode,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(ColourConstants.black.withOpacity(0.3), BlendMode.color,),
                      opacity: 0.1,
                      image: const AssetImage(Assets.bgAboutUs),
                    )
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Dimensions.height40),
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: ColourConstants.white,
                    size: Dimensions.height25,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                SizedBox(height: Dimensions.height6),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.height20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(aboutUsStr,style: TextStyle(fontSize: Dimensions.font28,fontWeight: FontWeight.w500,color: ColourConstants.white)),
                      SizedBox(height: Dimensions.height17),
                      const Text(aboutUsDescription1,style: const TextStyle(color: ColourConstants.white)),
                      SizedBox(height: Dimensions.height17),
                      const Text(aboutUsDescription2,style: TextStyle(color: ColourConstants.white)),
                      SizedBox(height: Dimensions.height17),
                      const Text(aboutUsDescription3,style: TextStyle(color: ColourConstants.white)),
                      SizedBox(height: Dimensions.height26),
                      Text(supportContactUs,style: TextStyle(fontSize: Dimensions.font16,fontWeight: FontWeight.w500,color: ColourConstants.white,decoration: TextDecoration.underline)),
                      SizedBox(height: Dimensions.height26),
                      GestureDetector(
                        onTap: (){
                          _launchCaller();
                        },
                        child: Row(
                          children: [
                            Text(contactUs,style: TextStyle(fontSize: Dimensions.font15,fontWeight: FontWeight.w500,color: ColourConstants.white)),
                            Text(baseContactNumber,style: TextStyle(fontSize: Dimensions.font15,fontWeight: FontWeight.w500,color: Colors.deepPurpleAccent)),
                          ]
                        ),
                      ),
                      SizedBox(height: Dimensions.height10),
                      GestureDetector(
                        onTap: ()async{
                          AnalyticsFireEvent(AboutUsMailClick, input: {
                            user:sp?.getString(Preference.FIRST_NAME)??"" /*+" "+sp?.getString(Preference.LAST_NAME)??""*/
                          });
                          final Uri emailLaunchUri = Uri(
                            scheme: mailto,
                            path: baseContactEmail,
                            query: encodeQueryParameters(<String, String>{
                              subject: nthDegreeOnSight,
                            }),
                          );

                          if (!await launchUrl(emailLaunchUri)) {
                          throw 'Could not launch helpdesk@nthdegree.com';
                          }
                        },
                        child: Row(
                            children: [
                              Text(contactEmail,style: TextStyle(fontSize: Dimensions.font15,fontWeight: FontWeight.w500,color: ColourConstants.white)),
                              Text(baseContactEmail,style: TextStyle(fontSize: Dimensions.font15,fontWeight: FontWeight.w500,color: Colors.deepPurpleAccent,decoration: TextDecoration.underline)),
                            ]
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  _launchCaller() async {
    AnalyticsFireEvent(AboutUsCallClick, input: {
      user:sp?.getString(Preference.FIRST_NAME)??"" /*+" "+sp?.getString(Preference.LAST_NAME)??""*/
    });
    if (await canLaunchUrl(Uri.parse("tel:7706925575"))) {
      await launchUrl(Uri.parse("tel:7706925575"));
    } else {
      throw 'Could not launch 7706925575';
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

}
