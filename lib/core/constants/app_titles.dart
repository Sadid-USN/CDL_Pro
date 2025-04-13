class AppTitles {
  static const String azkars = "azkars";
  static const String library = "library";
  static const String calendar = "prayerTimes";
  static const String radio = "podkast";

  static const String FAVORITES_BOX = 'favorites_box';
  static const String apiKey = 'a42bf68fde51c8';

  Map<String, Map<String, String>> methods = {
    "1": {
      "title": "Karachi",
      "subTitle": "University of Islamic Sciences, Karachi"
    },
    "2": {"title": "ISNA", "subTitle": "Islamic Society of North America"},
    "3": {"title": "MWL", "subTitle": "Muslim World League"},
    "5": {"title": "Egypt", "subTitle": "Egyptian General Authority of Survey"},
    "4": {"title": "Makkah", "subTitle": "Umm Al-Qura University, Makkah"},
    "11": {
      "title": "MUIS",
      "subTitle": "Majlis Ugama Islam Singapura, Singapore"
    },
    "17": {"title": "JAKIM", "subTitle": "Jabatan Kemajuan Islam Malaysia"},
    "8": {"title": "Gulf", "subTitle": "Gulf Region"},
    "9": {"title": "Kuwait", "subTitle": ""},
    "10": {"title": "Qatar", "subTitle": ""},
    "12": {
      "title": "France",
      "subTitle": "Union Organization islamic de France"
    },
    "13": {"title": "Diyanet", "subTitle": "Directorate of Religious Affairs"},
    "14": {
      "title": "DSMR",
      "subTitle": "Spiritual Administration of Muslims of Russia"
    },
    "15": {
      "title": "Moonsighting Committee Worldwide",
      "subTitle": "(also requires shafaq parameter)"
    },
    "18": {
      "title": "Tunisia",
      "subTitle": "Tunisian Menistry of Religious Affairs"
    },
    "19": {
      "title": "Algeria",
      "subTitle": "Algerian Menistry of Religious Affairs"
    },
    "20": {
      "title": "KEMENAG",
      "subTitle": "Kementerian Agama Republik Indonesia"
    },
    "21": {
      "title": "Morocco",
      "subTitle": "Moroccan Menistry of Religious Affairs"
    },
    "22": {"title": "CIL", "subTitle": "Comunidade Islamica de Lisboa"},
    "23": {
      "title": "Ministry of Awqaf",
      "subTitle": "Islamic Affairs and Holy Places, Jordan"
    }
  };
}

final List<String> titles = [
  AppTitles.azkars,
  AppTitles.library,
  AppTitles.calendar,
  AppTitles.radio,
];
