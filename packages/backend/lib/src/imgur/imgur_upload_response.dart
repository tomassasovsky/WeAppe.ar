part of 'imgur_client.dart';

ImgurUploadResponse imgurUploadResponseFromMap(String str) =>
    ImgurUploadResponse.fromMap(json.decode(str) as Map<String, dynamic>);

class ImgurUploadResponse {
  ImgurUploadResponse({
    this.status,
    this.success,
    this.data,
  });

  factory ImgurUploadResponse.fromMap(Map<String, dynamic> json) {
    return ImgurUploadResponse(
      status: json['status'] as num?,
      success: json['success'] as bool?,
      data: json['data'] == null
          ? null
          : Data.fromMap(json['data'] as Map<String, dynamic>),
    );
  }

  final num? status;
  final bool? success;
  final Data? data;
}

class Data {
  Data({
    this.id,
    this.deletehash,
    this.accountId,
    this.accountUrl,
    this.adType,
    this.adUrl,
    this.title,
    this.description,
    this.name,
    this.type,
    this.width,
    this.height,
    this.size,
    this.views,
    this.section,
    this.vote,
    this.bandwidth,
    this.animated,
    this.favorite,
    this.inGallery,
    this.inMostViral,
    this.hasSound,
    this.isAd,
    this.nsfw,
    this.link,
    this.tags,
    this.datetime,
    this.mp4,
    this.hls,
  });

  factory Data.fromMap(Map<String, dynamic> json) {
    return Data(
      id: json['id'] as String?,
      deletehash: json['deletehash'] as String?,
      accountId: json['account_id'],
      accountUrl: json['account_url'],
      adType: json['ad_type'],
      adUrl: json['ad_url'],
      title: json['title'],
      description: json['description'],
      name: json['name'] as String?,
      type: json['type'] as String?,
      width: json['width'] as num?,
      height: json['height'] as num?,
      size: json['size'] as num?,
      views: json['views'] as num?,
      section: json['section'],
      vote: json['vote'],
      bandwidth: json['bandwidth'] as num?,
      animated: json['animated'] as bool?,
      favorite: json['favorite'] as bool?,
      inGallery: json['in_gallery'] as bool?,
      inMostViral: json['in_most_viral'] as bool?,
      hasSound: json['has_sound'] as bool?,
      isAd: json['is_ad'] as bool?,
      nsfw: json['nsfw'],
      link: json['link'] as String?,
      datetime: json['datetime'] as num?,
      mp4: json['mp4'] as String?,
      hls: json['hls'] as String?,
    );
  }

  final String? id;
  final String? deletehash;
  final dynamic accountId;
  final dynamic accountUrl;
  final dynamic adType;
  final dynamic adUrl;
  final dynamic title;
  final dynamic description;
  final String? name;
  final String? type;
  final num? width;
  final num? height;
  final num? size;
  final num? views;
  final dynamic section;
  final dynamic vote;
  final num? bandwidth;
  final bool? animated;
  final bool? favorite;
  final bool? inGallery;
  final bool? inMostViral;
  final bool? hasSound;
  final bool? isAd;
  final dynamic nsfw;
  final String? link;
  final List<dynamic>? tags;
  final num? datetime;
  final String? mp4;
  final String? hls;
}
