part of 'index.dart';

@freezed
class GetImages with _$GetImages {
  const factory GetImages.start({required int page, required String search}) = GetImagesStart;

  const factory GetImages.successful(List<Picture> images) = GetImagesSuccessful;

  const factory GetImages.error(Object error, StackTrace stacktrace) = GetImagesError;
}
