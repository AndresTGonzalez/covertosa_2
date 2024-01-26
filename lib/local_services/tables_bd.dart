class TablesBd {
  static const String crearTablaUsers = "CREATE TABLE IF NOT EXISTS users("
      "id INTEGER PRIMARY KEY autoincrement,"
      " userid integer,"
      " email TEXT,"
      " password TEXT,"
      " name TEXT,"
      " surname TEXT)";

  static const String crearTablaOrders = "CREATE TABLE IF NOT EXISTS orders("
      "id INTEGER PRIMARY KEY autoincrement,"
      " code_customer TEXT,"
      " date_order DATETIME,"
      " process integer,"
      " phone_customer TEXT,"
      " route TEXT,"
      " identificator TEXT,"
      " subtotal REAL,"
      " iva REAL,"
      " total REAL,"
      " lat TEXT,"
      " lng TEXT)";

  static const String crearTablaOrderDetails =
      "CREATE TABLE IF NOT EXISTS order_details("
      "id INTEGER PRIMARY KEY autoincrement,"
      " id_order integer,"
      " id_product integer,"
      " stock integer,"
      " price REAL,"
      " product_code TEXT,"
      " product TEXT,"
      " amount integer,"
      " subtotal REAL,"
      " iva REAL,"
      " total REAL,"
      " tosend integer,"
      " order_identify TEXT)";

  static const String crearTablaCustomers =
      "CREATE TABLE IF NOT EXISTS customers("
      "id INTEGER PRIMARY KEY autoincrement,"
      " address TEXT,"
      " cod TEXT,"
      " tradename TEXT,"
      " document TEXT,"
      " email TEXT,"
      " lastname TEXT,"
      " name TEXT,"
      " phone TEXT,"
      " route integer,"
      " lat TEXT,"
      " lng TEXT)";

  static const String crearTablaCategories =
      "CREATE TABLE IF NOT EXISTS categories("
      "id INTEGER PRIMARY KEY autoincrement,"
      " name TEXT,"
      " code TEXT,"
      " status integer)";

  static const String crearTablaProdusts =
      "CREATE TABLE IF NOT EXISTS products("
      "id INTEGER PRIMARY KEY autoincrement,"
      " code TEXT,"
      " shortname TEXT,"
      " price REAL,"
      " category TEXT,"
      " taxable integer,"
      " stock integer,"
      " present integer)";

  static const String crearTablaProductsDetails =
      "CREATE TABLE IF NOT EXISTS products_details("
      "id INTEGER PRIMARY KEY autoincrement,"
      " id_product integer,"
      " description TEXT,"
      " price REAL)";

  static const String crearTradeRoutes =
      "CREATE TABLE IF NOT EXISTS trade_routes("
      "id INTEGER PRIMARY KEY autoincrement,"
      " route_id integer,"
      " user_id integer,"
      " seller TEXT,"
      " code TEXT)";
}
