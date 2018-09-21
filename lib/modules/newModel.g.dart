// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'newModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsItem _$NewsItemFromJson(Map<String, dynamic> json) {
  return NewsItem(
      title: json['title'] as String,
      media_name: json['media_name'] as String,
      hot: json['hot'] as int,
      comment_count: json['comment_count'] as int,
      image_url: json['image_url'] as String,
      item_id: json['item_id'] as String);
}

Map<String, dynamic> _$NewsItemToJson(NewsItem instance) => <String, dynamic>{
      'title': instance.title,
      'media_name': instance.media_name,
      'hot': instance.hot,
      'comment_count': instance.comment_count,
      'image_url': instance.image_url,
      'item_id': instance.item_id
    };
