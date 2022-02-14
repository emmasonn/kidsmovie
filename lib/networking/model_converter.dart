import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:kidsmovie/models/recipe_model/recipe_model.dart';
import 'package:kidsmovie/networking/recipe_networking/ApiResult.dart';

class ModelConverter implements Converter {
  @override
  FutureOr<Request> convertRequest(Request request) {
    final req = applyHeader(
      request,
      contentTypeKey,
      jsonHeaders,
      override: false,
    );
    return (req);
  }

  Request encodeJson(Request request) {
    final contentType = request.headers[contentTypeKey];
    if (contentType != null && contentType.contains(jsonHeaders)) {
      return request.copyWith(body: json.encode(request.body));
    }
    return request;
  }

  Response<BodyType> decodeJson<BodyType, InnerType>(Response response) {
    final contentType = response.headers[contentTypeKey];
    var body = response.body;
    if (contentType != null && contentType.contains(jsonHeaders)) {
      body = utf8.decode(response.bodyBytes);
    }

    try {
      final mapData = json.decode(body);
      if (mapData['status'] != null) {
        return response.copyWith<BodyType>(
            body: Error(Exception(mapData['status'])) as BodyType);
      }

      final recipeQuery = ApiRecipeQuery.fromJson(mapData);
      return response.copyWith<BodyType>(
          body: Success(recipeQuery) as BodyType);
    } catch (e) {
      chopperLogger.warning(e);
      return response.copyWith(body: Error(e as Exception) as BodyType);
    }
  }

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {
    return decodeJson<BodyType, InnerType>(response);
  }
}
