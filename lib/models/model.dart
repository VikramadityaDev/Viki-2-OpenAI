class Model {
  final String id;
  final int created;
  final String root;

  Model({
    required this.id,
    required this.root,
    required this.created,
  });

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        id: json['id'],
        root: json['root'],
        created: json['created'],
      );
}
