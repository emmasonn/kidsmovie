// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_recipe_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$NewRecipeService extends NewRecipeService {
  _$NewRecipeService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = NewRecipeService;

  @override
  Future<Response<ApiResult<ApiRecipeQuery>>> queryRecipes(
      String query, int from, int to) {
    final $url = 'search';
    final $params = <String, dynamic>{'q': query, 'from': from, 'to': to};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<ApiResult<ApiRecipeQuery>, ApiRecipeQuery>($request);
  }
}
