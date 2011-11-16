
#library('util');

inspect(v) {
  var s;
  if (v is String) {
    s = '"$v"';
  } else if (v is List) {
    var sb = new StringBuffer();
    var comma = false;
    sb.add("[");
    for (var i in v) {
      if (comma) {
        sb.add(', ');
      } else {
        comma = true;
      }
      sb.add(inspect(i));
    }
    sb.add("]");
    s = sb.toString();
  } else {
    s = '$v';
  }
  return s;
}

p(v) {
  print(inspect(v)); 
}

class Helpers {
  static var compiledPatterns;
  static regexp(v) {
    if (compiledPatterns === null) {
      compiledPatterns = {};
    }
    var re = compiledPatterns[v];
    if (re === null) {
      re = new RegExp(v);
      compiledPatterns[v] = re;
    }
    return re;
  }
  static match(pattern, s) {
    return regexp(pattern).firstMatch(s);
  }
}

scan(s, pattern) {
  var a = [];
  var re = pattern is String ? Helpers.regexp(pattern) : pattern;
  var mm = re.allMatches(s);
  for (var m in mm) {
    a.add(m[0]);
  }
  return a;
}

map(a, fn) {
  var b = [];
  for (var i in a) {
    b.add(fn(i));
  }
  return b;
}





