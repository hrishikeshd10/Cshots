
import 'package:coin_shot/models/GetCryptoList.dart' as crypto;
import 'package:coin_shot/models/GetMainWatchlist.dart' as watchlist;
import 'package:coin_shot/models/GetMarketData.dart' as marketData;
import 'package:coin_shot/models/GetNewsResp.dart' as news;
import 'package:coin_shot/models/GetUserDetail.dart' as saveProfile;
import 'package:coin_shot/models/GetValues.dart' as value;
import 'package:coin_shot/models/GetWatchlistData.dart' as watchlistData;
import 'package:coin_shot/models/SearchCurrency.dart';

class GlobalLists {
  static List<news.Datum> getNewsList = [];
  static List<value.Datum> getValues = [];
  static List<news.Datum> getNewsListDetail = [];
  static List<news.Datum> getBookmarkList = [];
  static List<marketData.Datum> getMarketDataList = [];
  static List<watchlist.Datum> getMainWatchList = [];
  static List<watchlistData.Datum> getWatchListData = [];
  static List<crypto.Datum> getCryptoDataList = [];
  static List<SearchCurrency> searchCryptoDataList = [];
  static List<crypto.Datum> getCryptoDataListRefresh = [];
  static List<crypto.Datum> getCryptoDataListSearch = [];
  static crypto.Datum getLastCryptoViewed; //my claims
  static SearchCurrency searchCrypto; //my claims
  static saveProfile.Data profileDetails; //my claims
  static double noOfLine=0;
  static List elementList = [];
  static List mainElementList = [];

  static String userName ='';
  static String  passSelectedSymbol="";
  static String  watchlistId="";
  static String  selectWatchlist="";
  static int  roleId=0;
  static int  currentPage=2;
  static int  initialValue=0;

  static bool signPwd = true, signOtp = false, signUp = false, forgetPwd = false, verifyPwd = false, sendOTPFor = false;

}
