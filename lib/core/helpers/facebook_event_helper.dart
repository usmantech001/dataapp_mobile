import 'package:facebook_app_events/facebook_app_events.dart';

class FacebookEventHelper {
  static final facebookAppEvents = FacebookAppEvents();

  void logEvent(String eventName)  async{
  // await  facebookAppEvents.setUserData(
  //     email: 'akanjiusman67@gmail.com',
  //     firstName: 'Usman',
  //     city: 'Ibadan',
  //     country: 'Nigeria',
  //   );
 try {
   await facebookAppEvents.logEvent(name: eventName);
  // print('...successfully logged event');
 } catch (e) {
   
 }
    
  }
}
