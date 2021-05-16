
class StandInAPI {

  static String getHikesNoAPI() {
    //{'name', 'location', 'difficulty', 'length', 'gain', 'hiketype', 'url', 'img_1', 'img_2', 'img_3', 'keywords'}
    return '[{"name":"panorama-ridge", "location":"Garibaldi Provincial Park", "difficulty": "Hard", "length":"28.3 km",'
        '"gain":"1541 m", "hiketype": "Loop", "url": "https://www.alltrails.com/trail/canada/british-columbia/panorama-ridge",'
        '"img_1":"https://cdn-assets.alltrails.com/uploads/photo/image/23668344/large_d48ba3d67631a56ec269e2bba156dfbc.jpg",'
        '"img_2":"https://cdn-assets.alltrails.com/uploads/photo/image/34305850/large_32c94ac9d47f6eb09b9b1b93c61be16f.jpg",'
        '"img_3":"https://cdn-assets.alltrails.com/uploads/photo/image/34305853/large_068d93155d2195357c1609fb3ecd3f7b.jpg", "keywords": null},'
        '{"name":"garibaldi-lake-trail", "location":"Garibaldi Provincial Park", "difficulty": "Moderate", "length":"18.2 km",'
        '"gain":"972 m", "hiketype": "Out & Back", "url": "https://www.alltrails.com/trail/canada/british-columbia/garibaldi-lake-trail",'
        '"img_1":"https://cdn-assets.alltrails.com/uploads/photo/image/23957167/large_04c8a06a56c3a328db71d851edb1bfb7.jpg",'
        '"img_2":"https://cdn-assets.alltrails.com/uploads/photo/image/34901847/large_be7ea843c1cfe9954a10f250b3130d69.jpg",'
        '"img_3":"https://cdn-assets.alltrails.com/uploads/photo/image/34480541/large_fcf2776da5f128d9e494e707ba167708.jpg", "keywords": null},'
        '{"name":"eagle-bluff-trail", "location":"Cypress Provincial Park", "difficulty": "Moderate", "length":"8.9 km",'
        '"gain":"443 m", "hiketype": "Out & Back", "url": "https://www.alltrails.com/trail/canada/british-columbia/eagle-bluff-trail",'
        '"img_1":"https://cdn-assets.alltrails.com/uploads/photo/image/19188231/large_ed307a8a1d3f90ade5f2b58fdf520339.jpg",'
        '"img_2":"https://cdn-assets.alltrails.com/uploads/photo/image/34906253/large_03a86e6ff18c9eab7263988d40e11571.jpg",'
        '"img_3":"https://cdn-assets.alltrails.com/uploads/photo/image/34903552/large_ab935d1f24175be5500149029dc1b58a.jpg", "keywords": null},'
        '{"name":"watersprite-lake-summer-route", "location":"Seaichem 16, British Columbia", "difficulty": "Moderate", "length":"19.0 km",'
        '"gain":"736 m", "hiketype": "Out & Back", "url": "https://www.alltrails.com/trail/canada/british-columbia/watersprite-lake-summer-route",'
        '"img_1":"https://cdn-assets.alltrails.com/uploads/photo/image/23996582/large_05f2f399322b219c104564781265e1be.jpg",'
        '"img_2":"https://cdn-assets.alltrails.com/uploads/photo/image/32187507/large_42718a3b683683b963cfe68853b54f0f.jpg",'
        '"img_3":"https://cdn-assets.alltrails.com/uploads/photo/image/31272629/large_0340b9537b9aaacd5289c15cad889007.jpg", "keywords": null}]';
  }

  static void postHikesNoAPI(String hikes) {
    print("Hikes posted");
    print(hikes);
  }

  static void postPrefsNoAPI(String prefs) {
    print("User preferences posted");
    print(prefs);
  }

}