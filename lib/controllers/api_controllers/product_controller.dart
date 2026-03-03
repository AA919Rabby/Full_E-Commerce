import 'dart:convert';
import 'package:get/get.dart';
import 'package:social_media/models/product_model.dart';
import '../../services/product_service.dart';


class ProductController extends GetxController{

  var isLoading=true.obs;
  var allProducts=<Products>[].obs;
  var allCategory=<String>[].obs;
  var selectedCategory = 'All'.obs;
  List<Products> masterList = [];


  @override
  void onInit() {
    getProduct();
    getCategories();
    super.onInit();
  }


  filterByCategory(String categoryName) {
    if (categoryName == 'All') {
      selectedCategory.value = 'All';
      allProducts.assignAll(masterList);
    } else {
      selectedCategory.value = categoryName;

      var filtered = masterList.where((element) {
        return element.category?.toLowerCase() == categoryName.toLowerCase();
      }).toList();

      allProducts.assignAll(filtered);
    }
  }



  getProduct()async{
    try{
      isLoading.value=true;
      final response=await ProductService().getProducts();
      if(response.statusCode==200){
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> productsJson = data['products'];
        // Clear old data
        allProducts.clear();
        masterList.clear();
        // Convert JSON to List of Product Models
        List<Products> loadedData = productsJson.map((e) => Products.fromJson(e)).toList();
        allProducts.assignAll(loadedData);
        masterList.addAll(loadedData);
      }else{
        print(response.statusCode);
      }
    }catch(e){
      print(e.toString());
    }finally{
      isLoading.value=false;
    }
  }



  getCategories()async{
    try{
      isLoading.value=true;
      final response=await ProductService().getCategories();
      if(response.statusCode==200){
        List<dynamic> cat=jsonDecode(response.body);
        allCategory.clear();
        allCategory.add('All');
        allCategory.addAll(cat.map((e) => e['name'].toString()).toList());
      }else{
        print(response.statusCode);
      }
    }catch(e){
      print(e.toString());
    }finally{
      isLoading.value=false;
    }
  }





}