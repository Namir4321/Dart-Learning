// show nly the essentails infrmatin and hiding the internal details
abstract class HumanBeing {
  Eyes();
}

class Male extends HumanBeing {
  @override
  Eyes() {
    print("for watching TV");
  }
}

class Female extends HumanBeing {
  @override
  Eyes() {
    print("for cooking");
  }
}

void main() {
  Male obj=Male();
  obj.Eyes();
  Female obj1=Female();
  obj1.Eyes();
  
}
