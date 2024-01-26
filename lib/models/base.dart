/*
* Clase Base para request
*/

class Base<Dats> {
  bool? _success;
  Dats? _data;
  String? _errorMessage;
  String? _errorCode;

  Base.success(Dats data) {
    this._success = true;
    this._data = data;
    this._errorMessage = null;
    this._errorCode = null;
  }

  Base.error(String errorMessage, String errorCode) {
    this._success = false;
    this._data = null;
    this._errorMessage = errorMessage;
    this._errorCode = errorCode;
  }

  bool? get getSuccess => this._success;

  Dats? get getData => this._data;

  String? get getErrorMessage => this._errorMessage;

  String? get getErrorCode => this._errorCode;
}
