class Reasturent {
  const Reasturent({
    required this.name,
    required this.rating,
    required this.cuisine,
  });
  final String name;
  final String cuisine;
  final List<double> rating;

  // double get totalRating {
  //   double sum = 0;
  //   for (final rate in rating) {
  //     sum += rate;
  //   }
  //   return sum;
  // }

  // double get averageRating {
  //   double avgRating = 0;
  //   for (final rate in rating) {
  //     avgRating += rate;
  //   }

  //   return avgRating > 0 ? avgRating / rating.length : 0;
  // }

  int get numRating => rating.length;
  double? avgRating() {
    if (rating.isEmpty) {
      return null;
    }
    return rating.reduce((value, element) => value + element) / rating.length;
  }
}
