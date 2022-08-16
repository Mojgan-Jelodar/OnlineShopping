//
//  ShoppingCartObserable.swift
//  Choco
//
//  Created by Mozhgan on 10/12/21.
//
import Combine
import NotificationCenter
let shoppingCartSender = ShoppingCartNotificationSender(orders: [])
let shoppingCartReceiver = ShoppingCartNotificationReceiver()

class ShoppingCartNotificationSender {
    var orders : [ProductOrder]
    init(orders : [ProductOrder]) {
        self.orders = orders
    }
    static let shoppingCartNotification = Notification.Name("CardWasUpdatedNotification")
}

class ShoppingCartNotificationReceiver {
    private var cancellable: Set<AnyCancellable> = []
    @Published var orders : [ProductOrder] = []

    init() {
        NotificationCenter.default.publisher(for: ShoppingCartNotificationSender.shoppingCartNotification)
            .compactMap {$0.object as? ShoppingCartNotificationSender}
            .map {$0.orders}
            .sink { [weak self] orders in
                self?.orders = orders
            }
            .store(in: &cancellable)
    }
}
