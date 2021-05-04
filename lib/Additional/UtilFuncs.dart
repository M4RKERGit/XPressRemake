class UtilFuncs
{
  static List<int> putRec(List<int> received, int result)
  {
    received.add(result);
    received.sort((a, b) => b.compareTo(a));
    received.removeAt(received.length - 1);
    return received;
  }
}
