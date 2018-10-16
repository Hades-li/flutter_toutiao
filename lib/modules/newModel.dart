import 'package:json_annotation/json_annotation.dart';

part 'newModel.g.dart';

@JsonSerializable(nullable: false)
class NewsItem {
    final String title; // 标题
    final String media_name; // 媒体
    final int hot; // 是否热
    final int comment_count; // 评论数
    final String image_url; // 图片
    final String item_id; // 详情id
    final int article_type; // 文章类型 1:广告 0:普通文章
    List<Map<String,dynamic>> image_list;
    NewsItem({
        this.title,
        this.media_name,
        this.hot,
        this.comment_count,
        this.image_url,
        this.item_id,
        this.image_list,
        this.article_type
    });
    factory NewsItem.fromJson(Map<String, dynamic> json) => _$NewsItemFromJson(json);
    Map<String, dynamic> toJson() => _$NewsItemToJson(this);
}