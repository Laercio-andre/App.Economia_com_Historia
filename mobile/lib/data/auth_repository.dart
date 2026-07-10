import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../core/network/api_client.dart";
import "../models/user.dart";

class AuthState {
  final AppUser? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({this.user, this.isLoading = false, this.errorMessage});

  /// Autenticado "a sério" (com conta e token), diferente de um convidado.
  bool get isAuthenticated => user != null && !user!.isGuest;
  bool get isGuest => user?.isGuest ?? false;

  AuthState copyWith({AppUser? user, bool? isLoading, String? errorMessage, bool clearError = false}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Autenticação real, ligada ao backend "plataforma-aprendizagem"
/// (ver mappings_sistema.txt, secção 1. AUTH e 2. USUARIOS).
class AuthController extends StateNotifier<AuthState> {
  final ApiClient _api;
  AuthController(this._api) : super(const AuthState());

  static const _kToken = "auth_token";
  static const _kGuest = "auth_guest";

  /// Tenta restaurar a sessão a partir do token guardado localmente.
  /// Se o token tiver expirado ou for inválido, a sessão é limpa.
  Future<void> tryRestoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final wasGuest = prefs.getBool(_kGuest) ?? false;
    final token = prefs.getString(_kToken);

    if (token != null && token.isNotEmpty) {
      _api.setToken(token);
      try {
        final json = await _api.get("/api/auth/me") as Map<String, dynamic>;
        state = state.copyWith(user: AppUser.fromJson(json));
        return;
      } catch (_) {
        // Token inválido/expirado: limpa a sessão guardada.
        await prefs.remove(_kToken);
        _api.setToken(null);
      }
    }

    if (wasGuest) {
      state = state.copyWith(user: AppUser.guest);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final json = await _api.post("/api/auth/login", body: {
        "email": email,
        "password": password,
      }) as Map<String, dynamic>;

      final token = json["token"] as String;
      final user = AppUser.fromJson(json["utilizador"] as Map<String, dynamic>);

      _api.setToken(token);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kToken, token);
      await prefs.setBool(_kGuest, false);

      state = state.copyWith(user: user, isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.mensagem);
      rethrow;
    }
  }

  Future<void> register(String email, String password, {String? regiao, String? instituicao}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final json = await _api.post("/api/auth/register", body: {
        "email": email,
        "password": password,
        if (regiao != null && regiao.isNotEmpty) "regiao": regiao,
        if (instituicao != null && instituicao.isNotEmpty) "instituicao": instituicao,
      }) as Map<String, dynamic>;

      final token = json["token"] as String;
      final user = AppUser.fromJson(json["utilizador"] as Map<String, dynamic>);

      _api.setToken(token);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kToken, token);
      await prefs.setBool(_kGuest, false);

      state = state.copyWith(user: user, isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.mensagem);
      rethrow;
    }
  }

  /// Modo convidado: navegação livre pelo conteúdo público, sem token e sem
  /// acesso às rotas/funcionalidades que exigem autenticação no backend.
  Future<void> continueAsGuest() async {
    _api.setToken(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
    await prefs.setBool(_kGuest, true);
    state = state.copyWith(user: AppUser.guest, clearError: true);
  }

  /// Atualiza região/instituição do utilizador autenticado.
  ///
  /// CONFIRMADO no documento "ROTAS E CONFIGURACAO PARA APP MOBILE":
  /// PATCH /api/usuarios/me com {"regiao":..., "instituicao":...}.
  Future<void> updateProfile({String? regiao, String? instituicao}) async {
    if (!state.isAuthenticated || state.user == null) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final json = await _api.patch("/api/usuarios/me", body: {
        "regiao": regiao,
        "instituicao": instituicao,
      }) as Map<String, dynamic>;
      state = state.copyWith(user: AppUser.fromJson(json), isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.mensagem);
      rethrow;
    }
  }

  /// Troca a senha do utilizador autenticado, exigindo a senha atual.
  /// CONFIRMADO: PATCH /api/usuarios/me/senha com
  /// {"senhaAtual":..., "novaSenha":...}.
  Future<void> changePassword({required String senhaAtual, required String novaSenha}) async {
    if (!state.isAuthenticated) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _api.patch("/api/usuarios/me/senha", body: {
        "senhaAtual": senhaAtual,
        "novaSenha": novaSenha,
      });
      state = state.copyWith(isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.mensagem);
      rethrow;
    }
  }

  /// Refresca os dados do utilizador autenticado (ex.: depois de ganhar pontos).
  Future<void> refresh() async {
    if (!state.isAuthenticated) return;
    try {
      final json = await _api.get("/api/auth/me") as Map<String, dynamic>;
      state = state.copyWith(user: AppUser.fromJson(json));
    } catch (_) {
      // Ignora falhas de refresh silenciosamente; a sessão mantém-se com os dados antigos.
    }
  }

  Future<void> logout() async {
    _api.setToken(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
    await prefs.setBool(_kGuest, false);
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(apiClient);
});
