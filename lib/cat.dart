// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'cat.freezed.dart';
// part 'cat.g.dart';
//
// @freezed
// class Cat with _$Cat {
//   const factory Cat({
//     required String id,
//     @JsonKey(name: 'created_at') required DateTime createdAt,
//     @JsonKey(name: 'updated_at') required DateTime updatedAt,
//     @JsonKey(name: 'promoted_at') required DateTime promotedAt,
//     required int width,
//     required int height,
//     //@ColorConvertor() required int color,
//     required String color,
//     @JsonKey(name: 'blue_hash') required String blueHash,
//     required String description,
//     @JsonKey(name: 'alt_description') required String altDescription
//
//   }) = Cat$;
//
//   factory Cat.fromJson(Map<dynamic, dynamic> json) => _$CatFromJson(Map<String, dynamic>.from(json));
// }
//
//
// // class ColorConverter implements JsonConverter<int, String>{
// //   @override
// //   int fromJson(String json){
// //     return int.parse(json.replaceAll('#', ''), radix: 16);
// //   }
// //
// //   @override
// //   String toJson(int object){
// //     throw UnimplementedError();
// //   }
// // }
//
// @freezed
// class Urls with _$Urls {
//   const factory Urls({
//     required String raw,
//     required String regular,
//     required String small,
//     @JsonKey(name: 'small_s3') required String smallS3,
//   }) = Urls$;
//
//   factory Urls.fromJson(Map<dynamic, dynamic> json) => _$UrlsFromJson(Map<String, dynamic>.from(json));
// }
//
//
//
