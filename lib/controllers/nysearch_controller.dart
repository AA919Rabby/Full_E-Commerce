import 'package:get/get.dart';
import 'api_controllers/product_controller.dart';


class MysearchController extends GetxController {

  ProductController productController = Get.put(ProductController());

  searchByFilter(String title) {
    if (productController.masterList.isEmpty) return;

    if (title.isEmpty) {

      productController.allProducts.assignAll(productController.masterList);
      productController.selectedCategory.value = 'All';
    } else {
      var filtered = productController.masterList.where((element) {
        String name = element.title?.toLowerCase() ?? "";
        String searchKey = title.toLowerCase().trim();
        return name.contains(searchKey);
      }).toList();

      productController.allProducts.assignAll(filtered);
      productController.selectedCategory.value = '';
    }
  }


}

