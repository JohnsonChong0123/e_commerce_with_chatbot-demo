import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../domain/entity/order_entity.dart';
import '../../../domain/usecases/order/add_order.dart';
import '../../../domain/usecases/order/clear_order.dart';
import '../../../domain/usecases/order/get_order.dart';
import '../../../domain/usecases/order/remove_order.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final AddOrder _addOrder;
  final GetOrder _getOrder;
  final RemoveOrder _removeOrder;
  final ClearOrder _clearOrder;
  OrderBloc({
    required AddOrder addOrder,
    required GetOrder getOrder,
    required RemoveOrder removeOrder,
    required ClearOrder clearOrder,
  })  : _addOrder = addOrder,
        _getOrder = getOrder,
        _removeOrder = removeOrder,
        _clearOrder = clearOrder,
        super(const OrderInitial()) {
    on<OrderAdd>(_onAddOrder);
    on<OrderLoad>(_onLoadOrder);
    on<OrderRemove>(_onRemoveOrder);
    on<OrderClear>(_onClearOrder);
  }

  void _onAddOrder(OrderAdd event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    final result = await _addOrder(AddOrderParams(
      subtotal: event.subtotal,
      shippingFee: event.shippingFee,
      totalAmount: event.totalAmount,
      orderItems: event.orderItems,
    ));
    result.fold(
      (l) => emit(OrderFailure(l.message)),
      (_) => emit(
        const OrderSuccess("Order added successfully"),
      ),
    );
  }

  void _onLoadOrder(OrderLoad event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    final result = await _getOrder(NoParams());
    result.fold(
      (l) => emit(OrderFailure(l.message)),
      (r) => emit(
        OrderLoadedSuccess(r),
      ),
    );
  }

  void _onRemoveOrder(OrderRemove event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    final result = await _removeOrder(RemoveOrderParams(
      orderId: event.orderId,
    ));
    result.fold(
      (l) => emit(OrderFailure(l.message)),
      (_) => emit(
        const OrderSuccess("Order removed successfully"),
      ),
    );
  }

  void _onClearOrder(OrderClear event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    final result = await _clearOrder(NoParams());
    result.fold(
      (l) => emit(OrderFailure(l.message)),
      (_) => emit(
        const OrderSuccess("Order cleared successfully"),
      ),
    );
  }
}
