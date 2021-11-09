import 'package:cloud_firestore/cloud_firestore.dart';

class CulturaModel {
  //String? uid;
  String? cultura;
  String? min;
  String? max;
  /* double umidade;
  double umidadeSolo;
  double temperatura;*/
  bool? finalizada;

  CulturaModel({
    // this.uid,
    this.cultura,
    //this.finalizada,
    this.min,
    this.max,
    // this.umidade = 0.0,
    // this.umidadeSolo = 0.0,
    // this.temperatura = 0.0
  });

  CulturaModel.fromMap(Map<String, dynamic> map) {
    //this.uid = map['uid'];
    this.cultura = map['cultura'];
    //this.finalizada = map['finalizada'];
    this.min = map['valor minimo'];
    this.max = map['valor maximo'];
  }
  Map<String, dynamic> toMap() {
    return {
      // "uid": this.uid,
      "cultura": this.cultura,
      //"finalizada": this.finalizada,
      "valor minimo": this.min,
      "valor maximo": this.max,
    };
  }
}
