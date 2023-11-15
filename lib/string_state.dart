class StringState {
  StringState();

  get data => null;
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

