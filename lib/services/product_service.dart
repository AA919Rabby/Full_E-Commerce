 import 'package:http/http.dart' as http;


class ProductService{

  static final baseUrl="https://dummyjson.com";


  getCategories()async{
    final response=await http.get(Uri.parse("$baseUrl/products/categories"),
    headers: {"Content-Type":"application/json"}
    );
    return response;
  }

  getProducts()async{
    final response=await http.get(Uri.parse("$baseUrl/products"),
        headers: {"Content-Type":"application/json"}
    );
   return response;
  }



}