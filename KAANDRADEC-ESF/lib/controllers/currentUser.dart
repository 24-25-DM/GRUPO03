// Clase para guardar y cargar datos de usuario actual

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:persistencia/controllers/database_controller.dart';

import 'package:persistencia/models/logR.dart';

import '../models/User.dart';

class CurrentUserController {
  CurrentUserController._singleton();

  static final CurrentUserController _mismaInstancia =
      CurrentUserController._singleton();
  static final DatabaseController _databaseController = DatabaseController();

  // Guardar nombre de quien hizo login permanente singleton con valor por defecto "Usuario"
  String? usuarioNombre = 'Usuario';

  factory CurrentUserController() => _mismaInstancia;

  //guardar ususario al logearse
  void setUsuarioNombre(String nombre){
    usuarioNombre = nombre;
  }

  //obtener usuario logeado
  String getUsuarioNombre(){
    return usuarioNombre!;
  }
}
















