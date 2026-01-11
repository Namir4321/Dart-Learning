class Credentials {
  const Credentials({this.email="",this.password=""});
  final String email;
  final String password;

  Credentials copyWith({
    String? email,
    String? password,
  }){
    return Credentials(
      email:email ?? this.email,
      password:password ?? this.password,
    );
  }
  @override
  String toString()=>'Credentials($email , $password)';
}
void main(){
  const credentials=Credentials();
  final updated1=credentials.copyWith(email: "example@example.com");
  print(updated1);
}