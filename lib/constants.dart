// ignore_for_file: constant_identifier_names

//Rutas internas app
const String LOGIN_ROUTE = '/login';
const String HOME_ROUTE = '/home';
const String CUSTOMERS_ROUTE = '/customers';
const String CUSTOMERS_ROUTE_NC = '/customers_nc';
const String QUERIES_ROUTE = '/queries';
const String PRODUCTS_ROUTE = '/products';
const String PRODUCTS_ROUTE_NC = '/products_nc';
const String SELECT_PRODUCT_ROUTE = '/select_product';
const String SELECT_PRODUCT_ROUTE_NO = '/select_product_no';
const String CUSTOMER_PAGE_ROUTE = '/customer_page';
const String ORDER_PAGE_ROUTE = '/order_page';
const String ORDERS_ROUTE = '/orders_page';
const String CHECK_AUTH_ROUTE = '/check_auth';

//Rutas Api Rest
const String HOST_URL = "http://174.138.68.90/api/public/";

const String LOGIN_URL = "${HOST_URL}loginApp";
const String GET_CUSTOMERS = "${HOST_URL}customersApp";
const String SET_CUSTOMERS = "${HOST_URL}customersApp";
const String GET_CUSTOMERS_ROUTE = "${HOST_URL}customersRoutes/";
const String GET_TRADE_SELLER_ROUTE = "${HOST_URL}routesSellersApp/";
const String GET_PRODUCTS = "${HOST_URL}productsApp";
const String POST_ORDERS = "${HOST_URL}ordersApp";
const String GET_ORDERS = "${HOST_URL}getOrdersApp";

//Keys
const String LOCAL_EMAIL = "localEmail";
const String LOCAL_PASSWORD = "localPassword";

const String HOUR_ZONE = "America/Guayaquil";

const int LONG_DECIMALS = 2;
const int IVA_VALUE = 12;
const int ICE_VALUE = 16;
const int MIN_STOCK = 10;
