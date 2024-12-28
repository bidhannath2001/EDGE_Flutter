void main() {
  List<dynamic> source = [85, 92, 78, 64, 88];
  double avg = 0;
  for (int it in source) {
    avg += it;
  }
  avg = avg / source.length;
  print("Average is: $avg");
  for (int it in source) {
    if (it >= 70)
      print("Pass");
    else
      print("Fail");
  }
}
