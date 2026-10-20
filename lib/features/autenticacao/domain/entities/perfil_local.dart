import 'package:freezed_annotation/freezed_annotation.dart';

part 'perfil_local.freezed.dart';

/// Entidade pura que representa o perfil local do usuário.
/// Não expõe salt ou hash da senha.
@freezed
abstract class PerfilLocal with _$PerfilLocal {
  const factory PerfilLocal({required String nome, required String email}) =
      _PerfilLocal;
}
