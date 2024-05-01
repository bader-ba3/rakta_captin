String generateId(String type) {
  var _ = DateTime.now().microsecondsSinceEpoch.toString();
  return "$type$_";
}
