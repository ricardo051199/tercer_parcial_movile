class StringState {
  StringState();
}

class StringLoading extends StringState {
  StringLoading();
}

class StringNew extends StringState {
  String data;
  StringNew({required this.data});

  @override
  List<Object> get props => [data];
}

