// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RecipeList_Model {
  final String timestamp;
  final String recipe_name;
  RecipeList_Model({
    required this.timestamp,
    required this.recipe_name,
  });

  RecipeList_Model copyWith({
    String? timestamp,
    String? recipe_name,
  }) {
    return RecipeList_Model(
      timestamp: timestamp ?? this.timestamp,
      recipe_name: recipe_name ?? this.recipe_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'timestamp': timestamp,
      'recipe_name': recipe_name,
    };
  }

  factory RecipeList_Model.fromMap(Map<String, dynamic> map) {
    return RecipeList_Model(
      timestamp: map['timestamp'] as String,
      recipe_name: map['recipe_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecipeList_Model.fromJson(String source) => RecipeList_Model.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RecipeList_Model(timestamp: $timestamp, recipe_name: $recipe_name)';

  @override
  bool operator ==(covariant RecipeList_Model other) {
    if (identical(this, other)) return true;
  
    return 
      other.timestamp == timestamp &&
      other.recipe_name == recipe_name;
  }

  @override
  int get hashCode => timestamp.hashCode ^ recipe_name.hashCode;
}
