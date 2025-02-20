class SearchStockModel {
  final int? id;
  final String? name;
  final String? symbol;
  final String? assetType;
  final String? exchange;
  final String? description;
  final ImageModel? image;

  SearchStockModel({
    this.id,
    this.name,
    this.symbol,
    this.assetType,
    this.exchange,
    this.description,
    this.image,
  });

  factory SearchStockModel.fromJson(Map<String, dynamic> json) {
    return SearchStockModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      assetType: json['asset_type'],
      exchange: json['exchange'],
      description: json['description'],
      image: json['image'] != null ? ImageModel.fromJson(json['image']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'asset_type': assetType,
      'exchange': exchange,
      'description': description,
      'image': image?.toJson(),
    };
  }
}

class ImageModel {
  final String? url;

  ImageModel({this.url});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}
