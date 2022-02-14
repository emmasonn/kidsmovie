import 'package:chopper/chopper.dart';
import 'package:kidsmovie/models/recipe_model/recipe_model.dart';
import 'package:kidsmovie/networking/model_converter.dart';
import 'package:kidsmovie/networking/recipe_networking/ApiResult.dart';
import 'package:kidsmovie/networking/recipe_networking/recipe_service.dart';

part 'new_recipe_service.chopper.dart';

const String apiUrl = 'https://api.edamam.com/';

@ChopperApi()
abstract class NewRecipeService extends ChopperService {
  @Get(path: 'search')
  Future<Response<ApiResult<ApiRecipeQuery>>> queryRecipes(
    @Query('q') String query,
    @Query('from') int from,
    @Query('to') int to,
  );

  static Request _addQuery(Request req) {
    final params = Map<String, dynamic>.from(req.parameters);
    params['app_id'] = appId;
    params['app_key'] = appKey;

    return req.copyWith(parameters: params);
  }

  static NewRecipeService create() {
    final client = ChopperClient(
      baseUrl: apiUrl,
      interceptors: [_addQuery, HttpLoggingInterceptor()],
      converter: ModelConverter(),
      errorConverter: const JsonConverter(),
      services: [
        _$NewRecipeService(),
      ],
    );
    return _$NewRecipeService(client);
  }
}
