// 창고 데이터
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test2/list_view_model.dart';
import 'package:flutter_test2/post_repository.dart';

class DetailModel {
  List<String> comments;

  DetailModel(this.comments);

  DetailModel.copy(DetailModel model) : comments = model.comments;
}

// 창고
class DetailViewModel extends StateNotifier<DetailModel?> {
  DetailViewModel(super.state, this.ref);

  Ref ref;

  Future<void> notifyInit() async {
    DetailModel model = await PostRepository().fetchDetail();
    state = model;
  }

  Future<void> add() async {
    String newComment = await PostRepository().save();
    DetailModel model = state!;
    model.comments = [...model.comments, newComment];
    state = DetailModel.copy(model);

    // ListProvider에게 알려줘야함 (List -> 1,2,3,4) , (Detail -> 1,2,3)
    ref.read(listProvider.notifier).detailNotify(newComment);
  }
}

// 창고 관리자
final detailProvider =
    StateNotifierProvider.autoDispose<DetailViewModel, DetailModel?>((ref) {
  return DetailViewModel(null, ref)..notifyInit();
});
