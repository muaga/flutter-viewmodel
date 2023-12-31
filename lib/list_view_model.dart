// 창고 데이터
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test2/post_repository.dart';

class ListModel {
  String title;
  List<String> comments;

  ListModel(this.title, this.comments);

  ListModel.copy(ListModel model)
      : title = model.title,
        comments = model.comments;

  ListModel.copyV2(ListModel model) : this(model.title, model.comments);
}

// 창고
class ListViewModel extends StateNotifier<ListModel?> {
  ListViewModel(super.state);

  Future<void> notifyInit() async {
    ListModel model = await PostRepository().fetchList();
    state = model;
  }

  Future<void> add() async {
    String newComment = await PostRepository().save();
    ListModel model = state!;
    model.comments = [newComment, ...model.comments]; // 1,2,3,4
    state = ListModel.copy(model);
  }
}

// 창고 관리자
final listProvider =
    StateNotifierProvider.autoDispose<ListViewModel, ListModel?>((ref) {
  return ListViewModel(null)..notifyInit();
});
