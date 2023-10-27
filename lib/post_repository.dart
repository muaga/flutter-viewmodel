import 'list_view_model.dart';

class PostRepository {
  static List<String> dbData = ["댓글3", "댓글2", "댓글1"];

  Future<ListModel> fetchList() async {
    ListModel temp = ListModel("제목", dbData);
    ListModel model = await Future.delayed(Duration(seconds: 2), () => temp);
    return model;
  }

  Future<String> save() async {
    await Future.delayed(Duration(seconds: 2),
        () => dbData = ["댓글${dbData.length + 1}", ...dbData]);
    return "댓글${dbData.length}";
  }
}
