class Bean {
  String? aPIName;
  List<String>? imgurls;

  Bean({this.aPIName, this.imgurls});

  Bean.fromJson(Map<String, dynamic> json) {
    aPIName = json['API_name'];
    imgurls = json['imgurls'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['API_name'] = aPIName;
    data['imgurls'] = imgurls;
    return data;
  }
}