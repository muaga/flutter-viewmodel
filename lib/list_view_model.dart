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
    // 1,2,3
    model.comments.removeAt(0); // 2,3
    model.comments = [...model.comments, newComment]; // 2,3,4
    state = ListModel.copy(model);

    // detailViewModel에는 알림을 해줄 필요가 없다 (상세보기할때, 다시 다운받을거니까)
  }

  // 통신이 필요 없다.
  Future<void> detailNotify(String newComment) async {
    ListModel model = state!;
    // 1,2,3
    model.comments.removeAt(0); // 2,3
    model.comments = [...model.comments, newComment]; // 2,3,4
    state = ListModel.copy(model);

    // detailViewModel에는 알림을 해줄 필요가 없다 (상세보기할때, 다시 다운받을거니까)
  }
}

// 창고 관리자
final listProvider =
    StateNotifierProvider.autoDispose<ListViewModel, ListModel?>((ref) {
  return ListViewModel(null)..notifyInit();
});
