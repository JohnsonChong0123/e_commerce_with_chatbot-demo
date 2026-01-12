import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../errors/failure.dart';

abstract interface class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}