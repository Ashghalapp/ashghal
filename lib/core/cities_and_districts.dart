


import 'package:get/get.dart';

class City {
  final int id;
  final String nameEn;
  final String nameAr;
  final List<District> districts;

  City({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.districts,
  });

  String get name => Get.locale?.languageCode == 'en' ? nameEn : nameAr;

  District? getDistrictById(int id) {
    final districtsIndex =
        districts.indexWhere((districts) => districts.id == id);
    if (districtsIndex != -1) {
      return districts[districtsIndex];
    }
    return null;
  }

  District? getDistrictByNameEn(String? nameEn) {
    if (nameEn == null) return null;
    final cityIndex =
        districts.indexWhere((district) => district.nameEn == nameEn);
    if (cityIndex != -1) {
      return districts[cityIndex];
    }
    return null;
  }

  String? getDistrictsNameById(int id) {
    final districtsIndex =
        districts.indexWhere((districts) => districts.id == id);
    if (districtsIndex != -1) {
      return districts[districtsIndex].name;
    }
    return null;
  }

  // List<District> getDist

  static City? getCityById(int? id) {
    if (id == null) return null;
    final cityIndex = citiess.indexWhere((city) => city.id == id);
    if (cityIndex != -1) {
      return citiess[cityIndex];
    }
    return null;
  }

  static City? getCityByNameEn(String nameEn) {
    final cityIndex = citiess.indexWhere((city) => city.nameEn == nameEn);
    if (cityIndex != -1) {
      return citiess[cityIndex];
    }
    return null;
  }

  static String? getCityNameById(int id) {
    final cityIndex = citiess.indexWhere((city) => city.id == id);
    if (cityIndex != -1) {
      return citiess[cityIndex].name;
    }
    return null;
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': Get.locale?.languageCode == 'en' ? nameEn : nameAr,
    };
  }
}

class District {
  final int id;
  final String nameEn;
  final String nameAr;

  District({required this.id, required this.nameAr, required this.nameEn});

  String get name => Get.locale?.languageCode == 'en' ? nameEn : nameAr;

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': Get.locale?.languageCode == 'en' ? nameEn : nameAr,
    };
  }
}
final List<District> sanaaDistiricts = [
  District(
    id: 11,
    nameAr: 'المديرية القديمة',
    nameEn: 'Old City District',
  ),
  District(
    id: 12,
    nameAr: 'مديرية شعوب',
    nameEn: 'Shuoub District',
  ),
  District(
    id: 13,
    nameAr: 'مديرية أزال',
    nameEn: 'Azal District',
  ),
  District(
    id: 14,
    nameAr: 'مديرية الصافية',
    nameEn: 'Al-Safia District',
  ),
  District(
    id: 15,
    nameAr: 'مديرية السبعين',
    nameEn: 'Sebeen District',
  ),
  District(
    id: 16,
    nameAr: 'مديرية الوحدة',
    nameEn: 'Al-Wahda District',
  ),
  District(
    id: 17,
    nameAr: 'مديرية التحرير',
    nameEn: 'Al-Tahrir District',
  ),
  District(
    id: 18,
    nameAr: 'مديرية معين',
    nameEn: 'Muain District',
  ),
  District(
    id: 19,
    nameAr: 'مديرية الثورة',
    nameEn: 'Al-Thawra District',
  ),
  District(
    id: 20,
    nameAr: 'مديرية بني الحارث',
    nameEn: 'Bani Al-Harith District',
  ),
  District(
    id: 21,
    nameAr: 'مديرية ضواحي سنحان وبني بهلول',
    nameEn: 'Suburbs of Sanhan and Bani Bahloul District',
  ),
  District(
    id: 22,
    nameAr: 'مديرية همدان',
    nameEn: 'Hamdan District',
  ),
  District(
    id: 23,
    nameAr: 'مديرية خولان',
    nameEn: 'Khawlan District',
  ),
  District(
    id: 24,
    nameAr: 'مديرية الطيال',
    nameEn: 'Al-Tayyal District',
  ),
  District(
    id: 25,
    nameAr: 'مديرية بني ضبيان',
    nameEn: 'Bani Dabyan District',
  ),
  District(
    id: 26,
    nameAr: 'مديرية الحصن',
    nameEn: 'Al-Hisn District',
  ),
  District(
    id: 27,
    nameAr: 'مديرية جحانة',
    nameEn: 'Jahana District',
  ),
  District(
    id: 29,
    nameAr: 'مديرية بكيل العروس',
    nameEn: 'Bakil Al-Arouss District',
  ),
  District(
    id: 30,
    nameAr: 'مديرية سنحان وبني بهلول',
    nameEn: 'Sanhan and Bani Bahloul District',
  ),
  District(
    id: 31,
    nameAr: 'مديرية الصبيحي',
    nameEn: 'Al-Sabahi District',
  ),
  District(
    id: 32,
    nameAr: 'مديرية بني مطر',
    nameEn: 'Bani Matar District',
  ),
  District(
    id: 33,
    nameAr: 'مديرية السبيعة',
    nameEn: 'Al-Sabie District',
  ),
  District(
    id: 34,
    nameAr: 'مديرية مظفر',
    nameEn: 'Mazhar District',
  ),
  District(
    id: 35,
    nameAr: 'مديرية عتق',
    nameEn: 'Ataq District',
  ),
  District(
    id: 36,
    nameAr: 'مديرية الحضن',
    nameEn: 'Al-Hudhn District',
  ),
  District(
    id: 37,
    nameAr: 'مديرية شعب',
    nameEn: 'Sha\'b District',
  ),
  District(
    id: 38,
    nameAr: 'مديرية نمار',
    nameEn: 'Nimar District',
  ),
  District(
    id: 39,
    nameAr: 'مديرية الريان',
    nameEn: 'Al-Rayan District',
  ),
  District(
    id: 40,
    nameAr: 'مديرية حجرة',
    nameEn: 'Hijrat District',
  ),
];

final List<District> adenDistiricts = [
  District(
    id: 1,
    nameAr: 'دار سعد',
    nameEn: 'Dar Saad',
  ),
  District(
    id: 2,
    nameAr: 'الشيخ عثمان',
    nameEn: 'Ash-Shaykh Uthman',
  ),
  District(
    id: 3,
    nameAr: 'المنصورة',
    nameEn: 'Al-Mansurah',
  ),
  District(
    id: 4,
    nameAr: 'البريقة',
    nameEn: 'Al-Bariqah',
  ),
  District(
    id: 5,
    nameAr: 'التواهي',
    nameEn: 'At-Tuwahi',
  ),
  District(
    id: 6,
    nameAr: 'المعلا',
    nameEn: 'Al-Ma\'alla',
  ),
  District(
    id: 7,
    nameAr: 'صيرة',
    nameEn: 'Sayrah',
  ),
  District(
    id: 8,
    nameAr: 'خور مكسر',
    nameEn: 'Khawr Maksar',
  ),
];

final List<District> hadramautDistiricts = [
  District(
    id: 1,
    nameAr: 'المكلا',
    nameEn: 'Al-Mukalla',
  ),
  District(
    id: 2,
    nameAr: 'ثمود',
    nameEn: 'Thamud',
  ),
  District(
    id: 3,
    nameAr: 'القف',
    nameEn: 'Al-Qif',
  ),
  District(
    id: 4,
    nameAr: 'زمخ ومنوخ',
    nameEn: 'Zamkh and Munukh',
  ),
  District(
    id: 5,
    nameAr: 'حجر',
    nameEn: 'Hajar',
  ),
  District(
    id: 6,
    nameAr: 'العبر',
    nameEn: 'Al-Abur',
  ),
  District(
    id: 7,
    nameAr: 'القطن',
    nameEn: 'Al-Qatan',
  ),
  District(
    id: 8,
    nameAr: 'شبام',
    nameEn: 'Shibam',
  ),
  District(
    id: 9,
    nameAr: 'ساه',
    nameEn: 'Sah',
  ),
  District(
    id: 10,
    nameAr: 'سيئون',
    nameEn: 'Sayun',
  ),
  District(
    id: 11,
    nameAr: 'تريم',
    nameEn: 'Tarim',
  ),
  District(
    id: 12,
    nameAr: 'السوم',
    nameEn: 'As-Sum',
  ),
  District(
    id: 13,
    nameAr: 'الريدة وقصيعر',
    nameEn: 'Ar-Raida and Qusai\'ar',
  ),
  District(
    id: 14,
    nameAr: 'الديس',
    nameEn: 'Ad-Dais',
  ),
  District(
    id: 15,
    nameAr: 'الشحر',
    nameEn: 'Ash-Shahr',
  ),
  District(
    id: 16,
    nameAr: 'غيل بن يمين',
    nameEn: 'Ghayl bin Yamin',
  ),
  District(
    id: 17,
    nameAr: 'غيل باوزير',
    nameEn: 'Ghayl Bawazir',
  ),
  District(
    id: 18,
    nameAr: 'دوعن',
    nameEn: 'Du\'an',
  ),
  District(
    id: 19,
    nameAr: 'حورة ووادي العين',
    nameEn: 'Hurah and Wadi Al-Ayn',
  ),
  District(
    id: 20,
    nameAr: 'رخية',
    nameEn: 'Rakhiah',
  ),
  District(
    id: 21,
    nameAr: 'عمد',
    nameEn: 'Amad',
  ),
  District(
    id: 22,
    nameAr: 'الضليعة',
    nameEn: 'Adh-Dhali\'ah',
  ),
  District(
    id: 23,
    nameAr: 'يبعث',
    nameEn: 'Yaba\'ath',
  ),
  District(
    id: 24,
    nameAr: 'حجر الصيعر',
    nameEn: 'Hajar As-Sa\'ir',
  ),
  District(
    id: 25,
    nameAr: 'بروم ميفع',
    nameEn: 'Broom Maifeh',
  ),
  District(
    id: 26,
    nameAr: 'حريضة',
    nameEn: 'Hareidah',
  ),
  District(
    id: 27,
    nameAr: 'رماه',
    nameEn: 'Rama',
  ),
  District(
    id: 28,
    nameAr: 'أرياف المكلا',
    nameEn: 'Ariaf Al-Mukalla',
  ),
];
final List<District> taizDistiricts = [
  District(
    id: 1,
    nameAr: 'ماوية',
    nameEn: 'Mawyah',
  ),
  District(
    id: 2,
    nameAr: 'شرعب السلام',
    nameEn: 'Sharab Al-Salam',
  ),
  District(
    id: 3,
    nameAr: 'شرعب الرونة',
    nameEn: 'Sharab Al-Rawna',
  ),
  District(
    id: 4,
    nameAr: 'مقبنة',
    nameEn: 'Maqbana',
  ),
  District(
    id: 5,
    nameAr: 'المخاء',
    nameEn: 'Al-Makhah',
  ),
  District(
    id: 6,
    nameAr: 'ذباب',
    nameEn: 'Dhabab',
  ),
  District(
    id: 7,
    nameAr: 'موزع',
    nameEn: 'Mawzah',
  ),
  District(
    id: 8,
    nameAr: 'جبل حبشي',
    nameEn: 'Jabal Habshi',
  ),
  District(
    id: 9,
    nameAr: 'مشرعة وحدنان',
    nameEn: 'Mashra\'ah Wahdan',
  ),
  District(
    id: 10,
    nameAr: 'صبر الموادم',
    nameEn: 'Sabr Al-Mawadim',
  ),
  District(
    id: 11,
    nameAr: 'المسراخ',
    nameEn: 'Al-Musrakh',
  ),
  District(
    id: 12,
    nameAr: 'خدير',
    nameEn: 'Khadeer',
  ),
  District(
    id: 13,
    nameAr: 'الصلو',
    nameEn: 'As-Salu',
  ),
  District(
    id: 14,
    nameAr: 'الشمايتين',
    nameEn: 'Ash-Shumaytin',
  ),
  District(
    id: 15,
    nameAr: 'الوازعية',
    nameEn: 'Al-Waz\'iyah',
  ),
  District(
    id: 16,
    nameAr: 'حيفان',
    nameEn: 'Hayfan',
  ),
  District(
    id: 17,
    nameAr: 'المظفر',
    nameEn: 'Al-Muzaffar',
  ),
  District(
    id: 18,
    nameAr: 'القاهرة',
    nameEn: 'Al-Qaherah',
  ),
  District(
    id: 19,
    nameAr: 'صالة',
    nameEn: 'Salah',
  ),
  District(
    id: 20,
    nameAr: 'التعزية',
    nameEn: 'At-Ta\'ziyah',
  ),
  District(
    id: 21,
    nameAr: 'المعافر',
    nameEn: 'Al-Ma\'afir',
  ),
  District(
    id: 22,
    nameAr: 'المواسط',
    nameEn: 'Al-Mawasit',
  ),
  District(
    id: 23,
    nameAr: 'سامع',
    nameEn: 'Same\'ah',
  ),
];
final List<District> hodeidahDistricts = [
  District(
    id: 1,
    nameAr: 'الزهرة',
    nameEn: 'Az-Zahrah',
  ),
  District(
    id: 2,
    nameAr: 'اللحية',
    nameEn: 'Al-Luhiah',
  ),
  District(
    id: 3,
    nameAr: 'كمران',
    nameEn: 'Kumran',
  ),
  District(
    id: 4,
    nameAr: 'الصليف',
    nameEn: 'As-Salif',
  ),
  District(
    id: 5,
    nameAr: 'المنيرة',
    nameEn: 'Al-Munirah',
  ),
  District(
    id: 6,
    nameAr: 'القناوص',
    nameEn: 'Al-Qanawis',
  ),
  District(
    id: 7,
    nameAr: 'الزيدية',
    nameEn: 'Az-Zaydiyah',
  ),
  District(
    id: 8,
    nameAr: 'المغلاف',
    nameEn: 'Al-Mughlaf',
  ),
  District(
    id: 9,
    nameAr: 'الضحى',
    nameEn: 'Ad-Duha',
  ),
  District(
    id: 10,
    nameAr: 'باجل',
    nameEn: 'Bajil',
  ),
  District(
    id: 11,
    nameAr: 'الحجيلة',
    nameEn: 'Al-Hujaylah',
  ),
  District(
    id: 12,
    nameAr: 'برع',
    nameEn: 'Bara',
  ),
  District(
    id: 13,
    nameAr: 'المراوعة',
    nameEn: 'Al-Muraw\'ah',
  ),
  District(
    id: 14,
    nameAr: 'الدريهمي',
    nameEn: 'Ad-Darihami',
  ),
  District(
    id: 15,
    nameAr: 'السخنة',
    nameEn: 'As-Sakhnah',
  ),
  District(
    id: 16,
    nameAr: 'المنصورية',
    nameEn: 'Al-Mansuriyah',
  ),
  District(
    id: 17,
    nameAr: 'بيت الفقيه',
    nameEn: 'Bait Al-Faqih',
  ),
  District(
    id: 18,
    nameAr: 'جبل راس',
    nameEn: 'Jabal Ras',
  ),
  District(
    id: 19,
    nameAr: 'حيس',
    nameEn: 'Hayis',
  ),
  District(
    id: 20,
    nameAr: 'الخوخة',
    nameEn: 'Al-Khawkhah',
  ),
  District(
    id: 21,
    nameAr: 'الحوك',
    nameEn: 'Al-Hawak',
  ),
  District(
    id: 22,
    nameAr: 'الميناء',
    nameEn: 'Al-Maynah',
  ),
  District(
    id: 23,
    nameAr: 'الحالي',
    nameEn: 'Al-Hali',
  ),
  District(
    id: 24,
    nameAr: 'زبيد',
    nameEn: 'Zabid',
  ),
  District(
    id: 25,
    nameAr: 'الجراحي',
    nameEn: 'Al-Jarahi',
  ),
  District(
    id: 26,
    nameAr: 'التحيتا',
    nameEn: 'At-Tahitah',
  ),
];
final List<District> alMahweetDistiricts = [
  District(
    id: 1,
    nameAr: 'شبام كوكبان',
    nameEn: 'Shibam Kokban',
  ),
  District(
    id: 2,
    nameAr: 'الطويلة',
    nameEn: 'Al-Tawila',
  ),
  District(
    id: 3,
    nameAr: 'الرجم',
    nameEn: 'Al-Rajam',
  ),
  District(
    id: 4,
    nameAr: 'الخبت',
    nameEn: 'Al-Khabt',
  ),
  District(
    id: 5,
    nameAr: 'ملحان',
    nameEn: 'Malhan',
  ),
  District(
    id: 6,
    nameAr: 'حفاش',
    nameEn: 'Hafash',
  ),
  District(
    id: 7,
    nameAr: 'بني سعد',
    nameEn: 'Bani Saad',
  ),
  District(
    id: 8,
    nameAr: 'مدينة المحويت',
    nameEn: 'Madinat Al-Mahwit',
  ),
  District(
    id: 9,
    nameAr: 'المحويت',
    nameEn: 'Al-Mahwit',
  ),
];
final List<District> alBaydaDistiricts = [
  District(
    id: 1,
    nameAr: 'نعمان',
    nameEn: 'Naman',
  ),
  District(
    id: 2,
    nameAr: 'ناطع',
    nameEn: 'Nat\'ah',
  ),
  District(
    id: 3,
    nameAr: 'مسورة',
    nameEn: 'Masurah',
  ),
  District(
    id: 4,
    nameAr: 'الصومعة',
    nameEn: 'As-Suwaymah',
  ),
  District(
    id: 5,
    nameAr: 'الزاهر',
    nameEn: 'Az-Zahir',
  ),
  District(
    id: 6,
    nameAr: 'ذي ناعم',
    nameEn: 'Dhi Na\'im',
  ),
  District(
    id: 7,
    nameAr: 'الطفة',
    nameEn: 'At-Tufah',
  ),
  District(
    id: 8,
    nameAr: 'مكيراس',
    nameEn: 'Mukayras',
  ),
  District(
    id: 9,
    nameAr: 'مدينة البيضاء',
    nameEn: 'Al-Bayda City',
  ),
  District(
    id: 10,
    nameAr: 'البيضاء',
    nameEn: 'Al-Bayda',
  ),
  District(
    id: 11,
    nameAr: 'السوادية',
    nameEn: 'As-Sawadiyah',
  ),
  District(
    id: 12,
    nameAr: 'ردمان',
    nameEn: 'Radman',
  ),
  District(
    id: 13,
    nameAr: 'رداع',
    nameEn: 'Radah',
  ),
  District(
    id: 14,
    nameAr: 'القريشية',
    nameEn: 'Al-Qurayshiyyah',
  ),
  District(
    id: 15,
    nameAr: 'ولد ربيع',
    nameEn: 'Wald Rabi',
  ),
  District(
    id: 16,
    nameAr: 'العرش',
    nameEn: 'Al-Arsh',
  ),
  District(
    id: 17,
    nameAr: 'صباح',
    nameEn: 'Sabah',
  ),
  District(
    id: 18,
    nameAr: 'الرياشية',
    nameEn: 'Ar-Riyashiyyah',
  ),
  District(
    id: 19,
    nameAr: 'الشرية',
    nameEn: 'Ash-Shariyah',
  ),
  District(
    id: 20,
    nameAr: 'الملاجم',
    nameEn: 'Al-Malajim',
  ),
];
final List<District> ibbDistiricts = [
  District(
    id: 1,
    nameAr: 'إب',
    nameEn: 'Ibb',
  ),
  District(
    id: 2,
    nameAr: 'السياني',
    nameEn: 'ِAlsayani',
  ),
  District(
    id: 3,
    nameAr: 'الرداع',
    nameEn: 'Al-Radah',
  ),
  District(
    id: 4,
    nameAr: 'الظالع',
    nameEn: 'Al-Dhale',
  ),
  District(
    id: 5,
    nameAr: 'المحابشة',
    nameEn: 'Al-Mahbashah',
  ),
  District(
    id: 6,
    nameAr: 'الخديرة',
    nameEn: 'Al-Khidrah',
  ),
  District(
    id: 7,
    nameAr: 'الحزمة',
    nameEn: 'Al-Hazmah',
  ),
  District(
    id: 8,
    nameAr: 'الحبابي',
    nameEn: 'Al-Habbabi',
  ),
  District(
    id: 9,
    nameAr: 'الجريبي',
    nameEn: 'Al-Jareebi',
  ),
  District(
    id: 10,
    nameAr: 'السد',
    nameEn: 'Al-Sadd',
  ),
  District(
    id: 11,
    nameAr: 'الرضمة',
    nameEn: 'Al-Radma',
  ),
  District(
    id: 12,
    nameAr: 'السبرة',
    nameEn: 'Al-Sabrah',
  ),
  District(
    id: 13,
    nameAr: 'السدة',
    nameEn: 'Al-Sadah',
  ),
  District(
    id: 14,
    nameAr: 'الشعر',
    nameEn: 'Al-Shaar',
  ),
  District(
    id: 15,
    nameAr: 'الظهار',
    nameEn: 'Al-Dhahar',
  ),
  District(
    id: 16,
    nameAr: 'العدين',
    nameEn: 'Al-Adain',
  ),
  District(
    id: 17,
    nameAr: 'القفر',
    nameEn: 'Al-Qifir',
  ),
  District(
    id: 18,
    nameAr: 'المخادر',
    nameEn: 'Al-Makhadir',
  ),
  District(
    id: 19,
    nameAr: 'المشنة',
    nameEn: 'Al-Mashnah',
  ),
  District(
    id: 20,
    nameAr: 'النادرة',
    nameEn: 'Al-Nadrah',
  ),
  District(
    id: 21,
    nameAr: 'بعدان',
    nameEn: 'Badan',
  ),
  District(
    id: 22,
    nameAr: 'جبلة',
    nameEn: 'Jabalah',
  ),
  District(
    id: 23,
    nameAr: 'حبيش',
    nameEn: 'Habeesh',
  ),
  District(
    id: 24,
    nameAr: 'حزم العدين',
    nameEn: 'Hazm Al-Adain',
  ),
  District(
    id: 25,
    nameAr: 'ذي السفال',
    nameEn: 'Dhi Al-Sufal',
  ),
  District(
    id: 26,
    nameAr: 'فرع العدين',
    nameEn: 'Fir\' Al-Adain',
  ),
  District(
    id: 27,
    nameAr: 'مذيخرة',
    nameEn: 'Muzaykhirah',
  ),
  District(
    id: 28,
    nameAr: 'يريم',
    nameEn: 'Yareem',
  ),
];
final List<District> alJawfDistiricts = [
  District(
    id: 1,
    nameAr: 'خب والشعف',
    nameEn: 'Khab and Al-Sha\'af',
  ),
  District(
    id: 2,
    nameAr: 'الحميدات',
    nameEn: 'Al-Humaydat',
  ),
  District(
    id: 3,
    nameAr: 'المطمة',
    nameEn: 'Al-Matmah',
  ),
  District(
    id: 4,
    nameAr: 'الزاهر',
    nameEn: 'Al-Zahir',
  ),
  District(
    id: 5,
    nameAr: 'الحزم',
    nameEn: 'Al-Hazm',
  ),
  District(
    id: 6,
    nameAr: 'المتون',
    nameEn: 'Al-Mutun',
  ),
  District(
    id: 7,
    nameAr: 'المصلوب',
    nameEn: 'Al-Musallub',
  ),
  District(
    id: 8,
    nameAr: 'الغيل',
    nameEn: 'Al-Ghayl',
  ),
  District(
    id: 9,
    nameAr: 'الخلق',
    nameEn: 'Al-Khalq',
  ),
  District(
    id: 10,
    nameAr: 'برط العنان',
    nameEn: 'Bart Al-Anan',
  ),
  District(
    id: 11,
    nameAr: 'رجوزة',
    nameEn: 'Rajuzah',
  ),
];
final List<District> maribDistiricts = [
  District(
    id: 1,
    nameAr: 'الجوبة',
    nameEn: 'Al-Jawbah',
  ),
  District(
    id: 2,
    nameAr: 'العبدية',
    nameEn: 'Al-Abdiyah',
  ),
  District(
    id: 3,
    nameAr: 'بدبدة',
    nameEn: 'Badbada',
  ),
  District(
    id: 4,
    nameAr: 'جبل مراد',
    nameEn: 'Jabal Murad',
  ),
  District(
    id: 5,
    nameAr: 'حريب',
    nameEn: 'Harib',
  ),
  District(
    id: 6,
    nameAr: 'حريب القرامش',
    nameEn: 'Harib Al-Qaramish',
  ),
  District(
    id: 7,
    nameAr: 'رحبة',
    nameEn: 'Rahbah',
  ),
  District(
    id: 8,
    nameAr: 'رغوان',
    nameEn: 'Raghwan',
  ),
  District(
    id: 9,
    nameAr: 'صرواح',
    nameEn: 'Sarwah',
  ),
  District(
    id: 10,
    nameAr: 'مأرب',
    nameEn: 'Ma\'rib',
  ),
  District(
    id: 11,
    nameAr: 'ماهلية',
    nameEn: 'Mahliyah',
  ),
  District(
    id: 12,
    nameAr: 'مجزر',
    nameEn: 'Majzar',
  ),
  District(
    id: 13,
    nameAr: 'مدغل الجدعان',
    nameEn: 'Mudghal Al-Jud\'an',
  ),
];
final List<District> abyanDistiricts = [
  District(
    id: 1,
    nameAr: 'المحفد',
    nameEn: 'Al-Mahfad',
  ),
  District(
    id: 2,
    nameAr: 'مودية',
    nameEn: 'Mawdiyah',
  ),
  District(
    id: 3,
    nameAr: 'جيشان',
    nameEn: 'Jishan',
  ),
  District(
    id: 4,
    nameAr: 'لودر',
    nameEn: 'Lodar',
  ),
  District(
    id: 5,
    nameAr: 'سباح',
    nameEn: 'Sabah',
  ),
  District(
    id: 6,
    nameAr: 'رصد',
    nameEn: 'Rasad',
  ),
  District(
    id: 7,
    nameAr: 'سرار',
    nameEn: 'Sarar',
  ),
  District(
    id: 8,
    nameAr: 'الوضيع',
    nameEn: 'Al-Wadiah',
  ),
  District(
    id: 9,
    nameAr: 'أحور',
    nameEn: 'Ahwar',
  ),
  District(
    id: 10,
    nameAr: 'زنجبار',
    nameEn: 'Zinjibar',
  ),
  District(
    id: 11,
    nameAr: 'خنفر',
    nameEn: 'Khanfar',
  ),
];
final List<District> shabwahDistircts = [
  District(
    id: 1,
    nameAr: 'دهر',
    nameEn: 'Dahr',
  ),
  District(
    id: 2,
    nameAr: 'الطلح',
    nameEn: 'At-Talh',
  ),
  District(
    id: 3,
    nameAr: 'جردان',
    nameEn: 'Jardan',
  ),
  District(
    id: 4,
    nameAr: 'عرماء',
    nameEn: 'Arma',
  ),
  District(
    id: 5,
    nameAr: 'عسيلان',
    nameEn: 'Asilan',
  ),
  District(
    id: 6,
    nameAr: 'عين',
    nameEn: 'Ain',
  ),
  District(
    id: 7,
    nameAr: 'بيحان',
    nameEn: 'Bayhan',
  ),
  District(
    id: 8,
    nameAr: 'مرخة العليا',
    nameEn: 'Marakhah Al-Ulya',
  ),
  District(
    id: 9,
    nameAr: 'مرخة السفلى',
    nameEn: 'Marakhah As-Sufla',
  ),
  District(
    id: 10,
    nameAr: 'نصاب',
    nameEn: 'Nisab',
  ),
  District(
    id: 11,
    nameAr: 'حطيب',
    nameEn: 'Hatib',
  ),
  District(
    id: 12,
    nameAr: 'الصعيد',
    nameEn: 'As-Sa\'id',
  ),
  District(
    id: 13,
    nameAr: 'عتق',
    nameEn: 'Ataq',
  ),
  District(
    id: 14,
    nameAr: 'حبان',
    nameEn: 'Habban',
  ),
  District(
    id: 15,
    nameAr: 'الروضة',
    nameEn: 'Ar-Rawdah',
  ),
  District(
    id: 16,
    nameAr: 'ميفعة',
    nameEn: 'Mifahah',
  ),
  District(
    id: 17,
    nameAr: 'رضوم',
    nameEn: 'Radum',
  ),
];
final List<District> alDhaleDistiricts = [
  District(
    id: 1,
    nameAr: 'الأزارق',
    nameEn: 'Azraq',
  ),
  District(
    id: 2,
    nameAr: 'الحشاء',
    nameEn: 'Al-Hasha',
  ),
  District(
    id: 3,
    nameAr: 'الحصين',
    nameEn: 'Al-Hasin',
  ),
  District(
    id: 4,
    nameAr: 'الشعيب',
    nameEn: 'Ash-Shu\'ayb',
  ),
  District(
    id: 5,
    nameAr: 'الضالع',
    nameEn: 'Ad-Dali',
  ),
  District(
    id: 6,
    nameAr: 'جبن',
    nameEn: 'Jibin',
  ),
  District(
    id: 7,
    nameAr: 'جحاف',
    nameEn: 'Juhaf',
  ),
  District(
    id: 8,
    nameAr: 'دمت',
    nameEn: 'Damt',
  ),
  District(
    id: 9,
    nameAr: 'قعطبة',
    nameEn: 'Qa\'tabah',
  ),
];
final List<District> raymahDistiricts = [
  District(
    id: 1,
    nameAr: 'بلاد الطعام',
    nameEn: 'Balad At-Ta\'am',
  ),
  District(
    id: 2,
    nameAr: 'السلفية',
    nameEn: 'As-Salafiyya',
  ),
  District(
    id: 3,
    nameAr: 'الجبين',
    nameEn: 'Al-Jubayn',
  ),
  District(
    id: 4,
    nameAr: 'مزهر',
    nameEn: 'Muzhir',
  ),
  District(
    id: 5,
    nameAr: 'كسمة',
    nameEn: 'Kismah',
  ),
  District(
    id: 6,
    nameAr: 'الجعفرية',
    nameEn: 'Al-Ja\'fariyya',
  ),
];
final List<District> alMahrahDistiricts = [
  District(
    id: 1,
    nameAr: 'شحن',
    nameEn: 'Shuhan',
  ),
  District(
    id: 2,
    nameAr: 'حات',
    nameEn: 'Hat',
  ),
  District(
    id: 3,
    nameAr: 'حوف',
    nameEn: 'Hawf',
  ),
  District(
    id: 4,
    nameAr: 'الغيظة',
    nameEn: 'Al-Ghayzah',
  ),
  District(
    id: 5,
    nameAr: 'منعر',
    nameEn: 'Mun\'ar',
  ),
  District(
    id: 6,
    nameAr: 'المسيلة',
    nameEn: 'Al-Musaylah',
  ),
  District(
    id: 7,
    nameAr: 'سيحوت',
    nameEn: 'Sayhut',
  ),
  District(
    id: 8,
    nameAr: 'قشن',
    nameEn: 'Qishn',
  ),
  District(
    id: 9,
    nameAr: 'حصوين',
    nameEn: 'Huswayn',
  ),
];
final List<District> thmarDistiricts = [
  District(
    id: 1,
    nameAr: 'الحداء',
    nameEn: 'Al-Haddah',
  ),
  District(
    id: 2,
    nameAr: 'جهران',
    nameEn: 'Jahran',
  ),
  District(
    id: 3,
    nameAr: 'جبل الشرق',
    nameEn: 'Jabal Al-Sharq',
  ),
  District(
    id: 4,
    nameAr: 'مغرب عنس',
    nameEn: 'Maghrib Anas',
  ),
  District(
    id: 5,
    nameAr: 'عتمة',
    nameEn: 'Atmah',
  ),
  District(
    id: 6,
    nameAr: 'وصاب العالي',
    nameEn: 'Wusab Al-Aali',
  ),
  District(
    id: 7,
    nameAr: 'وصاب السافل',
    nameEn: 'Wusab Al-Sufl',
  ),
  District(
    id: 8,
    nameAr: 'مدينة ذمار',
    nameEn: 'Dhamar City',
  ),
  District(
    id: 9,
    nameAr: 'ميفعة عنس',
    nameEn: 'Mif\'at Anas',
  ),
  District(
    id: 10,
    nameAr: 'عنس',
    nameEn: 'Anas',
  ),
  District(
    id: 11,
    nameAr: 'ضوران أنس',
    nameEn: 'Dawran Anas',
  ),
  District(
    id: 12,
    nameAr: 'المنار',
    nameEn: 'Al-Manar',
  ),
];
final List<District> lahijDistiricts = [
  District(
    id: 1,
    nameAr: 'الحد',
    nameEn: 'Al-Hadd',
  ),
  District(
    id: 2,
    nameAr: 'الحوطة',
    nameEn: 'Al-Hawtah',
  ),
  District(
    id: 3,
    nameAr: 'القبيطة',
    nameEn: 'Al-Qubaytah',
  ),
  District(
    id: 4,
    nameAr: 'المسيمير',
    nameEn: 'Al-Musaymir',
  ),
  District(
    id: 5,
    nameAr: 'المضاربة والعارة',
    nameEn: 'Al-Mudarbah wal-\'Arah',
  ),
  District(
    id: 6,
    nameAr: 'المفلحي',
    nameEn: 'Al-Muflahi',
  ),
  District(
    id: 7,
    nameAr: 'المقاطرة',
    nameEn: 'Al-Muqatrah',
  ),
  District(
    id: 8,
    nameAr: 'الملاح',
    nameEn: 'Al-Malah',
  ),
  District(
    id: 9,
    nameAr: 'تبن',
    nameEn: 'Taban',
  ),
  District(
    id: 10,
    nameAr: 'حالمين',
    nameEn: 'Halimin',
  ),
  District(
    id: 11,
    nameAr: 'حبيل جبر',
    nameEn: 'Habeel Jabr',
  ),
  District(
    id: 12,
    nameAr: 'ردفان',
    nameEn: 'Radfan',
  ),
  District(
    id: 13,
    nameAr: 'طور الباحة',
    nameEn: 'Tur Al-Bahah',
  ),
  District(
    id: 14,
    nameAr: 'يافع',
    nameEn: 'Yafe',
  ),
  District(
    id: 15,
    nameAr: 'يهر',
    nameEn: 'Yahar',
  ),
];
final List<District> saadaDistricts = [
  District(
    id: 1,
    nameAr: 'الحشوة',
    nameEn: 'Al-Hashwah',
  ),
  District(
    id: 2,
    nameAr: 'الصفراء',
    nameEn: 'As-Sufra',
  ),
  District(
    id: 3,
    nameAr: 'الظاهر',
    nameEn: 'Adh-Dhahir',
  ),
  District(
    id: 4,
    nameAr: 'باقم',
    nameEn: 'Baqqam',
  ),
  District(
    id: 5,
    nameAr: 'حيدان',
    nameEn: 'Haydan',
  ),
  District(
    id: 6,
    nameAr: 'رازح',
    nameEn: 'Razih',
  ),
  District(
    id: 7,
    nameAr: 'ساقين',
    nameEn: 'Saqqayn',
  ),
  District(
    id: 8,
    nameAr: 'سحار',
    nameEn: 'Sahar',
  ),
  District(
    id: 9,
    nameAr: 'شداء',
    nameEn: 'Shaddah',
  ),
  District(
    id: 10,
    nameAr: 'صعدة',
    nameEn: 'Sa\'dah',
  ),
  District(
    id: 11,
    nameAr: 'غمر',
    nameEn: 'Ghamr',
  ),
  District(
    id: 12,
    nameAr: 'قطابر',
    nameEn: 'Qatabir',
  ),
  District(
    id: 13,
    nameAr: 'كتاف والبقع',
    nameEn: 'Kataf and Al-Buq\'ah',
  ),
  District(
    id: 14,
    nameAr: 'مجز',
    nameEn: 'Majz',
  ),
  District(
    id: 15,
    nameAr: 'منبة',
    nameEn: 'Munbah',
  ),
];
final List<District>socotraDistiricts= [
  District(
    id: 1,
    nameAr: 'نعمان',
    nameEn: 'Naman',
  ),
  District(
    id: 2,
    nameAr: 'ناطع',
    nameEn: 'Nat\'ah',
  ),
  District(
    id: 3,
    nameAr: 'مسورة',
    nameEn: 'Masurah',
  ),
  District(
    id: 4,
    nameAr: 'الصومعة',
    nameEn: 'As-Suwaymah',
  ),
  District(
    id: 5,
    nameAr: 'الزاهر',
    nameEn: 'Az-Zahir',
  ),
  District(
    id: 6,
    nameAr: 'ذي ناعم',
    nameEn: 'Dhi Na\'im',
  ),
  District(
    id: 7,
    nameAr: 'الطفة',
    nameEn: 'At-Tufah',
  ),
  District(
    id: 8,
    nameAr: 'مكيراس',
    nameEn: 'Mukayras',
  ),
  District(
    id: 9,
    nameAr: 'مدينة البيضاء',
    nameEn: 'Al-Bayda City',
  ),
  District(
    id: 10,
    nameAr: 'البيضاء',
    nameEn: 'Al-Bayda',
  ),
  District(
    id: 11,
    nameAr: 'السوادية',
    nameEn: 'As-Sawadiyah',
  ),
  District(
    id: 12,
    nameAr: 'ردمان',
    nameEn: 'Radman',
  ),
  District(
    id: 13,
    nameAr: 'رداع',
    nameEn: 'Radah',
  ),
  District(
    id: 14,
    nameAr: 'القريشية',
    nameEn: 'Al-Qurayshiyyah',
  ),
  District(
    id: 15,
    nameAr: 'ولد ربيع',
    nameEn: 'Wald Rabi',
  ),
  District(
    id: 16,
    nameAr: 'العرش',
    nameEn: 'Al-Arsh',
  ),
  District(
    id: 17,
    nameAr: 'صباح',
    nameEn: 'Sabah',
  ),
  District(
    id: 18,
    nameAr: 'الرياشية',
    nameEn: 'Ar-Riyashiyyah',
  ),
  District(
    id: 19,
    nameAr: 'الشرية',
    nameEn: 'Ash-Shariyah',
  ),
  District(
    id: 20,
    nameAr: 'الملاجم',
    nameEn: 'Al-Malajim',
  ),
];

final List<City> citiess = [
  City(
    id: 1,
    nameAr: 'صنعاء',
    nameEn: 'Sanaa',
    districts: sanaaDistiricts,
  ),
  City(
    id: 2,
    nameAr: 'عدن',
    nameEn: 'Aden',
    districts: adenDistiricts,
  ),
  City(
    id: 3,
    nameAr: 'حضرموت',
    nameEn: 'Hadramaut',
    districts: hadramautDistiricts,
  ),
  City(
    id: 4,
    nameAr: 'تعز',
    nameEn: 'Taiz',
    districts: taizDistiricts,
  ),
  City(
    id: 5,
    nameAr: 'الحديدة',
    nameEn: 'Hodeidah',
    districts: hodeidahDistricts,
  ),
  City(
    id: 6,
    nameAr: 'المحويت',
    nameEn: 'Al Mahweet',
    districts: alMahweetDistiricts,
  ),
  City(
    id: 7,
    nameAr: 'البيضاء',
    nameEn: 'Al Bayda',
    districts: alBaydaDistiricts,
  ),
  City(
    id: 8,
    nameAr: 'إب',
    nameEn: 'Ibb',
    districts: ibbDistiricts,
  ),
  City(
    id: 9,
    nameAr: 'الجوف',
    nameEn: 'Al Jawf',
    districts: alJawfDistiricts,
  ),
  City(
    id: 10,
    nameAr: 'مأرب',
    nameEn: 'Marib',
    districts: maribDistiricts,
  ),
  City(
    id: 11,
    nameAr: 'أبين',
    nameEn: 'Abyan',
    districts: abyanDistiricts,
  ),
  City(
    id: 12,
    nameAr: 'شبوة',
    nameEn: 'Shabwa',
    districts: shabwahDistircts,
  ),
  City(
    id: 13,
    nameAr: 'الضالع',
    nameEn: 'Al Dhale',
    districts: alDhaleDistiricts,
  ),
  City(
    id: 14,
    nameAr: 'ريمة',
    nameEn: 'Raymah',
    districts: raymahDistiricts,
  ),
  City(
    id: 15,
    nameAr: 'المهرة',
    nameEn: 'Al Mahrah',
    districts: alMahrahDistiricts,
  ),
  City(
    id: 16,
    nameAr: 'ذمار',
    nameEn: 'thmar',
    districts: thmarDistiricts,
  ),
  City(
    id: 17,
    nameAr: 'لحج',
    nameEn: 'Lahij',
    districts: lahijDistiricts,
  ),
  City(
    id: 18,
    nameAr: 'صعدة',
    nameEn: 'Saada',
    districts: saadaDistricts,
  ),
  City(
    id: 19,
    nameAr: 'سقطرئ',
    nameEn: 'Socotra',
    districts: socotraDistiricts,
  ),
];

final List<Map<String, Object>> cities1 = [
  {
    'id': 1,
    'name_ar': 'صنعاء',
    'name_en': 'Sanaa',
  },
  {
    'id': 2,
    'name_ar': 'عدن',
    'name_en': 'Aden',
  },
  {
    'id': 3,
    'name_ar': 'حضرموت',
    'name_en': 'Hadramaut',
  },
  {
    'id': 4,
    'name_ar': 'تعز',
    'name_en': 'Taiz',
  },
  {
    'id': 5,
    'name_ar': 'الحديدة',
    'name_en': 'Hodeidah',
  },
  {
    'id': 6,
    'name_ar': 'المحويت',
    'name_en': 'Al Mahweet',
  },
  {
    'id': 7,
    'name_ar': 'البيضاء',
    'name_en': 'Al Bayda',
  },
  {
    'id': 8,
    'name_ar': 'إب',
    'name_en': 'Ibb',
  },
  {
    'id': 9,
    'name_ar': 'الجوف',
    'name_en': 'Al Jawf',
  },
  {
    'id': 10,
    'name_ar': 'مأرب',
    'name_en': 'Marib',
  },
  {
    'id': 11,
    'name_ar': 'أبين',
    'name_en': 'Abyan',
  },
  {
    'id': 12,
    'name_ar': 'شبوة',
    'name_en': 'Shabwa',
  },
  {
    'id': 13,
    'name_ar': 'الضالع',
    'name_en': 'Al Dhale',
  },
  {
    'id': 14,
    'name_ar': 'ريمة',
    'name_en': 'Raymah',
  },
  {
    'id': 15,
    'name_ar': 'المهرة',
    'name_en': 'Al Mahrah',
  },
  {
    'id': 16,
    'name_ar': "ذمار",
    'name_en': 'thmar',
  },
  {
    'id': 17,
    'name_ar': 'لحج',
    'name_en': 'Lahij',
  },
  {
    'id': 18,
    'name_ar': 'صعدة',
    'name_en': 'Saada',
  },
  {
    'id': 19,
    'name_ar': 'سقطرئ',
    'name_en': 'Socotra',
  },
];

final Map<int, List<Map<String, Object>>> cityDistricts = {
  // صنعاء
  1: [
    {'id': 11, 'name_ar': 'المديرية القديمة', 'name_en': 'Old City District'},
    {'id': 12, 'name_ar': 'مديرية شعوب', 'name_en': 'Shuoub District'},
    {'id': 13, 'name_ar': 'مديرية أزال', 'name_en': 'Azal District'},
    {'id': 14, 'name_ar': 'مديرية الصافية', 'name_en': 'Al-Safia District'},
    {'id': 15, 'name_ar': 'مديرية السبعين', 'name_en': 'Sebeen District'},
    {'id': 16, 'name_ar': 'مديرية الوحدة', 'name_en': 'Al-Wahda District'},
    {'id': 17, 'name_ar': 'مديرية التحرير', 'name_en': 'Al-Tahrir District'},
    {'id': 18, 'name_ar': 'مديرية معين', 'name_en': 'Muain District'},
    {'id': 19, 'name_ar': 'مديرية الثورة', 'name_en': 'Al-Thawra District'},
    {
      'id': 20,
      'name_ar': 'مديرية بني الحارث',
      'name_en': 'Bani Al-Harith District'
    },
    {
      'id': 21,
      'name_ar': 'مديرية ضواحي سنحان وبني بهلول',
      'name_en': 'Suburbs of Sanhan and Bani Bahloul District'
    },
    {'id': 22, 'name_ar': 'مديرية همدان', 'name_en': 'Hamdan District'},
    {'id': 22, 'name_ar': 'مديرية خولان', 'name_en': 'Khawlan District'},
    {'id': 23, 'name_ar': 'مديرية الطيال', 'name_en': 'Al-Tayyal District'},
    {
      'id': 24,
      'name_ar': 'مديرية بني ضبيان',
      'name_en': 'Bani Dabyan District'
    },
    {'id': 25, 'name_ar': 'مديرية الحصن', 'name_en': 'Al-Hisn District'},
    {'id': 26, 'name_ar': 'مديرية جحانة', 'name_en': 'Jahana District'},
    {
      'id': 27,
      'name_ar': 'مديرية بكيل العروس',
      'name_en': 'Bakil Al-Arouss District'
    },
    {
      'id': 29,
      'name_ar': 'مديرية سنحان وبني بهلول',
      'name_en': 'Sanhan and Bani Bahloul District'
    },
    {'id': 30, 'name_ar': 'مديرية الصبيحي', 'name_en': 'Al-Sabahi District'},
    {'id': 31, 'name_ar': 'مديرية بني مطر', 'name_en': 'Bani Matar District'},
    {'id': 32, 'name_ar': 'مديرية السبيعة', 'name_en': 'Al-Sabie District'},
    {'id': 33, 'name_ar': 'مديرية مظفر', 'name_en': 'Mazhar District'},
    {'id': 34, 'name_ar': 'مديرية عتق', 'name_en': 'Ataq District'},
    {'id': 35, 'name_ar': 'مديرية الحضن', 'name_en': 'Al-Hudhn District'},
    {'id': 36, 'name_ar': 'مديرية شعب', 'name_en': 'Sha\'b District'},
    {'id': 37, 'name_ar': 'مديرية نمار', 'name_en': 'Nimar District'},
    {'id': 38, 'name_ar': 'مديرية الريان', 'name_en': 'Al-Rayan District'},
    {'id': 39, 'name_ar': 'مديرية حجرة', 'name_en': 'Hijrat District'},
  ],
  // عدن
  2: [
    {'id': 1, 'name_ar': 'دار سعد', 'name_en': 'Dar Saad'},
    {'id': 2, 'name_ar': 'الشيخ عثمان', 'name_en': 'Ash-Shaykh Uthman'},
    {'id': 3, 'name_ar': 'المنصورة', 'name_en': 'Al-Mansurah'},
    {'id': 4, 'name_ar': 'البريقة', 'name_en': 'Al-Bariqah'},
    {'id': 5, 'name_ar': 'التواهي', 'name_en': 'At-Tuwahi'},
    {'id': 6, 'name_ar': 'المعلا', 'name_en': 'Al-Ma\'alla'},
    {'id': 7, 'name_ar': 'صيرة', 'name_en': 'Sayrah'},
    {'id': 8, 'name_ar': 'خور مكسر', 'name_en': 'Khawr Maksar'},
  ],
  // حضرموت
  3: [
    {'id': 1, 'name_ar': 'المكلا', 'name_en': 'Al-Mukalla'},
    {'id': 2, 'name_ar': 'ثمود', 'name_en': 'Thamud'},
    {'id': 3, 'name_ar': 'القف', 'name_en': 'Al-Qif'},
    {'id': 4, 'name_ar': 'زمخ ومنوخ', 'name_en': 'Zamkh and Munukh'},
    {'id': 5, 'name_ar': 'حجر', 'name_en': 'Hajar'},
    {'id': 6, 'name_ar': 'العبر', 'name_en': 'Al-Abur'},
    {'id': 7, 'name_ar': 'القطن', 'name_en': 'Al-Qatan'},
    {'id': 8, 'name_ar': 'شبام', 'name_en': 'Shibam'},
    {'id': 9, 'name_ar': 'ساه', 'name_en': 'Sah'},
    {'id': 10, 'name_ar': 'سيئون', 'name_en': 'Sayun'},
    {'id': 11, 'name_ar': 'تريم', 'name_en': 'Tarim'},
    {'id': 12, 'name_ar': 'السوم', 'name_en': 'As-Sum'},
    {'id': 13, 'name_ar': 'الريدة وقصيعر', 'name_en': 'Ar-Raida and Qusai\'ar'},
    {'id': 14, 'name_ar': 'الديس', 'name_en': 'Ad-Dais'},
    {'id': 15, 'name_ar': 'الشحر', 'name_en': 'Ash-Shahr'},
    {'id': 16, 'name_ar': 'غيل بن يمين', 'name_en': 'Ghayl bin Yamin'},
    {'id': 17, 'name_ar': 'غيل باوزير', 'name_en': 'Ghayl Bawazir'},
    {'id': 18, 'name_ar': 'دوعن', 'name_en': 'Du\'an'},
    {
      'id': 19,
      'name_ar': 'حورة ووادي العين',
      'name_en': 'Hurah and Wadi Al-Ayn'
    },
    {'id': 20, 'name_ar': 'رخية', 'name_en': 'Rakhiah'},
    {'id': 21, 'name_ar': 'عمد', 'name_en': 'Amad'},
    {'id': 22, 'name_ar': 'الضليعة', 'name_en': 'Adh-Dhali\'ah'},
    {'id': 23, 'name_ar': 'يبعث', 'name_en': 'Yaba\'ath'},
    {'id': 24, 'name_ar': 'حجر الصيعر', 'name_en': 'Hajar As-Sa\'ir'},
    {'id': 25, 'name_ar': 'بروم ميفع', 'name_en': 'Broom Maifeh'},
    {'id': 26, 'name_ar': 'حريضة', 'name_en': 'Hareidah'},
    {'id': 27, 'name_ar': 'رماه', 'name_en': 'Rama'},
    {'id': 28, 'name_ar': 'أرياف المكلا', 'name_en': 'Ariaf Al-Mukalla'},
  ],
  // تعز
  4: [
    {'id': 1, 'name_ar': 'ماوية', 'name_en': 'Mawyah'},
    {'id': 2, 'name_ar': 'شرعب السلام', 'name_en': 'Sharab Al-Salam'},
    {'id': 3, 'name_ar': 'شرعب الرونة', 'name_en': 'Sharab Al-Rawna'},
    {'id': 4, 'name_ar': 'مقبنة', 'name_en': 'Maqbana'},
    {'id': 5, 'name_ar': 'المخاء', 'name_en': 'Al-Makhah'},
    {'id': 6, 'name_ar': 'ذباب', 'name_en': 'Dhabab'},
    {'id': 7, 'name_ar': 'موزع', 'name_en': 'Mawzah'},
    {'id': 8, 'name_ar': 'جبل حبشي', 'name_en': 'Jabal Habshi'},
    {'id': 9, 'name_ar': 'مشرعة وحدنان', 'name_en': 'Mashra\'ah Wahdan'},
    {'id': 10, 'name_ar': 'صبر الموادم', 'name_en': 'Sabr Al-Mawadim'},
    {'id': 11, 'name_ar': 'المسراخ', 'name_en': 'Al-Musrakh'},
    {'id': 12, 'name_ar': 'خدير', 'name_en': 'Khadeer'},
    {'id': 13, 'name_ar': 'الصلو', 'name_en': 'As-Salu'},
    {'id': 14, 'name_ar': 'الشمايتين', 'name_en': 'Ash-Shumaytin'},
    {'id': 15, 'name_ar': 'الوازعية', 'name_en': 'Al-Waz\'iyah'},
    {'id': 16, 'name_ar': 'حيفان', 'name_en': 'Hayfan'},
    {'id': 17, 'name_ar': 'المظفر', 'name_en': 'Al-Muzaffar'},
    {'id': 18, 'name_ar': 'القاهرة', 'name_en': 'Al-Qaherah'},
    {'id': 19, 'name_ar': 'صالة', 'name_en': 'Salah'},
    {'id': 20, 'name_ar': 'التعزية', 'name_en': 'At-Ta\'ziyah'},
    {'id': 21, 'name_ar': 'المعافر', 'name_en': 'Al-Ma\'afir'},
    {'id': 22, 'name_ar': 'المواسط', 'name_en': 'Al-Mawasit'},
    {'id': 23, 'name_ar': 'سامع', 'name_en': 'Same\'ah'},
  ],
  // الحديدة
  5: [
    {'id': 1, 'name_ar': 'الزهرة', 'name_en': 'Az-Zahrah'},
    {'id': 2, 'name_ar': 'اللحية', 'name_en': 'Al-Luhiah'},
    {'id': 3, 'name_ar': 'كمران', 'name_en': 'Kumran'},
    {'id': 4, 'name_ar': 'الصليف', 'name_en': 'As-Salif'},
    {'id': 5, 'name_ar': 'المنيرة', 'name_en': 'Al-Munirah'},
    {'id': 6, 'name_ar': 'القناوص', 'name_en': 'Al-Qanawis'},
    {'id': 7, 'name_ar': 'الزيدية', 'name_en': 'Az-Zaydiyah'},
    {'id': 8, 'name_ar': 'المغلاف', 'name_en': 'Al-Mughlaf'},
    {'id': 9, 'name_ar': 'الضحى', 'name_en': 'Ad-Duha'},
    {'id': 10, 'name_ar': 'باجل', 'name_en': 'Bajil'},
    {'id': 11, 'name_ar': 'الحجيلة', 'name_en': 'Al-Hujaylah'},
    {'id': 12, 'name_ar': 'برع', 'name_en': 'Bara'},
    {'id': 13, 'name_ar': 'المراوعة', 'name_en': 'Al-Muraw\'ah'},
    {'id': 14, 'name_ar': 'الدريهمي', 'name_en': 'Ad-Darihami'},
    {'id': 15, 'name_ar': 'السخنة', 'name_en': 'As-Sakhnah'},
    {'id': 16, 'name_ar': 'المنصورية', 'name_en': 'Al-Mansuriyah'},
    {'id': 17, 'name_ar': 'بيت الفقيه', 'name_en': 'Bait Al-Faqih'},
    {'id': 18, 'name_ar': 'جبل راس', 'name_en': 'Jabal Ras'},
    {'id': 19, 'name_ar': 'حيس', 'name_en': 'Hayis'},
    {'id': 20, 'name_ar': 'الخوخة', 'name_en': 'Al-Khawkhah'},
    {'id': 21, 'name_ar': 'الحوك', 'name_en': 'Al-Hawak'},
    {'id': 22, 'name_ar': 'الميناء', 'name_en': 'Al-Maynah'},
    {'id': 23, 'name_ar': 'الحالي', 'name_en': 'Al-Hali'},
    {'id': 24, 'name_ar': 'زبيد', 'name_en': 'Zabid'},
    {'id': 25, 'name_ar': 'الجراحي', 'name_en': 'Al-Jarahi'},
    {'id': 26, 'name_ar': 'التحيتا', 'name_en': 'At-Tahitah'},
  ],
  // المحويت
  6: [
    {'id': 1, 'name_ar': 'شبام كوكبان', 'name_en': 'Shibam Kokban'},
    {'id': 2, 'name_ar': 'الطويلة', 'name_en': 'Al-Tawila'},
    {'id': 3, 'name_ar': 'الرجم', 'name_en': 'Al-Rajam'},
    {'id': 4, 'name_ar': 'الخبت', 'name_en': 'Al-Khabt'},
    {'id': 5, 'name_ar': 'ملحان', 'name_en': 'Malhan'},
    {'id': 6, 'name_ar': 'حفاش', 'name_en': 'Hafash'},
    {'id': 7, 'name_ar': 'بني سعد', 'name_en': 'Bani Saad'},
    {'id': 8, 'name_ar': 'مدينة المحويت', 'name_en': 'Madinat Al-Mahwit'},
    {'id': 9, 'name_ar': 'المحويت', 'name_en': 'Al-Mahwit'},
  ],
  // البيضاء
  7: [
    {'id': 1, 'name_ar': 'نعمان', 'name_en': 'Naman'},
    {'id': 2, 'name_ar': 'ناطع', 'name_en': 'Nat\'ah'},
    {'id': 3, 'name_ar': 'مسورة', 'name_en': 'Masurah'},
    {'id': 4, 'name_ar': 'الصومعة', 'name_en': 'As-Suwaymah'},
    {'id': 5, 'name_ar': 'الزاهر', 'name_en': 'Az-Zahir'},
    {'id': 6, 'name_ar': 'ذي ناعم', 'name_en': 'Dhi Na\'im'},
    {'id': 7, 'name_ar': 'الطفة', 'name_en': 'At-Tufah'},
    {'id': 8, 'name_ar': 'مكيراس', 'name_en': 'Mukayras'},
    {'id': 9, 'name_ar': 'مدينة البيضاء', 'name_en': 'Al-Bayda City'},
    {'id': 10, 'name_ar': 'البيضاء', 'name_en': 'Al-Bayda'},
    {'id': 11, 'name_ar': 'السوادية', 'name_en': 'As-Sawadiyah'},
    {'id': 12, 'name_ar': 'ردمان', 'name_en': 'Radman'},
    {'id': 13, 'name_ar': 'رداع', 'name_en': 'Radah'},
    {'id': 14, 'name_ar': 'القريشية', 'name_en': 'Al-Qurayshiyyah'},
    {'id': 15, 'name_ar': 'ولد ربيع', 'name_en': 'Wald Rabi'},
    {'id': 16, 'name_ar': 'العرش', 'name_en': 'Al-Arsh'},
    {'id': 17, 'name_ar': 'صباح', 'name_en': 'Sabah'},
    {'id': 18, 'name_ar': 'الرياشية', 'name_en': 'Ar-Riyashiyyah'},
    {'id': 19, 'name_ar': 'الشرية', 'name_en': 'Ash-Shariyah'},
    {'id': 20, 'name_ar': 'الملاجم', 'name_en': 'Al-Malajim'},
  ],
  // إب
  8: [
    {'id': 1, 'name_ar': 'إب', 'name_en': 'Ibb'},
    {'id': 2, 'name_ar': 'السياني', 'name_en': 'ِAlsayani'},
    {'id': 3, 'name_ar': 'الرداع', 'name_en': 'Al-Radah'},
    {'id': 4, 'name_ar': 'الظالع', 'name_en': 'Al-Dhale'},
    {'id': 5, 'name_ar': 'المحابشة', 'name_en': 'Al-Mahbashah'},
    {'id': 6, 'name_ar': 'الخديرة', 'name_en': 'Al-Khidrah'},
    {'id': 7, 'name_ar': 'الحزمة', 'name_en': 'Al-Hazmah'},
    {'id': 8, 'name_ar': 'الحبابي', 'name_en': 'Al-Habbabi'},
    {'id': 9, 'name_ar': 'الجريبي', 'name_en': 'Al-Jareebi'},
    {'id': 10, 'name_ar': 'السد', 'name_en': 'Al-Sadd'},
    {'id': 11, 'name_ar': 'الرضمة', 'name_en': 'Al-Radma'},
    {'id': 12, 'name_ar': 'السبرة', 'name_en': 'Al-Sabrah'},
    {'id': 13, 'name_ar': 'السدة', 'name_en': 'Al-Sadah'},
    {'id': 14, 'name_ar': 'الشعر', 'name_en': 'Al-Shaar'},
    {'id': 15, 'name_ar': 'الظهار', 'name_en': 'Al-Dhahar'},
    {'id': 16, 'name_ar': 'العدين', 'name_en': 'Al-Adain'},
    {'id': 17, 'name_ar': 'القفر', 'name_en': 'Al-Qifir'},
    {'id': 18, 'name_ar': 'المخادر', 'name_en': 'Al-Makhadir'},
    {'id': 19, 'name_ar': 'المشنة', 'name_en': 'Al-Mashnah'},
    {'id': 20, 'name_ar': 'النادرة', 'name_en': 'Al-Nadrah'},
    {'id': 21, 'name_ar': 'بعدان', 'name_en': 'Badan'},
    {'id': 22, 'name_ar': 'جبلة', 'name_en': 'Jabalah'},
    {'id': 23, 'name_ar': 'حبيش', 'name_en': 'Habeesh'},
    {'id': 24, 'name_ar': 'حزم العدين', 'name_en': 'Hazm Al-Adain'},
    {'id': 25, 'name_ar': 'ذي السفال', 'name_en': 'Dhi Al-Sufal'},
    {'id': 26, 'name_ar': 'فرع العدين', 'name_en': 'Fir\' Al-Adain'},
    {'id': 27, 'name_ar': 'مذيخرة', 'name_en': 'Muzaykhirah'},
    {'id': 28, 'name_ar': 'يريم', 'name_en': 'Yareem'},
  ],
  // الجوف
  9: [
    {'id': 1, 'name_ar': 'خب والشعف', 'name_en': 'Khab and Al-Sha\'af'},
    {'id': 2, 'name_ar': 'الحميدات', 'name_en': 'Al-Humaydat'},
    {'id': 3, 'name_ar': 'المطمة', 'name_en': 'Al-Matmah'},
    {'id': 4, 'name_ar': 'الزاهر', 'name_en': 'Al-Zahir'},
    {'id': 5, 'name_ar': 'الحزم', 'name_en': 'Al-Hazm'},
    {'id': 6, 'name_ar': 'المتون', 'name_en': 'Al-Mutun'},
    {'id': 7, 'name_ar': 'المصلوب', 'name_en': 'Al-Musallub'},
    {'id': 8, 'name_ar': 'الغيل', 'name_en': 'Al-Ghayl'},
    {'id': 9, 'name_ar': 'الخلق', 'name_en': 'Al-Khalq'},
    {'id': 10, 'name_ar': 'برط العنان', 'name_en': 'Bart Al-Anan'},
    {'id': 11, 'name_ar': 'رجوزة', 'name_en': 'Rajuzah'},
  ],
  // مأرب
  10: [
    {'id': 1, 'name_ar': 'الجوبة', 'name_en': 'Al-Jawbah'},
    {'id': 2, 'name_ar': 'العبدية', 'name_en': 'Al-Abdiyah'},
    {'id': 3, 'name_ar': 'بدبدة', 'name_en': 'Badbada'},
    {'id': 4, 'name_ar': 'جبل مراد', 'name_en': 'Jabal Murad'},
    {'id': 5, 'name_ar': 'حريب', 'name_en': 'Harib'},
    {'id': 6, 'name_ar': 'حريب القرامش', 'name_en': 'Harib Al-Qaramish'},
    {'id': 7, 'name_ar': 'رحبة', 'name_en': 'Rahbah'},
    {'id': 8, 'name_ar': 'رغوان', 'name_en': 'Raghwan'},
    {'id': 9, 'name_ar': 'صرواح', 'name_en': 'Sarwah'},
    {'id': 10, 'name_ar': 'مأرب', 'name_en': 'Ma\'rib'},
    {'id': 11, 'name_ar': 'ماهلية', 'name_en': 'Mahliyah'},
    {'id': 12, 'name_ar': 'مجزر', 'name_en': 'Majzar'},
    {'id': 13, 'name_ar': 'مدغل الجدعان', 'name_en': 'Mudghal Al-Jud\'an'},
  ],
  // أبين
  11: [
    {'id': 1, 'name_ar': 'المحفد', 'name_en': 'Al-Mahfad'},
    {'id': 2, 'name_ar': 'مودية', 'name_en': 'Mawdiyah'},
    {'id': 3, 'name_ar': 'جيشان', 'name_en': 'Jishan'},
    {'id': 4, 'name_ar': 'لودر', 'name_en': 'Lodar'},
    {'id': 5, 'name_ar': 'سباح', 'name_en': 'Sabah'},
    {'id': 6, 'name_ar': 'رصد', 'name_en': 'Rasad'},
    {'id': 7, 'name_ar': 'سرار', 'name_en': 'Sarar'},
    {'id': 8, 'name_ar': 'الوضيع', 'name_en': 'Al-Wadiah'},
    {'id': 9, 'name_ar': 'أحور', 'name_en': 'Ahwar'},
    {'id': 10, 'name_ar': 'زنجبار', 'name_en': 'Zinjibar'},
    {'id': 11, 'name_ar': 'خنفر', 'name_en': 'Khanfar'},
  ],
  // شبوة
  12: [
    {'id': 1, 'name_ar': 'دهر', 'name_en': 'Dahr'},
    {'id': 2, 'name_ar': 'الطلح', 'name_en': 'At-Talh'},
    {'id': 3, 'name_ar': 'جردان', 'name_en': 'Jardan'},
    {'id': 4, 'name_ar': 'عرماء', 'name_en': 'Arma'},
    {'id': 5, 'name_ar': 'عسيلان', 'name_en': 'Asilan'},
    {'id': 6, 'name_ar': 'عين', 'name_en': 'Ain'},
    {'id': 7, 'name_ar': 'بيحان', 'name_en': 'Bayhan'},
    {'id': 8, 'name_ar': 'مرخة العليا', 'name_en': 'Marakhah Al-Ulya'},
    {'id': 9, 'name_ar': 'مرخة السفلى', 'name_en': 'Marakhah As-Sufla'},
    {'id': 10, 'name_ar': 'نصاب', 'name_en': 'Nisab'},
    {'id': 11, 'name_ar': 'حطيب', 'name_en': 'Hatib'},
    {'id': 12, 'name_ar': 'الصعيد', 'name_en': 'As-Sa\'id'},
    {'id': 13, 'name_ar': 'عتق', 'name_en': 'Ataq'},
    {'id': 14, 'name_ar': 'حبان', 'name_en': 'Habban'},
    {'id': 15, 'name_ar': 'الروضة', 'name_en': 'Ar-Rawdah'},
    {'id': 16, 'name_ar': 'ميفعة', 'name_en': 'Mifahah'},
    {'id': 17, 'name_ar': 'رضوم', 'name_en': 'Radum'},
  ],
  // الضالع
  13: [
    {'id': 1, 'name_ar': 'الأزارق', 'name_en': 'Azraq'},
    {'id': 2, 'name_ar': 'الحشاء', 'name_en': 'Al-Hasha'},
    {'id': 3, 'name_ar': 'الحصين', 'name_en': 'Al-Hasin'},
    {'id': 4, 'name_ar': 'الشعيب', 'name_en': 'Ash-Shu\'ayb'},
    {'id': 5, 'name_ar': 'الضالع', 'name_en': 'Ad-Dali'},
    {'id': 6, 'name_ar': 'جبن', 'name_en': 'Jibin'},
    {'id': 7, 'name_ar': 'جحاف', 'name_en': 'Juhaf'},
    {'id': 8, 'name_ar': 'دمت', 'name_en': 'Damt'},
    {'id': 9, 'name_ar': 'قعطبة', 'name_en': 'Qa\'tabah'},
  ],
  // ريمة
  14: [
    {'id': 1, 'name_ar': 'بلاد الطعام', 'name_en': 'Balad At-Ta\'am'},
    {'id': 2, 'name_ar': 'السلفية', 'name_en': 'As-Salafiyya'},
    {'id': 3, 'name_ar': 'الجبين', 'name_en': 'Al-Jubayn'},
    {'id': 4, 'name_ar': 'مزهر', 'name_en': 'Muzhir'},
    {'id': 5, 'name_ar': 'كسمة', 'name_en': 'Kismah'},
    {'id': 6, 'name_ar': 'الجعفرية', 'name_en': 'Al-Ja\'fariyya'},
  ],
  // المهرة
  15: [
    {'id': 1, 'name_ar': 'شحن', 'name_en': 'Shuhan'},
    {'id': 2, 'name_ar': 'حات', 'name_en': 'Hat'},
    {'id': 3, 'name_ar': 'حوف', 'name_en': 'Hawf'},
    {'id': 4, 'name_ar': 'الغيظة', 'name_en': 'Al-Ghayzah'},
    {'id': 5, 'name_ar': 'منعر', 'name_en': 'Mun\'ar'},
    {'id': 6, 'name_ar': 'المسيلة', 'name_en': 'Al-Musaylah'},
    {'id': 7, 'name_ar': 'سيحوت', 'name_en': 'Sayhut'},
    {'id': 8, 'name_ar': 'قشن', 'name_en': 'Qishn'},
    {'id': 9, 'name_ar': 'حصوين', 'name_en': 'Huswayn'},
  ],
  // ذمار
  16: [
    {'id': 1, 'name_ar': 'الحداء', 'name_en': 'Al-Haddah'},
    {'id': 2, 'name_ar': 'جهران', 'name_en': 'Jahran'},
    {'id': 3, 'name_ar': 'جبل الشرق', 'name_en': 'Jabal Al-Sharq'},
    {'id': 4, 'name_ar': 'مغرب عنس', 'name_en': 'Maghrib Anas'},
    {'id': 5, 'name_ar': 'عتمة', 'name_en': 'Atmah'},
    {'id': 6, 'name_ar': 'وصاب العالي', 'name_en': 'Wusab Al-Aali'},
    {'id': 7, 'name_ar': 'وصاب السافل', 'name_en': 'Wusab Al-Sufl'},
    {'id': 8, 'name_ar': 'مدينة ذمار', 'name_en': 'Dhamar City'},
    {'id': 9, 'name_ar': 'ميفعة عنس', 'name_en': 'Mif\'at Anas'},
    {'id': 10, 'name_ar': 'عنس', 'name_en': 'Anas'},
    {'id': 11, 'name_ar': 'ضوران أنس', 'name_en': 'Dawran Anas'},
    {'id': 12, 'name_ar': 'المنار', 'name_en': 'Al-Manar'},
  ],
  // لحج
  17: [
    {'id': 1, 'name_ar': 'الحد', 'name_en': 'Al-Hadd'},
    {'id': 2, 'name_ar': 'الحوطة', 'name_en': 'Al-Hawtah'},
    {'id': 3, 'name_ar': 'القبيطة', 'name_en': 'Al-Qubaytah'},
    {'id': 4, 'name_ar': 'المسيمير', 'name_en': 'Al-Musaymir'},
    {
      'id': 5,
      'name_ar': 'المضاربة والعارة',
      'name_en': 'Al-Mudarbah wal-\'Arah'
    },
    {'id': 6, 'name_ar': 'المفلحي', 'name_en': 'Al-Muflahi'},
    {'id': 7, 'name_ar': 'المقاطرة', 'name_en': 'Al-Muqatrah'},
    {'id': 8, 'name_ar': 'الملاح', 'name_en': 'Al-Malah'},
    {'id': 9, 'name_ar': 'تبن', 'name_en': 'Taban'},
    {'id': 10, 'name_ar': 'حالمين', 'name_en': 'Halimin'},
    {'id': 11, 'name_ar': 'حبيل جبر', 'name_en': 'Habeel Jabr'},
    {'id': 12, 'name_ar': 'ردفان', 'name_en': 'Radfan'},
    {'id': 13, 'name_ar': 'طور الباحة', 'name_en': 'Tur Al-Bahah'},
    {'id': 14, 'name_ar': 'يافع', 'name_en': 'Yafe'},
    {'id': 15, 'name_ar': 'يهر', 'name_en': 'Yahar'},
  ],
  // صعدة
  18: [
    {'id': 1, 'name_ar': 'الحشوة', 'name_en': 'Al-Hashwah'},
    {'id': 2, 'name_ar': 'الصفراء', 'name_en': 'As-Sufra'},
    {'id': 3, 'name_ar': 'الظاهر', 'name_en': 'Adh-Dhahir'},
    {'id': 4, 'name_ar': 'باقم', 'name_en': 'Baqqam'},
    {'id': 5, 'name_ar': 'حيدان', 'name_en': 'Haydan'},
    {'id': 6, 'name_ar': 'رازح', 'name_en': 'Razih'},
    {'id': 7, 'name_ar': 'ساقين', 'name_en': 'Saqqayn'},
    {'id': 8, 'name_ar': 'سحار', 'name_en': 'Sahar'},
    {'id': 9, 'name_ar': 'شداء', 'name_en': 'Shaddah'},
    {'id': 10, 'name_ar': 'صعدة', 'name_en': 'Sa\'dah'},
    {'id': 11, 'name_ar': 'غمر', 'name_en': 'Ghamr'},
    {'id': 12, 'name_ar': 'قطابر', 'name_en': 'Qatabir'},
    {'id': 13, 'name_ar': 'كتاف والبقع', 'name_en': 'Kataf and Al-Buq\'ah'},
    {'id': 14, 'name_ar': 'مجز', 'name_en': 'Majz'},
    {'id': 15, 'name_ar': 'منبة', 'name_en': 'Munbah'},
  ],
  // سقطرئ
  19: [
    {'id': 1, 'name_ar': 'نعمان', 'name_en': 'Naman'},
    {'id': 2, 'name_ar': 'ناطع', 'name_en': 'Nat\'ah'},
    {'id': 3, 'name_ar': 'مسورة', 'name_en': 'Masurah'},
    {'id': 4, 'name_ar': 'الصومعة', 'name_en': 'As-Suwaymah'},
    {'id': 5, 'name_ar': 'الزاهر', 'name_en': 'Az-Zahir'},
    {'id': 6, 'name_ar': 'ذي ناعم', 'name_en': 'Dhi Na\'im'},
    {'id': 7, 'name_ar': 'الطفة', 'name_en': 'At-Tufah'},
    {'id': 8, 'name_ar': 'مكيراس', 'name_en': 'Mukayras'},
    {'id': 9, 'name_ar': 'مدينة البيضاء', 'name_en': 'Al-Bayda City'},
    {'id': 10, 'name_ar': 'البيضاء', 'name_en': 'Al-Bayda'},
    {'id': 11, 'name_ar': 'السوادية', 'name_en': 'As-Sawadiyah'},
    {'id': 12, 'name_ar': 'ردمان', 'name_en': 'Radman'},
    {'id': 13, 'name_ar': 'رداع', 'name_en': 'Radah'},
    {'id': 14, 'name_ar': 'القريشية', 'name_en': 'Al-Qurayshiyyah'},
    {'id': 15, 'name_ar': 'ولد ربيع', 'name_en': 'Wald Rabi'},
    {'id': 16, 'name_ar': 'العرش', 'name_en': 'Al-Arsh'},
    {'id': 17, 'name_ar': 'صباح', 'name_en': 'Sabah'},
    {'id': 18, 'name_ar': 'الرياشية', 'name_en': 'Ar-Riyashiyyah'},
    {'id': 19, 'name_ar': 'الشرية', 'name_en': 'Ash-Shariyah'},
    {'id': 20, 'name_ar': 'الملاجم', 'name_en': 'Al-Malajim'},
  ]
};


// import 'package:get/get.dart';

// class City {
//   final int id;
//   final String nameEn;
//   final String nameAr;
//   final List<District> districts;

//   City({
//     required this.id,
//     required this.nameAr,
//     required this.nameEn,
//     required this.districts,
//   });

//   String get name => Get.locale?.languageCode == 'en' ? nameEn : nameAr;

//   District? getDistrictById(int id) {
//     final districtsIndex =
//         districts.indexWhere((districts) => districts.id == id);
//     if (districtsIndex != -1) {
//       return districts[districtsIndex];
//     }
//     return null;
//   }

//   District? getDistrictByNameEn(String nameEn) {
//     final cityIndex =
//         districts.indexWhere((district) => district.nameEn == nameEn);
//     if (cityIndex != -1) {
//       return districts[cityIndex];
//     }
//     return null;
//   }

//   String? getDistrictsNameById(int id) {
//     final districtsIndex =
//         districts.indexWhere((districts) => districts.id == id);
//     if (districtsIndex != -1) {
//       return districts[districtsIndex].name;
//     }
//     return null;
//   }

//   // List<District> getDist

//   static City? getCityById(int id) {
//     final cityIndex = citiess.indexWhere((city) => city.id == id);
//     if (cityIndex != -1) {
//       return citiess[cityIndex];
//     }
//     return null;
//   }

//   static City? getCityByNameEn(String nameEn) {
//     final cityIndex = citiess.indexWhere((city) => city.nameEn == nameEn);
//     if (cityIndex != -1) {
//       return citiess[cityIndex];
//     }
//     return null;
//   }

//   static String? getCityNameById(int id) {
//     final cityIndex = citiess.indexWhere((city) => city.id == id);
//     if (cityIndex != -1) {
//       return citiess[cityIndex].name;
//     }
//     return null;
//   }

//   Map<String, Object> toJson() {
//     return {
//       'id': id,
//       'name': Get.locale?.languageCode == 'en' ? nameEn : nameAr,
//     };
//   }
// }

// class District {
//   final int id;
//   final String nameEn;
//   final String nameAr;

//   District({required this.id, required this.nameAr, required this.nameEn});

//   String get name => Get.locale?.languageCode == 'en' ? nameEn : nameAr;

//   Map<String, Object> toJson() {
//     return {
//       'id': id,
//       'name': Get.locale?.languageCode == 'en' ? nameEn : nameAr,
//     };
//   }
// }

// final sanaaDistiricts = [
//   District(
//     id: 1,
//     nameAr: 'المديرية القديمة',
//     nameEn: 'Old City District',
//   ),
//   District(
//     id: 2,
//     nameAr: 'مديرية شعوب',
//     nameEn: 'Shuoub District',
//   ),
//   District(
//     id: 3,
//     nameAr: 'مديرية أزال',
//     nameEn: 'Azal District',
//   ),
// ];

// final adenDistiricts = [
//   District(
//     id: 1,
//     nameAr: 'دار سعد',
//     nameEn: 'Dar Saad',
//   ),
//   District(
//     id: 2,
//     nameAr: 'الشيخ عثمان',
//     nameEn: 'Ash-Shaykh Uthman',
//   ),
//   District(
//     id: 3,
//     nameAr: 'المنصورة',
//     nameEn: 'Al-Mansurah',
//   ),
// ];

// final hadramautDistiricts = [
//   District(
//     id: 1,
//     nameAr: 'المكلا',
//     nameEn: 'Al-Mukalla',
//   ),
//   District(
//     id: 2,
//     nameAr: 'ثمود',
//     nameEn: 'Thamud',
//   ),
//   District(
//     id: 3,
//     nameAr: 'القف',
//     nameEn: 'Al-Qif',
//   ),
// ];

// final List<City> citiess = [
//   City(
//     id: 1,
//     nameAr: 'صنعاء',
//     nameEn: 'Sanaa',
//     districts: sanaaDistiricts,
//   ),
//   City(
//     id: 2,
//     nameAr: 'عدن',
//     nameEn: 'Aden',
//     districts: adenDistiricts,
//   ),
//   City(
//     id: 3,
//     nameAr: 'حضرموت',
//     nameEn: 'Hadramaut',
//     districts: hadramautDistiricts,
//   ),
// ];

// final List<Map<String, Object>> cities = [
//   {
//     'id': 1,
//     'name_ar': 'صنعاء',
//     'name_en': 'Sanaa',
//   },
//   {
//     'id': 2,
//     'name_ar': 'عدن',
//     'name_en': 'Aden',
//   },
//   {
//     'id': 3,
//     'name_ar': 'حضرموت',
//     'name_en': 'Hadramaut',
//   },
//   {
//     'id': 4,
//     'name_ar': 'تعز',
//     'name_en': 'Taiz',
//   },
//   {
//     'id': 5,
//     'name_ar': 'الحديدة',
//     'name_en': 'Hodeidah',
//   },
//   {
//     'id': 6,
//     'name_ar': 'المحويت',
//     'name_en': 'Al Mahweet',
//   },
//   {
//     'id': 7,
//     'name_ar': 'البيضاء',
//     'name_en': 'Al Bayda',
//   },
//   {
//     'id': 8,
//     'name_ar': 'إب',
//     'name_en': 'Ibb',
//   },
//   {
//     'id': 9,
//     'name_ar': 'الجوف',
//     'name_en': 'Al Jawf',
//   },
//   {
//     'id': 10,
//     'name_ar': 'مأرب',
//     'name_en': 'Marib',
//   },
//   {
//     'id': 11,
//     'name_ar': 'أبين',
//     'name_en': 'Abyan',
//   },
//   {
//     'id': 12,
//     'name_ar': 'شبوة',
//     'name_en': 'Shabwa',
//   },
//   {
//     'id': 13,
//     'name_ar': 'الضالع',
//     'name_en': 'Al Dhale',
//   },
//   {
//     'id': 14,
//     'name_ar': 'ريمة',
//     'name_en': 'Raymah',
//   },
//   {
//     'id': 15,
//     'name_ar': 'المهرة',
//     'name_en': 'Al Mahrah',
//   },
//   {
//     'id': 16,
//     'name_ar': "ذمار",
//     'name_en': 'thmar',
//   },
//   {
//     'id': 17,
//     'name_ar': 'لحج',
//     'name_en': 'Lahij',
//   },
//   {
//     'id': 18,
//     'name_ar': 'صعدة',
//     'name_en': 'Saada',
//   },
//   {
//     'id': 19,
//     'name_ar': 'سقطرئ',
//     'name_en': 'Socotra',
//   },
// ];

// final Map<int, List<Map<String, Object>>> cityDistricts = {
//   // صنعاء
//   1: [
//     {'id': 11, 'name_ar': 'المديرية القديمة', 'name_en': 'Old City District'},
//     {'id': 12, 'name_ar': 'مديرية شعوب', 'name_en': 'Shuoub District'},
//     {'id': 13, 'name_ar': 'مديرية أزال', 'name_en': 'Azal District'},
//     {'id': 14, 'name_ar': 'مديرية الصافية', 'name_en': 'Al-Safia District'},
//     {'id': 15, 'name_ar': 'مديرية السبعين', 'name_en': 'Sebeen District'},
//     {'id': 16, 'name_ar': 'مديرية الوحدة', 'name_en': 'Al-Wahda District'},
//     {'id': 17, 'name_ar': 'مديرية التحرير', 'name_en': 'Al-Tahrir District'},
//     {'id': 18, 'name_ar': 'مديرية معين', 'name_en': 'Muain District'},
//     {'id': 19, 'name_ar': 'مديرية الثورة', 'name_en': 'Al-Thawra District'},
//     {
//       'id': 20,
//       'name_ar': 'مديرية بني الحارث',
//       'name_en': 'Bani Al-Harith District'
//     },
//     {
//       'id': 21,
//       'name_ar': 'مديرية ضواحي سنحان وبني بهلول',
//       'name_en': 'Suburbs of Sanhan and Bani Bahloul District'
//     },
//     {'id': 22, 'name_ar': 'مديرية همدان', 'name_en': 'Hamdan District'},
//     {'id': 22, 'name_ar': 'مديرية خولان', 'name_en': 'Khawlan District'},
//     {'id': 23, 'name_ar': 'مديرية الطيال', 'name_en': 'Al-Tayyal District'},
//     {
//       'id': 24,
//       'name_ar': 'مديرية بني ضبيان',
//       'name_en': 'Bani Dabyan District'
//     },
//     {'id': 25, 'name_ar': 'مديرية الحصن', 'name_en': 'Al-Hisn District'},
//     {'id': 26, 'name_ar': 'مديرية جحانة', 'name_en': 'Jahana District'},
//     {
//       'id': 27,
//       'name_ar': 'مديرية بكيل العروس',
//       'name_en': 'Bakil Al-Arouss District'
//     },
//     {
//       'id': 29,
//       'name_ar': 'مديرية سنحان وبني بهلول',
//       'name_en': 'Sanhan and Bani Bahloul District'
//     },
//     {'id': 30, 'name_ar': 'مديرية الصبيحي', 'name_en': 'Al-Sabahi District'},
//     {'id': 31, 'name_ar': 'مديرية بني مطر', 'name_en': 'Bani Matar District'},
//     {'id': 32, 'name_ar': 'مديرية السبيعة', 'name_en': 'Al-Sabie District'},
//     {'id': 33, 'name_ar': 'مديرية مظفر', 'name_en': 'Mazhar District'},
//     {'id': 34, 'name_ar': 'مديرية عتق', 'name_en': 'Ataq District'},
//     {'id': 35, 'name_ar': 'مديرية الحضن', 'name_en': 'Al-Hudhn District'},
//     {'id': 36, 'name_ar': 'مديرية شعب', 'name_en': 'Sha\'b District'},
//     {'id': 37, 'name_ar': 'مديرية نمار', 'name_en': 'Nimar District'},
//     {'id': 38, 'name_ar': 'مديرية الريان', 'name_en': 'Al-Rayan District'},
//     {'id': 39, 'name_ar': 'مديرية حجرة', 'name_en': 'Hijrat District'},
//   ],
//   // عدن
//   2: [
//     {'id': 1, 'name_ar': 'دار سعد', 'name_en': 'Dar Saad'},
//     {'id': 2, 'name_ar': 'الشيخ عثمان', 'name_en': 'Ash-Shaykh Uthman'},
//     {'id': 3, 'name_ar': 'المنصورة', 'name_en': 'Al-Mansurah'},
//     {'id': 4, 'name_ar': 'البريقة', 'name_en': 'Al-Bariqah'},
//     {'id': 5, 'name_ar': 'التواهي', 'name_en': 'At-Tuwahi'},
//     {'id': 6, 'name_ar': 'المعلا', 'name_en': 'Al-Ma\'alla'},
//     {'id': 7, 'name_ar': 'صيرة', 'name_en': 'Sayrah'},
//     {'id': 8, 'name_ar': 'خور مكسر', 'name_en': 'Khawr Maksar'},
//   ],
//   // حضرموت
//   3: [
//     {'id': 1, 'name_ar': 'المكلا', 'name_en': 'Al-Mukalla'},
//     {'id': 2, 'name_ar': 'ثمود', 'name_en': 'Thamud'},
//     {'id': 3, 'name_ar': 'القف', 'name_en': 'Al-Qif'},
//     {'id': 4, 'name_ar': 'زمخ ومنوخ', 'name_en': 'Zamkh and Munukh'},
//     {'id': 5, 'name_ar': 'حجر', 'name_en': 'Hajar'},
//     {'id': 6, 'name_ar': 'العبر', 'name_en': 'Al-Abur'},
//     {'id': 7, 'name_ar': 'القطن', 'name_en': 'Al-Qatan'},
//     {'id': 8, 'name_ar': 'شبام', 'name_en': 'Shibam'},
//     {'id': 9, 'name_ar': 'ساه', 'name_en': 'Sah'},
//     {'id': 10, 'name_ar': 'سيئون', 'name_en': 'Sayun'},
//     {'id': 11, 'name_ar': 'تريم', 'name_en': 'Tarim'},
//     {'id': 12, 'name_ar': 'السوم', 'name_en': 'As-Sum'},
//     {'id': 13, 'name_ar': 'الريدة وقصيعر', 'name_en': 'Ar-Raida and Qusai\'ar'},
//     {'id': 14, 'name_ar': 'الديس', 'name_en': 'Ad-Dais'},
//     {'id': 15, 'name_ar': 'الشحر', 'name_en': 'Ash-Shahr'},
//     {'id': 16, 'name_ar': 'غيل بن يمين', 'name_en': 'Ghayl bin Yamin'},
//     {'id': 17, 'name_ar': 'غيل باوزير', 'name_en': 'Ghayl Bawazir'},
//     {'id': 18, 'name_ar': 'دوعن', 'name_en': 'Du\'an'},
//     {
//       'id': 19,
//       'name_ar': 'حورة ووادي العين',
//       'name_en': 'Hurah and Wadi Al-Ayn'
//     },
//     {'id': 20, 'name_ar': 'رخية', 'name_en': 'Rakhiah'},
//     {'id': 21, 'name_ar': 'عمد', 'name_en': 'Amad'},
//     {'id': 22, 'name_ar': 'الضليعة', 'name_en': 'Adh-Dhali\'ah'},
//     {'id': 23, 'name_ar': 'يبعث', 'name_en': 'Yaba\'ath'},
//     {'id': 24, 'name_ar': 'حجر الصيعر', 'name_en': 'Hajar As-Sa\'ir'},
//     {'id': 25, 'name_ar': 'بروم ميفع', 'name_en': 'Broom Maifeh'},
//     {'id': 26, 'name_ar': 'حريضة', 'name_en': 'Hareidah'},
//     {'id': 27, 'name_ar': 'رماه', 'name_en': 'Rama'},
//     {'id': 28, 'name_ar': 'أرياف المكلا', 'name_en': 'Ariaf Al-Mukalla'},
//   ],
//   // تعز
//   4: [
//     {'id': 1, 'name_ar': 'ماوية', 'name_en': 'Mawyah'},
//     {'id': 2, 'name_ar': 'شرعب السلام', 'name_en': 'Sharab Al-Salam'},
//     {'id': 3, 'name_ar': 'شرعب الرونة', 'name_en': 'Sharab Al-Rawna'},
//     {'id': 4, 'name_ar': 'مقبنة', 'name_en': 'Maqbana'},
//     {'id': 5, 'name_ar': 'المخاء', 'name_en': 'Al-Makhah'},
//     {'id': 6, 'name_ar': 'ذباب', 'name_en': 'Dhabab'},
//     {'id': 7, 'name_ar': 'موزع', 'name_en': 'Mawzah'},
//     {'id': 8, 'name_ar': 'جبل حبشي', 'name_en': 'Jabal Habshi'},
//     {'id': 9, 'name_ar': 'مشرعة وحدنان', 'name_en': 'Mashra\'ah Wahdan'},
//     {'id': 10, 'name_ar': 'صبر الموادم', 'name_en': 'Sabr Al-Mawadim'},
//     {'id': 11, 'name_ar': 'المسراخ', 'name_en': 'Al-Musrakh'},
//     {'id': 12, 'name_ar': 'خدير', 'name_en': 'Khadeer'},
//     {'id': 13, 'name_ar': 'الصلو', 'name_en': 'As-Salu'},
//     {'id': 14, 'name_ar': 'الشمايتين', 'name_en': 'Ash-Shumaytin'},
//     {'id': 15, 'name_ar': 'الوازعية', 'name_en': 'Al-Waz\'iyah'},
//     {'id': 16, 'name_ar': 'حيفان', 'name_en': 'Hayfan'},
//     {'id': 17, 'name_ar': 'المظفر', 'name_en': 'Al-Muzaffar'},
//     {'id': 18, 'name_ar': 'القاهرة', 'name_en': 'Al-Qaherah'},
//     {'id': 19, 'name_ar': 'صالة', 'name_en': 'Salah'},
//     {'id': 20, 'name_ar': 'التعزية', 'name_en': 'At-Ta\'ziyah'},
//     {'id': 21, 'name_ar': 'المعافر', 'name_en': 'Al-Ma\'afir'},
//     {'id': 22, 'name_ar': 'المواسط', 'name_en': 'Al-Mawasit'},
//     {'id': 23, 'name_ar': 'سامع', 'name_en': 'Same\'ah'},
//   ],
//   // الحديدة
//   5: [
//     {'id': 1, 'name_ar': 'الزهرة', 'name_en': 'Az-Zahrah'},
//     {'id': 2, 'name_ar': 'اللحية', 'name_en': 'Al-Luhiah'},
//     {'id': 3, 'name_ar': 'كمران', 'name_en': 'Kumran'},
//     {'id': 4, 'name_ar': 'الصليف', 'name_en': 'As-Salif'},
//     {'id': 5, 'name_ar': 'المنيرة', 'name_en': 'Al-Munirah'},
//     {'id': 6, 'name_ar': 'القناوص', 'name_en': 'Al-Qanawis'},
//     {'id': 7, 'name_ar': 'الزيدية', 'name_en': 'Az-Zaydiyah'},
//     {'id': 8, 'name_ar': 'المغلاف', 'name_en': 'Al-Mughlaf'},
//     {'id': 9, 'name_ar': 'الضحى', 'name_en': 'Ad-Duha'},
//     {'id': 10, 'name_ar': 'باجل', 'name_en': 'Bajil'},
//     {'id': 11, 'name_ar': 'الحجيلة', 'name_en': 'Al-Hujaylah'},
//     {'id': 12, 'name_ar': 'برع', 'name_en': 'Bara'},
//     {'id': 13, 'name_ar': 'المراوعة', 'name_en': 'Al-Muraw\'ah'},
//     {'id': 14, 'name_ar': 'الدريهمي', 'name_en': 'Ad-Darihami'},
//     {'id': 15, 'name_ar': 'السخنة', 'name_en': 'As-Sakhnah'},
//     {'id': 16, 'name_ar': 'المنصورية', 'name_en': 'Al-Mansuriyah'},
//     {'id': 17, 'name_ar': 'بيت الفقيه', 'name_en': 'Bait Al-Faqih'},
//     {'id': 18, 'name_ar': 'جبل راس', 'name_en': 'Jabal Ras'},
//     {'id': 19, 'name_ar': 'حيس', 'name_en': 'Hayis'},
//     {'id': 20, 'name_ar': 'الخوخة', 'name_en': 'Al-Khawkhah'},
//     {'id': 21, 'name_ar': 'الحوك', 'name_en': 'Al-Hawak'},
//     {'id': 22, 'name_ar': 'الميناء', 'name_en': 'Al-Maynah'},
//     {'id': 23, 'name_ar': 'الحالي', 'name_en': 'Al-Hali'},
//     {'id': 24, 'name_ar': 'زبيد', 'name_en': 'Zabid'},
//     {'id': 25, 'name_ar': 'الجراحي', 'name_en': 'Al-Jarahi'},
//     {'id': 26, 'name_ar': 'التحيتا', 'name_en': 'At-Tahitah'},
//   ],
//   // المحويت
//   6: [
//     {'id': 1, 'name_ar': 'شبام كوكبان', 'name_en': 'Shibam Kokban'},
//     {'id': 2, 'name_ar': 'الطويلة', 'name_en': 'Al-Tawila'},
//     {'id': 3, 'name_ar': 'الرجم', 'name_en': 'Al-Rajam'},
//     {'id': 4, 'name_ar': 'الخبت', 'name_en': 'Al-Khabt'},
//     {'id': 5, 'name_ar': 'ملحان', 'name_en': 'Malhan'},
//     {'id': 6, 'name_ar': 'حفاش', 'name_en': 'Hafash'},
//     {'id': 7, 'name_ar': 'بني سعد', 'name_en': 'Bani Saad'},
//     {'id': 8, 'name_ar': 'مدينة المحويت', 'name_en': 'Madinat Al-Mahwit'},
//     {'id': 9, 'name_ar': 'المحويت', 'name_en': 'Al-Mahwit'},
//   ],
//   // البيضاء
//   7: [
//     {'id': 1, 'name_ar': 'نعمان', 'name_en': 'Naman'},
//     {'id': 2, 'name_ar': 'ناطع', 'name_en': 'Nat\'ah'},
//     {'id': 3, 'name_ar': 'مسورة', 'name_en': 'Masurah'},
//     {'id': 4, 'name_ar': 'الصومعة', 'name_en': 'As-Suwaymah'},
//     {'id': 5, 'name_ar': 'الزاهر', 'name_en': 'Az-Zahir'},
//     {'id': 6, 'name_ar': 'ذي ناعم', 'name_en': 'Dhi Na\'im'},
//     {'id': 7, 'name_ar': 'الطفة', 'name_en': 'At-Tufah'},
//     {'id': 8, 'name_ar': 'مكيراس', 'name_en': 'Mukayras'},
//     {'id': 9, 'name_ar': 'مدينة البيضاء', 'name_en': 'Al-Bayda City'},
//     {'id': 10, 'name_ar': 'البيضاء', 'name_en': 'Al-Bayda'},
//     {'id': 11, 'name_ar': 'السوادية', 'name_en': 'As-Sawadiyah'},
//     {'id': 12, 'name_ar': 'ردمان', 'name_en': 'Radman'},
//     {'id': 13, 'name_ar': 'رداع', 'name_en': 'Radah'},
//     {'id': 14, 'name_ar': 'القريشية', 'name_en': 'Al-Qurayshiyyah'},
//     {'id': 15, 'name_ar': 'ولد ربيع', 'name_en': 'Wald Rabi'},
//     {'id': 16, 'name_ar': 'العرش', 'name_en': 'Al-Arsh'},
//     {'id': 17, 'name_ar': 'صباح', 'name_en': 'Sabah'},
//     {'id': 18, 'name_ar': 'الرياشية', 'name_en': 'Ar-Riyashiyyah'},
//     {'id': 19, 'name_ar': 'الشرية', 'name_en': 'Ash-Shariyah'},
//     {'id': 20, 'name_ar': 'الملاجم', 'name_en': 'Al-Malajim'},
//   ],
//   // إب
//   8: [
//     {'id': 1, 'name_ar': 'إب', 'name_en': 'Ibb'},
//     {'id': 2, 'name_ar': 'السياني', 'name_en': 'ِAlsayani'},
//     {'id': 3, 'name_ar': 'الرداع', 'name_en': 'Al-Radah'},
//     {'id': 4, 'name_ar': 'الظالع', 'name_en': 'Al-Dhale'},
//     {'id': 5, 'name_ar': 'المحابشة', 'name_en': 'Al-Mahbashah'},
//     {'id': 6, 'name_ar': 'الخديرة', 'name_en': 'Al-Khidrah'},
//     {'id': 7, 'name_ar': 'الحزمة', 'name_en': 'Al-Hazmah'},
//     {'id': 8, 'name_ar': 'الحبابي', 'name_en': 'Al-Habbabi'},
//     {'id': 9, 'name_ar': 'الجريبي', 'name_en': 'Al-Jareebi'},
//     {'id': 10, 'name_ar': 'السد', 'name_en': 'Al-Sadd'},
//     {'id': 11, 'name_ar': 'الرضمة', 'name_en': 'Al-Radma'},
//     {'id': 12, 'name_ar': 'السبرة', 'name_en': 'Al-Sabrah'},
//     {'id': 13, 'name_ar': 'السدة', 'name_en': 'Al-Sadah'},
//     {'id': 14, 'name_ar': 'الشعر', 'name_en': 'Al-Shaar'},
//     {'id': 15, 'name_ar': 'الظهار', 'name_en': 'Al-Dhahar'},
//     {'id': 16, 'name_ar': 'العدين', 'name_en': 'Al-Adain'},
//     {'id': 17, 'name_ar': 'القفر', 'name_en': 'Al-Qifir'},
//     {'id': 18, 'name_ar': 'المخادر', 'name_en': 'Al-Makhadir'},
//     {'id': 19, 'name_ar': 'المشنة', 'name_en': 'Al-Mashnah'},
//     {'id': 20, 'name_ar': 'النادرة', 'name_en': 'Al-Nadrah'},
//     {'id': 21, 'name_ar': 'بعدان', 'name_en': 'Badan'},
//     {'id': 22, 'name_ar': 'جبلة', 'name_en': 'Jabalah'},
//     {'id': 23, 'name_ar': 'حبيش', 'name_en': 'Habeesh'},
//     {'id': 24, 'name_ar': 'حزم العدين', 'name_en': 'Hazm Al-Adain'},
//     {'id': 25, 'name_ar': 'ذي السفال', 'name_en': 'Dhi Al-Sufal'},
//     {'id': 26, 'name_ar': 'فرع العدين', 'name_en': 'Fir\' Al-Adain'},
//     {'id': 27, 'name_ar': 'مذيخرة', 'name_en': 'Muzaykhirah'},
//     {'id': 28, 'name_ar': 'يريم', 'name_en': 'Yareem'},
//   ],
//   // الجوف
//   9: [
//     {'id': 1, 'name_ar': 'خب والشعف', 'name_en': 'Khab and Al-Sha\'af'},
//     {'id': 2, 'name_ar': 'الحميدات', 'name_en': 'Al-Humaydat'},
//     {'id': 3, 'name_ar': 'المطمة', 'name_en': 'Al-Matmah'},
//     {'id': 4, 'name_ar': 'الزاهر', 'name_en': 'Al-Zahir'},
//     {'id': 5, 'name_ar': 'الحزم', 'name_en': 'Al-Hazm'},
//     {'id': 6, 'name_ar': 'المتون', 'name_en': 'Al-Mutun'},
//     {'id': 7, 'name_ar': 'المصلوب', 'name_en': 'Al-Musallub'},
//     {'id': 8, 'name_ar': 'الغيل', 'name_en': 'Al-Ghayl'},
//     {'id': 9, 'name_ar': 'الخلق', 'name_en': 'Al-Khalq'},
//     {'id': 10, 'name_ar': 'برط العنان', 'name_en': 'Bart Al-Anan'},
//     {'id': 11, 'name_ar': 'رجوزة', 'name_en': 'Rajuzah'},
//   ],
//   // مأرب
//   10: [
//     {'id': 1, 'name_ar': 'الجوبة', 'name_en': 'Al-Jawbah'},
//     {'id': 2, 'name_ar': 'العبدية', 'name_en': 'Al-Abdiyah'},
//     {'id': 3, 'name_ar': 'بدبدة', 'name_en': 'Badbada'},
//     {'id': 4, 'name_ar': 'جبل مراد', 'name_en': 'Jabal Murad'},
//     {'id': 5, 'name_ar': 'حريب', 'name_en': 'Harib'},
//     {'id': 6, 'name_ar': 'حريب القرامش', 'name_en': 'Harib Al-Qaramish'},
//     {'id': 7, 'name_ar': 'رحبة', 'name_en': 'Rahbah'},
//     {'id': 8, 'name_ar': 'رغوان', 'name_en': 'Raghwan'},
//     {'id': 9, 'name_ar': 'صرواح', 'name_en': 'Sarwah'},
//     {'id': 10, 'name_ar': 'مأرب', 'name_en': 'Ma\'rib'},
//     {'id': 11, 'name_ar': 'ماهلية', 'name_en': 'Mahliyah'},
//     {'id': 12, 'name_ar': 'مجزر', 'name_en': 'Majzar'},
//     {'id': 13, 'name_ar': 'مدغل الجدعان', 'name_en': 'Mudghal Al-Jud\'an'},
//   ],
//   // أبين
//   11: [
//     {'id': 1, 'name_ar': 'المحفد', 'name_en': 'Al-Mahfad'},
//     {'id': 2, 'name_ar': 'مودية', 'name_en': 'Mawdiyah'},
//     {'id': 3, 'name_ar': 'جيشان', 'name_en': 'Jishan'},
//     {'id': 4, 'name_ar': 'لودر', 'name_en': 'Lodar'},
//     {'id': 5, 'name_ar': 'سباح', 'name_en': 'Sabah'},
//     {'id': 6, 'name_ar': 'رصد', 'name_en': 'Rasad'},
//     {'id': 7, 'name_ar': 'سرار', 'name_en': 'Sarar'},
//     {'id': 8, 'name_ar': 'الوضيع', 'name_en': 'Al-Wadiah'},
//     {'id': 9, 'name_ar': 'أحور', 'name_en': 'Ahwar'},
//     {'id': 10, 'name_ar': 'زنجبار', 'name_en': 'Zinjibar'},
//     {'id': 11, 'name_ar': 'خنفر', 'name_en': 'Khanfar'},
//   ],
//   // شبوة
//   12: [
//     {'id': 1, 'name_ar': 'دهر', 'name_en': 'Dahr'},
//     {'id': 2, 'name_ar': 'الطلح', 'name_en': 'At-Talh'},
//     {'id': 3, 'name_ar': 'جردان', 'name_en': 'Jardan'},
//     {'id': 4, 'name_ar': 'عرماء', 'name_en': 'Arma'},
//     {'id': 5, 'name_ar': 'عسيلان', 'name_en': 'Asilan'},
//     {'id': 6, 'name_ar': 'عين', 'name_en': 'Ain'},
//     {'id': 7, 'name_ar': 'بيحان', 'name_en': 'Bayhan'},
//     {'id': 8, 'name_ar': 'مرخة العليا', 'name_en': 'Marakhah Al-Ulya'},
//     {'id': 9, 'name_ar': 'مرخة السفلى', 'name_en': 'Marakhah As-Sufla'},
//     {'id': 10, 'name_ar': 'نصاب', 'name_en': 'Nisab'},
//     {'id': 11, 'name_ar': 'حطيب', 'name_en': 'Hatib'},
//     {'id': 12, 'name_ar': 'الصعيد', 'name_en': 'As-Sa\'id'},
//     {'id': 13, 'name_ar': 'عتق', 'name_en': 'Ataq'},
//     {'id': 14, 'name_ar': 'حبان', 'name_en': 'Habban'},
//     {'id': 15, 'name_ar': 'الروضة', 'name_en': 'Ar-Rawdah'},
//     {'id': 16, 'name_ar': 'ميفعة', 'name_en': 'Mifahah'},
//     {'id': 17, 'name_ar': 'رضوم', 'name_en': 'Radum'},
//   ],
//   // الضالع
//   13: [
//     {'id': 1, 'name_ar': 'الأزارق', 'name_en': 'Azraq'},
//     {'id': 2, 'name_ar': 'الحشاء', 'name_en': 'Al-Hasha'},
//     {'id': 3, 'name_ar': 'الحصين', 'name_en': 'Al-Hasin'},
//     {'id': 4, 'name_ar': 'الشعيب', 'name_en': 'Ash-Shu\'ayb'},
//     {'id': 5, 'name_ar': 'الضالع', 'name_en': 'Ad-Dali'},
//     {'id': 6, 'name_ar': 'جبن', 'name_en': 'Jibin'},
//     {'id': 7, 'name_ar': 'جحاف', 'name_en': 'Juhaf'},
//     {'id': 8, 'name_ar': 'دمت', 'name_en': 'Damt'},
//     {'id': 9, 'name_ar': 'قعطبة', 'name_en': 'Qa\'tabah'},
//   ],
//   // ريمة
//   14: [
//     {'id': 1, 'name_ar': 'بلاد الطعام', 'name_en': 'Balad At-Ta\'am'},
//     {'id': 2, 'name_ar': 'السلفية', 'name_en': 'As-Salafiyya'},
//     {'id': 3, 'name_ar': 'الجبين', 'name_en': 'Al-Jubayn'},
//     {'id': 4, 'name_ar': 'مزهر', 'name_en': 'Muzhir'},
//     {'id': 5, 'name_ar': 'كسمة', 'name_en': 'Kismah'},
//     {'id': 6, 'name_ar': 'الجعفرية', 'name_en': 'Al-Ja\'fariyya'},
//   ],
//   // المهرة
//   15: [
//     {'id': 1, 'name_ar': 'شحن', 'name_en': 'Shuhan'},
//     {'id': 2, 'name_ar': 'حات', 'name_en': 'Hat'},
//     {'id': 3, 'name_ar': 'حوف', 'name_en': 'Hawf'},
//     {'id': 4, 'name_ar': 'الغيظة', 'name_en': 'Al-Ghayzah'},
//     {'id': 5, 'name_ar': 'منعر', 'name_en': 'Mun\'ar'},
//     {'id': 6, 'name_ar': 'المسيلة', 'name_en': 'Al-Musaylah'},
//     {'id': 7, 'name_ar': 'سيحوت', 'name_en': 'Sayhut'},
//     {'id': 8, 'name_ar': 'قشن', 'name_en': 'Qishn'},
//     {'id': 9, 'name_ar': 'حصوين', 'name_en': 'Huswayn'},
//   ],
//   // ذمار
//   16: [
//     {'id': 1, 'name_ar': 'الحداء', 'name_en': 'Al-Haddah'},
//     {'id': 2, 'name_ar': 'جهران', 'name_en': 'Jahran'},
//     {'id': 3, 'name_ar': 'جبل الشرق', 'name_en': 'Jabal Al-Sharq'},
//     {'id': 4, 'name_ar': 'مغرب عنس', 'name_en': 'Maghrib Anas'},
//     {'id': 5, 'name_ar': 'عتمة', 'name_en': 'Atmah'},
//     {'id': 6, 'name_ar': 'وصاب العالي', 'name_en': 'Wusab Al-Aali'},
//     {'id': 7, 'name_ar': 'وصاب السافل', 'name_en': 'Wusab Al-Sufl'},
//     {'id': 8, 'name_ar': 'مدينة ذمار', 'name_en': 'Dhamar City'},
//     {'id': 9, 'name_ar': 'ميفعة عنس', 'name_en': 'Mif\'at Anas'},
//     {'id': 10, 'name_ar': 'عنس', 'name_en': 'Anas'},
//     {'id': 11, 'name_ar': 'ضوران أنس', 'name_en': 'Dawran Anas'},
//     {'id': 12, 'name_ar': 'المنار', 'name_en': 'Al-Manar'},
//   ],
//   // لحج
//   17: [
//     {'id': 1, 'name_ar': 'الحد', 'name_en': 'Al-Hadd'},
//     {'id': 2, 'name_ar': 'الحوطة', 'name_en': 'Al-Hawtah'},
//     {'id': 3, 'name_ar': 'القبيطة', 'name_en': 'Al-Qubaytah'},
//     {'id': 4, 'name_ar': 'المسيمير', 'name_en': 'Al-Musaymir'},
//     {
//       'id': 5,
//       'name_ar': 'المضاربة والعارة',
//       'name_en': 'Al-Mudarbah wal-\'Arah'
//     },
//     {'id': 6, 'name_ar': 'المفلحي', 'name_en': 'Al-Muflahi'},
//     {'id': 7, 'name_ar': 'المقاطرة', 'name_en': 'Al-Muqatrah'},
//     {'id': 8, 'name_ar': 'الملاح', 'name_en': 'Al-Malah'},
//     {'id': 9, 'name_ar': 'تبن', 'name_en': 'Taban'},
//     {'id': 10, 'name_ar': 'حالمين', 'name_en': 'Halimin'},
//     {'id': 11, 'name_ar': 'حبيل جبر', 'name_en': 'Habeel Jabr'},
//     {'id': 12, 'name_ar': 'ردفان', 'name_en': 'Radfan'},
//     {'id': 13, 'name_ar': 'طور الباحة', 'name_en': 'Tur Al-Bahah'},
//     {'id': 14, 'name_ar': 'يافع', 'name_en': 'Yafe'},
//     {'id': 15, 'name_ar': 'يهر', 'name_en': 'Yahar'},
//   ],
//   // صعدة
//   18: [
//     {'id': 1, 'name_ar': 'الحشوة', 'name_en': 'Al-Hashwah'},
//     {'id': 2, 'name_ar': 'الصفراء', 'name_en': 'As-Sufra'},
//     {'id': 3, 'name_ar': 'الظاهر', 'name_en': 'Adh-Dhahir'},
//     {'id': 4, 'name_ar': 'باقم', 'name_en': 'Baqqam'},
//     {'id': 5, 'name_ar': 'حيدان', 'name_en': 'Haydan'},
//     {'id': 6, 'name_ar': 'رازح', 'name_en': 'Razih'},
//     {'id': 7, 'name_ar': 'ساقين', 'name_en': 'Saqqayn'},
//     {'id': 8, 'name_ar': 'سحار', 'name_en': 'Sahar'},
//     {'id': 9, 'name_ar': 'شداء', 'name_en': 'Shaddah'},
//     {'id': 10, 'name_ar': 'صعدة', 'name_en': 'Sa\'dah'},
//     {'id': 11, 'name_ar': 'غمر', 'name_en': 'Ghamr'},
//     {'id': 12, 'name_ar': 'قطابر', 'name_en': 'Qatabir'},
//     {'id': 13, 'name_ar': 'كتاف والبقع', 'name_en': 'Kataf and Al-Buq\'ah'},
//     {'id': 14, 'name_ar': 'مجز', 'name_en': 'Majz'},
//     {'id': 15, 'name_ar': 'منبة', 'name_en': 'Munbah'},
//   ],
//   // سقطرئ
//   19: [
//     {'id': 1, 'name_ar': 'نعمان', 'name_en': 'Naman'},
//     {'id': 2, 'name_ar': 'ناطع', 'name_en': 'Nat\'ah'},
//     {'id': 3, 'name_ar': 'مسورة', 'name_en': 'Masurah'},
//     {'id': 4, 'name_ar': 'الصومعة', 'name_en': 'As-Suwaymah'},
//     {'id': 5, 'name_ar': 'الزاهر', 'name_en': 'Az-Zahir'},
//     {'id': 6, 'name_ar': 'ذي ناعم', 'name_en': 'Dhi Na\'im'},
//     {'id': 7, 'name_ar': 'الطفة', 'name_en': 'At-Tufah'},
//     {'id': 8, 'name_ar': 'مكيراس', 'name_en': 'Mukayras'},
//     {'id': 9, 'name_ar': 'مدينة البيضاء', 'name_en': 'Al-Bayda City'},
//     {'id': 10, 'name_ar': 'البيضاء', 'name_en': 'Al-Bayda'},
//     {'id': 11, 'name_ar': 'السوادية', 'name_en': 'As-Sawadiyah'},
//     {'id': 12, 'name_ar': 'ردمان', 'name_en': 'Radman'},
//     {'id': 13, 'name_ar': 'رداع', 'name_en': 'Radah'},
//     {'id': 14, 'name_ar': 'القريشية', 'name_en': 'Al-Qurayshiyyah'},
//     {'id': 15, 'name_ar': 'ولد ربيع', 'name_en': 'Wald Rabi'},
//     {'id': 16, 'name_ar': 'العرش', 'name_en': 'Al-Arsh'},
//     {'id': 17, 'name_ar': 'صباح', 'name_en': 'Sabah'},
//     {'id': 18, 'name_ar': 'الرياشية', 'name_en': 'Ar-Riyashiyyah'},
//     {'id': 19, 'name_ar': 'الشرية', 'name_en': 'Ash-Shariyah'},
//     {'id': 20, 'name_ar': 'الملاجم', 'name_en': 'Al-Malajim'},
//   ]
// };
