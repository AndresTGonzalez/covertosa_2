class DocumentValidator {
  static bool identificationCardValidator(String identificationCard) {
    // Verificar si la longitud de la cédula es correcta
    if (identificationCard.length != 10) {
      return false;
    }

    // Extraer los primeros 9 dígitos
    String firstNineDigits = identificationCard.substring(0, 9);

    // Calcular el dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      int digit = int.parse(firstNineDigits[i]);
      int weight = (i % 2 == 0) ? 2 : 1;
      int product = digit * weight;
      if (product > 9) {
        product -= 9;
      }
      sum += product;
    }

    int remainder = sum % 10;
    int verificationDigit = (remainder == 0) ? 0 : (10 - remainder);

    // Comparar el dígito verificador con el último dígito de la cédula
    int lastDigit = int.parse(identificationCard[9]);
    return verificationDigit == lastDigit;
  }

  static bool rucValidator(String ruc) {
    // Verificar si la longitud del RUC es correcta (13 caracteres)
    if (ruc.length != 13) {
      return false;
    }

    // Obtener el número de cédula del RUC (los primeros 10 caracteres)
    String cedulaPart = ruc.substring(0, 10);

    // Validar el número de cédula utilizando el método identificationCardValidator
    bool cedulaIsValid = identificationCardValidator(cedulaPart);

    // Verificar que el último trío de caracteres sea "001"
    bool is001 = ruc.substring(10) == "001";

    // Devolver true si la cédula es válida y el último trío es "001"
    return cedulaIsValid && is001;
  }
}
