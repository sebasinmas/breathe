class Example {
  String? greeting;
 
  Example({this.greeting});
 
  Example.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
    greeting = json['greeting'] as String?;
  }
 
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{};
    if (greeting != null) json['greeting'] = greeting;
    return json;
  }
}