// extend String to have an Email Validator
extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension PasswordValidator on String{
  bool isValidPassword(){
    RegExp hasUpper = RegExp(r'[A-Z]');
    RegExp hasLower = RegExp(r'[a-z]');
    RegExp hasDigit = RegExp(r'\d');
    //RegExp hasPunct = RegExp(r'[!@#\$&*~-]');

    if (!RegExp(r'.{6,}').hasMatch(this)) return false;
      //return 'Passwords must have at least 8 characters';

    //if (this.length > 15) return false;

    //if (!hasUpper.hasMatch(this)) return false;
      //return 'Passwords must have at least one uppercase character';

    //if (!hasLower.hasMatch(this)) return false;
      //return 'Passwords must have at least one lowercase character';

    if (!hasDigit.hasMatch(this)) return false;
      //return 'Passwords must have at least one number';

    //if (!hasPunct.hasMatch(this))
    //  return 'Passwords need at least one special character like !@#\$&*~-';

    return true;
  }
}