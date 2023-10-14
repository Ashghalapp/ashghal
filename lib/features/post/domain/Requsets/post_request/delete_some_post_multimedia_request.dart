
class DeleteSomePostMultimediaRequest{
  final int postId;
  final List<int> multimediaIds;

  DeleteSomePostMultimediaRequest({required this.postId, required this.multimediaIds});

  Map<String, Object> toJson(){
    return {
      'post_id': postId,
      'multimedia_ids': multimediaIds,
    };
  }
}