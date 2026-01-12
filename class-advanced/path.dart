import 'equtable-operator.dart';

class ClosedPath {
List<Point> _points=[];

void moveTo(Point point){
  _points=[point];
}
void lineTo(Point point){
  _points.add(point);
}
}

void main(){
  final path=ClosedPath()
  ..moveTo(Point(0, 0))
  ..moveTo(Point(0, 0))
  ..moveTo(Point(0, 0))
  ..moveTo(Point(0, 0))
  ..moveTo(Point(0, 0));
}
// yu