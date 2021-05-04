class Track {
  String absPath;
  String naming;
  String format;
  int seekDelay;

  Track(String absPath)
  {
    if (absPath == "-")
      {
        this.absPath = "-";
        this.naming = "-";
        this.format = "-";
        this.seekDelay = 0;
        return;
      }
    this.absPath = absPath;
    String buf = "";
    for (int i = 0; i < absPath.split("/")[absPath.split("/").length - 1].split(".").length - 1; i++)
    {
        buf += absPath.split("/")[absPath.split("/").length - 1].split(".")[i];
    }
    this.naming = buf;
    this.format = absPath.split(".")[absPath.split(".").length - 1];
    switch (format)
    {
      case "mp3":
        this.seekDelay = 100;
        break;
      case "flac":
        this.seekDelay = 400;
        break;
      default:
        this.seekDelay = 500;
    }
  }
}