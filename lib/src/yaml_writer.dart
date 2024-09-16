class YamlWriter {
  final int spaces;

  YamlWriter({
    this.spaces = 2,
  });

  String write(dynamic yaml) {
    return _writeInternal(yaml).trim();
  }

  String _writeInternal(dynamic yaml, {int indent = 0}) {
    String str = '';

    if (yaml is List) {
      str += _writeList(yaml, indent: indent);
    } else if (yaml is Map) {
      str += _writeMap(yaml, indent: indent);
    } else if (yaml is String) {
      str += yaml.replaceAll("\"", "\\\"");
    } else {
      str += yaml.toString();
    }

    return str;
  }

  String _writeList(List yaml, {int indent = 0}) {
    String str = '\n';

    for (var item in yaml) {
      str +=
          "${_indent(indent)}- ${_writeInternal(item, indent: indent + 1)}\n";
    }

    return str;
  }

  String _writeMap(Map yaml, {int indent = 0}) {
    String str = '\n';

    for (var key in yaml.keys) {
      var value = yaml[key];
      str +=
          "${_indent(indent)}${key.toString()}: ${_writeInternal(value, indent: indent + 1)}\n";
    }

    return str;
  }

  String _indent(int indent) {
    return ''.padLeft(indent * spaces, ' ');
  }
}
