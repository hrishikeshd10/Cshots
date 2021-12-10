
class AllUrls {
  String host = 'http://3.109.243.231';
  String prodHost = "";

  String apiKey = "";

  //TODO: Change status to "U" to switch to UAT- "V" to switch to Prod
  final String appStatus = 'U';

  AllUrls() {
    switch (appStatus) {
      case 'U':
        host = host;
        break;

      default:
        host = prodHost;
    }
  }

 String uploadMediaFile(String userId) =>
      '$host/mt/mediaupload?UserId=${userId}';

}