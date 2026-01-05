import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('Usage:dart totals.dart <inputFile.csv>');
    exit(1);
  }
  ;
  final inputFile = arguments.first;
  final lines = File(inputFile).readAsLinesSync();
  final totalDurationByTag = <String, double>{};
  lines.removeAt(0);

  for (var line in lines) {
    final values = line.split(",");
    final durationStr = values[3].replaceAll('"', '');
    final duration = double.parse(durationStr);
    final tag = values[5].replaceAll('"', "");  
    // this is " " " single " but " " this is simple space to remove the ""
    final previousTotal = totalDurationByTag[tag];
    if (previousTotal == null) {
      totalDurationByTag[tag] = duration;
    } else {
      totalDurationByTag[tag] = previousTotal + duration;
    }
    for(var entry in totalDurationByTag.entries){
        final durationFormatted=entry.value.toStringAsFixed(1);
        final tag=entry.key == '' ? 'Unallocated' : entry.key;
        print('$tag: ${durationFormatted}h');
    }
    // print(line);
  }
  //   print(inputFile);
}
// lines=readLinesSync

// duratinByTag= empty map
// first line remove as it is header
// for line in lines
// values=lines.split(',');
// tag=values[3]
// tag =values[5]
// update durationByTag[tag,duration];
// end
// print all durationByTag
