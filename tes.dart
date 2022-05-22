void main(){
  List<int> let = [1,2,3];
  print(let.at(-4));
}
extension ListAddr<T> on List<T>{
  T at(int index){
    int len = this.length;
    int loc = index+1;
    int abs = loc.abs();
    int sign = loc.sign;
    if(0 < abs && abs < len){
      if(sign == 1){
        return this[index];
      }else if(sign == -1){
        return this[len-abs];
      }
    }
    throw RangeError("Invalid value: Not in inclusive range 0..${len-1}");
  }
}