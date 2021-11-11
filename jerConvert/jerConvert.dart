import 'package:path/path.dart' as p;
void main(List<String> args) {
  String currentDirectory = Directory.current.path;
  Strig manifestPath = [currentDirectory, "manifest.2jer.cfg"].join('/');
}
class Manifest{
  late String _manifestPath;
  late File _manifestFile;
  late String _manifestContent;
  late List<String> _manifestLines;
  late List<String> _locateDirPaths;
  Manifest(Strig manifestPath){
    this._manifestPath = manifestPath;
    this._manifestFile = File(this._manifestPath);
  }
  void load(){
    if(this._manifestFile.existsSync()){
      this._manifestContent = this._manifestFile.readAsStringSync();
      this._manifestLines = this._manifestContent.split("\n");
      this._testOfCtldef();
      this._testOfOn();
      
    }
  }
  void _testOfCtldef(){
    List<int> ctldefLine = this._manifestLines.map((String line) => line.startWith("defctr")).indexedMap((int index, bool isDefCtl) => isDefCtl ? index : -1).where((int index) => index > 0).toList();
    List<int> ctldefEndLine = ctldefLine.map((int index) => this._testOfBlockEnd(index+1, this._manifestLines, index)).toList();
  }
  void _testOfOn(){
    List<int> onLine = this._manifestLines.map((String line) => line.startWith("on")).indexedMap((int index, bool isOn) => isOn ? index : -1).where((int index) => index > 0).toList();
  }
  String _testOfOnDir(String arg){
    if(arg == "current"){
      return Directory.current.path;
    }else{
      return p.canonicalize(arg);
    }
  }
  int _testOfBlockEnd(int lineIndex, List<String> manifestLines, int startDefLine){
    String indentMarker = "||";
    String endMarker = "end";
    String line = manifestLines[lineIndex-1];
    int endLineIndex = manifestLines.length;
    if(lineIndex <= startDefLine){
      throw RangeError("lineIndex must be greater than ctldefLine");
    }else if(startDefLine < 1 || startDefLine > endLineIndex){
      throw RangeError("ctldefLine must be between 1 and endLineIndex");
    }else if(lineIndex > endLineIndex){
      throw BlockDoesNotEndUntilEOFErr(lineIndex, line);
    }else if(line.startsWith(indentMarker)){
      return this._testOfBlockEnd(lineIndex+1, manifestLines, ctldefLine);
    }else if(line.startsWith(endMarker)){
      return lineIndex;
    }else{
      throw BlockDoesNotHaveValidEndErr(lineIndex, line);
    }
  }
}

class Schema{
  late String _schemaPath;
  late File _schemaFile;
  Schema(Strig schemaPath){
    this._schemaPath = schemaPath;
    this._schemaFile = File(this._schemaPath);
  }
  void load(){
    if(this._schemaFile.existsSync()){
      String schemaContent = this._schemaFile.readAsStringSync();
      List<String> schemaLines = schemaContent.split("\n");
    }
  }
}
class XSD extends Schema{}
class SchemaCfg{
  //on Yaml
}
class XIADD_Article extends Schema{}
class BlockDoesNotHaveValidEndErr extends Exeption{
  late int lineIndex;
  late String line;
  BlockDoesNotHaveValidEndErr(int lineIndex, String line){
    this.lineIndex = lineIndex;
    this.line = line;
  }
  @override
  String toString(){
    return "BlockDoesNotHaveValidEndErr: \n\ton: ${this.lineIndex}, line: ${this.line}";
  }
}
class BlockDoesNotEndUntilEOFErr extends Exeption{
  late int lineIndex;
  late String line;
  BlockDoesNotEndUntilEOFErr(int lineIndex, String line){
    this.lineIndex = lineIndex;
    this.line = line;
  }
  @override
  String toString(){
    return "BlockDoesNotEndUntilEOFErr: \n\ton: ${this.lineIndex}, line: ${this.line}";
  }
}
extension IndexedMap<T, E> on List<T> {
  List<E> indexedMap<E>(E Function(int index, T item) function) {
    final list = <E>[];
    asMap().forEach((index, element) {
      list.add(function(index, element));
    });
    return list;
  }
}
