import 'package:core/data/models/tv/tv_model.dart';
import 'package:equatable/equatable.dart';

class TVResponse extends Equatable {
  final List<TVModel> tvList;

  const TVResponse({required this.tvList});

  factory TVResponse.fromJson(Map<String, dynamic> json) => TVResponse(
        tvList: List<TVModel>.from((json["results"] as List)
            .map((x) => TVModel.fromJson(x))
            .where((element) => element.posterPath != null)),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(tvList.map((x) => x.toJson())),
      };

  @override
  List<Object> get props => [tvList];
}
