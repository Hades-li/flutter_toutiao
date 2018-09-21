import 'package:json_annotation/json_annotation.dart';

part 'detailModel.g.dart';

@JsonSerializable(nullable: false)
class DetailItem {
    final String title; // 标题
    @JsonKey(name: 'media_user', fromJson: _avatarUrl)
    String avatar_url; // 图标
    final String detail_source;// 媒体
    final String publish_time; // 发布时间
    final String comment_count; // 评论数
    DetailItem({
        this.title,
        this.avatar_url,
        this.detail_source,
        this.publish_time,
        this.comment_count
    });

    String _avatarUrl(Map<String, dynamic> map) {
        return map['avatar_url'];
    }

    factory DetailItem.fromJson(Map<String, dynamic> json) => _$DetailItemFromJson(json);
    Map<String, dynamic> toJson() => _$DetailItemToJson(this);
}