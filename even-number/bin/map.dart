class Test {
  add() {
    // can use the dynamic instead f string just if yu want t stre different type f values means in dataType
    Map<String, String> mapdata = {
      "id": "1",
      "Name": "Sujal",
      "SirName": "Dave"
    };

    Map<String, String> mapdata1 = {"1": "Sujal", "2": "Dave", "3": "Patel"};

    // mapdata["school"] = "Central Academy";
    // print(mapdata.keys);
    // mapdata.remve("id");
    mapdata.addAll(mapdata1);
    print(mapdata);
    // print(mapdata.isNotEmpty);
  }
}

void main() {
  Test obj = Test();
  obj.add();
}
