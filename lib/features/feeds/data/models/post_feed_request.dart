import 'package:copy_with_extension/copy_with_extension.dart';


part 'post_feed_request.g.dart';

@CopyWith()
class PostFeedRequest {

  // {id: "uuid.v1", media: MediaType, "status": "pending/success/error"}
  final List<Map<String, dynamic>> mediaParts;

  // {id: uuid.vi, payload: {"purpose": "eg. introduction", ....} } // payloads added
  final List<Map<String, dynamic>> payloadParts;

  const PostFeedRequest({this.mediaParts = const [], this.payloadParts = const [] });

}