import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirestoreService {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection('products');

  // READ - Stream en temps réel
  Stream<List<Product>> getProducts() {
    return _productsRef
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // CREATE - Ajouter un produit
  Future<void> addProduct(Product product) async {
    await _productsRef.add(product.toMap());
  }

  // UPDATE - Modifier la quantité (+1 ou -1)
  Future<void> updateQuantity(String id, int delta) async {
    final doc = await _productsRef.doc(id).get();
    final current = (doc.data() as Map<String, dynamic>)['quantity'] as int;
    final newQty = (current + delta).clamp(0, 9999);
    await _productsRef.doc(id).update({'quantity': newQty});
  }

  // DELETE - Supprimer un produit
  Future<void> deleteProduct(String id) async {
    await _productsRef.doc(id).delete();
  }
}